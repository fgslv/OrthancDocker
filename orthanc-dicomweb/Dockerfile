FROM debian:stable-slim

WORKDIR /root/

COPY ./setup-locales.sh ./setup-locales.sh
RUN bash ./setup-locales.sh

COPY ./download-orthanc.sh ./download-orthanc.sh
RUN bash ./download-orthanc.sh

ADD ./download-plugins.sh ./download-plugins.sh
RUN bash ./download-plugins.sh

RUN rm ./download-plugins.sh

COPY ./create-config.sh ./create-config.sh
RUN bash ./create-config.sh

RUN rm ./setup-locales.sh ./download-orthanc.sh ./create-config.sh

VOLUME [ "/var/lib/orthanc/db" ]
EXPOSE 4242
EXPOSE 8042

ENTRYPOINT [ "Orthanc" ]
CMD [ "/etc/orthanc/" ]
