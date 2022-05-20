#!/bin/bash

source /home/logan/.nvm/nvm.sh
cd /usr/share/sbr/sbr-document-api
npm run generate
npm run prod-start
