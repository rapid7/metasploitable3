copy /Y C:\Vagrant\resources\rails_server\Gemfile "C:\Program Files\Rails_Server"
cd "C:\Program Files\Rails_Server"
gem install bundler -v '1.17.3' --no-document
bundle install
