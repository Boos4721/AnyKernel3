# Change Selinux status as per user desire
    setenforce 0

# Set backlight min value as per user desire
       echo 1 > /sys/module/msm_drm/parameters/backlight_min 

# Enable fast charge as per user desire
       echo 1 > /sys/kernel/fast_charge/force_fast_charge
       
# Enable OTG by default
       echo 1 > /sys/class/power_supply/usb/otg_switch
    
# Input boost and stune configuration
       echo "0:1056000 1:0 2:0 3:0 4:0 5:0 6:0 7:0" > /sys/module/cpu_boost/parameters/input_boost_freq
       echo 500 > /sys/module/cpu_boost/parameters/input_boost_ms
       echo 5 > /dev/stune/top-app/schedtune.boost

# Configure cpu governor settings
      echo "schedhorizon" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
      echo 500 > /sys/devices/system/cpu/cpu0/cpufreq/schedhorizon/up_rate_limit_us
      echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/schedhorizon/down_rate_limit_us
      echo 1056000 1612800 > /sys/devices/system/cpu/cpu0/cpufreq/schedhorizon/efficient_freq
      echo 30 50 > /sys/devices/system/cpu/cpu0/cpufreq/schedhorizon/up_delay
      echo "schedhorizon" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
      echo 500 > /sys/devices/system/cpu/cpu4/cpufreq/schedhorizon/up_rate_limit_us
      echo 20000 > /sys/devices/system/cpu/cpu4/cpufreq/schedhorizon/down_rate_limit_us
      echo 1843200 2476800 > /sys/devices/system/cpu/cpu0/cpufreq/schedhorizon/efficient_freq
      echo 50 60 > /sys/devices/system/cpu/cpu0/cpufreq/schedhorizon/up_delay
      
# Set min cpu freq
      echo 480000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
      echo 825600 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq

# Set gpu freq
       echo 130000000 > /sys/class/devfreq/5000000.qcom,kgsl-3d0/min_freq
            
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

if [ -f /wlan_aging.ko ]; then
#    beacause system partition must not mount as r/w, so do nothing here
#    ln -s -f /wlan_aging.ko /system/lib/modules/wlan.ko
     echo "init.oem.early_boot.sh go" > /dev/ksmg
fi

