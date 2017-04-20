#!/bin/sh

cd /opt/readme_app
bundle install
rails s -b 0.0.0.0 -p 3500
