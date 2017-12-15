#!/usr/bin/env ruby

# gem install zxing
require 'zxing'
require 'fileutils'

# Installing rmagick is weird.
# Do:
# brew install imagemagick
# brew unlink imagemagick
# brew install imagemagick@6 && brew link imagemagick@6 --force
# gem install rmagick
#
# https://stackoverflow.com/questions/39494672/rmagick-installation-cant-find-magickwand-h
require 'Rmagick'
include Magick

class CardExtractor

  TEMPPATH = File.expand_path(File.join(__FILE__, '..', '.temp'))

  def initialize(gif_path)
    make_temp_folder
    @frames = Image.read(gif_path)
  end

  def print_status(msg='')
    puts "[*] #{msg}"
  end

  def make_temp_folder
    Dir.mkdir(TEMPPATH) unless Dir.exists?(TEMPPATH)
  end

  def clear
    FileUtils.rm_rf(TEMPPATH) if Dir.exists?(TEMPPATH)
  end

  def extract
    s = ''
    print_status("Extracting #{@frames.length} frames...")
    count = 0
    @frames.each do |frame|
      count += 1
      path = File.join(TEMPPATH, "qr#{count}.png")
      frame.write(path)
      qr = convert_qr_to_text(path).strip
      print_status("Decoded #{File.basename(path)}: #{qr}")
      s << qr if qr && !qr.empty?
    end

    File.open('your_zip_hint.png', 'wb') { |f| f.write([s].pack('H*')) }
  end

  def convert_qr_to_text(path)
    ZXing.decode(path)
  end
end

def main
  gif_path = ARGV.shift
  if gif_path.nil? || gif_path.empty?
    puts "[x] Please specify a source GIF file"
    return
  end

  ext = CardExtractor.new(gif_path)
  begin
    ext.extract
  ensure
    ext.clear
  end
end

if __FILE__ == $PROGRAM_NAME
  main
end
