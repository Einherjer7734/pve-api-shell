#!/bin/env bash

# Load Config
source ./pve.conf

func_change_vm_status () {
    curl --silent --insecure --header "Authorization: PVEAPIToken=$(<token)" -X POST \
        $URL/api2/json/nodes/$NODE/qemu/$VM/status/$CMD
}

func_get_vm_status () {
    curl --silent --insecure --header "Authorization: PVEAPIToken=$(<token)" \
        $URL/api2/json/nodes/$NODE/qemu/$VM/status/current \
        | jq --raw-output '.data.status'
}

usage () {
    echo "Usage: "
    echo "pve_vm_status.sh <vm id> <start|stop|shutdown|reboot|current> [<URL> <node>]" 
    echo "<URL>: URL to PVE e.g. https://pve.example.com:8006"
    echo "<NODE>: Name of the PVE Node e.g. PVE01"
}

VM=""
CMD=""

if [ $# -lt 2 ]; then
    echo "Not enough arguments!"
    usage
    exit 2
else
    VM=$1
    C=$2
    case ${C} in 
        start)
            CMD="start"
            ;;
        stop)
            CMD="stop"
            ;;
        shutdown)
            CMD="shutdown"
            ;;
        reboot)
            CMD="reboot"
            ;;
        current)
            CMD="current"
            ;;
        *)
            echo "This is not a valid option!"
            echo "Use start|stop|shutdown|reboot as cmd"
            exit 2
            ;;
    esac

    # Override optional parameters, normally configured in config file
    [ $# -ge 3 ] && URL=$3
    [ $# -ge 4 ] && NODE=$4
fi

ERROR=0
if [ "${URL}" = "" ]; then 
    echo "Must provide a adress/URL"
    ERROR=1
elif [ "${NODE}" = "" ]; then
    echo "Must provide the PVE Node"
    ERROR=1
elif [ "${VM}" = "" ]; then
    echo "Must provide the VM Id"
    ERROR=1
elif [ "${CMD}" = "" ]; then
    echo "Must provide the cmd for the VM"
    ERROR=1
fi

if [ $ERROR -gt 0 ]; then
    usage
    exit 2
elif [ "${CMD}" = "current" ]; then
    echo "Get status of VM $VM@$NODE ($URL)"
    func_get_vm_status
else
    echo "Send cmd $CMD to VM $VM@$NODE $URL"
    func_change_vm_status
fi
