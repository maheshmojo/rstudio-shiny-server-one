FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y  \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    curl \
    libcairo2-dev \
    libxt-dev \
    unp \
    emacs \
    supervisor \
    libfuse-dev \
    gnupg \
    wget


## Download and install Shiny Server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O shiny-server-latest.deb && \
    gdebi -n shiny-server-latest.deb && \
    rm -f version.txt shiny-server-latest.deb


CMD R -e "install.packages(c('shiny', 'rmarkdown', 'rsconnect'), repos = 'https://cloud.r-project.org/')"

EXPOSE 3838 8787

# COPY src/shiny-server.sh /usr/bin/shiny-server.sh
COPY src/shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY src/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

## set directory to `~/ShinyApps`
# RUN yes | /opt/shiny-server/bin/deploy-example user-dirs
# RUN cp -R /usr/local/lib/R/site-library/shiny/examples/* ~/ShinyApps/

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
# CMD ["/init;/usr/bin/shiny-server.sh"]
# CMD ["sh", "-c", "/usr/bin/shiny-server.sh;/init"]
