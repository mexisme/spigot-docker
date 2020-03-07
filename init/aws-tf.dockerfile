FROM base:init as download-terraform

ARG TERRAFORM_VERSION=0.12.12

USER root
RUN install-apt-packages unzip || install-apk-packages unzip || install-dnf-packages unzip

# TODO: Can we use a packaged version, instead?
ADD --chown=app:app https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip /app/
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    chmod +x /app/terraform

FROM base:init

USER root

COPY --from=download-terraform /app/terraform /usr/local/bin/

RUN install-apt-packages coreutils git make vim-tiny; \
    install-apk-packages git make vim; \
    install-dnf-packages git make vim

# For running AWS CLI:
RUN install-apt-packages python3-pip jq; \
    install-apk-packages python3 jq git make; \
    install-dnf-packages python3-pip jq git make

USER app

RUN pip3 install --user boto3 --upgrade
RUN pip3 install --user awscli --upgrade

RUN find -H \
      `python3 -c 'import site; print(site.USER_BASE + "/bin")'` \
      -type f -maxdepth 1 \
      -exec ln -sv '{}' ~/bin/ \; ||:
