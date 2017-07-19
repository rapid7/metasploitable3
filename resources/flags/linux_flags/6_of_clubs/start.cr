io = IO::Memory.new
Process.run("cd /opt/sinatra && bundle install", shell: true)
code = %{require 'obfuscate'; Obfuscate.setup { |c| c.salt = 'sinatra'; c.mode = :string }; code = Obfuscate.clarify(File.read('.server')); eval(code)}
Process.run("cd /opt/sinatra && ruby -e \"#{code}\"", shell: true)
