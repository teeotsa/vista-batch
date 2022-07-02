@ECHO OFF
COLOR A
SET CUR_DIR=%~dp0
IF NOT EXIST %CUR_DIR% GOTO CURRENT_DIRECTORY_NOT_FOUND 
GOTO CHECK_ADMIN_PERMS

:SHOW_MAIN_MENU
	CLS
	COLOR A
	ECHO Vista Optimizer Script
	ECHO [ 1 ] - Optimize Vista for SSD (Solid State Drive)
	ECHO [ 2 ] - Disable Unnecessary Services
	ECHO [ 3 ] - Re-Enable Unnecessary Services
	ECHO [ 4 ] - Disable Windows Defender
	ECHO [ 5 ] - Enable Windows Defender
	ECHO [ 6 ] - Disable Unnecessary Scheduled Tasks
	ECHO [ 7 ] - Re-Enable Unnecessary Scheduled Tasks
	ECHO [ 8 ] - Disable UAC (User Account Control)
	ECHO [ 9 ] - Re-Enable UAC (User Account Control)
	ECHO [ 10 ] - About
	SET /P SELECTION="[1, 2, 3, 4, 5, 6, 7, 8, 9] > "
	IF %SELECTION% == 1 GOTO OPTIMIZE_FOR_SSD
	IF %SELECTION% == 2 GOTO DISABLE_UNNECESSARY_SERVICES
	IF %SELECTION% == 3 GOTO ENABLE_UNNECESSARY_SERVICES
	IF %SELECTION% == 4 GOTO DISABLE_WINDOWS_DEFENDER
	IF %SELECTION% == 5 GOTO ENABLE_WINDOWS_DEFENDER
	IF %SELECTION% == 6 GOTO DISABLE_SCH_TASKS
	IF %SELECTION% == 7 GOTO ENABLE_SCH_TASKS
	IF %SELECTION% == 8 GOTO DISABLE_UAC
	IF %SELECTION% == 9 GOTO ENABLE_UAC
	IF %SELECTION% == 10 GOTO ABOUT_SCRIPT
	GOTO SHOW_MAIN_MENU

:CHECK_ADMIN_PERMS
	NET SESSION >NUL 2>&1 
	IF NOT %ERRORLEVEL% == 0 GOTO NO_ADMIN_PERMS
	GOTO START
	
:NO_ADMIN_PERMS
	CLS
	COLOR C
	ECHO Please run this script as Administrator!
	GOTO EXIT_PRESS_KEY
	
:CURRENT_DIRECTORY_NOT_FOUND
	CLS
	COLOR C
	ECHO Current directory not found ? 
	GOTO EXIT_PRESS_KEY

:START
	GOTO SHOW_MAIN_MENU

:EXIT_PRESS_KEY
	ECHO Press any key to exit...
	PAUSE > NUL & EXIT
	
:COMMAND_SUCCESSFUL
	CLS
	COLOR E
	ECHO Command executed... Returning to main menu...
	TIMEOUT 3 /NOBREAK > NUL
	GOTO SHOW_MAIN_MENU
	
:OPTIMIZE_FOR_SSD
	CLS
	COLOR C
	ECHO Do you really want to do it ? There's no way to restore those settings later!
	ECHO [1] - Yes
	ECHO [2] - No
	SET /P SELECTION="[1, 2] > "
	IF NOT %SELECTION% == 1 GOTO COMMAND_SUCCESSFUL
	
	CLS
	COLOR A
	ECHO Currently, this function is not done. Press any key to continue
	PAUSE > NUL
	GOTO COMMAND_SUCCESSFUL

:DISABLE_UNNECESSARY_SERVICES
	CLS
	SET USL="LanmanWorkstation" "wuauserv" "WMPNetworkSvc" "MpsSvc" "WerSvc" "WinDefend" "VSS" "TermService" "TabletInputService" "slsvc" "LanmanServer" "wscsvc" "EMDMgmt" "Spooler" "PcaSvc" "CscService"
	SET USL=%USL%;"swprv" "TrkWks"
	FOR %%A IN (%USL%) DO (
		NET STOP %%A /Y >NUL 2>&1 
		IF NOT %ERRORLEVEL% == 0 (
			ECHO Failed to disable %%A
		)
		SC CONFIG %%A start= disabled >NUL 2>&1 
	)
	GOTO COMMAND_SUCCESSFUL

:ENABLE_UNNECESSARY_SERVICES
	CLS
	SET USL="LanmanWorkstation" "wuauserv" "WMPNetworkSvc" "MpsSvc" "WerSvc" "WinDefend" "VSS" "TermService" "TabletInputService" "slsvc" "LanmanServer" "wscsvc" "EMDMgmt" "Spooler" "PcaSvc" "CscService"
	SET USL=%USL%;"swprv" "TrkWks"
	FOR %%A IN (%USL%) DO (
		SC CONFIG %%A start= auto >NUL 2>&1 
	)
	GOTO COMMAND_SUCCESSFUL
	
:DISABLE_WINDOWS_DEFENDER
	CLS
	ECHO Trying to disable Windows Defender...
	SC CONFIG "WinDefend" START= DISABLED >NUL 2>&1 
	NET STOP "WinDefend" /Y >NUL 2>&1 
	TASKKILL /F /IM MSASCui.exe /T
	GOTO COMMAND_SUCCESSFUL
	
:ENABLE_WINDOWS_DEFENDER
	CLS
	ECHO Trying to enable Windows Defender...
	SC CONFIG "WinDefend" START= AUTO >NUL 2>&1 
	NET START "WinDefend" >NUL 2>&1
	GOTO COMMAND_SUCCESSFUL
	
:SCH_TASK_FUNCTION
	IF %~1 == 1 ( SET ARG="/Disable" ) ELSE ( SET ARG="/Enable" )
	schtasks /change /tn "\Microsoft\Windows\SideShow\AutoWake" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\SideShow\GadgetManager" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\SideShow\SessionAgent" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\SideShow\SystemDataProviders" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\Windows Error Reporing\QueueReporting" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\SystemRestore\SR" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\MobilePC\HotStart" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\MobilePC\TMM" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\Meida Center\ehDRMInit" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\Meida Center\mcupdate" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\Meida Center\OCURActivate" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\Meida Center\OCURDiscovery" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\Meida Center\UpdateRecordPath" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\Defrag\ScheduledDefrag" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\OptinNotification" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" %ARG% >NUL 2>&1 
	schtasks /change /tn "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver" %ARG% >NUL 2>&1 
	GOTO COMMAND_SUCCESSFUL
	
:DISABLE_SCH_TASKS
	CLS
	CALL :SCH_TASK_FUNCTION 1

:ENABLE_SCH_TASKS
	CLS
	CALL :SCH_TASK_FUNCTION 0
	
:DISABLE_UAC
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f
	CLS
	ECHO System reboot may be required...
	TIMEOUT 3 /NOBREAK > NUL
	GOTO COMMAND_SUCCESSFUL

:ENABLE_UAC
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f
	CLS
	ECHO System reboot may be required...
	TIMEOUT 3 /NOBREAK > NUL
	GOTO COMMAND_SUCCESSFUL
	
:ABOUT_SCRIPT
	CLS
	ECHO Build date : July 2nd 2022
	ECHO\
	ECHO Built by : Teeotsa
	ECHO\
	ECHO Do whatever you'd like to do with this script :)
	ECHO\
	ECHO\
	ECHO\
	ECHO Press any key to return to menu...
	PAUSE > NUL
	GOTO START
	
GOTO START