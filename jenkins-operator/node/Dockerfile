FROM jenkins/inbound-agent
USER root
RUN apt-get update && apt-get install -y curl
RUN curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
RUN install skaffold /usr/local/bin
USER jenkins
ENTRYPOINT ["tail", "-f", "/dev/null"]
