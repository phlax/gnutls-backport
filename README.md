# gnutls-backport

Backport recipe for `gnutls` packages for Debian Buster

If you are not sure if you need this, then you probably dont 8/

## Building

Building requires `docker`. The following commands will create a `build` folder containing the built `deb` for `criu`.

This will take some time to build.

```

git clone https://github.com/phlax/gnutls-backport
cd gnutls-backport
make deb

```

## Usage

There are unsigned prebuilt debs available in the docker image `phlax/criu-backport`.

These can be accessed with the following command

```
mkdir gnutls-build
docker run \
	-v `pwd`/gnutls-build:/tmp/build phlax/gnutls-backport \
	bash -c "cp -a /usr/share/gnutls-backport/*deb /tmp/build"

```

The prebuilt debs are useful for testing only.

For production use you are strongly recommended to build your own debs.
