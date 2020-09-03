param(
[int]$Users=(read-host " How many Users to create ?"),
[string] $domainname= [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
)
#Create Groups OU and 'Los Potatos' Group in Groups OU
New-ADOrganizationalUnit Groups -ProtectedFromAccidentalDeletion $false
$ADOU=Get-ADOrganizationalUnit -Filter "name -eq 'groups'"
new-adgroup "Los Potatos" -GroupScope Global -Path $AdOU.DistinguishedName 
#Create the rest of the OU's
New-ADOrganizationalUnit 0-Zeros -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit 1-Tens -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit 2-Twenties -path "OU=1-Tens, DC=Aurian, DC=club" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit 3-Thirties -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit 4-Forties -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit 5-Fifties -ProtectedFromAccidentalDeletion $false
#Set the count for creating Users
foreach ($i in 1..$Users) {
    If ($i -lt 10) {
        $i = "0$i"
    }else {
        $i = $i
    }
    New-ADUser -Name Potato$i `
               -AccountPassword (ConvertTo-SecureString -AsPlainText "London2019*" -Force) `
               -City London `
               -Company QA  `
               -DisplayName Potato$i `
               -Enabled $True `
               -PasswordNeverExpires $True `
               -SamAccountName Potato$i `
               -UserPrincipalName "Potato$i@$domainname"
    if ($i -lt 10) {
        $ADOU=Get-ADOrganizationalUnit -Filter "name -eq '0-Zeros'"
        Set-ADUser -Identity "Potato$i" -Department Zeros
        Get-ADUser -Identity "potato$i" | Move-ADObject -TargetPath $ADOU.DistinguishedName 
    }
    elseif ($i -ge 10 -and $i -lt 20) { 
        $ADOU=Get-ADOrganizationalUnit -Filter "name -eq '1-Tens'"
        Set-ADUser -Identity "Potato$i" -Department Tens
        Get-ADUser -Identity "potato$i" | Move-ADObject -TargetPath $ADOU.DistinguishedName
    }elseif ($i -ge 20 -and $i -lt 30) { 
        $ADOU=Get-ADOrganizationalUnit -Filter "name -eq '2-Twenties'"
        Set-ADUser -Identity "Potato$i" -Department Twenties
        Get-ADUser -Identity "potato$i" | Move-ADObject -TargetPath $ADOU.DistinguishedName
    }elseif ($i -ge 30 -and $i -lt 40) { 
        $ADOU=Get-ADOrganizationalUnit -Filter "name -eq '3-Thirties'"
        Set-ADUser -Identity "Potato$i" -Department Thirties
        Get-ADUser -Identity "potato$i" | Move-ADObject -TargetPath $ADOU.DistinguishedName
    }elseif ($i -ge 40 -and $i -lt 50) { 
        $ADOU=Get-ADOrganizationalUnit -Filter "name -eq '4-Forties'"
        Set-ADUser -Identity "Potato$i" -Department Forties
        Get-ADUser -Identity "potato$i" | Move-ADObject -TargetPath $ADOU.DistinguishedName
    }elseif ($i -ge 50 -and $i -lt 60) { 
        $ADOU=Get-ADOrganizationalUnit -Filter "name -eq '5-Fifties'"
        Set-ADUser -Identity "Potato$i" -Department Fifties
        Get-ADUser -Identity "potato$i" | Move-ADObject -TargetPath $ADOU.DistinguishedName
    }
    Add-ADGroupMember -Identity 'los potatos' -Members "potato$i"
    Add-ADGroupMember -Identity 'Domain Admins' -Members "Domain Users"
}


New-ADUser -Name OnPremAdmin `
               -AccountPassword (ConvertTo-SecureString -AsPlainText "London2019*" -Force) `
               -City London `
               -Company QA  `
               -DisplayName OnPremAdmin `
               -Enabled $True `
               -PasswordNeverExpires $True `
               -SamAccountName OnPremAdmin `
               -UserPrincipalName "OnPremAdmin@$domainname"

Add-ADGroupMember -Identity 'Administrators' -Members "OnPremadmin"
Add-ADGroupMember -Identity 'Domain Admins' -Members "OnPremadmin"
Add-ADGroupMember -Identity 'Enterprise Admins' -Members "OnPremadmin"
Add-ADGroupMember -Identity 'Group Policy Creator Owners' -Members "OnPremadmin"
Add-ADGroupMember -Identity 'Schema Admins' -Members "OnPremadmin"



dsa.msc

netsh advfirewall set allprofiles state off
