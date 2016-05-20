:: undatehosts.bat
:: Michael McMahon
:: This script downloads HOSTS files from github.com/BlueHillBGCB/HOSTS on Windows systems.

:: MUST BE RUN WITH ADMIN CMD

@ECHO OFF
:: Create a directory on disk.
if not exist C:\hosts mkdir C:\hosts
powershell "$url = 'https://raw.githubusercontent.com/BlueHillBGCB/HOSTS/master/HOSTSFwin.txt'; $path = 'c:\hosts\HOSTSFwin.txt'; [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = new-object System.Net.WebClient; $webClient.DownloadFile( $url, $path )" 1>NUL
powershell "$url = 'https://raw.githubusercontent.com/BlueHillBGCB/HOSTS/master/HOSTSMTWRwin.txt'; $path = 'c:\hosts\HOSTSMTWRwin.txt'; [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = new-object System.Net.WebClient; $webClient.DownloadFile( $url, $path )" 1>NUL
:: Formatting from ::http://blog.gpunktschmitz.com/504-powershell-download-file-from-server-via-https-which-has-a-self-signed-certificate