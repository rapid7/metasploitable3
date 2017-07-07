#!/usr/bin/env ruby

require 'chunky_png'
require 'base64'

FAKEPNG   = 'fake.png'
SOURCEPNG = 'source.png'
OUTPNG    = 'q_of_hearts.png'

puts "[*] Injecting Q of Hearts data into #{FAKEPNG}..."
source = File.read(SOURCEPNG)
b64 = Base64.strict_encode64(source)
img = ChunkyPNG::Image.from_file(FAKEPNG)
img.metadata['q_of_hearts'] = b64
img.save(OUTPNG)

puts "Done"
