FROM registry.fedoraproject.org/fedora-minimal
RUN microdnf install -y taskd rsync tar procps vi less which && \
    microdnf -y clean all

COPY run.sh /app/taskd/

# Set the data location
ARG TASKDDATA
ENV TASKDDATA ${TASKDDATA:-/var/taskd}
ENV TASKD_PKI_ROOT ${TASKD_PKI_ROOT:-/usr/share/taskd/pki}

# Configure container
VOLUME ["${TASKDDATA}"]
EXPOSE 53589
ENTRYPOINT ["/app/taskd/run.sh"]
