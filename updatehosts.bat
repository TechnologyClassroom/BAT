:: undatehosts.bat
:: Michael McMahon
:: This script downloads HOSTS files from github.com/BlueHillBGCB/HOSTS on Windows systems.

:: MUST BE RUN WITH ADMIN CMD

@ECHO OFF
:: Create a directory on disk.
if not exist C:\hosts mkdir C:\hosts
powershell "$url = 'https://raw.githubusercontent.com/BlueHillBGCB/HOSTS/master/HOSTSFwin.txt'; $path = 'c:\hosts\HOSTSFwin.txt'; [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = new-object System.Net.WebClient; $webClient.DownloadFile( $url, $path )" 1>NUL
powershell "$url = 'https://raw.githubusercontent.com/BlueHillBGCB/HOSTS/master/HOSTSMTWRwin.txt'; $path = 'c:\hosts\HOSTSMTWRwin.txt'; [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = new-object System.Net.WebClient; $webClient.DownloadFile( $url, $path )" 1>NUL
powershell "$url = 'https://raw.githubusercontent.com/BlueHillBGCB/HOSTS/master/HOSTSFwinLS.txt'; $path = 'c:\hosts\HOSTSFwinLS.txt'; [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = new-object System.Net.WebClient; $webClient.DownloadFile( $url, $path )" 1>NUL
powershell "$url = 'https://raw.githubusercontent.com/BlueHillBGCB/HOSTS/master/HOSTSMTWRwinLS.txt'; $path = 'c:\hosts\HOSTSMTWRwinLS.txt'; [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = new-object System.Net.WebClient; $webClient.DownloadFile( $url, $path )" 1>NUL
:: Formatting from ::http://blog.gpunktschmitz.com/504-powershell-download-file-from-server-via-https-which-has-a-self-signed-certificate

:: This copies the file to hosts depending on the day of the week
setlocal 
for /f "delims=" %%a in ('wmic path win32_localtime get dayofweek /format:list ') do for /f "delims=" %%d in ("%%a") do set %%d 
IF %dayofweek%==5 (copy /Y C:\hosts\HOSTSFwin.txt C:\windows\system32\drivers\etc\hosts) ELSE (copy /Y C:\hosts\HOSTSMTWRwin.txt C:\windows\system32\drivers\etc\hosts) 
::IF %dayofweek%==5 (copy /Y C:\hosts\HOSTSFwinLS.txt C:\windows\system32\drivers\etc\hosts) ELSE (copy /Y C:\hosts\HOSTSMTWRwinLS.txt C:\windows\system32\drivers\etc\hosts) 
endlocal 
:: Formatting from http://stackoverflow.com/questions/11364147/setting-a-windows-batch-file-variable-to-the-day-of-the-week 
