# /bin/bash

apt update
apt install -y wget git build-essential autoconf libtool pkg-config rsync
apt install -y g++-11 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100 && update-alternatives --config g++

# install cmake
CMAKE_VERSION=3.30.5
wget https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION-linux-x86_64.sh
chmod +x cmake-$CMAKE_VERSION-linux-x86_64.sh && bash ./cmake-$CMAKE_VERSION-linux-x86_64.sh
# copy to /usr/local
rsync -av cmake-$CMAKE_VERSION-linux-x86_64/ /usr/local/
cmake --version


# install absl
# ref link: https://abseil.io/docs/cpp/quickstart-cmake.html
cd ~ && git clone https://github.com/abseil/abseil-cpp.git
cd abseil-cpp
mkdir build && cd build
cmake -DABSL_BUILD_TESTING=ON -DABSL_USE_GOOGLETEST_HEAD=ON -DCMAKE_CXX_STANDARD=17 ..
cmake --build . --target all --parallel 4 && cmake --install .

# install protobuf
# ref link: https://github.com/protocolbuffers/protobuf/tree/main/src#protocol-buffers---googles-data-interchange-format
# PROTOBUF_VERSION=v22.5
# cd ~ && git clone -b $PROTOBUF_VERSION https://github.com/protocolbuffers/protobuf.git
cd ~ && git clone https://github.com/protocolbuffers/protobuf.git
cd protobuf && git submodule update --init --recursive
cmake . -DCMAKE_CXX_STANDARD=17 && cmake --build . --parallel 4 && cmake --install .

# it seems that we need also install protobuf library by apt?

# install grpc
# ref link: https://grpc.io/docs/languages/cpp/quickstart/
git clone -b v1.49.1 https://github.com/grpc/grpc.git
cd grpc && git submodule update --init
mkdir -p cmake/build && cd cmake/build && cmake ../.. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_STANDARD=17
make -j4 && make install

# install google-test
# ref link: https://github.com/google/googletest/blob/main/googletest/README.md#generic-build-instructions
GOOGLE_TEST_VERSION=v1.15.2
cd ~ && git clone https://github.com/google/googletest.git -b $GOOGLE_TEST_VERSION
cd googletest && mkdir build && cd build
cmake .. && make -j4 && make install

# install google-benchmark
# ref link: https://github.com/google/benchmark#installation
cd ~ && git clone https://github.com/google/benchmark.git
cd benchmark && mkdir build && cd build
cmake -DBENCHMARK_DOWNLOAD_DEPENDENCIES=on -DCMAKE_BUILD_TYPE=Release .. && make -j4 && make install

# install opentelemetry
# ref link: https://github.com/open-telemetry/opentelemetry-cpp/blob/main/INSTALL.md
cd ~ && git clone --recurse-submodules https://github.com/open-telemetry/opentelemetry-cpp
cd opentelemetry-cpp && mkdir build && cd build
cmake -DWITH_OTLP_GRPC=ON -DCMAKE_CXX_STANDARD=17 .. && make -j4 && make install

# install prequisites of social-network
apt-get install -y libmongoc-1.0-0 libmongoc-dev nlohmann-json3-dev libyaml-cpp-dev libmemcached-dev libopentracing1 curl

# install thrift
# ref link: https://github.com/apache/thrift/tree/master/compiler/cpp#build-thrift-idl-compiler-using-cmake
apt-get install -y automake bison flex libboost-all-dev libevent-dev libssl-dev libtool thrift-compiler libthrift-dev
cd ~ && git clone https://github.com/apache/thrift.git
cd thrift/compiler/cpp && mkdir build && cd build
cmake .. && make -j4 && cmake --install .

# install AMQP-CPP
# ref link: https://github.com/CopernicaMarketingSoftware/AMQP-CPP?tab=readme-ov-file#how-to-install
cd ~ && git clone https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git
cd AMQP-CPP && mkdir build && cd build
cmake .. -DAMQP_CPP_BUILD_EXAMPLES=OFF -DAMQP_CPP_BUILD_TESTS=OFF -DAMQP-CPP_BUILD_SHARED=ON && make -j4 && make install
ln -s /usr/local/lib/libamqpcpp.so /usr/local/lib/libSimpleAmqpClient.so # using libSimpleAmqpClient.so in social-network

# install OpenTracing
# ref link: https://github.com/opentracing/opentracing-cpp?tab=readme-ov-file#compile-and-install
cd ~ && git clone https://github.com/opentracing/opentracing-cpp.git
cd opentracing-cpp && mkdir build && cd build
cmake .. -DBUILD_TESTING=OFF && make -j4 && make install

# install jwt-cpp
# ref link: https://thalhammer.github.io/jwt-cpp/md_docs_2install.html
cd ~ && git clone https://github.com/Thalhammer/jwt-cpp.git
cd jwt-cpp && cmake . && make -j4 && make install

# install hiredis
# ref link: 
cd ~ && git clone https://github.com/redis/hiredis.git
cd hiredis && mkdir build && cd build
# cmake -DBUILD_SHARED_LIBS=OFF -DENABLE_SSL=ON -DENABLE_SSL_TESTS=ON .. && make -j4 && make install
cmake -DENABLE_SSL=ON -DENABLE_SSL_TESTS=ON .. && make -j4 && make install

# install redis-plus-plus
# ref link: 
# REDIS_PLUS_PLUS_VERSION=1.2.3
# cd ~ && git clone -b $REDIS_PLUS_PLUS_VERSION  https://github.com/sewenew/redis-plus-plus.git
cd ~ && git clone https://github.com/sewenew/redis-plus-plus.git
cd redis-plus-plus
sed -i '/Transaction transaction/i\\    ShardsPool* get_shards_pool(){\n        return _pool.get();\n    }\n' \
   src/sw/redis++/redis_cluster.h
mkdir build && cd build
cmake .. && make -j4 && make install

# # build social-network
# cd ~ && git clone https://github.com/eta-zhang/DeathStar.git
# cd DeathStar/socialNetwork && mkdir build && cd build
# cmake -DCMAKE_BUILD_TYPE=Debug .. && make -j4 && make install

cd ~/Social-network && rm -rf build && mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Debug .. && make -j4 && make install