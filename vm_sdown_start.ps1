# script collects from AD servers with Hyper-V role installed
# and creates two files in its execution directory for future use:
# vhost.txt - file with list of all hosts with virtual machines
# vm.txt - file is listing all running machines (excluding server-hpdp80)
#
# use vm_stop_start.ps1 with following parameters to shutdown/start:
# vm_stop_start.ps1 stop - shutdown of running virt machines;
# vm_stop_start.ps1 start - starts the machine that is turned off.

import-module servermanager; import-module activedirectory

$param = $args[0]

if ($param -eq "stop")
{ 
write-host "Begin getting of virtual hosts and machines."
$servers=Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server 2012 R2*' }
$vhost = @()
$vm = @()
if ( (test-path vm.txt) -or (test-path vhost.txt) ) { write-host "Erasing old files"; remove-item vm.txt -ea 0; remove-item vhosts.txt -ea 0 }
foreach ($i in $servers) { if ( (get-windowsfeature -name Hyper-V -computername $i.dnshostname -ea 0).installed ) {$vhost += $i} }
$vhost.dnshostname >>.\vhost.txt
foreach ($i in $vhost) { $vm += Get-VM –ComputerName $i.dnshostname | Where-Object { $_.State –eq 'Running' } -ea 0 }
foreach ($element in $vm) { if ($element.name -ne 'server-hpdp80') { $element.name >>.\vm.txt } }
write-host "Get hosts and vms are done."
write-host "Stopping VM"
get-content .\vhost.txt | Tee-Object -Variable vhost
get-content .\vm.txt | Tee-Object -Variable vm
foreach ($i in $vhost) {
foreach ($j in $vm) { stop-vm -name $j -computername $i -turnoff -ea 0 }
}
write-host -foregroundcolor red "All VM are stopped."
}

elseif ($param -eq "start")
{
if ( (-not (test-path vm.txt) ) -or (-not (test-path vhost.txt) ) ) {
write-host -foregroundcolor red "VM.txt or VHOST.txt is absent. Please run script with stop parameter"
break
}
write-host "Starting VM"
get-content .\vhost.txt | Tee-Object -Variable vhost
get-content .\vm.txt | Tee-Object -Variable vm
foreach ($i in $vhost) {
foreach ($j in $vm) { start-vm -name $j -computername $i -ea 0 }
}
write-host -foregroundcolor green "All VM are started."
}
