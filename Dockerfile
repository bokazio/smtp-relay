# Base Image
FROM debian:bookworm-slim

# Install exim4-deamon-light
RUN set -ex; \
    apt-get update; \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -qq install exim4-daemon-light; \
    apt-get clean

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
EXPOSE 25/tcp
ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "exim", "-bdf", "-v", "-q30m" ]