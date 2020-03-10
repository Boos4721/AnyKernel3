#!/system/bin/sh
# 请不要硬编码/magisk/modname/...;相反，请使用$MODDIR/...
# 这将使您的脚本兼容，即使Magisk以后改变挂载点
MODDIR=${0%/*}

# 此脚本将在post-fs-data模式下执行

# Change Selinux status as per user desire
    setenforce 0

# Set backlight min value as per user desire
       echo 1 > /sys/module/msm_drm/parameters/backlight_min 

# Enable fast charge as per user desire
       echo 1 > /sys/kernel/fast_charge/force_fast_charge
	

# Enable OTG by default
       echo 1 > /sys/class/power_supply/usb/otg_switch
    

# Configure cpu governor settings
       echo "schedhorizon" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
       echo "schedhorizon" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
      
# Disable Boost_No_Override
	echo 0 > /dev/stune/foreground/schedtune.sched_boost_no_override 
	echo 0 > /dev/stune/top-app/schedtune.sched_boost_no_override 

# Set default schedTune value for foreground/top-app
	echo 1 > /dev/stune/foreground/schedtune.prefer_idle
	echo 1 > /dev/stune/top-app/schedtune.prefer_idle
        echo 1 > /dev/stune/top-app/schedtune.boost

# Tweak IO performance after boot complete
        echo "zen" > /sys/block/sda/queue/scheduler
        echo 64 > /sys/block/sda/queue/read_ahead_kb

# Set TCP congestion algorithm
        echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control

echo "Boot Pixel completed " >> /dev/kmsg
