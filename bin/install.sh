#!/bin/sh
if [[ ! -f /sdcard/type ]] ; then
    echo "[×] 找不到架构文件，请重新运行脚本！"
    exit 0
fi
result=$(cat /sdcard/type | grep "64")
echo 'Maigisk安装脚本-1.0'
if [[ "$result" != "" ]]
then
    echo "类型:64位(v8a)"
    abi=1
else
    echo "架构:32位(v7a)"
    abi=0
fi
echo 'By:hxzbaka'
echo '[*] 获取Root权限...'
#获取root权限
result=$(id | grep "root")
if [[ "$result" != "" ]]
then
    echo "[√] 获取Root权限成功！"
else
    echo "[×] 获取Root权限失败！请Root后再试"
    exit 0
fi
#判断文件
echo "[*] 检测Magisk文件是否存在..."
if [ $abi == "0" ] ; then
     if [[ ! -f /sdcard/tmp/magisk32 ]] ; then
     echo '[×] 找不到Magisk文件，请重新运行脚本！'
     exit 0
     else
     echo "[√] Magisk文件校验成功！"
     fi

    else
     if [[ ! -f /sdcard/tmp/magisk64 ]] ; then
     echo '[×] 找不到Magisk文件，请重新运行脚本！'
     exit 0
     else
     echo "[√] Magisk文件校验成功！"
     fi
fi
#挂载读写
echo "[*] 挂载目录读写权限..."
echo "[*] 挂载目录:/"
mount -o rw,remount /
if [ $? -eq 0 ]; then
    echo "[√] 挂载成功！"
else
    echo "[×] 挂载失败，安装终止！"
    exit 0
fi
echo "[*] 挂载目录:/system"
mount -o rw,remount /system
if [ $? -eq 0 ]; then
    echo "[√] 挂载成功！"
else
    echo "[×] 挂载失败，安装终止！"
    exit 0
fi
#复制文件
echo "[*] 复制文件"
mkdir /data/adb/magisk
cp -r /sdcard/tmp/* /data/adb/magisk/
if [ $? -eq 0 ]; then
    echo "[√] 复制文件成功！"
else
    echo "[×] 复制文件失败，安装终止！"
    exit 0
fi
#安装启动脚本
echo "[*] 安装启动脚本"
echo "[*] 检测Magisk文件是否存在..."
     if [[ ! -f /sdcard/install-recovery.sh ]] ; then
     echo '[×] 找不到启动脚本，请重新运行脚本！'
     exit 0
     else
     echo "[√] 启动脚本校验成功！"
     fi
echo "[*] 开始加载..."
cp /sdcard/install-recovery.sh /system/etc/install-recovery.sh
cp /sdcard/install-recovery.sh /system/bin/install-recovery.sh
chmod 755 /system/etc/install-recovery.sh
chmod 755 /system/bin/install-recovery.sh
chown root /system/etc/install-recovery.sh
chown root /system/bin/install-recovery.sh
echo "[*] 删除旧su文件..."
rm /system/bin/su > /dev/null
rm /system/xbin/su > /dev/null
rm /system/sbin/su > /dev/null
echo "[*] 删除残留文件..."
rm -r /sdcard/tmp
rm /sdcard/type
rm /sdcard/install-recovery.sh
echo "[*] 重启设备..."
echo "[√] 安装完成！"
reboot
