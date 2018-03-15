# -*- coding: binary -*-
#!/usr/bin/env ruby

require 'zlib'

def load_wav(fname)
  File.read(fname)
end

def find_data_chunk_offset(wav)
  wav.index('data') + 1
end

def get_data_chunk_size(wav)
  data_chunk_offset = find_data_chunk_offset(wav)
  wav[data_chunk_offset, 4].unpack('N').first
end

def extract_data_chunk(wav)
  chunk_offset = find_data_chunk_offset(wav)
  chunk_size = get_data_chunk_size(wav)

  wav[chunk_offset + 4 + 3, chunk_size]
end

wav_fname = ARGV.shift
output = ARGV.shift

wav = load_wav(wav_fname)
data_chunk = extract_data_chunk(wav)
data_chunk = Zlib::Inflate.inflate(data_chunk)

File.open(output, 'wb') do |f|
  f.write(data_chunk)
end

puts "#{output} written"
