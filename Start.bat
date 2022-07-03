@ECHO OFF
COLOR A
SET CUR_DIR=%~dp0
GOTO CHECK_ADMIN_PERMS

:SHOW_MAIN_MENU
	CLS
	COLOR A
	ECHO Vista Optimizer Script
	ECHO [ 1 ] - Optimize Vista for SSD (Solid State Drive)
	ECHO [ 2 ] - Unnecessary Services
	ECHO [ 3 ] - Windows Defender
	ECHO [ 4 ] - Unnecessary Scheduled Tasks
	ECHO [ 5 ] - UAC (User Account Control)
	ECHO [ 6 ] - About
	SET /P SELECTION="[1, 2, 3, 4, 5, 6] > "
	IF %SELECTION% == 1 GOTO OPTIMIZE_FOR_SSD_MENU
	IF %SELECTION% == 2 GOTO UN_SERVICE_MENU
	IF %SELECTION% == 3 GOTO WIN_DEFENDER_MENU
	IF %SELECTION% == 4 GOTO UN_SCHEDULED_TASK_MENU
	IF %SELECTION% == 5 GOTO UAC_MENU
	IF %SELECTION% == 6 GOTO ABOUT_SCRIPT
	GOTO SHOW_MAIN_MENU

:OPTIMIZE_FOR_SSD_MENU
	CLS
	COLOR A
	ECHO [ 1 ] - Optimize
	ECHO [ 2 ] - Redo Optimize
	ECHO [ 3 ] - Back to main menu
	SET /P SELECTION="[1, 2, 3] > "
	IF %SELECTION% == 1 GOTO OPTIMIZE_FOR_SSD_CHANGE
	IF %SELECTION% == 2 GOTO OPTIMIZE_FOR_SSD_REDOCHANGE
	IF %SELECTION% == 3 GOTO START_SCRIPT
	GOTO OPTIMIZE_FOR_SSD_MENU
	
:OPTIMIZE_FOR_SSD_CHANGE
	GOTO THIS_FUNC_IS_NOT_DONE
	
:OPTIMIZE_FOR_SSD_REDOCHANGE
	GOTO THIS_FUNC_IS_NOT_DONE
	
:UN_SERVICE_MENU
	CLS
	COLOR A
	ECHO [ 1 ] - Disable Unnecessary Services
	ECHO [ 2 ] - Enable Unnecessary Services
	ECHO [ 3 ] - Back to main menu
	SET /P SELECTION="[1, 2, 3] > "
	IF %SELECTION% == 1 GOTO UN_SERVICE_DISABLE
	IF %SELECTION% == 2 GOTO UN_SERVICE_ENABLE
	IF %SELECTION% == 3 GOTO START_SCRIPT
	GOTO UN_SERVICE_MENU

:UN_SERVICE_DISABLE
	CLS
	SET USL="LanmanWorkstation" "wuauserv" "WMPNetworkSvc" "MpsSvc" "WerSvc" "WinDefend" "VSS" "TermService" "TabletInputService" "slsvc" "wscsvc" "EMDMgmt" "Spooler" "PcaSvc" "CscService"
	SET USL=%USL%;"swprv" "TrkWks" "LanmanServer"
	FOR %%A IN (%USL%) DO (
		NET STOP %%A /Y >NUL 2>&1 
		IF NOT %ERRORLEVEL% == 0 (
			ECHO Failed to disable %%A
		)
		SC CONFIG %%A start= disabled >NUL 2>&1 
	)
	GOTO COMMAND_SUCCESSFUL
	
:UN_SERVICE_ENABLE
	CLS
	SET USL="LanmanWorkstation" "wuauserv" "WMPNetworkSvc" "MpsSvc" "WerSvc" "WinDefend" "VSS" "TermService" "TabletInputService" "slsvc" "wscsvc" "EMDMgmt" "Spooler" "PcaSvc" "CscService"
	SET USL=%USL%;"swprv" "TrkWks" "LanmanServer"
	FOR %%A IN (%USL%) DO (
		SC CONFIG %%A start= auto >NUL 2>&1 
	)
	GOTO COMMAND_SUCCESSFUL
	
