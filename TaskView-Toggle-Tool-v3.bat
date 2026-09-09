@echo off
setlocal EnableExtensions
:: ============================================================
:: Task View / Desktop View Toggle Tool (Windows 11)
:: Run this file AS ADMINISTRATOR (right-click -> Run as administrator)
:: ============================================================

echo Checking for administrator privileges...
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo ERROR: This script must be run as Administrator.
    echo Right-click the file and choose "Run as administrator".
    pause
    exit /b 1
)

:menu
cls
echo ============================================================
echo   Task View / Desktop View Toggle Tool
echo ============================================================
echo.
echo   1. DISABLE Task View (button, gestures, animations, widgets)
echo   2. ENABLE / RESTORE Task View (back to Windows defaults)
echo   3. Exit
echo.
set /p choice="Enter your choice (1, 2, or 3): "

if "%choice%"=="1" goto disable
if "%choice%"=="2" goto enable
if "%choice%"=="3" goto end
echo Invalid choice, try again.
pause
goto menu

:disable
echo.
echo ------------------------------------------------------------
echo Disabling Task View button on taskbar...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f

echo Disabling Task View via Group Policy registry key (per-user)...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideTaskViewButton /t REG_DWORD /d 1 /f

echo Disabling Task View via Group Policy registry key (machine-wide)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v HideTaskViewButton /t REG_DWORD /d 1 /f

echo Disabling virtual desktop switch animation...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops" /v VirtualDesktopEnableMultiDisplaySwitch /t REG_DWORD /d 0 /f

echo Disabling "Meet Now" flyout...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideSCAMeetNow /t REG_DWORD /d 1 /f

echo Disabling Widgets policy...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f
if %errorLevel% NEQ 0 echo   Note: Widgets policy key could not be set. Non-critical, continuing...

echo Disabling 3-finger touchpad swipe...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" /v ThreeFingerSlideEnabled /t REG_DWORD /d 0 /f

echo Disabling 4-finger touchpad swipe...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" /v FourFingerSlideEnabled /t REG_DWORD /d 0 /f

echo Disabling 3-finger touchpad tap...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" /v ThreeFingerTapEnabled /t REG_DWORD /d 0 /f

echo Disabling 4-finger touchpad tap...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" /v FourFingerTapEnabled /t REG_DWORD /d 0 /f

echo Disabling master touch-gesture switch...
reg add "HKCU\Control Panel\Desktop" /v TouchGestureSetting /t REG_DWORD /d 0 /f

echo Disabling "Open Xbox Game Bar using this button on a controller"...
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f

echo Disabling Xbox Game Bar / GameDVR entirely (covers controller Guide/Home/Power button triggers)...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f

echo Disabling USB Selective Suspend (root-cause fix: stops USB devices from
echo   powering down/reinitializing and sending phantom HID signals)...
powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg /setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
powercfg /setactive SCHEME_CURRENT

echo Disabling Fast Startup (root-cause fix: Fast Startup can leave USB
echo   controller drivers in a stale state that misfires on the next boot)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f

echo.
echo Restarting Windows Explorer to apply changes...
taskkill /f /im explorer.exe
start explorer.exe

echo.
echo ============================================================
echo Task View / Desktop View has been DISABLED, including:
echo   - Taskbar button and Group Policy keys
echo   - Virtual desktop switch animation, Meet Now, Widgets
echo   - 3/4-finger touchpad swipe and tap gestures
echo   - Xbox Game Bar controller-button trigger (Guide/Home/Power)
echo   - USB Selective Suspend and Fast Startup (root-cause fix for
echo     USB devices sending phantom input on power state changes)
echo Sign out and back in (or reboot) for all changes to fully
echo take effect. Fast Startup change needs a FULL RESTART
echo (not just sign out) to apply.
echo ============================================================
pause
goto menu

:enable
echo.
echo ------------------------------------------------------------
echo Restoring Task View button on taskbar...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 1 /f

echo Removing Group Policy Task View restriction (per-user)...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideTaskViewButton /f
if %errorLevel% NEQ 0 echo   Note: key was not present, nothing to remove.

echo Removing Group Policy Task View restriction (machine-wide)...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v HideTaskViewButton /f
if %errorLevel% NEQ 0 echo   Note: key was not present, nothing to remove.

echo Restoring virtual desktop switch animation...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops" /v VirtualDesktopEnableMultiDisplaySwitch /t REG_DWORD /d 1 /f

echo Restoring "Meet Now" flyout...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideSCAMeetNow /t REG_DWORD /d 0 /f

echo Restoring Widgets policy (removing restriction)...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /f
if %errorLevel% NEQ 0 echo   Note: key was not present, nothing to remove.

echo Restoring 3-finger touchpad swipe...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" /v ThreeFingerSlideEnabled /t REG_DWORD /d 1 /f

echo Restoring 4-finger touchpad swipe...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" /v FourFingerSlideEnabled /t REG_DWORD /d 1 /f

echo Restoring 3-finger touchpad tap...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" /v ThreeFingerTapEnabled /t REG_DWORD /d 1 /f

echo Restoring 4-finger touchpad tap...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad" /v FourFingerTapEnabled /t REG_DWORD /d 1 /f

echo Restoring master touch-gesture switch...
reg add "HKCU\Control Panel\Desktop" /v TouchGestureSetting /t REG_DWORD /d 1 /f

echo Restoring "Open Xbox Game Bar using this button on a controller"...
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 1 /f

echo Restoring Xbox Game Bar / GameDVR...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v GameDVR_Enabled /t REG_DWORD /d 1 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /f
if %errorLevel% NEQ 0 echo   Note: key was not present, nothing to remove.

echo Restoring USB Selective Suspend...
powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1
powercfg /setdcvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 1
powercfg /setactive SCHEME_CURRENT

echo Restoring Fast Startup...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f

echo.
echo Restarting Windows Explorer to apply changes...
taskkill /f /im explorer.exe
start explorer.exe

echo.
echo ============================================================
echo Task View / Desktop View has been RESTORED to Windows defaults.
echo Sign out and back in (or reboot) for touchpad gesture changes
echo to fully take effect.
echo ============================================================
pause
goto menu

:end
echo Goodbye.
endlocal
exit /b 0
