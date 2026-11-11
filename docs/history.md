I turned off wake timers, which was the most likely cause. I haven't confirmed it, because the setting only matters during a sleep and none has happened since.

**What I found**
- No devices were allowed to wake the PC, so your existing script was already doing its job.
- Wake timers were enabled on both plugged-in and battery power.
- Two HP Print Scan Doctor scheduled tasks ("Printer Health Monitor" and "Printer Health Monitor Logon") are set to wake the PC to run.
- The last wake source Windows recorded was the power button.
- The power log shows several wakes today, at 3:56 AM, 7:02 AM, 12:37 PM and 6:08 PM. I couldn't tell from the log what triggered each one.

**What I changed**
- **Wake timers:** now off on both AC and battery, for the current power plan. This stops scheduled tasks from waking the PC, including the HP ones.
- **Your script:** [DisableWakeFromSuspend.ps1](DisableWakeFromSuspend.ps1) now also sets wake timers to off. Your ROG may reset the setting, so the script puts it back each time it runs.

**What I didn't change**
- I couldn't edit the HP tasks because that needs admin rights. They're harmless now that wake timers are off, but you can set them to not wake the PC from an elevated PowerShell if you want.
- The script only sets the current power plan. If you switch to a different plan, the setting won't carry over.
- If it still wakes, run `powercfg /lastwake` right after it happens and send me the output. That shows what triggered the wake.