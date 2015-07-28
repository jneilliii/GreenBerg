#requires -version 3
param($path="\\dc-fas-02\vol1\apps\Inventory\")
"Looking for log files found in $path"
$SSOClientLogs = Get-ChildItem $path\* -Include *SignIn*.log 

#$patchLogs = Get-childItem "C:\TEMP\Patches\*Patch*.log"
#$SSOcllogs = Get-childItem "C:\TEMP\Patches\*SignIn*.log"


ForEach ($log in $SSOClientLogs){
    $content = Import-Csv $log 
    $computer = $log.BaseName -replace '_SignInassistant',''
    $status = $content | sort TimeStamp -Descending | select -First 1
    
    [pscustomobject]@{Computer=$computer;TimeStamp=$status.TimeStamp;LastStatus=$status.SignInIassistantInstalled}
    
}
<#
.Synopsis
   use this tool to parse the results of log files created by the SigninAssistant GPO
.DESCRIPTION
   In order to facilitate the migration from on-prem to Office 365 for GreenBerg Farrow, we at ivision developed a series of VBScripts, deployed as GPOs, and used to distribute needed pieces of software seemlessly, while also offering logging
.EXAMPLE
   .\Get-GPOssoLogfile.ps1
   Looking for logfiles found in \\dc-fas-02\vol1\apps\Inventory\

   Computer      TimeStamp             LastStatus
   --------      ---------             ----------
   GAAT-JNEILL14 7/21/2015 11:10:48 AM Installing
.EXAMPLE
   .\Get-GPOssoLogfile.ps1 -path C:\TEMP\Patches

   Looking for log files found in C:\TEMP\Patches
   Computer      TimeStamp            LastStatus
   --------      ---------            ----------
   GAAT-JNEILL14 7/28/2015 2:05:50 PM Installed 

   This tool can also be used with an alternative path, if desired.  
#>
