# base-image

Base docker image for web projects.

## Developing

Make changes then run `docker build .` to build the image locally.

## Releasing

In 2021 Dockerhub disabled automated builds for our current account tier. This means we have to manually grant access to Dockerhub and manually push images. To do so, we first have to build, then push:

```
# Build the docker image
docker build -t <tag> .

# Push the docker image
docker push <tag>

# Exmample with tag:
docker build -t uber/web-base-image:14.18.0-buster .
docker push uber/web-base-image:14.18.0-buster
```
