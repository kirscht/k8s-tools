#!/usr/bin/env bash

set -ev

function accounts()
{
    awk '/^\[profile/ {gsub("]","") ; print $2}' ${HOME}/.aws/config | egrep -v 'performance'
}

for account in $(accounts)
do
    export AWS_PROFILE=${account}
    echo $AWS_PROFILE

    cat <<EOD

    Generating reports for account ${AWS_PROFILE}

EOD
#    python3 /usr/local/bin/tags_report.py
    python3 ./tags_report.py --output /tmp/${AWS_PROFILE}
done