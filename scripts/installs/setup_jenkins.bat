mkdir "%ProgramFiles%\jenkins"
copy C:\vagrant\resources\jenkins\jenkins.war "%ProgramFiles%\jenkins"
copy C:\vagrant\resources\jenkins\start_jenkins.bat "%ProgramFiles%\jenkins"
schtasks /create /tn "Jenkins" /tr "\"%ProgramFiles%\jenkins\start_jenkins.bat\"" /sc onstart /np
schtasks /run /tn "Jenkins"