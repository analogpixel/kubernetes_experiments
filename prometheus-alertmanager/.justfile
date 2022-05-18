default:
  just --list

alias bc := build_cluster
alias dc := delete_cluster

delete_cluster:
  kind delete cluster
  docker kill kind-registry
  docker rm kind-registry

#
# https://prometheus-operator.dev/docs/operator/design/
# https://github.com/prometheus-operator/prometheus-operator
# https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/troubleshooting.md
#
install_operator:
  #!/usr/local/bin/bash
  if [ ! -f bundle.yaml ] 
  then
   wget https://github.com/prometheus-operator/prometheus-operator/releases/download/v0.56.2/bundle.yaml
  fi
  KUBECONFIG=${HOME}/.kind_config
  # apply the rbac config
  kubectl apply --context kind-kind -f manifests/po_rbac.yaml
  # install operator
  kubectl create --context kind-kind -f bundle.yaml
  # install prometheus crd which installs prometheus
  kubectl apply --context kind-kind -f manifests/po_prometheus.yaml

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

