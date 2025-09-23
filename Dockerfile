FROM quay.io/biocontainers/funannotate:1.8.17--pyhdfd78af_3

LABEL MAINTAINER "Tom Harrop"
LABEL version=1.8.17

ENV LC_ALL=C
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="${PATH}:/usr/local/opt/genemark"

# funannotate variables
ENV AUGUSTUS_CONFIG_PATH=/usr/local/config
ENV EVM_HOME=/usr/local/opt/evidencemodeler-1.1.1
ENV GENEMARK_PATH=/usr/local/opt/genemark
ENV PASAHOME=/usr/local/opt/pasa-2.5.3
ENV TRINITYHOME=/usr/local/bin

# download genemark then fix shebangs
COPY    src/genemark_download.sh /usr/local/opt/genemark_download.sh
WORKDIR /usr/local/opt
RUN     bash genemark_download.sh && \
        rm genemark_download.sh && \
        find genemark -name "*.pl" -type f \
        -exec perl -i -0pe 's/^#\!.*perl.*/#\!\/usr\/bin\/env perl/g' {} +

ENTRYPOINT ["/usr/local/bin/funannotate"]
