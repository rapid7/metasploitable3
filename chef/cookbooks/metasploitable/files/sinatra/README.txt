==============
Description
==============

This application is vulnerable to a deserialization vulnerability due to a
compromised session secret.

Since this is a custom application, the Metasploitable player is required to
figure out what the secret is (remotely, not through code reading), and write
an exploit from scratch.

For development purposes, you can use the following scripts to test the
vulnerable service:

* check.rb - This will check if the application is vulnerable.
* poc.rb   - This will attempt to exploit the application. It will create a
             file named /tmp/your_id.txt

==============
Usage
==============

To start the vulnerable application, first do:

$ bundle install

And then finally:

$ ruby start.rb

The server should start on port 8181.
