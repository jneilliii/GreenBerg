#requires -version 3
param($path="\\dc-fas-02\vol1\apps\Inventory\")
"Looking for log files found in $path"
$patchLogs = Get-ChildItem $path\* -Include *Patch*.txt 


ForEach ($log in $patchLogs){
       $content = Import-Csv $log 
      $computer = $log.BaseName -replace '_PatchInventory',''
    $mostRecent = $content.InstalledDate | % {$_ -as [DateTime]} | sort -Descending | select -First 1
     $timestamp = $content.TimeStamp | sort -Descending | select -Last 1
        $status = $content | sort InstalledDate -Descending | select -First 1
    
    [pscustomobject]@{Computer=$computer;TimeStamp=$TimeStamp;LastPatchInstalled=$mostRecent.Date.ToString().Split()[0]}
    
}
<#
.Synopsis
   use this tool to parse the results of log files created by the SigninAssistant GPO
.DESCRIPTION
   In order to facilitate the migration from on-prem to Office 365 for GreenBerg Farrow, we at ivision developed a series of VBScripts, deployed as GPOs, and used to distribute needed pieces of software seemlessly, while also offering logging
.EXAMPLE
   .\Get-GPOPatchLogFile.ps1 -path C:\TEMP\Patches\
   Looking for log files found in C:\TEMP\Patches\

   Computer      TimeStamp            LastPatchInstalled
   --------      ---------            ------------------
   GAAT-JNEILL14 7/28/2015 2:05:25 PM 7/22/2015         
.EXAMPLE
   .\Get-GPOPatchLogFile.ps1
   Looking for logfiles found in \\dc-fas-02\vol1\apps\Inventory\

   Computer      TimeStamp             LastStatus
   --------      ---------             ----------
   GAAT-JNEILL14 7/21/2015 11:10:48 AM Installing

   This tool will search the directory \\dc-fas-02\vol1\apps\Inventory\ by default, but can also be used with an alternative path, if desired.  
#>