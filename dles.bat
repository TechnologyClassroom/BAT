@ECHO OFF
@title DLES

:: dles.bat
:: Michael McMahon

:: github.com/BlueHillBGCB/BAT/dles.bat

:: Based off of OSACS by agent-squirrel
:: https://www.reddit.com/r/commandline/comments/2sm2lc/osacs_officeworks_setup_and_cleaning_system/

REM ######################################################
REM #The Digital Learning Environment Setup (DLES) script
REM #creates useful scheduled tasks and helps automate
REM #Windows systems in educational environments.
REM ######################################################

CLS
mode con: cols=92 lines=20

:: First lets check what mode we are running in.
:: This is more for the sake of TRON which likes to run in safe mode.
:: Failure to check what mode we are in will result in the admin check failing
:: in safe mode.
if /i "%SAFEBOOT_OPTION%"=="MINIMAL" goto progstart
if /i "%SAFEBOOT_OPTION%"=="NETWORK" goto progstart

:MENU
CLS


goto check_Permissions

:: Attempts to run the 'net session' command and if it fails, assumes we are not
:: running with elevated permissions.
:check_Permissions
    net session >nul 2>&1
    if %errorLevel% == 0 (
        GOTO progstart
    ) else (
        echo.
        echo.
        echo.
        echo Current permissions inadequate.
        echo Please re-run as admin by right clicking the program and choosing
        echo 'Run as Administrator'
        echo Press Enter to quit.
    )

    pause>nul
    EXIT

:progstart


mode con: cols=74 lines=20

:: Spawn the batch file used to generate the ASCII art at the top of the menu.
:: The ASCII script is pretty hefty and as a wonderful side effect, it tends to
:: load in line by line on slower machines.
:: ECHO out the menu then pause.
ECHO.
ECHO.
ECHO ================= Digital Learning Environment Setup (DLES) =============
ECHO ======================= What would you like to do? ======================
ECHO -------------------------------------------------------------------------
ECHO 1. Setup automatic yearly shutdown (Sep-Jun)
ECHO 2. Setup automatic summer shutdown (Jul-Aug)
ECHO 3. Setup yearly HOSTS file rotation (to manage games only on Fridays)
ECHO 4. Setup summer HOSTS file rotation (to manage games only on Fridays)
ECHO ============================PRESS 'Q' TO QUIT============================
ECHO.

SET INPUT=
SET /P INPUT=Please select a number:

IF /I '%INPUT%'=='1' GOTO Selection1
IF /I '%INPUT%'=='2' GOTO Selection2
IF /I '%INPUT%'=='3' GOTO Selection3
IF /I '%INPUT%'=='4' GOTO Selection4
IF /I '%INPUT%'=='Q' GOTO EXITMSG

CLS

ECHO.
ECHO.
ECHO.
ECHO Whatever you just pressed probably wasn't between 1 and 5.
ECHO -------------------------------------
ECHO Please select a number from the Main Menu
ECHO  [1-4] or select 'Q' to quit.
ECHO -------------------------------------
ECHO.
ECHO Press enter to have another go.

PAUSE > NUL
GOTO MENU

:Selection1

CLS
schtasks /delete /tn "Summer Computer Shutdown" /f 1>NUL
SCHTASKS /Create /RU "SYSTEM" /RL "HIGHEST" /SC "DAILY" /TN "Yearly Computer Shutdown" /TR "shutdown -s -t 300 -c '7:45PM Auto-Shutdown In Effect.' -f" /ST "19:40:00" 1>NUL
GOTO progstart

:Selection2

CLS
schtasks /delete /tn "Yearly Computer Shutdown" /f 1>NUL
SCHTASKS /Create /RU "SYSTEM" /RL "HIGHEST" /SC "DAILY" /TN "Summer Computer Shutdown" /TR "shutdown -s -t 900 -c '3:55PM Auto-Shutdown In Effect.' -f" /ST "15:40:00" 1>NUL
GOTO progstart

:Selection3

mode con: cols=80 lines=25
CLS

:: Create a directory on disk.
if not exist C:\hosts mkdir C:\hosts

:: MUST BE RUN WITH ADMIN CMD
powershell "$url = 'https://raw.githubusercontent.com/BlueHillBGCB/HOSTS/master/HOSTSFwin.txt'; $path = 'c:\hosts\HOSTSFwin.txt'; [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = new-object System.Net.WebClient; $webClient.DownloadFile( $url, $path )" 1>NUL
powershell "$url = 'https://raw.githubusercontent.com/BlueHillBGCB/HOSTS/master/HOSTSMTWRwin.txt'; $path = 'c:\hosts\HOSTSMTWRwin.txt'; [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = new-object System.Net.WebClient; $webClient.DownloadFile( $url, $path )" 1>NUL
powershell "$url = 'https://raw.githubusercontent.com/BlueHillBGCB/BAT/master/updatehosts.bat'; $path = 'c:\hosts\updatehosts.bat'; [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = new-object System.Net.WebClient; $webClient.DownloadFile( $url, $path )" 1>NUL
:: Formatting from ::http://blog.gpunktschmitz.com/504-powershell-download-file-from-server-via-https-which-has-a-self-signed-certificate

