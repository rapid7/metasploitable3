mkdir "%ProgramFiles%\jmx"
copy C:\vagrant\resources\jmx\Hello.class "%ProgramFiles%\jmx"
copy C:\vagrant\resources\jmx\HelloMBean.class "%ProgramFiles%\jmx"
copy C:\vagrant\resources\jmx\SimpleAgent.class "%ProgramFiles%\jmx"
copy C:\vagrant\resources\jmx\jmx.exe "%ProgramFiles%\jmx"
copy C:\vagrant\resources\jmx\start_jmx.bat "%ProgramFiles%\jmx"
cmd /c ""C:\Program Files\7-Zip\7z.exe" x "C:\vagrant\resources\jmx\jdk1.6.zip" -o"C:\Program Files\Java""
"%ProgramFiles%\jmx\jmx.exe" -Service Install
cacls "C:\Program Files\jmx" /t /e /g Everyone:f