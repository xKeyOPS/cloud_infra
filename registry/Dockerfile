FROM docker:dind
RUN apk --no-cache add bash
RUN mkdir -p "/etc/docker/certs.d/local.cloud.registry\:5000"

COPY domain.crt /etc/docker/certs.d/local.cloud.registry\:5000/domain.crt
COPY domain.crt /usr/local/share/ca-certificates/domain.crt
RUN update-ca-certificates -f

VOLUME /var/lib/docker
EXPOSE 2375

ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD []
