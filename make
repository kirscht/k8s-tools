#!/bin/bash
exit

export TTAG=develop

docker build -t kirscht/k8s-tools:${TTAG} .
docker push kirscht/k8s-tools:${TTAG}
