FROM ubuntu:latest AS build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install build-essential git libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev cmake make wget xz-utils git build-essential libssl-dev openssl -y

# belabox patched srt
#
RUN mkdir -p /build; \
	git clone https://github.com/IRLServer/srt.git /build/srt; \
	cd /build/srt; \
	git checkout belabox; \
	cmake -DCMAKE_INSTALL_PREFIX=/usr /build/srt; \
	./configure; \
	make -j${nproc}; \
	make install;

WORKDIR /belacoder
COPY . .

RUN mkdir /bela-out
RUN make
RUN cp ./belacoder /bela-out

FROM scratch AS export
RUN mkdir -p /usr/bin
COPY --from=build /bela-out /usr/bin/