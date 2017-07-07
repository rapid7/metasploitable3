# -*- coding: binary -*-
#!/usr/bin/env ruby

require 'zlib'

def load_image(fname)
  data = File.read(fname)
  Zlib::Deflate.deflate(data)
end

# http://www-mmsp.ece.mcgill.ca/documents/audioformats/wave/wave.html
def make_wav(data_chunk)
  # 47202 test size
  size = 216 + data_chunk.length
  wav = ''

  # WAV RIFF Header
  wav << 'RIFF'                          # groupID
  wav << [ size ].pack('V')              # WAV Size
  wav << 'WAVE'                          # Riff Type

  # FORMAT CHUNK
  wav << 'fmt '                          # Chunk ID
  wav << [ 18 ].pack('V')                # Chunk Size
  wav << [ 0x06 ].pack('v')              # Format tag
  wav << [ 0x02 ].pack('v')              # Channels
  wav << [ 0x1f40].pack('V')             # Sample per sec
  wav << [ 0x3e80 ].pack('V')            # Average Bytes per sec
  wav << [ 0x02 ].pack('v')              # Block align
  wav << [ 0x08 ].pack('v')              # Bits per sample
  wav << [ 0x00 ].pack('v')

  # Fact Chunk
  wav << 'fact'                          # Chunk ID
  wav << [ 0x04 ].pack('V')              # Chunk size
  wav << [ 0x5bc5 ].pack('V')            # uncompressed size

  # Data chunk
  wav << 'data'                          # Chunk ID
  wav << [ data_chunk.length ].pack('V') # Chunk size
  wav << data_chunk

  # afsp Chunk
  wav << 'afsp'                          # Chunk ID
  wav << [ 73 ].pack('V')                # Chunk size
  wav << 'AFspdate: 2003-01-30 03:28:44 UTC'
  wav << "\x00"
  wav << 'user: kabal@CAPELLA'
  wav << "\x00"
  wav << 'program: CopyAudio'
  wav << [ 0x00 ].pack('v')

  # List chunk
  wav << 'LIST'                          # Chunk ID
  wav << [ 76 ].pack('V')                # Chunk size
  wav << 'INFO'
  # Sub chunk: ICRD
  wav << 'ICRD'                          # Chunk ID
  wav << [ 0x18 ].pack('V')              # Chunk size
  wav << '2003-01-30 03:28:44 UTC'       # Timestamp
  wav << "\x00"
  # Sub Chunk: ISFT
  wav << 'ISFT'                          # Chunk ID
  wav << [ 0x0a ].pack('V')              # Chunk Size
  wav << 'CopyAudio'                     # Value
  wav << "\x00"
  # Sub chunk: ICMT
  wav << 'ICMT'                          # Chunk ID
  wav << [ 0x0e ].pack('V')              # Chunk Size
  wav << 'kabal@CAPELLA'                 # Value
  wav << "\x00"

  wav
end

# 'jack_of_clubs.PNG'
image_fname = ARGV.shift
output = ARGV.shift

zip_image = load_image(image_fname)
wav = make_wav(zip_image)

File.open(output, 'wb') do |f|
  f.write(wav)
end

puts "Imaged zipped in a wav file."
puts "Wav file written to #{output}"
