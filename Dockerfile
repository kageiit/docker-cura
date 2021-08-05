# Pull base image for building
FROM alpine:latest as builder

# Install packages
RUN apk add --no-cache wget curl jq

# Download latest Cura version.
RUN mkdir -p /tmp
RUN wget --no-check-certificate --content-disposition -O /tmp/Ultimaker_Cura.AppImage `curl --silent "https://api.github.com/repos/ultimaker/cura/releases/latest" | jq -r '.assets[] | select(.name | endswith("AppImage")).browser_download_url'`

# Pull base image for app
FROM jlesage/baseimage-gui:debian-10

# Copy app from builder image
RUN mkdir -p /usr/share/cura
COPY --from=builder /tmp/Ultimaker_Cura.AppImage /usr/share/cura/Ultimaker_Cura.AppImage
RUN chmod a+x /usr/share/cura/Ultimaker_Cura.AppImage

# Create startup script
RUN echo '#!/bin/sh' > /startapp.sh
RUN echo 'exec /usr/share/cura/Ultimaker_Cura.AppImage --appimage-extract-and-run .' >> /startapp.sh

# Maximize Only the Main Window
RUN sed-patch 's/<application type="normal">/<application type="normal" title="Ultimaker Cura">/' /etc/xdg/openbox/rc.xml

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/Ultimaker/Cura/raw/master/icons/cura-128.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Create directories
RUN mkdir /storage
RUN mkdir /output
RUN chmod 777 /output

# Define mountable directories
VOLUME ["/config"]
VOLUME ["/storage"]
VOLUME ["/output"]

# Metadata
LABEL \
      org.label-schema.name="cura" \
      org.label-schema.description="Docker container for Cura" \
      org.label-schema.version="unknown" \
      org.label-schema.vcs-url="https://github.com/kageiit/docker-cura" \
      org.label-schema.schema-version="1.0"
      
# Set the name of the application
ENV APP_NAME="Cura"

# Keep app running
ENV KEEP_APP_RUNNING=1
