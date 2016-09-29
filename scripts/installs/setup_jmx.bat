mkdir "%ProgramFiles%\jmx"
copy C:\vagrant\resources\jmx\Hello.class "%ProgramFiles%\jmx"
copy C:\vagrant\resources\jmx\HelloMBean.class "%ProgramFiles%\jmx"
copy C:\vagrant\resources\jmx\SimpleAgent.class "%ProgramFiles%\jmx"
copy C:\vagrant\resources\jmx\jmx.exe "%ProgramFiles%\jmx"
copy C:\vagrant\resources\jmx\start_jmx.bat "%ProgramFiles%\jmx"
"%ProgramFiles%\jmx\jmx.exe" -Service Install
sc config jmx start= auto
cacls "C:\Program Files\jmx" /t /e /g Everyone:f