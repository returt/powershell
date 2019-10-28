# Script removes user from domain group
# The list of users and the name of the security AD-group are taken from the command line
# Display Names listed in text file (incomplete possible)
# Use: remove_user_from_group.ps1 exclude.txt some_security_ad-group

if ($args[0] -ne $null -and $args[1] -ne $null)
{
import-module activedirectory
$dn=get-content $args[0] -readcount 1
if ($dn -ne $null) {
foreach ($a in $dn) {
$b=$a+"*"
$c=get-aduser -SearchBase "dc=zoloto585,dc=int" -ldapfilter "(&(objectCategory=person)(objectClass=user)(!userAccountControl:1.2.840.113556.1.4.803:=2)(displayname=$b))" | select samaccountname
remove-adgroupmember -identity $args[1] -members $c #-confirm:$false
}
}
else { 
write-host "no users was getted from file"
}
}
else {
write-host "some command line parameters is missing"
}
