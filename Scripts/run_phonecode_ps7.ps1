Write-Host "PhoneCode PSVersion: $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"

# Anpassbare Variablen
$mainFolder = "C:\temp\Result\PhoneCode_$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
$scriptPath = "C:\scripts\algorithmen\PhoneCode_Problem.ps1"
$numRuns = 10

function Get-SystemUsage {
    $cpu = Get-Counter '\Processor(_Total)\% Processor Time'
    $ram = Get-Counter '\Memory\% Committed Bytes In Use'
    return "$($cpu.CounterSamples.CookedValue),$($ram.CounterSamples.CookedValue)"
}

# Hauptordner erstellen
$null = New-Item -ItemType Directory -Path $mainFolder -Force


for ($i = 1; $i -le $numRuns; $i++) {
    $runFolder = "$mainFolder\Run_$i"
    New-Item -ItemType Directory -Path $runFolder -Force

    $outputFilePath = "$runFolder\Output_Run_$i.csv"
    $infoFilePath = "$runFolder\Info_Run_$i.txt"
    $outputData = @()

    $idleUsage = Get-SystemUsage

    $executionTime = Measure-Command {
        
        Start-Process -Filepath "C:\Program Files\PowerShell\7-preview\pwsh.exe" -ArgumentList  "-File $scriptPath"

        do {
            Start-Sleep -Milliseconds 10
            $currentUsage = Get-SystemUsage
            $outputData += $currentUsage
        } while ((Get-Process pwsh -ErrorAction SilentlyContinue).Count -ge 2)
    }

    $outputData += Get-SystemUsage

    $header = "CPU,RAM"
    $header | Out-File -FilePath $outputFilePath
    $outputData | Out-File -FilePath $outputFilePath -Append

    $executionTimeInSeconds = $executionTime.TotalSeconds

    $idleEntry = "Idle CPU,Idle RAM"
    $idleData = "$($idleUsage)"
    $runtimeEntry = "Script Laufzeit (Sekunden),$executionTimeInSeconds"

    $idleEntry | Out-File -FilePath $infoFilePath
    $idleData | Out-File -FilePath $infoFilePath -Append
    $runtimeEntry | Out-File -FilePath $infoFilePath -Append
}

"Done"