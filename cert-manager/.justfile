default:
  just --list

alias bc := build_cluster
alias dc := delete_cluster

delete_cluster:
  kind delete cluster
  docker kill kind-registry
  docker rm kind-registry

download_cert_manager:
  curl -LO https://github.com/jetstack/cert-manager/releases/download/v1.0.4/cert-manager.yaml

install_cert_manager:
  kind download_cert_manager
  export KUBECONFIG=${HOME}/.kind_config
  kubectl apply -f cert-manager.yaml

create_registry:
  #!/usr/local/bin/bash

  # create registry container unless it already exists
  if ! docker ps | grep kind-registry 
  then
    echo "Creating Local Registry"
    reg_name='kind-registry'
    reg_port='5000'
    running="$(docker inspect -f '{{{{.State.Running}}}}' "${reg_name}" 2>/dev/null || true)"
    if [ "${running}" != 'true' ]; then
      docker run \
        -d --restart=always -p "127.0.0.1:${reg_port}:5000" --name "${reg_name}" \
        registry:2
    fi
  fi
create_cluster:
  kind create cluster --config cluster.yaml

connect_registry:
  docker network connect "kind" "kind-registry"

build_cluster: 
  just create_registry 
  just create_cluster
  just connect_registry

