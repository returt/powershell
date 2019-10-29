rem script replace administrative password for trendmicro virusscan
rem for further removal of this product

setlocal enabledelayedexpansion
sc qc TMBMServer >tm_os.tmp
for /f tokens^=2^ delims^=^" %%i in ('findstr -i binary tm_os.tmp') do (
set tmpath=%%i
set tmpath=!tmpath:~0,-15!
)

set ini_path=%tmpath%\OfficeScan Client

setlocal DISABLEDELAYEDEXPANSION 

cd "%ini_path%"
copy ofcscan.ini ofcscan.old
set verfile=ofcscan.ini
set tmpfile=ofcscan.tmp
set seek=Uninstall_Pwd
if exist %tmpfile% del /q %tmpfile%
for /f "delims=" %%a in (%verfile%) do (
  echo %%a|>nul find /i "%seek%=" && echo %seek%=!CRYPT!523D617DF57CBF0E9ACD37611537EBB612F9B6F1C471EB529B89772E71AD9D2431BC212ACF23B7767831E317364>>%tmpfile% || echo %%a>>%tmpfile%
)
copy /y %tmpfile% %verfile% >nul
del /f /q %tmpfile% >nul
