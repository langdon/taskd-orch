#! /bin/sh

echo "started run.sh"
echo "taskdata = ${TASKDDATA}"

echo "printing environment"
env

echo "checking for taskdata"
if ! test -e ${TASKDDATA}/config; then
    echo "${TASKDDATA}/config not found"
fi

array=(one two three four)
echo ${array[*]}

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
