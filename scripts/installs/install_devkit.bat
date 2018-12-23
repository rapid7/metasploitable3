mkdir "C:\RubyDevKit"
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe', 'C:\RubyDevKit\devkit.exe')" <NUL
sfx.exe', 'C:\RubyDevKit\devkit.exe')" <NUL
cmd /c ""C:\Program Files\7-Zip\7z.exe" x "C:\RubyDevKit\devkit.exe" -o"C:\RubyDevKit\""
copy /Y C:\Vagrant\resources\Rails_Server\devkit\dk.rb "C:\RubyDevKit"
C:\tools\ruby23\bin\ruby.exe "C:\RubyDevKit\dk.rb" init
C:\tools\ruby23\bin\ruby.exe "C:\RubyDevKit\dk.rb" install
"C:\RubyDevKit\devkitvars.bat"
