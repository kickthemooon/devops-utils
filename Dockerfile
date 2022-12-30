ARG AWSCLI_VERSION="2.9.0"

FROM amazon/aws-cli:$AWSCLI_VERSION

RUN yum -y update && yum -y install \
  curl \
  unzip \
  gzip \
  tar.x86_64 \
  wget \
  git \
  && yum clean all \
  && rm -rf /var/cache/yum/*

COPY bin/* /usr/local/bin/
COPY versions.yaml /root/versions.yaml
ENTRYPOINT ["entrypoint"]

# install initial yq for parsing versions.yaml
RUN curl -L "https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_amd64" -o /usr/local/bin/inityq \
    && chmod +x /usr/local/bin/inityq

# install tfenv for managing terraform versions
RUN git clone --depth=1 https://github.com/tfutils/tfenv.git ${HOME}/.tfenv \
    && ln -s "$HOME/.tfenv/bin/tfenv" "/usr/local/bin/tfenv" \
    && ln -s "$HOME/.tfenv/bin/terraform" "/usr/local/bin/terraform"

# install tools based on versions.yaml
RUN install_all

WORKDIR /workspace
