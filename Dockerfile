FROM ubuntu as app
RUN apt-get update

RUN apt-get install -y --no-install-recommends \
    git \
    tig \
    vim \
    jq \
    libvips-tools

RUN mkdir /app
WORKDIR /app

RUN --mount=type=bind,source=image_source,target=/image_source vips dzsave  /image_source/veil.tif veil --suffix .jpg[Q=99]

RUN mkdir /openseadragon
WORKDIR /openseadragon

ADD https://github.com/openseadragon/openseadragon/releases/download/v4.1.0/openseadragon-bin-4.1.0.tar.gz /openseadragon
RUN tar -xvf openseadragon-bin-4.1.0.tar.gz
RUN cp /openseadragon/openseadragon-bin-4.1.0/openseadragon.min.js /app/

COPY index.html /app

FROM nginx

COPY --from=app /app /usr/share/nginx/html/