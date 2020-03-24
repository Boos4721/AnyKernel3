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
    
# Configure governor settings for little cluster
       echo "schedhorizon" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
       echo 150 > /sys/devices/system/cpu/cpufreq/policy0/schedhorizon/up_rate_limit_us
       echo 200 > /sys/devices/system/cpu/cpufreq/policy0/schedhorizon/down_rate_limit_us 
       echo 1 > /sys/devices/system/cpu/cpufreq/policy0/schedhorizon/iowait_boost_enable 
       echo 441600 960000 > /sys/devices/system/cpu/cpu0/cpufreq/schedhorizon/efficient_freq
       echo 50 60 > /sys/devices/system/cpu/cpu0/cpufreq/schedhorizon/up_delay
       
# Configure governor settings for big cluster
       echo "schedhorizon" >/sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
       echo 50 > /sys/devices/system/cpu/cpufreq/policy4/schedhorizon/up_rate_limit_us 
       echo 20000 > /sys/devices/system/cpu/cpufreq/policy4/schedhorizon/down_rate_limit_us 
       echo 1 > /sys/devices/system/cpu/cpufreq/policy4/schedhorizon/iowait_boost_enable 
       echo 8064000 10560000 22080000 > /sys/devices/system/cpu/cpu4/cpufreq/schedhorizon/efficient_freq
       echo 40 70 75> /sys/devices/system/cpu/cpu4/cpufreq/schedhorizon/up_delay

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
        echo "cdg" > /proc/sys/net/ipv4/tcp_congestion_control
