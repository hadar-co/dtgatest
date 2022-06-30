#!/bin/zsh

inputfile="$INPUT_FILE"
options="$INPUT_OPTIONS"
isHelmChart=$INPUT_ISHELMCHART
helmArgs="$INPUT_HELMARGUMENTS"

echo "CHECK"
which zsh

which bash

if [ -z "$DATREE_TOKEN" ]; then
    echo "No account token configured, see https://github.com/datreeio/action-datree for instructions"
    exit 1
fi

if [ $isHelmChart ]; then
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | /bin/bash
    helm plugin install https://github.com/datreeio/helm-datree
    
    helm datree test $inputfile $options -- $helmArgs
else
    datree test $inputfile $options  
fi
