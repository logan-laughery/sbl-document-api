#!/bin/bash


# View deployment logs at journalctl -S today -f -u githubDeployer.service
/home/logan/.nvm/versions/node/v17.9.0/bin/npm ci --unsafe-perm=true --allow-root
cp sbrDocumentApi.service /etc/systemd/system/sbrDocumentApi.service
systemctl restart sbrDocumentApi

echo $(systemctl status sbrDocumentApi)