# Common DevOps utilities in a docker image

## What's inside

- [AWS CLI](https://aws.amazon.com/cli/)
- [Terraform (tfenv)](https://www.terraform.io/)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/)
- [kubectx](https://github.com/ahmetb/kubectx/)
- [kubens](https://github.com/ahmetb/kubectx/)
- [kubeconform](https://github.com/yannh/kubeconform)
- [Helm](https://helm.sh/)
- [JQ](https://stedolan.github.io/jq/)
- [YQ](https://github.com/mikefarah/yq)
- [HCLQ](https://hclq.sh/)

## How to use it

### Add a shortcut

For a shortcut we need to consider aws and kubernetes credentials.  
To avoid typing all that stuff every time, we can add a shell function to our profile:
```
# devops utils
dou() {
  local kube_config_dir="${HOME}/.dou/kube"
  local aws_config_dir="${HOME}/.dou/aws"
  
  # create kube config dir 
  if [ ! -d "${kube_config_dir}" ]; then
    mkdir -p "${kube_config_dir}"
  fi
  
  # create aws config dir 
  if [ ! -d "${aws_config_dir}" ]; then
    mkdir -p "${aws_config_dir}"
  fi
  
  env | grep "DOU_VERSION_" > "${HOME}/.dou/versions.env"
  
  # use -it if intent bash or sh
  docker_interactivity_flags="-i"
  arguments="${@}"
  if [ "${arguments}" = "bash" ] ||
    [ "${arguments}" = "/bin/bash" ] ||
    [ "${arguments}" = "sh" ] ||
    [ "${arguments}" = "/bin/sh" ]; then
    docker_interactivity_flags="-it"  
  fi
  
  # run the image with the command
  docker run --rm ${docker_interactivity_flags} \
    --env-file "${HOME}/.dou/versions.env" \
    -v "${HOME}/.dou/kube:/root/.kube" \
    -v "${HOME}/.dou/aws:/root/.aws" \
    -v "$(pwd):/workspace" \
    kickthemooon/devops-utils \
    $@
}

```

Running this shortcut function creates a configuration directory under:  
```
$HOME/.dou
```
This is used for configuration files of aws, kubectl and others

### Versions

To see installed versions for each tool run:
```
dou info
```
By default, the highest versions are used.  
You can also take a look at [versions.yaml](versions.yaml).

### Change versions

You can change versions by using env variables (`DOU_VERSION_[TOOL_NAME]`):
```
DOU_VERSION_KUBECTL="1.15.3" dou kubectl version --client
```

### Usage examples
```
# jq
cat some.json | dou jq

# yq
cat some.json | dou yq

# helm
dou helm

# terraform
dou terraform

# aws-cli
dou aws

# bash
dou bash

# helm / kubernetes validation
dou helm template app ./chart | dou kubeconform
