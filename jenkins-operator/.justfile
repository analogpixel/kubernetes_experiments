# https://github.com/casey/just

default:
  just --list

alias bc := build_cluster
alias dc := delete_cluster

install_jenkins_operator:
  kubectl --context kind-kind apply -f https://raw.githubusercontent.com/jenkinsci/kubernetes-operator/master/config/crd/bases/jenkins.io_jenkins.yaml 
  kubectl --context kind-kind apply -f https://raw.githubusercontent.com/jenkinsci/kubernetes-operator/master/deploy/all-in-one-v1alpha2.yaml
  kubectl --context kind-kind apply -f ~/github_secret.yml
  kubectl --context kind-kind apply -f manifests/confgimap-config-as-code.yml
  kubectl --context kind-kind apply -f manifests/jenkins-operator-config.yml
  kind get_jenkins_secrets

get_jenkins_secrets:
  @echo "---"
  kubectl --context kind-kind get secret jenkins-operator-credentials-example -o 'jsonpath={.data.user}' | base64 -d
  @echo "\n---"
  kubectl --context kind-kind get secret jenkins-operator-credentials-example -o 'jsonpath={.data.password}' | base64 -d
  @echo "\n---"

delete_cluster:
  kind delete cluster
  docker kill kind-registry
  docker rm kind-registry

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

