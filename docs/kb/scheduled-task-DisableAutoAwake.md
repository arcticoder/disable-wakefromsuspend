# Scheduled task `\DisableAutoAwake` (LLM-only KB)

Audience: future Claude chats. Not for end users.

## What it is
- Task at root path `\`, name `DisableAutoAwake`, runs `DisableWakeFromSuspend.ps1` (this repo) on startup/logon.
- Principal: `echo_`, LogonType Interactive, RunLevel **Highest** (hence editing needs elevation).
- Action BEFORE 2026-11-11: `Powershell -ExecutionPolicy Bypass C:\Users\echo_\Code\powershell\disable-wakefromsuspend\DisableWakeFromSuspend.ps1` (visible window).
- Action AFTER 2026-11-11 (applied by the user from an elevated shell; verified by read-back):
  `powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Users\echo_\Code\powershell\disable-wakefromsuspend\DisableWakeFromSuspend.ps1"`
- Not test-run after the change. Settings.Hidden is still False (that flag only hides it in the Task Scheduler UI; unrelated to the window).

## Incident: window titled "Select Administrator: ...PowerShell.EXE" never closed
- Cause: the "Select" prefix = console QuickEdit selection mode (stray click). It pauses the console process until Esc/Enter. The script itself ends in `exit` and has no prompts, so it was not hung.
- Fix: run hidden (above). Esc/Enter dismisses a stuck window.

## Script behaviour (DisableWakeFromSuspend.ps1)
- Disables wake on every device in `powercfg /devicequery wake_armed`.
- Added 2026-11-10: sets RTCWAKE (wake timers) to 0 for AC and DC on the current scheme, then `/setactive SCHEME_CURRENT`.
- Runs elevated via the task, so its device/powercfg calls succeed there even though Claude's own session can't do the admin-only ones.