:: Create a task that runs every Friday morning.
schtasks /delete /tn "HostRotateYearFriMorn" /f 1>NUL
SCHTASKS /Create /RU "SYSTEM" /RL "HIGHEST" /SC "weekly" /TN "HostRotateYearFriMorn" /TR "copy C:\hosts\HOSTSFwin.txt C:\WINDOWS\System32\drivers\etc\hosts" /mo 1 /d FRI /ST "13:00:00"
schtasks /delete /tn "HostRotateSumFriMorn" /f 1>NUL
SCHTASKS /Create /RU "SYSTEM" /RL "HIGHEST" /SC "weekly" /TN "HostRotateSumFriMorn" /TR "copy C:\hosts\HOSTSFwin.txt C:\WINDOWS\System32\drivers\etc\hosts" /mo 1 /d FRI /ST "09:05:00"
:: Create a scheduled task that runs every Friday evening.
schtasks /delete /tn "HostRotateYearFriEven" /f 1>NUL
schtasks /delete /tn "HostRotateSumFriEven" /f 1>NUL
SCHTASKS /Create /RU "SYSTEM" /RL "HIGHEST" /SC "weekly" /TN "HostRotateYearFriEven" /TR "copy C:\hosts\HOSTSMTWRwin.txt C:\WINDOWS\System32\drivers\etc\hosts" /mo 1 /d FRI /ST "17:45:00" 1>NUL
:: Create a task that runs every time the computer starts
schtasks /delete /tn "HostRotateonlogon" /f 1>NUL
SCHTASKS /Create /RU "SYSTEM" /RL "HIGHEST" /SC "onlogon" /TN "HostRotateonlogon" /TR "copy C:\hosts\HOSTSMTWRwin.txt C:\WINDOWS\System32\drivers\etc\hosts"
schtasks /delete /tn "HostRotateonstart" /f 1>NUL
SCHTASKS /Create /RU "SYSTEM" /RL "HIGHEST" /SC "onstart" /TN "HostRotateonstart" /TR "copy C:\hosts\HOSTSMTWRwin.txt C:\WINDOWS\System32\drivers\etc\hosts"
schtasks /delete /tn "UpdateHosts" /f 1>NUL
SCHTASKS /Create /RU "SYSTEM" /RL "HIGHEST" /SC "onstart" /TN "UpdateHosts" /TR "C:\hosts\updatehosts.bat" 1>NUL

GOTO progstart


:Selection4

mode con: cols=80 lines=25
CLS

:: Create some directories on disk.
if not exist C:\hosts mkdir C:\hosts

:: MUST BE RUN WITH ADMIN CMD
powershell "$url = 'https://raw.githubusercontent.com/BlueHillBGCB/HOSTS/master/HOSTSFwin.txt'; $path = 'c:\hosts\HOSTSFwin.txt'; [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = new-object System.Net.WebClient; $webClient.DownloadFile( $url, $path )" 1>NUL
powershell "$url = 'https://raw.githubusercontent.com/BlueHillBGCB/HOSTS/master/HOSTSMTWRwin.txt'; $path = 'c:\hosts\HOSTSMTWRwin.txt'; [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = new-object System.Net.WebClient; $webClient.DownloadFile( $url, $path )" 1>NUL
powershell "$url = 'https://raw.githubusercontent.com/BlueHillBGCB/BAT/master/updatehosts.bat'; $path = 'c:\hosts\updatehosts.bat'; [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = new-object System.Net.WebClient; $webClient.DownloadFile( $url, $path )" 1>NUL
:: Formatting from ::http://blog.gpunktschmitz.com/504-powershell-download-file-from-server-via-https-which-has-a-self-signed-certificate

:: Create a task that runs every Friday morning.
schtasks /delete /tn "HostRotateYearFriMorn" /f 1>NUL
SCHTASKS /Create /RU "SYSTEM" /RL "HIGHEST" /SC "weekly" /TN "HostRotateYearFriMorn" /TR "copy C:\hosts\HOSTSFwin.txt C:\WINDOWS\System32\drivers\etc\hosts" /mo 1 /d FRI /ST "13:00:00"
schtasks /delete /tn "HostRotateSumFriMorn" /f 1>NUL
SCHTASKS /Create /RU "SYSTEM" /RL "HIGHEST" /SC "weekly" /TN "HostRotateSumFriMorn" /TR "copy C:\hosts\HOSTSFwin.txt C:\WINDOWS\System32\drivers\etc\hosts" /mo 1 /d FRI /ST "09:05:00"
:: Create a scheduled task that runs every Friday evening.
schtasks /delete /tn "HostRotateYearFriEven" /f 1>NUL
schtasks /delete /tn "HostRotateSumFriEven" /f 1>NUL
SCHTASKS /Create /RU "SYSTEM" /RL "HIGHEST" /SC "weekly" /TN "HostRotateSumFriEven" /TR "copy C:\hosts\HOSTSMTWRwin.txt C:\WINDOWS\System32\drivers\etc\hosts" /mo 1 /d FRI /ST "15:40:00"
:: Create a task that runs every time the computer starts
schtasks /delete /tn "HostRotateonlogon" /f 1>NUL
SCHTASKS /Create /RU "SYSTEM" /RL "HIGHEST" /SC "onlogon" /TN "HostRotateonlogon" /TR "copy C:\hosts\HOSTSMTWRwin.txt C:\WINDOWS\System32\drivers\etc\hosts"
schtasks /delete /tn "HostRotateonstart" /f 1>NUL
SCHTASKS /Create /RU "SYSTEM" /RL "HIGHEST" /SC "onstart" /TN "HostRotateonstart" /TR "copy C:\hosts\HOSTSMTWRwin.txt C:\WINDOWS\System32\drivers\etc\hosts"
schtasks /delete /tn "UpdateHosts" /f 1>NUL
SCHTASKS /Create /RU "SYSTEM" /RL "HIGHEST" /SC "onstart" /TN "UpdateHosts" /TR "C:\hosts\updatehosts.bat" 1>NUL

GOTO progstart


:Quit
EXIT

:EXITMSG

ECHO ================================Goodbye==================================
ECHO -------------------------------------------------------------------------
ECHO =========================PRESS ANY KEY TO QUIT===========================

PAUSE>NUL
EXIT
