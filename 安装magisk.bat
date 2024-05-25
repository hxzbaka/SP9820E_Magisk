#by 幻想乡最强baka
@ECHO OFF
chcp 65001 >nul
title SC9820E-Magisk安装器 作者:B站@幻想乡最强baka
mode con cols=71
set adb=%cd%\bin\adb\adb.exe
echo "前排提醒：你的设备必须Root后才能使用此项目！"
echo "确定有Root权限后按回车继续使用!"
pause >nul
cls
type logo
ECHO.准备环境...
ECHO.关闭多余adb进程...
adb kill-server
%adb% kill-server 2>nul
taskkill /f / im adb.exe 2>nul

:adb
ECHO.开启adb服务...
%adb% start-server
tasklist|find /i "adb.exe" 2>nul
if %errorlevel%==0 ( 
	ECHO.adb服务启动成功!
	goto wait
goto wait
) else (
	ECHO.adb服务启动失败! 
	ECHO.按任意键重试
	pause >nul
goto adb
)

:wait
cls
type logo
ECHO.正在等待设备连接电脑...
%adb% wait-for-device
ECHO.设备连接成功!
ECHO.正在读取信息...
ECHO.代号:
%adb% shell getprop ro.build.id
ECHO.SDK:
%adb% shell getprop ro.build.version.sdk
ECHO.系统版本:
%adb% shell getprop ro.build.version.release
ECHO.型号:
%adb% shell getprop ro.product.model
ECHO.架构:
%adb% shell getprop ro.product.cpu.abi
ECHO.
%adb% shell getprop ro.product.cpu.abi |findstr "v8a">nul
if %errorlevel% equ 0 (ECHO.系统架构:64位 && set abi=1) else ECHO.系统架构:32位 && set abi=0
ECHO.确保信息正确后按任意键继续!!!
pause >nul
goto :push

:push
cls
ECHO.卸载旧Magisk管理器...
%adb% uninstall com.topjohnwu.magisk
ECHO.安装Magisk管理器...
%adb% install %cd%\bin\Magisk.apk
echo "正在向设备推送magisk文件"
%adb% push %cd%/bin/magisk /sdcard/tmp/ >nul
if %abi%==0 (
ECHO.推送32位设备专用脚本... && %adb% push %cd%/bin/install-recovery_32.sh /sdcard/install-recovery.sh >nul && %adb% shell "echo 32 >/sdcard/type"
) else (
ECHO.推送64位设备专用脚本... && %adb% push %cd%/bin/install-recovery_64.sh /sdcard/install-recovery.sh >nul && %adb% shell "echo 64 >/sdcard/type"
)
ECHO.推送安装脚本...
%adb% push %cd%/bin/install.sh /sdcard/install.sh >nul
ECHO.5秒后执行安装脚本...
timeout /T 5 /NOBREAK >nul
goto :run

:run
cls
type logo
ECHO.开始执行安装脚本...
ECHO.执行结果:
%adb% shell su -c sh /sdcard/install.sh
echo "执行结束,按任意键关闭窗口"
pause >nul