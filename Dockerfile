FROM phusion/baseimage
MAINTAINER Lars Hoss <lars.hoss@gmail.com>


RUN apt-get update
RUN apt-get install -y libssl-dev build-essential wget libbz2-dev libsqlite3-dev git openssl

RUN mkdir /usr/src/python
WORKDIR /usr/src/python

# http://bugs.python.org/issue19846
ENV LANG C.UTF-8 
ENV PYTHON_VERSION 3.4.2

RUN curl -SL "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz" \
		| tar -xJ --strip-components=1
# skip "test_shutil" thanks to "PermissionError: [Errno 1] Operation not permitted" trying to set xattrs
RUN ./configure \
	&& make -j$(nproc) \
	&& make -j$(nproc) EXTRATESTOPTS='--exclude test_shutil' test \
	&& make install \
	&& make clean


# make some useful symlinks that are expected to exist
RUN cd /usr/local/bin \
	&& ln -s easy_install-3.4 easy_install \
	&& ln -s idle3 idle \
	&& ln -s pip3 pip \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python-config3 python-config

CMD ["python3"]
