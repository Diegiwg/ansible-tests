#!/bin/bash

# source .drop-node.sh

function dropNode() {
    dropNode__nodeName=$1
    "${dropNode__nodeName:?'Please pass a node name as first argument'}"
    
    dropNode__engine=$2
    "${dropNode__engine:?'Please pass a engine name as second argument'}"

    $dropNode__engine rm -f "${dropNode__nodeName}"
}