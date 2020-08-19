chocolatey feature enable -n=allowGlobalConfirmation
choco install jre8 --version 8.0.251
chocolatey feature disable -n=allowGlobalConfirmation
exit
