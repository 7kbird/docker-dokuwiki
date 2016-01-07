FROM ubuntu:14.04
MAINTAINER 7kbird <7kbird@gmail.com>

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys E5267A6C && \
    echo 'deb http://ppa.launchpad.net/ondrej/php5/ubuntu trusty main' > /etc/apt/sources.list.d/ondrej-php5-trusty.list && \
    apt-get update && \
    apt-get install -y supervisor nginx php5-fpm php5-gd curl gettext

ENV DOKUWIKI_VERSION 2015-08-10a
ENV MD5_CHECKSUM a4b8ae00ce94e42d4ef52dd8f4ad30fe
ENV TEMPLATE_DIR /var/dokuwiki-template
ENV STORAGE_DIR /var/dokuwiki-storage

RUN mkdir -p /var/www ${TEMPLATE_DIR}/data ${STORAGE_DIR} && \
    cd /var/www && \
    curl -O "http://download.dokuwiki.org/src/dokuwiki/dokuwiki-$DOKUWIKI_VERSION.tgz" && \
    echo "$MD5_CHECKSUM  dokuwiki-$DOKUWIKI_VERSION.tgz" | md5sum -c - && \
    tar xzf "dokuwiki-$DOKUWIKI_VERSION.tgz" --strip 1 && \
    rm "dokuwiki-$DOKUWIKI_VERSION.tgz" && \
    mv /var/www/data/pages ${TEMPLATE_DIR}/data/pages && \
    ln -s ${STORAGE_DIR}/data/pages /var/www/data/pages && \
    mv /var/www/data/meta ${TEMPLATE_DIR}/data/meta && \
    ln -s ${STORAGE_DIR}/data/meta /var/www/data/meta && \
    mv /var/www/data/media ${TEMPLATE_DIR}/data/media && \
    ln -s ${STORAGE_DIR}/data/media /var/www/data/media && \
    mv /var/www/data/media_attic ${TEMPLATE_DIR}/data/media_attic && \
    ln -s ${STORAGE_DIR}/data/media_attic /var/www/data/media_attic && \
    mv /var/www/data/media_meta ${TEMPLATE_DIR}/data/media_meta && \
    ln -s ${STORAGE_DIR}/data/media_meta /var/www/data/media_meta && \
    mv /var/www/data/attic ${TEMPLATE_DIR}/data/attic && \
    ln -s ${STORAGE_DIR}/data/attic /var/www/data/attic && \
    mv /var/www/conf ${TEMPLATE_DIR}/conf && \
    ln -s ${STORAGE_DIR}/conf /var/www/conf

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/*

ENV DOKUWIKI_BUILD_DIR /var/dokuwiki/build 
COPY build/  ${DOKUWIKI_BUILD_DIR}/
RUN chmod +x ${DOKUWIKI_BUILD_DIR}/start.sh

ADD supervisord.conf /etc/supervisord.conf

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
VOLUME ["${STORAGE_DIR}"]

CMD ${DOKUWIKI_BUILD_DIR}/start.sh
