#ifndef SOCIAL_NETWORK_MICROSERVICES_SRC_MEDIASERVICE_MEDIAHANDLER_H_
#define SOCIAL_NETWORK_MICROSERVICES_SRC_MEDIASERVICE_MEDIAHANDLER_H_

#include <chrono>
#include <iostream>
#include <string>
#include <opentracing/tracer.h>

#include "../../gen-cpp/MediaService.h"
#include "../logger.h"
#include "../tracing.h"

// 2018-01-01 00:00:00 UTC
#define CUSTOM_EPOCH 1514764800000

namespace social_network {

class MediaHandler : public MediaServiceIf {
 public:
  MediaHandler() = default;
  ~MediaHandler() override = default;

  void ComposeMedia(std::vector<Media> &_return, int64_t,
                    const std::vector<std::string> &,
                    const std::vector<int64_t> &,
                    const std::map<std::string, std::string> &) override;

 private:
};

// Get Meter instance from MeterProvider
opentelemetry::nostd::shared_ptr<opentelemetry::v1::metrics::Meter> GetMeter() {
  auto meter_provider = opentelemetry::metrics::Provider::GetMeterProvider();
  return meter_provider->GetMeter("social_network.media", "1.0.0");
}

void MediaHandler::ComposeMedia(
    std::vector<Media> &_return, int64_t req_id,
    const std::vector<std::string> &media_types,
    const std::vector<int64_t> &media_ids,
    const std::map<std::string, std::string> &carrier) {

  // ----- Metrics: start timing and increment counter -----
  auto meter = GetMeter();
  // Create (or retrieve) instruments—static so they are created only once.
  static auto request_counter = meter->CreateUInt64Counter("compose_media.requests");
  static auto latency_histogram = meter->CreateDoubleHistogram("compose_media.latency_ms");

  auto start_time = std::chrono::steady_clock::now();
  request_counter->Add(1, {
      {"operation", "ComposeMedia"},
      {"app", "MediaService"}
  });
  // ----- Metrics -----
  
  // Initialize a span
  TextMapReader reader(carrier);
  std::map<std::string, std::string> writer_text_map;
  TextMapWriter writer(writer_text_map);
  auto parent_span = opentracing::Tracer::Global()->Extract(reader);
  auto span = opentracing::Tracer::Global()->StartSpan(
      "compose_media_server", {opentracing::ChildOf(parent_span->get())});
  opentracing::Tracer::Global()->Inject(span->context(), writer);

  if (media_types.size() != media_ids.size()) {
    ServiceException se;
    se.errorCode = ErrorCode::SE_THRIFT_HANDLER_ERROR;
    se.message =
        "The lengths of media_id list and media_type list are not equal";
    throw se;
  }

  for (int i = 0; i < media_ids.size(); ++i) {
    Media new_media;
    new_media.media_id = media_ids[i];
    new_media.media_type = media_types[i];
    _return.emplace_back(new_media);
  }

  span->Finish();

  // ----- Metrics: record latency -----
  auto end_time = std::chrono::steady_clock::now();
  double duration_ms = std::chrono::duration_cast<std::chrono::milliseconds>(end_time - start_time).count();
  
  latency_histogram->Record(duration_ms, {
      {"operation", "ComposeMedia"},
      {"app", "MediaService"}
  }, opentelemetry::context::RuntimeContext::GetCurrent());
  // ----- Metrics -----

}

}  // namespace social_network

#endif  // SOCIAL_NETWORK_MICROSERVICES_SRC_MEDIASERVICE_MEDIAHANDLER_H_
