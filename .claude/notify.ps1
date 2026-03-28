Add-Type -AssemblyName System.Windows.Forms
$n = New-Object System.Windows.Forms.NotifyIcon
$n.Icon = [System.Drawing.SystemIcons]::Information
$n.BalloonTipTitle = "Claude Code"
$n.BalloonTipText = "Done! Quay lai xem ket qua nhe."
$n.Visible = $True
$n.ShowBalloonTip(8000)
Start-Sleep 2
$n.Dispose()
