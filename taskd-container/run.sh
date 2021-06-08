#! /bin/sh

echo "started run.sh"
echo "taskdata = ${TASKDDATA}"

echo "printing environment with task in the name"
env | grep -i task

TASKD_PKI_ROOT=$TASKD_PKI_ROOT || "/usr/share/"
echo "got $TASKD_PKI_ROOT for pki root"

echo "checking for taskdata"
# If no config file found, do initial config
if ! test -e ${TASKDDATA}/config; then
    echo "${TASKDDATA}/config not found"
    # Create directories for log and certs
    mkdir -p ${TASKDDATA}/log ${TASKDDATA}/pki

    # Init taskd and configure log
    taskd init
    taskd config --force log ${TASKDDATA}/log/taskd.log

    # Copy tools for certificates generation and generate it
    cp $TASKD_PKI_ROOT/taskd/pki/generate* ${TASKDDATA}/pki
    cp $TASKD_PKI_ROOT/taskd/pki/vars ${TASKDDATA}/pki
    cd ${TASKDDATA}/pki
    ./generate
    cd /

    # Configure taskd to use this newly generated certificates
    taskd config --force client.cert ${TASKDDATA}/pki/client.cert.pem
    taskd config --force client.key ${TASKDDATA}/pki/client.key.pem
    taskd config --force server.cert ${TASKDDATA}/pki/server.cert.pem
    taskd config --force server.key ${TASKDDATA}/pki/server.key.pem
    taskd config --force server.crl ${TASKDDATA}/pki/server.crl.pem
    taskd config --force ca.cert ${TASKDDATA}/pki/ca.cert.pem

    # And finaly set taskd to listen in default port
    taskd config --force server 0.0.0.0:53589
fi

APPS=( taskd tar rsync )
echo "checking for apps: ${APPS[*]}"
for app in "${APPS[@]}"
do
    if ! command -v $app &> /dev/null; then
        echo "$app not found"
    fi
done

echo "attempting taskd server --data ${TASKDDATA}"
exec taskd server --data ${TASKDDATA}
