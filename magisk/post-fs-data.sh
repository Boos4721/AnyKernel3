#!/system/bin/sh
# 请不要硬编码/magisk/modname/...;相反，请使用$MODDIR/...
# 这将使您的脚本兼容，即使Magisk以后改变挂载点
MODDIR=${0%/*}

# 此脚本将在post-fs-data模式下执行

# Thanks Yc9559

# Change Selinux status as per user desire
    setenforce 0
    
# OnePlus opchain pins UX threads on the big cluster
       lock_val "0" /sys/module/opchain/parameters/chain_on

# Set backlight min value as per user desire
       echo 1 > /sys/module/msm_drm/parameters/backlight_min 

# Enable fast charge as per user desire
       echo 1 > /sys/kernel/fast_charge/force_fast_charge
	
# Disable adrenoboost
       echo 0 > /sys/class/devfreq/5000000.qcom,kgsl-3d0/adrenoboost

# Enable OTG by default
       echo 1 > /sys/class/power_supply/usb/otg_switch
       
# Input boost and stune configuration
       echo "0:1056000 1:0 2:0 3:0 4:1056000 5:0 6:0 7:0" > /sys/module/cpu_boost/parameters/input_boost_freq
       echo 450 > /sys/module/cpu_boost/parameters/input_boost_ms
       echo 15 > /sys/module/cpu_boost/parameters/dynamic_stune_boost
       
# Fix laggy bilibili feed scrolling
       change_task_cgroup "servicemanager" "top-app" "cpuset"
       change_task_cgroup "servicemanager" "foreground" "stune"
       change_task_cgroup "android.phone" "top-app" "cpuset"
       change_task_cgroup "android.phone" "foreground" "stune"

# Fix laggy home gesture
       change_task_cgroup "system_server" "top-app" "cpuset"
       change_task_cgroup "system_server" "foreground" "stune"

# Reduce render thread waiting time
       change_task_cgroup "surfaceflinger" "top-app" "cpuset"
       change_task_cgroup "surfaceflinger" "foreground" "stune"

# Reduce big cluster wakeup, eg. android.hardware.sensors@1.0-service
       change_task_affinity ".hardware." "0f"
       
# ...But exclude the fingerprint&camera service for speed
       change_task_affinity ".hardware.biometrics.fingerprint" "ff"
       change_task_affinity ".hardware.camera.provider" "ff"

# Configure cpu governor settings
       echo "schedhorizon" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
       echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/schedhorizon/up_rate_limit_us
       echo 50 > /sys/devices/system/cpu/cpu0/cpufreq/schedhorizon/down_rate_limit_us
       echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/schedhorizon/iowait_boost_enable
       echo 300000 /sys/devices/system/cpu/cpu0/cpufreq/schedhorizon/hispeed_freq 
       echo 90 /sys/devices/system/cpu/cpu0/cpufreq/schedhorizon/hispeed_load 
       echo "schedhorizon" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
       echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/schedhorizon/up_rate_limit_us
       echo 60 > /sys/devices/system/cpu/cpu4/cpufreq/schedhorizon/down_rate_limit_us
       echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/schedhorizon/iowait_boost_enable
       echo 2476800 /sys/devices/system/cpu/cpu4/cpufreq/schedhorizon/hispeed_freq 
       echo 90 /sys/devices/system/cpu/cpu4/cpufreq/schedhorizon/hispeed_load
      
# Disable Boost_No_Override
	   echo 0 > /dev/stune/foreground/schedtune.sched_boost_no_override 
	   echo 0 > /dev/stune/top-app/schedtune.sched_boost_no_override 

# Set default schedTune value for foreground/top-app
	    echo 1 > /dev/stune/foreground/schedtune.prefer_idle
	    echo 1 > /dev/stune/top-app/schedtune.prefer_idle
        echo 1 > /dev/stune/top-app/schedtune.boost

# Tweak IO performance after boot complete
        echo "bfq" > /sys/block/sda/queue/scheduler
        echo 64 > /sys/block/sda/queue/read_ahead_kb

# Set TCP congestion algorithm
        echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control

echo "Boot Hentai completed " >> /dev/kmsg

