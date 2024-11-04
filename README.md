# Docker Image for SMTP Relay

The image is based on the official Debian 12 (bookworm) image and adds the exim4-deamon-light package. The configuration is changed by the [update-exim4.conf](https://manpages.ubuntu.com/manpages/xenial/man8/update-exim4.conf.8.html) script and defaults to DC_EXIMCONFIG_CONFIGTYPE="internet" to send Email directly over the host. If a relay host is specified then the configuration is switched to DC_EXIMCONFIG_CONFIGTYPE="satellite" and uses the relay host as the smart host.

## Build
```bash
docker buildx build --platform linux/amd64 -t bokazio/smtp-relay:latest .
```

## Environment Variables

All environment variables are optional. But if you specify a RELAY_HOST, then you'll want to also specify the port, username and password otherwise it's unlikely to work!

* MAILNAME: Sets Exim's primary_hostname, which defaults to the hostname of the server.
* RELAY_HOST: The remote SMTP server to use.
* RELAY_PORT: The remote SMTP server port.
* RELAY_USERNAME: Username to authenticate against remote SMTP.
* RELAY_PASSWORD: Password to authenticate against remote SMTP.
* RELAY_NETS: Declare which networks can be used by the smart host, separated by semi-colons.(Default is 10.0.0.0/8;172.16.0.0/12;192.168.0.0/16). You eventually need to adapt this to your network, if you changed the docker network.

## Example Usage

Examples of Basic Usage as a SMTP Relay with the Hostsystem, or as a Smart Host as Docker run commands, as well as docker-compose.yaml examples.

### Docker CLI
```bash
docker run -d --name mail --restart always bokazio/smtp-relay:latest
```

or with SMTP Relay:

```bash
docker run -d --name mail --restart always  \
    -e RELAY_HOST=<mail.smtp.com> \
    -e RELAY_PORT=587 \
    -e RELAY_USERNAME=<username> \
    -e RELAY_PASSWORD=<password> \ 
    bokazio/smtp-relay:latest   
```

### Docker Compose 
```yaml
services:
  mail:
    image: bokazio/smtp-relay:latest
    container_name: mail
    restart: always
    environment:
      RELAY_HOST: ${RELAY_HOST}
      RELAY_PORT: ${RELAY_PORT}
      RELAY_USERNAME: ${RELAY_USERNAME}
      RELAY_PASSWORD: ${RELAY_PASSWORD}
```