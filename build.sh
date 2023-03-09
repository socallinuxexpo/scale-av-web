#!/usr/bin/env bash

#### set environment variable for project root ####
project_root=$PWD

#### set asciidoctor version ####
version=2.0.17

#### Create dist/ directory, if none exists ####
if [ ! -r ./dist ]; then
    mkdir dist
fi

#### generate landing page as html ####
clitool="asciidoctor"
cmdargs="index.adoc -o dist/index.html"
cmd="$clitool $cmdargs"
workdir=$project_root
podmancmd="podman run --rm -v "$PWD:/src" -w "/src" docker.io/asciidoctor/docker-asciidoctor:1.27.0 $cmd"
condition="$clitool --version | grep $version"

if ! eval $condition; then
    echo "asciidoctor $version not installed"
    echo "generating landing page as html via podman..."
    cd $project_root
    eval $(echo $podmancmd)
else
    echo "generating landing page as html..."
    cd $workdir
    eval $cmd
    cd $project_root
fi

#### generate scale av user manual as html ####
clitool="asciidoctor"
cmdargs="user_manual/index.adoc -o dist/scale-av-user-manual.html -acommitHash=$(git rev-parse --short HEAD) -r asciidoctor-diagram"
cmd="$clitool $cmdargs"
workdir=$project_root
podmancmd="podman run --rm -v "$PWD:/src" -w "/src" docker.io/asciidoctor/docker-asciidoctor:1.27.0 $cmd"
condition="$clitool --version | grep $version"

if ! eval $condition; then
    echo "asciidoctor $version not installed"
    echo "generating scale av user manual as html via podman..."
    cd $project_root
    eval $(echo $podmancmd)
else
    echo "generating scale av user manual as html..."
    cd $workdir
    eval $cmd
    cd $project_root
fi

#### generate scale av user manual as pdf ####
clitool="asciidoctor"
cmdargs="user_manual/index.adoc -o dist/scale-av-user-manual.pdf -r asciidoctor-pdf -acommitHash=$(git rev-parse --short HEAD) -r asciidoctor-diagram -b pdf -a pdf-theme=user_manual/theme.yml"
cmd="$clitool $cmdargs"
workdir=$project_root
podmancmd="podman run --rm -v "$PWD:/src" -w "/src" docker.io/asciidoctor/docker-asciidoctor:1.27.0 $cmd"
condition="$clitool --version | grep $version"

if ! eval $condition; then
    echo "asciidoctor $version not installed"
    echo "generating scale av user manual as pdf via podman..."
    cd $project_root
    eval $(echo $podmancmd)
else
    echo "generating scale av user manual as pdf..."
    cd $workdir
    eval $cmd
    cd $project_root
fi

#### copy assets to dist/ ####
cp -r user_manual/assets/ dist/
