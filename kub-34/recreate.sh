#!/bin/bash

NS=logging

delAndRun ()
{
    echo
    echo "# Uninstall $1"
    echo
    helm -n $NS uninstall $1
    echo
    echo "# Install $1"
    echo
    helm -n $NS upgrade --install $1 -f ./values.$1.dev.yaml ./$1
}

delAndRun elasticsearch
delAndRun fluent-bit
delAndRun kibana

echo; echo "# Helm list"; echo
helm -n $NS list

echo; echo "# Get pod,deploy,pvc,pv"; echo
kubectl -n $NS get pod,deploy,pvc,pv