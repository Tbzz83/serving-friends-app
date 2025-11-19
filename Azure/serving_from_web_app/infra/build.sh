#!/bin/bash
usage() {
    echo "Argument -e required"
    exit 1
}

# Check if no arguments are passed
if [ $# -eq 0 ]; then
    usage
fi

while getopts ":e:" opt; do
    case ${opt} in
        e)
            echo "Environment ${OPTARG} selected"
            env=${OPTARG}
            ;;
        :)
            echo "Option -${OPTARG} requires an argument."
            exit 1
            ;;
        ?)
            echo "Invalid option: -${OPTARG}."
            exit 1
            ;;
    esac
done

cd "envs/$env"

# Quick script to automate deploying tf code in correct order
cd vnet
echo "building vnet..."
terraform apply -auto-approve

cd ../sql
echo "building sql db..."
terraform apply -auto-approve

cd ../app
echo "building app..."
terraform apply -auto-approve
