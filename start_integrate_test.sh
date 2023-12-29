#
#  Licensed to the Apache Software Foundation (ASF) under one or more
#  contributor license agreements.  See the NOTICE file distributed with
#  this work for additional information regarding copyright ownership.
#  The ASF licenses this file to You under the Apache License, Version 2.0
#  (the "License"); you may not use this file except in compliance with
#  the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

# helloworld
array+=("helloworld")

# game
#array+=("game/go-server-game")
#array+=("game/go-server-gate")

# config-api
#array=("config-api/rpc/triple") # 404 Not Found
array+=("config-api/configcenter/nacos")
array+=("config-api/configcenter/zookeeper")
array+=("config-api/config-merge")

# error
array+=("error/triple/hessian2")
array+=("error/triple/pb")

# metrics
array+=("metrics")

# direct
array+=("direct")

# filer
array+=("filter/custom")
array+=("filter/token")

# context
array+=("context/dubbo")
array+=("context/triple") # ERROR   proxy_factory/default.go:146    Invoke function error: interface conversion: interface {} is nil, not []string,

# registry
array+=("registry/zookeeper")
array+=("registry/nacos")

# generic
#array+=("generic/default") # illegal service type registered

# rpc
array+=("rpc/dubbo")
#array+=("rpc/triple/codec-extension")
array+=("rpc/triple/hessian2")
#array+=("rpc/triple/msgpack")
array+=("rpc/triple/pb/dubbogo-grpc")
#array+=("rpc/grpc")
array+=("rpc/jsonrpc")
array+=("rpc/triple/pb2")

# tls
#array+=("tls/dubbo")# tls.LoadX509KeyPair(certs{../../../x509/server1_cert.pem}, privateKey{../../../x509/server1_key.pem}) = err:open ../../../x509/server1_cert.pem: no such file or directory
#array+=("tls/triple")# tls.LoadX509KeyPair(certs{../../../x509/server1_cert.pem}, privateKey{../../../x509/server1_key.pem}) = err:open ../../../x509/server1_cert.pem: no such file or directory
#array+=("tls/grpc")# tls.LoadX509KeyPair(certs{../../../x509/server1_cert.pem}, privateKey{../../../x509/server1_key.pem}) = err:open ../../../x509/server1_cert.pem: no such file or directory

# async
array+=("async")

# polaris
array+=("polaris/registry")
array+=("polaris/limit")

# compatibility
## registry
array+=("compatibility/registry/zookeeper")
array+=("compatibility/registry/nacos")
array+=("compatibility/registry/etcd")
array+=("compatibility/registry/servicediscovery/zookeeper")
array+=("compatibility/registry/servicediscovery/nacos")
array+=("compatibility/registry/all/zookeeper")
array+=("compatibility/registry/all/nacos")

# replace tls config
echo "The prefix of certificate path of the following files were replaced to \"$(pwd)/tls\"."
find $(pwd)/tls -type f -name '*.yml' -print0 | xargs -0 -n1
find $(pwd)/tls -type f -name '*.yml' -print0 | xargs -0 sed -i  's#\.\.\/\.\.\/\.\.#'"$(pwd)/tls"'#g'

DOCKER_DIR=$(pwd)/integrate_test/dockercompose
docker-compose -f $DOCKER_DIR/docker-compose.yml up -d
bash -f $DOCKER_DIR/docker-health-check.sh
for ((i=0;i<${#array[*]};i++))
do
	./integrate_test.sh "${array[i]}"
	result=$?
	if [ $result -gt 0 ]; then
	      docker-compose -f $DOCKER_DIR/docker-compose.yml down
        exit $result
	fi
done
docker-compose -f $DOCKER_DIR/docker-compose.yml down
