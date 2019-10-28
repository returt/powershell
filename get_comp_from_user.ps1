# скрипт определяет, какой юзер залогинился на компьютере
import-module activedirectory
# Объявляем переменные
# область поиска
$OU="OU=,OU=,OU=,DC=,DC="
# Указываем Домен
$domain=''
# Указываем путь к отчету
$reportpatch="с:\temp\audit.csv"
if (Test-Path -Path $reportPatch) {Remove-Item $reportPatch}
# Отбираем ПК по фильтру
Get-ADComputer -Filter * -SearchBase $OU  |
ForEach-Object {
#Переводим в переменную только имя ПК
$computer=($_).Name
echo "computer = $computer"
if ((Test-Connection -computer $computer -count 2 -quiet) -eq $True)
{
# Узнаем какой пользователь работает на данном ПК и удаляем приставку с названием домена. 
$sam=(get-wmiobject win32_computerSystem -computerName $computer).username.split("\")[1]
echo "user = $sam"
if ($sam -ne $null)
{
# Находим пользователя в ActiveDirectory по samaccountname и переводим в вывод Имя Фамилия
$dn=(Get-ADUser -identity $sam).Name
if ($dn -ne $null)
{
# Выводим полученный результат - ПК - Имя Фамилия
echo "$computer - $dn" >> $reportPatch
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
