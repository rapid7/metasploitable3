#!/usr/bin/env ruby

require 'rqrcode'
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

class SevenOfDiamonds

  TEMPPATH = File.expand_path(File.join(__FILE__, '..', '.temp'))

  def initialize
    make_temp_folder
  end

  def make_temp_folder
    Dir.mkdir(TEMPPATH) unless Dir.exists?(TEMPPATH)
  end

  def clear
    FileUtils.rm_rf(TEMPPATH) if Dir.exists?(TEMPPATH)
  end

  def make_flag(source_image_path, out_path)
    bin = File.read(source_image_path)
    h = get_hex(bin)
    generate_qr_codes(h)
    make_gif(out_path)
  end

  def print_status(msg='')
    puts "[*] #{msg}"
  end

  def get_hex(bin)
    h = bin.unpack('H*').first
    print_status("Hex string size: #{h.length}")
    h
  end

  def generate_qr_codes(text)
    str_length = 50
    max_fname_length = (text.length / str_length).round.to_s.length
    counter = 0
    (0..text.length).step(str_length) do |i|
      s = text[i, str_length]
      if !s.nil? && !s.empty?
        counter += 1
        qr = RQRCode::QRCode.new(s)
        File.open(File.join(TEMPPATH, "#{counter.to_s.rjust(max_fname_length, '0')}.png"), 'wb') { |f| f.write(png = qr.as_png) }
        print_status("QR ##{counter} generated: #{s}")
      end
    end
  end

  def make_gif(out_path)
    gif = ImageList.new(*Dir[".temp/*.png"])
    gif.delay = 10
    gif.write(out_path)
    print_status("GIF written as: #{out_path}")
  end

end

if __FILE__ == $PROGRAM_NAME
  source_image_path = 'hint.png'
  out_image_path    = 'hint.gif'
  card = SevenOfDiamonds.new
  begin
    card.make_flag(source_image_path, out_image_path)
  ensure
    card.clear
  end

end
