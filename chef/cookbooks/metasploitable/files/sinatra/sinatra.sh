#! /bin/sh
### BEGIN INIT INFO
# Provides: sinatra
# Required-Start: $remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Sinatra
# Description: This file starts the sinatra service
# 
### END INIT INFO

case "$1" in
 start)
   /opt/sinatra/start.rb
   ;;
 *)
   echo "Usage: start {start}" >&2
   exit 3
   ;;
esac
