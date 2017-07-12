==============
Description
==============

This application is vulnerable to a deserialization vulnerability due to a
compromised session secret.

Since this is a custom application, the Metasploitable player is required to
figure out what the secret is (remotely, not through code reading), and write
an exploit from scratch.

==============
Usage
==============

To start the vulnerable application, first do:

$ bundle install

And then finally:

$ ruby start.rb

The server should start on port 8181.
