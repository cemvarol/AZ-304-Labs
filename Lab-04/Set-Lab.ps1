Set-NetFirewallProfile -Enabled False


$url1 = "https://raw.githubusercontent.com/cemvarol/DC/master/ChromeInstall.ps1"
$output1 = "$env:USERPROFILE\downloads\ChromeInstall.ps1"
Invoke-WebRequest -Uri $url1 -OutFile $output1

$url2 = "https://raw.githubusercontent.com/cemvarol/AZ-304-Labs/master/Lab-04/InstallDC.ps1"
$output2 = "$env:USERPROFILE\desktop\InstallDC.ps1"
Invoke-WebRequest -Uri $url2 -OutFile $output2

$url3 = "https://raw.githubusercontent.com/cemvarol/DC/master/50-ADUsers.ps1"
$output3 = "$env:USERPROFILE\desktop\50-ADusers.ps1"
Invoke-WebRequest -Uri $url3 -OutFile $output3

Start-Sleep -s 3

Start-Process Powershell.exe -Argumentlist "-file $output1"

Start-Sleep -s 30

Start-Process Powershell.exe -Argumentlist "-file $output2"


