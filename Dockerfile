FROM fedora:31

RUN dnf makecache
RUN dnf install -y \
  supermin \
  xz

ADD supermin /supermin

RUN /supermin/build-appliance.sh
