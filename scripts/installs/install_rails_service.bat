copy C:\Vagrant\resources\rails_server\start_rails_server.bat "C:\Program Files\Rails_Server"
schtasks /create /tn "rails" /tr "\"cmd.exe\" /c \"C:\Program Files\Rails_Server\start_rails_server.bat\"" /sc onstart /NP /ru "SYSTEM"
