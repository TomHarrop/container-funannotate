FROM quay.io/biocontainers/funannotate:1.8.15--pyhdfd78af_2

LABEL MAINTAINER "Tom Harrop"
LABEL version=5bf6256

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C
ENV GENEMARK_PATH=/usr/local/opt/genemark
ENV PATH="${PATH}:/usr/local/opt/genemark"

# Not working. Will need a separate container for emapper. The conda funannotate
# container doesn't have APT.
# RUN     /usr/local/bin/python3 \
#             -m pip install --upgrade \
#             pip \
#             setuptools \
#             wheel && \
#         /usr/local/bin/python3 \
#             -m pip install \
#             git+https://github.com/jhcepas/eggnog-mapper.git@v2.1.11

# download genemark and fix shebangs
WORKDIR /usr/local/opt

RUN     wget -O genemark_download.sh \
            --no-check-certificate \
            https://raw.githubusercontent.com/TomHarrop/funannotate-singularity/master/src/genemark_download.sh && \
        bash genemark_download.sh && \
        rm genemark_download.sh && \
        find genemark -name "*.pl" -type f \
            -exec perl -i -0pe 's/^#\!.*perl.*/#\!\/usr\/bin\/env perl/g' {} +

ENTRYPOINT ["/usr/local/bin/funannotate"]
