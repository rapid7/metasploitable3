mkdir "%ProgramFiles%\jenkins"
copy C:\vagrant\resources\jenkins\jenkins.war "%ProgramFiles%\jenkins"
copy C:\vagrant\resources\jenkins\jenkins.exe "%ProgramFiles%\jenkins"
copy C:\vagrant\resources\jenkins\jenkins.xml "%ProgramFiles%\jenkins"
"%ProgramFiles%\jenkins\jenkins.exe" -Service Install -ServiceName jinkies -ServiceDisplayName "jinkies" -ServiceDescription "jinkies jokies" 
sc config jenkins start= auto