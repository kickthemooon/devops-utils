ARG AWSCLI_VERSION="2.9.0"

FROM amazon/aws-cli:$AWSCLI_VERSION

ARG JQ_VERSION="1.6"
ARG YQ_VERSION="4.30.4"
ARG HELM_VERSION="3.10.0"
ARG KUBECTL_VERSION="1.23.14"
ARG TERRAFORM_VERSION="1.3.5"

RUN echo "jq: ${AWSCLI_VERSION}" && \
    echo "jq: ${JQ_VERSION}" && \
    echo "yq: ${YQ_VERSION}" && \
    echo "kubectl: ${KUBECTL_VERSION}" && \
    echo "helm: ${HELM_VERSION}" && \
    echo "terraform: ${TERRAFORM_VERSION}"

RUN yum update && yum install -y \
  curl \
  unzip \
  gzip \
  tar.x86_64 \
  wget \
  && yum clean all

# install jq
RUN curl -L "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" \
    -o /usr/local/bin/jq \
    && chmod +x /usr/local/bin/jq

# install yq
RUN curl -L "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64" \
    -o /usr/local/bin/yq \
    && chmod +x /usr/local/bin/yq

# install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin/kubectl

# install terraform
RUN curl -L "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
  -o terraform.zip \
  && unzip terraform.zip \
  && chmod +x ./terraform \
  && mv ./terraform /usr/local/bin/terraform \
  && rm terraform.zip

# install helm
RUN curl -L "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" -o helm.tar.gz \
  && mkdir ./helm \
  && tar -zxvf helm.tar.gz -C ./helm \
  && chmod +x ./helm/linux-amd64/helm \
  && mv ./helm/linux-amd64/helm /usr/local/bin/helm \
  && rm -rf ./helm helm.tar.gz

WORKDIR /workspace

ENTRYPOINT []
