# How to use these scripts

# SignInAssistantInstalled.vbs 
#####Purpose: Deploy as GPO, installs the Single Sign On assistant.  
  It will check for the Sign In Assistant (SSO) program, and if not there, install it.  It will log to the network path specified on line 27.  

  The only things to be adjusted are the references on line 20, 27 & 28, which should be updated with the actual path where the install file and logs will be placed.

#Get-InstalledProgram.ps1 
#####Purpose: used to monitor the success of SignInAssistantInstalled.vbs 
This tool is used to remotely query WMI on machines (the source of which is specified on line 2), to check and see if the Sign In Assistant program has been installed.  This was written to speed Abe’s efforts, and is intended to be used once the Sign In Assistant GPO has been running for a few days.  It will write a report to the PowerShell console identifying whether machines have or do not have SSO installed, or if a machine was offline.  

#DetermineNewestHotFixINstalled.vbs
#####Purpose: Deploy as GPO, writes a .csv of Update data
  This script is ready for production, just update line 26 with the path to place the log files it outputs.  It will scan a machine and return a table of the updates installed, and the last installed date of each, writing this as %comptuername%.csv. This can be scraped with a few lines of PowerShell to determine whether or not a machine has installed updates recently.  

####For Reporting
To pour through a bulk number of logs, use the two Get-* .ps1 commands.  Each will default to the appropriate directory for this client, and will grab files of the apropriate type for parsing.  

*You may need to authorize scripts on your computer, by changing the PowerShell execution policy*

To change the execution policy, launch PowerShell as an administrator, then run the following:
`Set-ExecutionPolicy RemoteSigned`.  

Before running them, ensure that your system has at least PowerShell version 3.0 installed (only needed on the machine from which the logs will be reviewed, not needed on every system).  If you do not have PowerShell v3.0 install it by [downloading WMF 3.0!](https://www.microsoft.com/en-us/download/details.aspx?id=34595).
