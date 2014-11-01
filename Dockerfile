FROM nginx

ADD bin/ /usr/sbin/
ADD static/ /usr/share/nginx/html/

RUN apt-get update &&\
  apt-get upgrade  && \
  apt-get autoremove -y && \
  apt-get autoclean -y && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
  configure-nginx.sh

VOLUME ["/etc/nginx/sites-templates"]
WORKDIR /etc/nginx

ENTRYPOINT ["entrypoint.sh"]
CMD ["nginx"]
