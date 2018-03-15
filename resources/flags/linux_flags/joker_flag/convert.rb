require 'chunky_png'

include ChunkyPNG::Color

# https://gist.github.com/jeffkreeftmeijer/923084
module ChunkyPNG::Color
  def invert(value)
    rgb(MAX - r(value), MAX - g(value), MAX - b(value))
  end
end

source = ARGV.shift
dest = ARGV.shift

# joker-black.png
img = ChunkyPNG::Image.from_file(source)
img.pixels.map! do |p|
  if ChunkyPNG::Color.fully_transparent?(p)
    p
  else
    ChunkyPNG::Color.invert(p)
  end
end

img.save(dest)
