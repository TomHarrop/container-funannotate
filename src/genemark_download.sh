#!/usr/bin/env bash

set -eux

wget 'https://exon.gatech.edu/GeneMark/license_download.cgi' \
  --post-data='program=gmes&os=linux64_4&name=https%3A%2F%2Fbit.ly%2F2GAQMGz&institution=na&address=&city=&state=&country=na&email=na%40na.com&submit=I+agree+to+the+terms+of+this+license+agreement'

bin_url="$(grep -o 'http://[^ ]*linux_64_4\.tar\.gz' license_download.cgi)"
url32="$(grep -o 'http://[^ ]*gm_key\.gz' license_download.cgi)"
url64="${url32/gm_key_32/gm_key_64}"
wget -O "genemark.tar.gz" "${bin_url}"
mkdir genemark
tar -zxf genemark.tar.gz \
    -C genemark \
    --strip-components 1
rm -f genemark.tar.gz
cd genemark || exit 1
wget "${url32}"
wget "${url64}"
gunzip *.gz
cd .. || exit 1
rm license_download.cgi
