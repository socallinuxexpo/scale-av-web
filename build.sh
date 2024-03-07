#!/usr/bin/env bash

#### set environment variable for project root ####
project_root=$PWD

#### set asciidoctor version ####
version=2.0.17

#### Create dist/ directory, if none exists ####
if [ ! -r ./dist ]; then
    mkdir dist
fi

#### copy contents to dist/ ####
cp index.adoc dist/
cp -r user_manual/ dist/
cp -r user_manual/assets dist/

#### generate config.adoc from config.yaml using jinja2 ####
clitool="jinja2"
cmdargs="-o dist/config.adoc --format yaml templates/config.adoc.jinja2 -D commit_hash=$(git rev-parse --short HEAD) -D commit_date=$(git show -s --format=%cI HEAD) config.yaml"
workdir=$project_root
cmd="$clitool $cmdargs"
podmancmd="podman run --rm -v $workdir:/work -w /work docker.io/roquie/docker-jinja2-cli $cmdargs"
condition="$clitool --version | grep 'v0.8.2'"

if ! eval $condition; then
    echo "generating config.adoc from jinja2 template via podman..."
    cd $project_root
    eval $(echo $podmancmd)
else
    echo "generating config.adoc from jinja2 template..."
    cd $workdir
    eval $cmd
    cd $project_root
fi

#### generate landing page as html ####
clitool="asciidoctor"
cmdargs="index.adoc"
cmd="$clitool $cmdargs"
workdir=$project_root/dist
podmancmd="podman run --rm -v "$workdir:/src" -w "/src" docker.io/asciidoctor/docker-asciidoctor:1.27.0 $cmd"
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
cmdargs="user_manual/index.adoc -o scale-av-user-manual.html -r asciidoctor-diagram"
cmd="$clitool $cmdargs"
workdir=$project_root/dist
podmancmd="podman run --rm -v "$workdir:/src" -w "/src" docker.io/asciidoctor/docker-asciidoctor:1.27.0 $cmd"
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
cmdargs="user_manual/index.adoc -o scale-av-user-manual.pdf -r asciidoctor-pdf -r asciidoctor-diagram -b pdf -a pdf-theme=user_manual/theme.yml"
cmd="$clitool $cmdargs"
workdir=$project_root/dist
podmancmd="podman run --rm -v "$workdir:/src" -w "/src" docker.io/asciidoctor/docker-asciidoctor:1.27.0 $cmd"
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
