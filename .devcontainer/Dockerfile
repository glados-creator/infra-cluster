FROM alpine:latest

# Install dependencies
RUN apk add --no-cache bash curl jq git fish zsh yq

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# Install kube-linter (stackrox/kube-linter)
RUN curl -LO "https://github.com/stackrox/kube-linter/releases/download/v0.8.3/kube-linter-linux.tar.gz" \
    && tar -xzf kube-linter-linux.tar.gz \
    && chmod +x kube-linter \
    && mv kube-linter /usr/local/bin/

# install KPR 
RUN curl -LO "https://github.com/open-policy-agent/conftest/releases/download/v0.69.0/conftest_0.69.0_Linux_x86_64.tar.gz" \
    && tar xzf conftest_0.69.0_Linux_x86_64.tar.gz \
    && chmod +x conftest \
    && mv conftest /usr/local/bin/

WORKDIR /infra-cluster-ct

CMD ["sleep", "infinity"]