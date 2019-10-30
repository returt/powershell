rem Windows Time Service configuration validation logon-script
rem If errors occur, sends an e-mail message (postie.exe) to the admin@domain.ru and tries to correct them
@echo off
ping -n 20 127.0.0.1
chcp 866 >nul
for /f "skip=3 tokens=2 delims=. " %%I in ('w32tm.exe /stripchart /computer:ntp.domain.ru /dataonly /samples:1') do set error=%%I && goto skip
:skip
set ntp_error_tmp=%error: =%
set ntp_error=%ntp_error_tmp:~1%
if "%ntp_error%"=="00" goto end
set tz1=""
set tz2=""
for /f "skip=1 tokens=3" %%I in ('wmic OS get caption') do set os_ver=%%I
if "%os_ver%"=="Windows XP" goto win_xp || goto next
:win_xp
wmic qfe list brief |find /i "KB2779562" && goto next || %0\..\WindowsXP-KB2779562-x86-RUS.exe /quiet /norestart
set tz1="Update"
set tz2="timezone"
:next
set spin="back"
if "%error:~0,1%"=="-" set spin="forward"
%0\..\postie.exe -host:mta.domain.ru -port:2525 -to:admin@domain.ru -from:time_service@domain.ru -s:"Time Error %computername%" -msg:"Time Service error on %computername% Windows %os_ver%. Shift is %spin% to %ntp_error% seconds. Trying to correct... %tz1% %tz2%"
w32tm /config /update
w32tm /resync /rediscover
:end
exit
