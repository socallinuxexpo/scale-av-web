#!/bin/bash

asciidoctor user_manual/index.adoc -o site/scale18-av-user-manual.pdf -r asciidoctor-pdf -r asciidoctor-diagram -b pdf -a pdf-theme=user_manual/theme.yml

