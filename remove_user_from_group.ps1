# script removes user from domain group
# the list of users and the name of the security AD-group are taken from the command line
# display Names listed in text file (incomplete possible)
# use: remove_user_from_group.ps1 exclude.txt some_security_ad-group

if ($args[0] -ne $null -and $args[1] -ne $null)
{
import-module activedirectory
$dn=get-content $args[0] -readcount 1
if ($dn -ne $null) {
foreach ($a in $dn) {
$b=$a+"*"
$c=get-aduser -SearchBase "dc=domain,dc=ru" -ldapfilter "(&(objectCategory=person)(objectClass=user)(!userAccountControl:1.2.840.113556.1.4.803:=2)(displayname=$b))" | select samaccountname
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
