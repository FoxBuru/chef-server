FROM 		centos:centos6
MAINTAINER 	Iván De Gyves <fox@foxburu.mx>

VOLUME  	["/var/opt/chef-server"]

RUN 		yum -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

WORKDIR 	/root

RUN 		curl -L -o chef-server-core-11.1.5-1.el5.x86_64.rpm "https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-server-11.1.5-1.el6.x86_64.rpm"

RUN 		yum -y install /root/chef-server-core-11.1.5-1.el5.x86_64.rpm

RUN 		yum -y install supervisor

WORKDIR 	/

COPY 		supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY 		chef-check-hostname /usr/sbin/chef-check-hostname

RUN 		chmod +x /usr/sbin/chef-check-hostname
RUN 		ln -sf /bin/true /sbin/initctl

RUN 		/opt/chef-server/embedded/bin/runsvdir-start & \
		chef-server-ctl reconfigure && \
		chef-server-ctl stop

EXPOSE 		80 443

CMD 		["/usr/bin/supervisord -f /etc/supervisor/conf.d/supervisord.conf"
