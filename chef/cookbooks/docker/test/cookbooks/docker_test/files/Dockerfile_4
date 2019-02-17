# Create a docker image that takes a long time to build

# Centos as a base image. Any should work for the for loop test, but
# CentOS is needed for the yum test.
# Note that pulling the base image will not trigger a
# timeout, regardless of how long it
# takes
FROM centos

# Simply wait for wait for 30 minutes, output a status update every 10 seconds
# This does not appear to trigger the timeout problem
# RUN [ "bash", "-c", "for minute in {1..30} ; do for second in {0..59..10} ; do echo -n \" $minute:$second \" ; sleep 10 ; done ; done" ]

# This triggers the timeout.
# Sleep for 5 minutes, 3 times.
# RUN [ "bash", "-c", "for minute in {0..10..5} ; do echo -n \" $minute \" ; sleep 300 ; done" ]

# Let's try this next.
# Sleep for 1 minutes, 15 time
RUN [ "bash", "-c", "for minute in {0..15} ; do echo -n \" $minute \" ; sleep 60 ; done" ]

# This should trigger the timeout unless you have a very fast Internet connection.
# RUN \
   # curl -SL https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -o epel.rpm \
   # && yum install -y epel.rpm \
   # && rm epel.rpm \
   # && yum install -y \
          # zarafa \
          # supervisor \
   # && yum clean all \
   # && rm -rf /usr/share/man /etc/httpd/conf.d/ssl.conf

