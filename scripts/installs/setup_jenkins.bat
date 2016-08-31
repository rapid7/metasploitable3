mkdir "%ProgramFiles%\jenkins"
copy C:\vagrant\resources\jenkins\jenkins.war "%ProgramFiles%\jenkins"
copy C:\vagrant\resources\jenkins\jenkins.exe "%ProgramFiles%\jenkins"
"%ProgramFiles%\jenkins\jenkins.exe" -Service Install