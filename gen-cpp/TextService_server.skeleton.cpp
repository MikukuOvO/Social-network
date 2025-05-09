// This autogenerated skeleton file illustrates how to build a server.
// You should copy it to another filename to avoid overwriting it.

#include "TextService.h"
#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/server/TSimpleServer.h>
#include <thrift/transport/TServerSocket.h>
#include <thrift/transport/TBufferTransports.h>

using namespace ::apache::thrift;
using namespace ::apache::thrift::protocol;
using namespace ::apache::thrift::transport;
using namespace ::apache::thrift::server;

using namespace  ::social_network;

class TextServiceHandler : virtual public TextServiceIf {
 public:
  TextServiceHandler() {
    // Your initialization goes here
  }

  void ComposeText(TextServiceReturn& _return, const int64_t req_id, const std::string& text, const std::map<std::string, std::string> & carrier) {
    // Your implementation goes here
    printf("ComposeText\n");
  }

};

int main(int argc, char **argv) {
  int port = 9090;
  std::shared_ptr<TextServiceHandler> handler(new TextServiceHandler());
  std::shared_ptr<TProcessor> processor(new TextServiceProcessor(handler));
  std::shared_ptr<TServerTransport> serverTransport(new TServerSocket(port));
  std::shared_ptr<TTransportFactory> transportFactory(new TBufferedTransportFactory());
  std::shared_ptr<TProtocolFactory> protocolFactory(new TBinaryProtocolFactory());

  TSimpleServer server(processor, serverTransport, transportFactory, protocolFactory);
  server.serve();
  return 0;
}

