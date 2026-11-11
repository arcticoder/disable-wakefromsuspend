powercfg /devicequery wake_armed | % { powercfg /devicedisablewake "$($_)" }

# Also disable wake timers (scheduled tasks / Windows Update waking the PC)
powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP RTCWAKE 0
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP RTCWAKE 0
powercfg /setactive SCHEME_CURRENT
exit
