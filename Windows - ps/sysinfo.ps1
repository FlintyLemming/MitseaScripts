$OperatingSystemCaption = (Get-CimInstance Win32_OperatingSystem).Caption
$OSArchitecture = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
$Version = (Get-CimInstance  Win32_OperatingSystem).Version

$Uptime = (([DateTime](Get-CimInstance Win32_OperatingSystem).LocalDateTime) -
            ([DateTime](Get-CimInstance Win32_OperatingSystem).LastBootUpTime))
$FormattedUptime =  $Uptime.Days.ToString() + "天 " + $Uptime.Hours.ToString() + "小时 " + $Uptime.Minutes.ToString() + "分钟 " + $Uptime.Seconds.ToString() + "秒 "

$CPUModule = ((Get-CimInstance Win32_Processor).Name) -replace '\s+', ' '
$CPUClass = Get-WmiObject -Class Win32_Processor
$CPULoad = $CPUClass.LoadPercentage
$ComputerMemory = Get-WmiObject -Class win32_operatingsystem -ErrorAction Stop
$UsedMemory = ($ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory)
$Memory = ((($UsedMemory)*100)/ $ComputerMemory.TotalVisibleMemorySize)
$RoundMemory = [math]::Round($Memory, 2)
$TotalMemory = [math]::Round(($ComputerMemory.TotalVisibleMemorySize/1048576),2)
$FreeMemory = [math]::Round(($ComputerMemory.FreePhysicalMemory/1048576),2)
$RoundUsedMemory = [math]::Round(($UsedMemory/1048576), 2)

$FormattedDisks = New-Object System.Collections.Generic.List[System.Object];

$NumDisks = (Get-CimInstance Win32_LogicalDisk).Count;

if ($NumDisks) {
    for ($i=0; $i -lt ($NumDisks); $i++) {
        $DiskID = (Get-CimInstance Win32_LogicalDisk)[$i].DeviceId;

        $DiskSize = (Get-CimInstance Win32_LogicalDisk)[$i].Size;

        if ($DiskSize -gt 0) {
            $FreeDiskSize = (Get-CimInstance Win32_LogicalDisk)[$i].FreeSpace
            $FreeDiskSizeGB = $FreeDiskSize / 1073741824;
            $FreeDiskSizeGB = "{0:N0}" -f $FreeDiskSizeGB;

            $DiskSizeGB = $DiskSize / 1073741824;
            $DiskSizeGB = "{0:N0}" -f $DiskSizeGB;

            if ($DiskSizeGB -gt 0 -And $FreeDiskSizeGB -gt 0) {
                $FreeDiskPercent = ($FreeDiskSizeGB / $DiskSizeGB) * 100;
                $FreeDiskPercent = "{0:N0}" -f $FreeDiskPercent;

                $UsedDiskSizeGB = $DiskSizeGB - $FreeDiskSizeGB;
                $UsedDiskPercent = ($UsedDiskSizeGB / $DiskSizeGB) * 100;
                $UsedDiskPercent = "{0:N0}" -f $UsedDiskPercent;
            }
            else {
                $FreeDiskPercent = 0;
                $UsedDiskSizeGB = 0;
                $UsedDiskPercent = 0;
            }
        }
        else {
            $DiskSizeGB = 0;
            $FreeDiskSizeGB = 0;
            $FreeDiskPercent = 0;
            $UsedDiskSizeGB = 0;
            $UsedDiskPercent = 100;
        }

        $FormattedDisk = "磁盘 " + $DiskID.ToString() + " " + 
            $UsedDiskSizeGB.ToString() + "GB" + " / " + $DiskSizeGB.ToString() + "GB " + 
            "(" + $UsedDiskPercent.ToString() + "%" + ")";
        $FormattedDisks.Add($FormattedDisk);
    }
}
else {
    $DiskID = (Get-CimInstance Win32_LogicalDisk).DeviceId;

    $FreeDiskSize = (Get-CimInstance Win32_LogicalDisk).FreeSpace
    $FreeDiskSizeGB = $FreeDiskSize / 1073741824;
    $FreeDiskSizeGB = "{0:N0}" -f $FreeDiskSizeGB;

    $DiskSize = (Get-CimInstance Win32_LogicalDisk).Size;
    $DiskSizeGB = $DiskSize / 1073741824;
    $DiskSizeGB = "{0:N0}" -f $DiskSizeGB;

    if ($DiskSize -gt 0 -And $FreeDiskSize -gt 0 ) {
        $FreeDiskPercent = ($FreeDiskSizeGB / $DiskSizeGB) * 100;
        $FreeDiskPercent = "{0:N0}" -f $FreeDiskPercent;

        $UsedDiskSizeGB = $DiskSizeGB - $FreeDiskSizeGB;
        $UsedDiskPercent = ($UsedDiskSizeGB / $DiskSizeGB) * 100;
        $UsedDiskPercent = "{0:N0}" -f $UsedDiskPercent;

        $FormattedDisk = "磁盘 " + $DiskID.ToString() + " " +
            $UsedDiskSizeGB.ToString() + "GB" + " / " + $DiskSizeGB.ToString() + "GB " +
            "(" + $UsedDiskPercent.ToString() + "%" + ")";
        $FormattedDisks.Add($FormattedDisk);
    } 
    else {
        $FormattedDisk = "磁盘 " + $DiskID.ToString() + " 空";
        $FormattedDisks.Add($FormattedDisk);
    }
}

Write-Host "----------------系统---------------"
Write-Host "系统：" $OperatingSystemCaption 
Write-Host "架构：" $OSArchitecture 
Write-Host "版本：" $Version 
Write-Host "运行时间：" $FormattedUptime 
Write-Host "----------------CPU---------------"
Write-Host "型号：" $CPUModule 
Write-Host "负载：" $CPULoad "%"
Write-Host "----------------内存---------------"
Write-Host "总内存：" $TotalMemory "GB"
Write-Host "可用内存：" $FreeMemory "GB"
Write-Host "已用内存：" $RoundUsedMemory "GB"
Write-Host "已用内存占比：" $RoundMemory "%"
Write-Host "----------------硬盘---------------"  
Write-Host $FormattedDisk
