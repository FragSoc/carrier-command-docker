<div align="center">
  <a href="https://www.carriercommand.com/">
    <img width=100% src="https://cdn.akamai.steamstatic.com/steam/apps/1489630/header_alt_assets_2.jpg?t=1653319934" alt="carrier command 2 banner"/>
  </a>
  <img src="https://img.shields.io/github/license/FragSoc/carrier-command-docker"/>
</div>

---

A [docker](https://www.docker.com/) image for running a dedicated server for the game [Carrier Command 2](https://www.carriercommand.com/).

## Usage

### Quickstart

```bash
git clone https://github.com/FragSoc/carrier-command-docker
cd carrier-command-docker
make STEAM_USERNAME=your_steam_username
docker run -d -p 25565:25565/udp -p 25566:25566/udp -p 25567:25567/udp fragsoc/carrier-command
```

### Building

The image takes several build args, passed with the `BUILD_ARGS` `make` var.

Argument Key | Default Value | Description
---|---|---
`APPID` | `1489630` | The steam appid to install, there's little reason to change this
`STEAM_BETAS` | (Blank) | A string to pass to `steamcmd` to download any beta versions of the game, eg. `-beta mybeta -betapassword letmein`
<!-- `STEAM_EPOCH` | (Blank) | Used to rebuild the image when a new game version is released, retaining the cached `apt` packages etc. Value itself is ignored. When you want to rebuild the image for the latest version of the game, use any unique value (the current timestamp is a good idea). -->
`UID` | `999` | The user ID to assign to the created user within the container
`GID` | `999` | The group ID to assign to the created user's primary group within the container

### Running

The container requires 3 ports, `25565`, `25566` and `25567` over UDP.

There are two volumes; `/config` is where the server expects a [`server_config.xml` file](https://geometa.co.uk/wiki/carrier_command_2/view/dedicated_servers), and `/logs` is where text copies of (stdout) logs are placed.

# Licensing

The few files in this repo are licensed under the AGPL3 license.
However, Carrier Command 2 and it's dedicated server are proprietary software licensed by [Geometa](https://geometa.co.uk/), no credit is taken for their software in this container.
