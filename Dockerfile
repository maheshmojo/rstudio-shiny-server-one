FROM ubuntu:20.04 AS rocker

RUN apt-get update && apt-get install -y 

FROM rocker/tidyverse 

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
    gnupg
#   aufs-tools \
#   cgroupfs-mount

# RUN wget --no-verbose http://ftp.us.debian.org/debian/pool/main/l/lvm2/libdevmapper1.02.1_1.02.136-1_amd64.deb && \
#    dpkg -i libdevmapper1.02.1_1.02.136-1_amd64.deb && \
#    rm -f libdevmapper1.02.1_1.02.136-1_amd64.deb

# RUN wget --no-verbose http://ftp.us.debian.org/debian/pool/main/libt/libtool/libltdl7_2.4.6-2_amd64.deb && \
#    dpkg -i libltdl7_2.4.6-2_amd64.deb && \
#    rm -f libltdl7_2.4.6-2_amd64.deb

################
# Shiny Server #
################

## Thanks: rocker-org/shiny

## Download and install Shiny Server
RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O shiny-server-latest.deb && \
    gdebi -n shiny-server-latest.deb && \
    rm -f version.txt shiny-server-latest.deb

RUN Rscript -e "install.packages(c('shiny', 'rmarkdown', 'rsconnect'), repos = 'https://cloud.r-project.org/')"

RUN cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/

RUN mkdir /home/rstudio/ShinyApps/

RUN cp -R /usr/local/lib/R/site-library/shiny/examples/* /home/rstudio/ShinyApps/

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
