FROM centos

MAINTAINER Rohan

RUN yum install httpd -y

COPY ./index.html /var/www/html

EXPOSE 80

ENTRYPOINT ["/usr/sbin/httpd","-D","FOREGROUND"]



