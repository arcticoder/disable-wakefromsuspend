# Environment & wake diagnosis (LLM-only KB)

Audience: future Claude chats. Not for end users. Facts verified 2026-11-10/11 unless noted.

## Machine / session facts
- Windows 11 Pro, host `HERCULES`, user `echo_`, ASUS ROG Strix (the ROG software/firmware tends to re-arm wake devices; see README).
- Claude runs inside the VS Code extension. The shell inherits VS Code's integrity level: **Medium (not elevated)**, even if the user "ran a terminal as administrator" elsewhere. Verify with `[Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole('Administrator')`.
- Therefore these need the user to run commands in their own elevated PowerShell (give them a paste-ready snippet; they paste back output):
  - `powercfg /waketimers` ("requires administrator privileges")
  - `Set-ScheduledTask` / editing tasks with RunLevel Highest ("Access is denied")
- These work unelevated: `powercfg /lastwake`, `/devicequery wake_armed`, `/setacvalueindex|/setdcvalueindex` + `/setactive` on the current scheme, `Get-ScheduledTask`, reading System event log.
- User prefers minimal privilege: don't suggest running all of VS Code as admin; suggest a one-off elevated paste.

## Diagnosis recipe (unelevated)
1. `powercfg /lastwake` - last wake source. Seen: "Fixed Feature: Power Button".
2. `powercfg /devicequery wake_armed` - seen: NONE (the startup script already clears these).
3. `Get-ScheduledTask | ? { $_.Settings.WakeToRun -and $_.State -ne 'Disabled' }` - seen: HP `\HP\HP Print Scan Doctor\Printer Health Monitor` and `... Logon`.
4. `powercfg /q SCHEME_CURRENT SUB_SLEEP RTCWAKE` - wake timer policy (0 disable, 1 enable, 2 important only). Was 1/1 on AC/DC; set to 0/0.
5. System log, provider `Microsoft-Windows-Power-Troubleshooter`: shows Sleep/Wake times (UTC) per wake but NOT the source. Several wakes on 2026-11-10 (03:56, 07:02, 12:37, 18:08 local).

## Status / unknowns
- Root cause of the user's spontaneous wakes is **not confirmed**; wake timers were the best hypothesis. No sleep cycle was observed after the fix. If the user reports it again, ask for `powercfg /lastwake` immediately after the wake.
- HP tasks' `WakeToRun` was NOT changed (needs admin); neutralised by wake timers = 0.
- Setting applies only to the active power scheme at the time; a different scheme keeps its own value.

## Gotchas
- `Get-ScheduledTask ... | Set-ScheduledTask` on a foreign task prints a long garbled "Subscription:<QueryList>..." line with the Access denied error - harmless noise from the task's event-triggers.
- Event-log timestamps in message text are UTC; `TimeCreated` is local.
