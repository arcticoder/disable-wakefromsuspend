powercfg /devicequery wake_armed | % { powercfg /devicedisablewake "$($_)" }
exit