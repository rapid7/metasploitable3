chocolatey feature enable -n=allowGlobalConfirmation
choco install tomcat --version 8.0.33
chocolatey feature disable -n=allowGlobalConfirmation
exit
