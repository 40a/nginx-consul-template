FROM nginx:1.7

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq && \
    apt-get -y install wget runit unzip&& \
    rm -rf /var/lib/apt/lists/*

RUN wget --no-check-certificate https://releases.hashicorp.com/consul-template/0.12.1/consul-template_0.12.1_linux_amd64.zip \
    && unzip consul-template_0.12.1_linux_amd64.zip -d /usr/bin \
    && rm consul-template_0.12.1_linux_amd64.zip \
    && mkdir /opt/blue-green \
    && mkdir /etc/nginx/apps.d

COPY nginx.conf /etc/nginx/nginx.conf
COPY web-services.tmpl /web-services.tmpl
COPY nginx.service /etc/service/nginx/run
COPY consul-template.service /etc/service/consul-template/run
COPY consul-template.conf /consul-template.conf
COPY playground-green.tmpl /opt/blue-green/playground-green.tmpl
COPY playground-blue.tmpl /opt/blue-green/playground-blue.tmpl
COPY playground.tmpl /opt/blue-green/playground.tmpl

CMD ["/usr/bin/runsvdir", "/etc/service"]

