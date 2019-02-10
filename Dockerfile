# Download base image centos 7
FROM centos:7

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql && useradd -r -g mysql mysql

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install necessary repos and clean up after we're done
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum update -y && yum clean all

# Make sure that all necessary packages are installed and ready for use
RUN yum-config-manager --enable remi-php72   [Install PHP 7.2]
RUN yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo nginx httpd httpd-tools mariadb-server

# Start Apache HTTPD Service
EXPOSE 80
ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
#CMD ["sh", "-c", "/usr/sbin/httpd", "-D", "FOREGROUND"]

# Place VOLUME statement below changes to /var/lib/mysql
VOLUME /var/lib/mysql

# Start MariaDB Service
EXPOSE 3306
#CMD ["/usr/bin/mysqld_safe"]
