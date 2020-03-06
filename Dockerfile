FROM alpine:3.10.1

ENV packer_zip packer_1.3.4_linux_amd64.zip
ENV helm_tgz helm-v2.14.3-linux-amd64.tar.gz
ENV terraform_release 0.12.5
ENV terraform_zip terraform_${terraform_release}_linux_amd64.zip
ENV pkgs git bash ncurses docker-cli python3 ca-certificates openssh groff jq curl make nmap
ENV dev_pkgs python-dev python3-dev musl-dev linux-headers libffi-dev build-base openssl-dev gcc
ENV pip_pkgs ansible awscli s3cmd python-magic ec2instanceconnectcli boto3 pythonwhois ipstack noaa-sdk

ENV kubectx_url https://github.com/ahmetb/kubectx.git

 RUN apk add --update --no-cache git ${pkgs} ${dev_pkgs} && \
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
mv kubectl /bin/kubectl ; chmod a+x /bin/kubectl && \
pip3 --version && \
pip3 install --upgrade pip && \
pip3 --version && \
pip3 install --upgrade ${pip_pkgs} && \
(cd /usr/local/ ; curl -vs https://get.helm.sh/${helm_tgz} | tar -xvzf -) && \
ln -s /usr/local/linux-amd64/helm /usr/local/bin/helm && \
ln -s /usr/local/linux-amd64/tiller /usr/local/bin/tiller && \
git clone ${kubectx_url} /usr/local/.kubectx && \
ln -s /usr/local/.kubectx/kubectx /bin/kubectx && \
ln -s /usr/local/.kubectx/kubens /bin/kubens && \
(cd /usr/local/bin/ ; \
    curl -vs https://releases.hashicorp.com/terraform/${terraform_release}/${terraform_zip} | \
    unzip - ; \
    chmod a+x terraform) && \
apk del ${dev_pkgs} && \
rm -rf /var/cache/apk/* && \
addgroup -S kkirscht && adduser -S kkirscht -G kkirscht -s /bin/bash

# https://kubernetes.io/docs/tasks/tools/install-kubectl/
#RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
#RUN mv kubectl /bin/kubectl ; chmod a+x /bin/kubectl

#RUN pip3 --version
#RUN pip3 install --upgrade pip
#RUN pip3 --version
#RUN pip3 install --upgrade ${pip_pkgs}

# https://helm.sh/docs/using_helm/
#RUN (cd /usr/local/ ; curl -vs https://get.helm.sh/${helm_tgz} | tar -xvzf -)
#RUN ln -s /usr/local/linux-amd64/helm /usr/local/bin/helm
#RUN ln -s /usr/local/linux-amd64/tiller /usr/local/bin/tiller

# https://github.com/ahmetb/kubectx
#RUN git clone ${kubectx_url} /usr/local/.kubectx
#RUN ln -s /usr/local/.kubectx/kubectx /bin/kubectx
#RUN ln -s /usr/local/.kubectx/kubens /bin/kubens

# https://www.terraform.io/downloads.html
#RUN (cd /usr/local/bin/ ; \
#    curl -vs https://releases.hashicorp.com/terraform/${terraform_release}/${terraform_zip} | \
#    unzip - ; \
#    chmod a+x terraform)

#  https://wiki.alpinelinux.org/wiki/Local_APK_cache
#  https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management
#RUN apk del ${dev_pkgs}
# RUN apk -v cache clean
#RUN addgroup -S kkirscht && adduser -S kkirscht -G kkirscht -s /bin/bash

COPY files /
 RUN  chown -R kkirscht:kkirscht /home/kkirscht/ && chmod a+x /home/kkirscht/.bashrc
RUN  echo '[[ -x ${HOME}/.bashrc ]] && . ${HOME}/.bashrc'
