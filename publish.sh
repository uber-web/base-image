#!/bin/bash

function run {(
  set -e # `validate` might throw from subshell, bail out if so

  version="${1}"
  validate "${version}"

  curr=$(get_current_version)
  replace "s/FROM node:${curr}/FROM node:${version}/" "$(root)/Dockerfile"

  tag="uber/web-base-image:${version}"
  info "Building ${tag}"
  if ! docker build -q -t "${tag}" $(root)
  then
    throw "Failed to build image ${tag}"
  fi

  info "Publishing ${tag}"
  if ! docker push -q "${tag}"
  then
    throw "Failed to push image ${tag}.\nCheck that you have publish permissions"
  fi
)}



function get_current_version {(
  grep "FROM node:" "$(root)/Dockerfile" | awk '{print $2}' | sed -E 's/node://g'
)}

function validate {(
  version="${1}"

  validate-arg "${version}"
  validate-docker-hub "${version}"
  validate-docker-daemon
)}

function validate-arg {(
  version="${1}"

  if [ -z "${version}" ]
  then
    throw "No version specified. Example usage: ./upgrade-node.sh 14.18.0"
  fi
)}

function validate-docker-hub {(
  version="${1}"

  page=1
  while true 
  do
    # paginate through JSON API until we find either `"name":"${version}"` (found) or `"next":null` (not found)
    json=$(curl -s "https://hub.docker.com/v2/repositories/uber/web-base-image/tags?n=100&page=${page}")
    if echo "${json}" | grep -q "\"name\":\"${version}\""
    then
      throw "Image with version ${version} already exists"
    elif echo "${json}" | grep -q "\"next\":null"
    then
      break
    else
      ((page++))
    fi
  done
)}

function validate-docker-daemon {(
  # validate docker daemon is running so that build and push commands work
  if ! docker ps >/dev/null 2>/dev/null
  then
    throw "Docker Desktop is not running"
  fi
)}



# utils
function root {(
  cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
)}

function info {(
  green="\033[1;32m"
  end="\033[0m"
  echo -e "${green}${1}${end}" 1>&2
)}

function throw {(
  red="\033[1;31m"
  end="\033[0m"
  echo -e "${red}Error: ${1}${end}" 1>&2
  exit 1
)}

function replace {(
  replace="${1}"
  file="${2}"

  case "$(uname -s)" in
    Darwin*) sed -Ei '' "${replace}" "${file}";; # mac sed needs empty arg after -i
    *) sed -Ei "${replace}" "${file}";;
  esac
)}



run "${1}"
