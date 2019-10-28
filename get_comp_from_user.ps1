# ������ ����������, ����� ���� ����������� �� ����������
import-module activedirectory
# ��������� ����������
# ������� ������
$OU="OU=,OU=,OU=,DC=,DC="
# ��������� �����
$domain=''
# ��������� ���� � ������
$reportpatch="�:\temp\audit.csv"
if (Test-Path -Path $reportPatch) {Remove-Item $reportPatch}
# �������� �� �� �������
Get-ADComputer -Filter * -SearchBase $OU  |
ForEach-Object {
#��������� � ���������� ������ ��� ��
$computer=($_).Name
echo "computer = $computer"
if ((Test-Connection -computer $computer -count 2 -quiet) -eq $True)
{
# ������ ����� ������������ �������� �� ������ �� � ������� ��������� � ��������� ������. 
$sam=(get-wmiobject win32_computerSystem -computerName $computer).username.split("\")[1]
echo "user = $sam"
if ($sam -ne $null)
{
# ������� ������������ � ActiveDirectory �� samaccountname � ��������� � ����� ��� �������
$dn=(Get-ADUser -identity $sam).Name
if ($dn -ne $null)
{
# ������� ���������� ��������� - �� - ��� �������
echo "$computer - $dn" >> $reportPatch
}
}
else 
{
# ���������� "����������" �����
echo $computer >> c:\temp\bad_comp.txt
}
}
$sam = $null
}
