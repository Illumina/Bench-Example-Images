# Bench Console
This repository provides example instructions for building a minimal container image compatible with [Illumina Connected Analytics - Bench](https://developer.illumina.com/illumina-connected-analytics) which enables console access.

## Getting Started

### Prerequisities

In order to build this container you'll need to install docker.

* [OS X](https://docs.docker.com/desktop/install/mac-install/)
* [Linux](https://docs.docker.com/desktop/install/linux/)

### Usage

#### Building

##### x86 architecture

Images can be locally build on x86 architecture using following command:

```shell
docker build -f Dockerfile -t bench-console:1.0 .
```

##### ARM archirecture

Bench only supports x86 architecture infrastructure.
Images can be locally build on ARM architecture using following command:

```shell
docker buildx build --platform linux/amd64 -f Dockerfile -t bench-console:1.0 .
```

#### Uploading

Instructions to upload this image can be found at [link](https://help.ica.illumina.com/home/h-dockerrepository#importing-a-private-image)

## License

This project is licensed under Apache-2.0 - see the [LICENSE](LICENSE) file for details.
