# script determines which user loged on the computer
import-module activedirectory
# search arrea
$OU="OU=,OU=,OU=,DC=,DC="
# specify the path to the report
$reportpatch="c:\temp\audit.csv"
if (Test-Path -Path $reportPatch) {Remove-Item $reportPatch}
# select PC by filter
Get-ADComputer -Filter * -SearchBase $OU  |
ForEach-Object {
# transfer only netbios name of the PC into a variable
$computer=($_).Name
if ((Test-Connection -computer $computer -count 2 -quiet) -eq $True)
{
# find out who is working on this PC and remove domain_name\
$sam=(get-wmiobject win32_computerSystem -computerName $computer).username.split("\")[1]
if ($sam -ne $null)
{
# find the user in AD by samaccountname and put them in First Name Last Name
$dn=(Get-ADUser -identity $sam).Name
if ($dn -ne $null)
{
# display the result: PC - First name Last name
echo "$computer - $dn" >> $reportpatch
}
}
else 
{
# writing "problem" computers
echo $computer >> c:\temp\bad_comp.txt
}
}
$sam = $null
}
