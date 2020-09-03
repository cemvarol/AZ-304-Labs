install-windowsfeature AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment
$dsrmPassword = (ConvertTo-SecureString -AsPlainText -Force -String "Potato2019")
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "aurian.club" `
-DomainNetbiosName "AURIAN" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-SafeModeAdministratorPassword $dsrmPassword `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
