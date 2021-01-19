# base-image

Base docker image for web projects.

## Developing

Make changes then run `docker build .` to build the image locally.

## Releasing

Once your change has landed in master, publish your release by pushing to a branch named `release-{tag}`, where `tag` is the docker base image tag you wish to publish. Dockerhub has an [Automated Build](https://cloud.docker.com/u/uber/repository/docker/uber/web-base-image/builds) that will build & publish base images with the corresponding tag. Release branches are protected by Github to prevent accidental deletion.

If you wish to modify an existing release, make a change to `release-{tag}` and push your changes back to origin.

For our full list of releases, see https://github.com/uber-web/base-image/branches
