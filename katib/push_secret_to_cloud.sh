#!/bin/sh
# in actual production this would upload to AWS secret manager. here the vault namespace is a simulation of that.
# you must have the local .env file ready before running this. it's not tracked in git for security reasons.
kubectl --namespace vault create secret generic katib --from-file=.env=.env --dry-run=client -o yaml | kubectl apply -f -