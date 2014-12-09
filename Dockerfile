FROM registry.service.altiscale.com:443/prometheus-6.5.7-201409302345
RUN wget http://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.gz
RUN wget http://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.gz.sig
RUN tar xfz autoconf-latest.tar.gz
WORKDIR /autoconf-2.69/
RUN ./configure
RUN make
RUN make install
RUN make check
COPY ovs /root/ovs
WORKDIR /root/ovs
RUN yum install -y gcc make python-devel openssl-devel kernel-devel graphviz kernel-debug-devel autoconf automake rpm-build redhat-rpm-config libtool
RUN ./boot.sh
RUN ./configure
RUN make dist
RUN mkdir -p /rpmbuild/SOURCES
RUN cp openvswitch-*.tar.gz /rpmbuild/SOURCES
RUN tar xzf ./openvswitch-*.tar.gz
WORKDIR /root/ovs/openvswitch-2.3.0
RUN pwd
RUN rpmbuild -bb --without check rhel/openvswitch.spec
#RUN sed -i 's/14;/16;/g' ./configure
#RUN yum -y install kexec-tools crash kernel-debug
#RUN rpmbuild -bb -D "kversion 3.15.5-15.alti6.x86_64" -D "kflavors default debug kdump" rhel/openvswitch-kmod-rhel6.spec