:WIN_DEFENDER_MENU
	CLS
	COLOR A
	ECHO [ 1 ] - Disable Windows Defender
	ECHO [ 2 ] - Enable Windows Defender
	ECHO [ 3 ] - Back to main menu
	SET /P SELECTION="[1, 2, 3] > "
	IF %SELECTION% == 1 GOTO WIN_DEFENDER_DISABLE
	IF %SELECTION% == 2 GOTO WIN_DEFENDER_ENABLE
	IF %SELECTION% == 3 GOTO START_SCRIPT
	GOTO WIN_DEFENDER_MENU
	
:WIN_DEFENDER_DISABLE
	CLS
	ECHO Trying to disable Windows Defender...
	SC CONFIG "WinDefend" START= DISABLED >NUL 2>&1 
	NET STOP "WinDefend" /Y >NUL 2>&1
	REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /V "Windows Defender" >NUL 2>&1
	::Value Exists
	IF %errorlevel% == 0 (
		REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /V "Windows Defender" /F
	)
	TASKKILL /F /IM MSASCui.exe /T
	GOTO COMMAND_SUCCESSFUL
	
:WIN_DEFENDER_ENABLE
	CLS
	ECHO Trying to enable Windows Defender...
	SC CONFIG "WinDefend" START= AUTO >NUL 2>&1 
	NET START "WinDefend" >NUL 2>&1
	REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /V "Windows Defender" /T REG_SZ /D "%ProgramFiles%\Windows Defender\MSASCui.exe -hide"
	GOTO COMMAND_SUCCESSFUL
	
:UN_SCHEDULED_TASK_MENU
	CLS
	COLOR A
	ECHO [ 1 ] - Disable Unnecessary Scheduled Tasks
	ECHO [ 2 ] - Enable Unnecessary Scheduled Tasks
	ECHO [ 3 ] - Back to main menu
	SET /P SELECTION="[1, 2, 3] > "
	IF %SELECTION% == 1 GOTO UN_SCHEDULED_TASK_DISABLE
	IF %SELECTION% == 2 GOTO UN_SCHEDULED_TASK_ENABLE
	IF %SELECTION% == 3 GOTO START_SCRIPT
	GOTO UN_SCHEDULED_TASK_MENU
	
:UN_SCHEDULED_TASK_DISABLE
	CLS
	CALL :SCH_TASK_FUNCTION 1
	
:UN_SCHEDULED_TASK_ENABLE
	CLS
	CALL :SCH_TASK_FUNCTION 0
	
:UAC_MENU
	CLS
	COLOR A
	ECHO [ 1 ] - Disable UAC (User Account Control)
	ECHO [ 2 ] - Enable UAC (User Account Control)
	ECHO [ 3 ] - Back to main menu
	SET /P SELECTION="[1, 2, 3] > "
	IF %SELECTION% == 1 GOTO UAC_DISABLE
	IF %SELECTION% == 2 GOTO UAC_ENABLE
	IF %SELECTION% == 3 GOTO START_SCRIPT
	GOTO UAC_MENU

:UAC_DISABLE
	CLS
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /V EnableLUA /T REG_DWORD /D 0 /F >NUL 2>&1
	ECHO System reboot may be required...
	TIMEOUT 3 /NOBREAK > NUL
	GOTO COMMAND_SUCCESSFUL

:UAC_ENABLE
	CLS
	REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /V EnableLUA /T REG_DWORD /D 1 /F >NUL 2>&1
	ECHO System reboot may be required...
	TIMEOUT 3 /NOBREAK > NUL
	GOTO COMMAND_SUCCESSFUL

:CHECK_ADMIN_PERMS
	OPENFILES >NUL 2>&1
	IF NOT %ERRORLEVEL% == 0 ( GOTO NO_ADMIN_PERMS )
	GOTO START_SCRIPT
	
:NO_ADMIN_PERMS
	CLS
	COLOR C
	ECHO Please run this script as Administrator!
	ECHO\
	GOTO EXIT_PRESS_KEY
	
:CURRENT_DIRECTORY_NOT_FOUND
	CLS
	COLOR C
	ECHO Current directory not found ? 
	GOTO EXIT_PRESS_KEY

:START_SCRIPT
	IF NOT EXIST %CUR_DIR% GOTO CURRENT_DIRECTORY_NOT_FOUND 
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
	GOTO START_SCRIPT
	
:THIS_FUNC_IS_NOT_DONE
	CLS
	COLOR E
	ECHO This function is not currently done, returning to main menu ...
	TIMEOUT 3 /NOBREAK > NUL
	GOTO START_SCRIPT