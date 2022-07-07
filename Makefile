STEAM_USERNAME := ""
STEAM_BETA := ""

DOCKER_COMMAND := "docker"
IMAGE_NAME := "fragsoc/carrier-command"

.PHONY: build clean

build: game_files
	${DOCKER_COMMAND} build -t ${IMAGE_NAME} .

game_files:
	steamcmd \
		+@sSteamCmdForcePlatformType windows \
		+force_install_dir "$(shell pwd -P)/game_files_temp" \
		+login $(STEAM_USERNAME) \
		+app_update 1489630 ${STEAM_BETA} validate \
		+app_update 1007 validate \
		+quit
	mv ./game_files_temp ./game_files

clean:
	rm -rfv ./game_files ./game_files_temp
