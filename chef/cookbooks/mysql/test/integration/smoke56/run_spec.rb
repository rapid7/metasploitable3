# A fully secure / special-charactersy root password:
# MyPa$$wordHas_"Special\'Chars%!

require_relative '../spec_helper'

# Extract version
version = '5.6'
# Client version
check_mysql_client(version)
# Server version
check_mysql_server(version)
# Master slave
check_master_slave
