FROM alpine:3.10.1
RUN apk add --no-cache curl

# https://kubernetes.io/docs/tasks/tools/install-kubectl/
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

RUN mv kubectl /bin/kubectl ; chmod a+x /bin/kubectl
RUN apk add git bash ncurses docker-cli

# https://helm.sh/docs/using_helm/
#RUN (cd /root/ ; curl -LO https://get.helm.sh/helm-v2.14.2-linux-amd64.tar.gz ; tar xf helm-v2.14.2-linux-amd64.tar.gz)
RUN (cd /root/ ; curl -LO https://get.helm.sh/helm-v2.13.1-linux-amd64.tar.gz ; tar xf helm-v2.13.1-linux-amd64.tar.gz)
RUN ln -s /root/linux-amd64/helm /bin/helm
RUN ln -s /root/linux-amd64/tiller /bin/tiller

# https://github.com/ahmetb/kubectx
RUN git clone https://github.com/ahmetb/kubectx.git /root/.kubectx
RUN ln -s /root/.kubectx/kubectx /bin/kubectx
RUN ln -s /root/.kubectx/kubens /bin/kubens

# https://www.terraform.io/downloads.html
RUN (cd /usr/local/bin/ ; \
    curl -LO https://releases.hashicorp.com/terraform/0.12.5/terraform_0.12.5_linux_amd64.zip ; \
    unzip terraform_0.12.5_linux_amd64.zip ; \
    chmod a+x terraform)