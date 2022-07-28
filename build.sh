#!/usr/bin/env bash

version=2.0.17

if [ ! -r ./public ]; then
    mkdir public
fi

if ! asciidoctor --version | grep $version > /dev/null; then
    echo "asciidoctor $version not installed"
    echo "running build via docker..."
    docker run --rm -v "$PWD:/src" -w "/src" asciidoctor/docker-asciidoctor:1.27.0 asciidoctor index.adoc -o public/index.html
    docker run --rm -v "$PWD:/src" -w "/src" asciidoctor/docker-asciidoctor:1.27.0 asciidoctor user_manual/index.adoc -o public/scale-av-user-manual.html -acommitHash=$(git rev-parse --short HEAD) -r asciidoctor-diagram
    docker run --rm -v "$PWD:/src" -w "/src" asciidoctor/docker-asciidoctor:1.27.0 asciidoctor user_manual/index.adoc -o public/scale-av-user-manual.pdf -r asciidoctor-pdf -acommitHash=$(git rev-parse --short HEAD) -r asciidoctor-diagram -b pdf -a pdf-theme=user_manual/theme.yml
else
    echo "asciidoctor $version installed!"
    echo "running build..."
    asciidoctor index.adoc -o public/index.html
    asciidoctor user_manual/index.adoc -o public/scale-av-user-manual.html -acommitHash=$(git rev-parse --short HEAD) -r asciidoctor-diagram
    asciidoctor user_manual/index.adoc -o public/scale-av-user-manual.pdf -r asciidoctor-pdf -acommitHash=$(git rev-parse --short HEAD) -r asciidoctor-diagram -b pdf -a pdf-theme=user_manual/theme.yml
fi

cp -r user_manual/assets/ public/
