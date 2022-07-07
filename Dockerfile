FROM fragsoc/steamcmd-wine-xvfb
# Maintainer: Laura Demkowicz-Duffy <dev@demkowiczduffy.co.uk>

ARG UID=999
ARG GID=999

ENV CONFIG_LOC="/config"
ENV LOG_LOC="/logs"
ENV INSTALL_LOC="/carriercommand"
ENV HOME=${INSTALL_LOC}
ENV DEBIAN_FRONTEND="noninteractive"

USER root

RUN apt update && \
    # Install libsdl, used by steamcmd
    apt install -y --no-install-recommends libsdl2-2.0-0 winbind

# Setup directory structure and user permissions
RUN mkdir -p $INSTALL_LOC && \
    groupadd -g $GID carriercommand && \
    useradd -m -s /bin/false -u $UID -g $GID carriercommand

# Install the carriercommand server
ARG APPID=1489630
ARG STEAM_BETA=""
COPY ./game_files $INSTALL_LOC
COPY ./docker-entrypoint.sh /entrypoint.sh
COPY ./healthcheck.sh /healthcheck.sh
RUN chown -R carriercommand:carriercommand $INSTALL_LOC && \
    chmod +x /entrypoint.sh /healthcheck.sh && \
    ln -s $CONFIG_LOC/server_config.xml $INSTALL_LOC/server_config.xml

# I/O
VOLUME $CONFIG_LOC $LOG_LOC
# We can't do arithmetic here so the ports are hardcoded :(
EXPOSE 25565/udp 25566/udp 25567/udp

# Expose and run
USER carriercommand
WORKDIR $INSTALL_LOC
HEALTHCHECK CMD /healthcheck.sh
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
