FROM quay.io/biocontainers/funannotate:1.8.15--pyhdfd78af_2

LABEL MAINTAINER "Tom Harrop"
LABEL version=1.8.15

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C
ENV GENEMARK_PATH=/usr/local/opt/genemark
ENV PATH="${PATH}:/usr/local/opt/genemark"

# download genemark and fix shebangs
COPY    genemark_download.sh /usr/local/opt/genemark_download.sh
WORKDIR /usr/local/opt

RUN     bash genemark_download.sh && \
        rm genemark_download.sh && \
        find genemark -name "*.pl" -type f \
            -exec perl -i -0pe 's/^#\!.*perl.*/#\!\/usr\/bin\/env perl/g' {} +

ENTRYPOINT ["/usr/local/bin/funannotate"]
