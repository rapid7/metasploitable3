mkdir "C:\Program Files\Rails_Server"
mkdir "C:\Program Files\Rails_Server\devkit"
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe', 'C:\Program Files\Rails_Server\devkit\devkit.exe')" <NUL
cmd /c ""C:\Program Files\7-Zip\7z.exe" x "C:\Program Files\Rails_Server\devkit\devkit.exe" -o"C:\Program Files\Rails_Server\devkit\""
copy /Y C:\Vagrant\resources\Rails_Server\devkit\dk.rb "C:\Program Files\Rails_Server\devkit"
C:\tools\ruby23\bin\ruby.exe "C:\Program Files\Rails_Server\devkit\dk.rb" init
C:\tools\ruby23\bin\ruby.exe "C:\Program Files\Rails_Server\devkit\dk.rb" install
"C:\Program Files\Rails_Server\devkit\devkitvars.bat"
