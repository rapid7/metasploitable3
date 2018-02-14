#!/usr/bin/env ruby

require 'chunky_png'
require 'base64'

img_fname = ARGV.shift

if img_fname.nil? || img_fname.empty?
  puts "[*] Please provide a PNG file"
  exit
end

puts "[*] Extracting 5 of Hearts from #{img_fname}..."
img = ChunkyPNG::Image.from_file(img_fname)
five_of_hearts = Base64::strict_decode64(img.metadata['5_of_hearts'])
File.open('real_5_of_hearts.png', 'wb') { |f| f.write(five_of_hearts) }

puts "[*] Done."
