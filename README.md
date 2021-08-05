# Docker Cura
[Cura](https://ultimaker.com/software/ultimaker-cura) in a Docker container

# Docker compose
```
version: '3.8'
services:
  cura:
    image: kageiit/cura:latest
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TZ}
    ports:
      - 5800:5800
    volumes:
      - ./config:/config
      - ./storage:/storage
      - ./output:/output
```
