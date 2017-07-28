#!/usr/bin/env ruby

# This tool is built to create the King of Spades flag, which is placed in a motd file on IRC.
#
# Because IRC has a max size limit of roughly 200kb for MOTD, we need to do some
# modifications to the images, such as resizing, changing the quality, and optimizing to
# keep them under that limit.

# To use image_optimizer, first you need to do this:
# $ brew install optipng jpegoptim gifsicle pngquant
require 'image_optimizer'

require 'fileutils'
require 'zip'
require 'base64'
require 'digest'
require 'mini_magick'
require 'chunky_png'
include ChunkyPNG::Color

FLAGNAME   = 'flag.png'                         # The flag name, which should be used in the CTF
B64NAME    = 'flag_base64.txt'                  # The file name of the Base64 string
CARDNAME   = 'king_of_spades.png'               # The name of the card is the secret ZIP.
WORKFOLDER = 'temp'                             # A temp folder for processing the images
RESOURCES  = ['fake.png', 'king_of_spades.png'] # The source images we want to use

# There is some trial-and-errors involved to determine these two numbers.
# Changing the quality tends to have a bigger size change.
JPGQUALITY = '10'
REIZEPERT  = 0.18


# Resizes the image by reducing a specific percentage.
# The percentage to reduce is set by the RESIZEPERT constant.
def resize_image(img_path)
  img = MiniMagick::Image.open(img_path)
  print_status("Original #{img_path} dimension = #{img.height}x#{img.width}")
  new_width = img.width - (img.width * REIZEPERT).to_i
  new_height = img.height - (img.height * REIZEPERT).to_i
  img = img.resize("#{new_width}x#{new_height}")
  print_status("Resized #{img_path} dimension = #{img.height}x#{img.width}")
  img.write(img_path)
end

# Converts a PNG to JPG.
# The purpose of this is really to lower the quality of the image, which will dramatically
# reduce the size of the image.
def convert_png_to_jpg(img_path)
  print_status("Converting #{img_path} to JPG to reduce image quality to #{JPGQUALITY}")
  basename = File.basename(img_path, '.png')
  img = MiniMagick::Image.open(img_path)
  img.format('JPEG')
  img.quality(JPGQUALITY)
  dst = "#{WORKFOLDER}/#{basename}.jpg"
  img.write(dst)
  dst
end

# Converts a JPG back to PNG.
def convert_jpg_to_png(img_path)
  print_status("Converting #{img_path} back to PNG")
  basename = File.basename(img_path, '.jpg')
  img = MiniMagick::Image.open(img_path)
  img.format('PNG')
  dst = "#{WORKFOLDER}/#{basename}.png"
  img.write(dst)
  dst
end

# Collects the transparent pixel indexes from PNG.
# The purpose of this is because after converting an image to JPG, we lose transparency.
# So before converting to JPG, we need to keep track of where the transparent pixels are,
# and then when we can finally convert these JPGs back to PNGs again, we will need to
# restore these pixels.
def map_transparent_pixels(img_path)
  print_status("Mapping transparent pixels for #{img_path}")
  img = ChunkyPNG::Image.from_file(img_path)

  found_indexes = []
  index = 0
  img.pixels.each do |p|
    found_indexes << index if ChunkyPNG::Color.fully_transparent?(p)
    index += 1
  end

  found_indexes
end

# Optimizes a PNG file.
# There is some voodoo invovled in this optimizer to make a PNG smaller without
# losing quality that our eyes can see.
# @see https://github.com/jtescher/image_optimizer
def optimize(image_path)
  print_status("Optimizing #{image_path}, this may take a while...")
  ImageOptimizer.new(image_path, quiet: true).optimize
end

# Restores the transparent pixels for a PNG file based on a map.
def restore_transparency(img_path, transparency_map)
  print_status("Restoring transparency for #{img_path}")
  img = ChunkyPNG::Image.from_file(img_path)
  transparency_map.each do |i|
    img.pixels[i] = ChunkyPNG::Color::TRANSPARENT
  end
  img.save(img_path)
end

# Zip a file
def zip_file(fname)
  png = File.read(fname)
  zip = Zip::OutputStream.write_buffer(::StringIO.new('')) do |o|
    o.put_next_entry(CARDNAME)
    o.write(png)
  end

  dst = "#{fname}.zip"
  File.write(dst, zip.string)
  dst
end

# Creates a Base64 file for a PNG
def make_base64_file(fname)
  b64 = Base64.strict_encode64(File.read(fname))
  File.write(B64NAME, b64)
  B64NAME
