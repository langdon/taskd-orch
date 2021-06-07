#! /bin/sh

echo "started run.sh"
echo "taskdata = ${TASKDDATA}"
echo "attempting taskd server --data ${TASKDDATA}"
exec taskd server --data ${TASKDDATA}
