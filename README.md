# base-image

Base docker image for web projects.

## Publishing images for new Node versions

Run `./publish.sh [base-version]`. This will update the Dockerfile and publish the image to [DockerHub](https://hub.docker.com/r/uber/web-base-image/tags)

For example: `./publish.sh 14.18.0-buster`

Don't forget to commit changes
