# скрипт определяет, какой юзер залогинился на компьютере
import-module activedirectory
# область поиска
$OU="OU=,OU=,OU=,DC=,DC="
# указываем Домен
$domain=''
# указываем путь к отчету
$reportpatch="c:\temp\audit.csv"
if (Test-Path -Path $reportPatch) {Remove-Item $reportPatch}
# отбираем ПК по фильтру
Get-ADComputer -Filter * -SearchBase $OU  |
ForEach-Object {
# переводим в переменную только имя ПК
$computer=($_).Name
if ((Test-Connection -computer $computer -count 2 -quiet) -eq $True)
{
# Узнаем кто работает на данном ПК и удаляем приставку с названием домена
$sam=(get-wmiobject win32_computerSystem -computerName $computer).username.split("\")[1]
if ($sam -ne $null)
{
# Находим пользователя в AD по samaccountname и переводим в вывод Имя Фамилия
$dn=(Get-ADUser -identity $sam).Name
if ($dn -ne $null)
{
# выводим полученный результат - ПК - Имя Фамилия
echo "$computer - $dn" >> $reportpatch
}
}
else 
{
# записываем "проблемные" компы
echo $computer >> c:\temp\bad_comp.txt
}
}
$sam = $null
}
