#!/usr/bin/make -f

SHELL := /bin/bash


debs:
	mkdir -p build
	chmod -R 777 build
	docker run -ti -v `pwd`/build:/home/bob phlax/debian-build bash -c "\
	  sudo apt-get -y -qq build-dep -t sid libgnutls30 \
	  && apt source -t sid libgnutls30 \
	  && sudo apt install -y -qq -t unstable debhelper \
	  && cd gnutls28-*/ \
	  && export DEBFULLNAME=\"Bob the builder\" \
	  && dch --bpo \"Adding backport!\" \
	  && dpkg-buildpackage -us -uc | grep -v libtool"
	docker run -ti -v `pwd`/build:/home/bob phlax/debian-build bash -c "\
	  sudo apt-get -y -qq build-dep -t sid libtasn1-6  \
	  && apt source -t sid libtasn1-6 \
	  && cd libtasn1-*/ \
	  && export DEBFULLNAME=\"Bob the builder\" \
	  && dch --bpo \"Adding backport!\" \
	  && dpkg-buildpackage -us -uc | grep -v libtool"
	docker run -ti -v `pwd`/build:/home/bob phlax/debian-build bash -c "\
	  sudo apt-get -y -qq build-dep -t sid libffi7 \
	  && apt source -t sid libffi7 \
	  && cd libffi-*/ \
	  && export DEBFULLNAME=\"Bob the builder\" \
	  && dch --bpo \"Adding backport!\" \
	  && dpkg-buildpackage -us -uc | grep -v libtool"
	docker run -ti -v `pwd`/build:/home/bob phlax/debian-build bash -c "\
	  sudo apt-get -y -qq build-dep -t sid libp11-kit0 \
	  && apt source -t sid libp11-kit0 \
	  && cd p11-kit-*/ \
	  && export DEBFULLNAME=\"Bob the builder\" \
	  && dch --bpo \"Adding backport!\" \
	  && dpkg-buildpackage -us -uc | grep -v libtool"
	docker run -ti -v `pwd`/build:/home/bob phlax/debian-build bash -c "\
	  sudo apt-get -y -qq build-dep -t sid libhogweed5 \
	  && apt source -t sid libhogweed5 \
	  && cd nettle-*/ \
	  && export DEBFULLNAME=\"Bob the builder\" \
	  && dch --bpo \"Adding backport!\" \
	  && dpkg-buildpackage -us -uc | grep -v libtool"

docker: debs
	docker run --name=gnutls -v `pwd`/build:/tmp/build debian:buster-slim bash -c "\
		ls /tmp/build -lh \
		&& mkdir -p /usr/share/gnutls-backport \
		&& cp -a /tmp/build/* /usr/share/gnutls-backport/ \
		&& apt update \
		&& apt install -y /tmp/build/libtasn1-6_*deb \
		&& apt install -y /tmp/build/libffi7_*deb \
		&& apt install -y /tmp/build/libp11-kit0_*deb \
		&& apt install -y /tmp/build/libnettle7_*deb \
		&& apt install -y /tmp/build/libhogweed5_*deb \
		&& apt install -y /tmp/build/libgnutls30_*deb"
	docker commit gnutls phlax/gnutls-backport

hub-image:
	docker push phlax/gnutls-backport
