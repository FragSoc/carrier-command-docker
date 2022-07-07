FROM steamcmd/steamcmd AS steambuild
# REPO_SETUP: Add maintainers

ARG UID=999
ARG GID=999

ENV CONFIG_LOC="/config"
ENV INSTALL_LOC="/GAME_NAME"
ENV HOME=${INSTALL_LOC}
ENV DEBIAN_FRONTEND="noninteractive"

USER root

# REPO_SETUP: Append any packages that your server needs to the
# REPO_SETUP: `apt install` line.
RUN apt update && \
    # Install libsdl, used by steamcmd
    apt install -y --no-install-recommends libsdl2-2.0-0

# Setup directory structure and user permissions
RUN mkdir -p $INSTALL_LOC && \
    groupadd -g $GID GAME_NAME && \
    useradd -m -s /bin/false -u $UID -g $GID GAME_NAME && \
    mkdir -p $CONFIG_LOC $INSTALL_LOC && \
    chown -R GAME_NAME:GAME_NAME $INSTALL_LOC $CONFIG_LOC

USER GAME_NAME

# REPO_SETUP: You might consider installing steam appid 1007 ("+app_update 1007 validate \")
# REPO_SETUP: alongside your game here if your game needs the steam libraries
# REPO_SETUP: to appear in the server browser etc.

# REPO_SETUP: If your game is windows only, you *might* be able to run it inside a linux container
# REPO_SETUP: with wine and xvfb-run. If so, add a "+@sSteamCmdForcePlatformType windows \"
# REPO_SETUP: line to this steamcmd command, and install xvfb and wine.
# REPO_SETUP: Alternatively, see https://github.com/FragSoc/steamcmd-wine-xvfb-docker;
# REPO_SETUP: you can use this as the base image for this template if you want :)
# REPO_SETUP: (you'll still need that that platform force steamcmd command)

# Install the GAME_NAME server
# REPO_SETUP: Get the appid of the dedicated server from steamdb or similar
ARG APPID=<YOUR APPID HERE>
ARG STEAM_BETA
RUN steamcmd \
        +login anonymous \
        +force_install_dir $INSTALL_LOC \
        +app_update $APPID $STEAM_BETA validate \
        +quit && \
    # REPO_SETUP: you will probably want to symlink the game's default config directory
    # REPO_SETUP: to $CONFIG_LOC here

# I/O
VOLUME $CONFIG_LOC
# REPO_SETUP: Add any ports you might need. Don't forget to append with /udp if necessary

# Expose and run
USER GAME_NAME
WORKDIR $INSTALL_LOC
# REPO_SETUP: Add an entrypoint for the game