end

# Creates a fake PNG that actually functions like a ZIP file. Once is ZIP file is decompressed,
# there is actually another PNG in it (which in our case, is the flag).
def finalize_king_of_spades(fake_card_path, king_of_spades_path)
  print_status("Creating flag as #{FLAGNAME}")
  zip = zip_file(king_of_spades_path)
  print_status("King of Spades compressed as: #{zip}")
  `cat #{fake_card_path} #{zip} > #{FLAGNAME}`
  FLAGNAME
end

# Initializes our image workspace
def make_work_folder_if_empty
  unless Dir.exists?(WORKFOLDER)
    FileUtils.mkdir_p(WORKFOLDER)
    print_status("Workspace \"#{WORKFOLDER}\" created")
  end
end

# Removes the workspace at the end of the script
def cleanup
  if Dir.exists?(WORKFOLDER)
    FileUtils.remove_dir(WORKFOLDER)
    print_status("Workspace \"#{WORKFOLDER}\" deleted.")
  end
end


# Returns the file size
def get_file_size(img_path)
  File.size(img_path)
end

def print_status(msg='')
  puts "* #{msg}"
end

def init_workspace
  make_work_folder_if_empty
  FileUtils.copy(RESOURCES.first, WORKFOLDER)
  FileUtils.copy(RESOURCES.last, WORKFOLDER)
  @fake_card_path = "#{WORKFOLDER}/#{RESOURCES.first}"
  @king_of_spades_path = "#{WORKFOLDER}/#{RESOURCES.last}"
end

# Returns the MD5 string of a file
def get_md5(fname)
  Digest::MD5.hexdigest(File.read(fname))
end

def fake_card_path
  @fake_card_path
end

def king_of_spades_path
  @king_of_spades_path
end

def process_cards
  resize_image(fake_card_path)
  resize_image(king_of_spades_path)
  fake_png_transparency_map = map_transparent_pixels(fake_card_path)
  king_of_spades_transparency_map = map_transparent_pixels(king_of_spades_path)
  [ fake_card_path, king_of_spades_path ].each do |card_path|
    jpg_path = convert_png_to_jpg(card_path)
    convert_jpg_to_png(jpg_path)
    case card_path
    when fake_card_path
      restore_transparency(card_path, fake_png_transparency_map)
    when king_of_spades_path
      restore_transparency(card_path, king_of_spades_transparency_map)
    end
    optimize(card_path)
  end

  md5 = get_md5(king_of_spades_path)
  print_status("Final King of Spades MD5 hash is: #{md5} (use this on the score server)")

  flag_path = finalize_king_of_spades(fake_card_path, king_of_spades_path)
  print_status("Flag created: #{flag_path} (Size: #{get_file_size(flag_path)} bytes)")

  b64_file = make_base64_file(flag_path)
  print_status("Base64 file for the flag is: #{b64_file} (Size: #{get_file_size(b64_file)} bytes)")
end

def main
  init_workspace
  process_cards
ensure
  cleanup
end

if __FILE__ == $PROGRAM_NAME
  main
end

=begin
Script output:

* Workspace "temp" created
* Original temp/fake.png dimension = 700x500
* Resized temp/fake.png dimension = 574x410
* Original temp/king_of_spades.png dimension = 700x500
* Resized temp/king_of_spades.png dimension = 574x410
* Mapping transparent pixels for temp/fake.png
* Mapping transparent pixels for temp/king_of_spades.png
* Converting temp/fake.png to JPG to reduce image quality to 10
* Converting temp/fake.jpg back to PNG
* Restoring transparency for temp/fake.png
* Optimizing temp/fake.png, this may take a while...
pngquant: unrecognized option `--speed 1'
* Converting temp/king_of_spades.png to JPG to reduce image quality to 10
* Converting temp/king_of_spades.jpg back to PNG
* Restoring transparency for temp/king_of_spades.png
* Optimizing temp/king_of_spades.png, this may take a while...
pngquant: unrecognized option `--speed 1'
* Final King of Spades MD5 hash is: 8fc453ee48180b958f98e0d2d856d1c8 (use this on the score server)
* Creating flag as flag.png
* King of Spades compressed as: temp/king_of_spades.png.zip
* Flag created: flag.png (Size: 150533 bytes)
* Base64 file for the flag is: flag_base64.txt (Size: 200712 bytes)
* Workspace "temp" deleted.
=end
