FROM ubuntu:latest AS build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install build-essential git libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev cmake make wget xz-utils git build-essential libssl-dev openssl -y

RUN git clone https://github.com/irlserver/srt.git 
RUN cd srt

RUN mkdir /out
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr ./srt
RUN make -j
RUN make DESTDIR=/out install


WORKDIR /belacoder
COPY . .

RUN mkdir /bela-out
RUN make -j
RUN make DESTDIR=/bela-out

FROM scratch AS export
COPY --from=build /bela-out /