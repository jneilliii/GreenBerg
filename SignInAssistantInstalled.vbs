'iVision Determine HotFix installation / inventory tool
' Usage  : use this tool as a startup script to determine if a program is installed, and if not, install it
' Author : Stephen Owen
' Date   : 07/21/2015
' version:  
'           0.1 - detect if program installed

'Setup stating variables
Set objFSO=CreateObject("Scripting.FileSystemObject")
Set stdOut = objFSO.getStandardStream (1)
Set wshNetwork = WScript.CreateObject( "WScript.Network" )
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Const TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0
    strComputerName = wshNetwork.ComputerName
    strComputer = "."
    patchfound = 0
    'prod Path below
    'params = " /quiet /passive /norestart /log \\localhost\Patches\" & strComputerName & "_SignInIassistant.log"
    'testPath
    params = " /quiet /passive /norestart /log \\localhost\Patches\" & strComputerName & "_SignInIassistant.log"
    'Testlab path
    
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")


'Stephen testlab path
  logPath =  "\\localhost\Patches\" & strComputerName & ".log"
  HotfixPath = "\\localhost\Patches\msoidcli_64.msi"
'Production below
  'logPath =  "\\localhost\Patches\"& strComputerName & ".log"
  'set HotfixPath = "\\localhost\Patches\WindowsXP-KB944043-v3-x86-ENU.exe"
Const For_Writing = 2


'Gather OS info
Set OperInfo = objWMIService.ExecQuery("Select * from Win32_OperatingSystem",,48)
 For Each OS in OperInfo
     OSName = OS.Caption
     SPVers = OS.Version
 Next

'check for log file, if not exist, create
if objFSO.FileExists(logPath) then
    ''
  Else
    'make a file'
    stdOut.WriteLine "No log file exists at " & logpath & " creating"
    Set objFileToCreate = objFSO.CreateTextFile(logPath)
    stdOut.WriteLine "Just created " & logPath
    WScript.Sleep 750
    data = "TimeStamp,OS,SignInIassistantInstalled,Version"
        stdOut.WriteLine "First line to contain " & data
        stdOut.WriteLine "Writing..."
    'Set objFileToWrite = objFSO.OpenTextFile(logPath,2,true)
        objFileToCreate.WriteLine(data)
        objFileToCreate.Close
    Set objFileToCreate = Nothing
End If

'determine if patch is needed 
'if OSName <> "Microsoft Windows XP Professional" then
 '   stdOut.WriteLine "System is not Win XP, patch not needed"
  '  Set objFileToWrite = objFSO.OpenTextFile(logPath,8,true)
   '     data = Now & "," & OSName & ",NA"
    '    stdOut.WriteLine data
     '   objFileToWrite.WriteLine(data)
      '  objFileToWrite.Close
   ' Else

stdOut.WriteLine "Searching for installed programs..."

'Gather Patch Info
    Set colItems = objWMIService.ExecQuery("Select * from Win32_Product",,48)



'colItems contains all of the hotfixes installed on this machine
For Each objItem in colItems
    If objItem.Name = "Microsoft Online Services Sign-in Assistant" then
        Version = objItem.Version
        stdOut.WriteLine "We found the signin Assistant , logging"
        Set objFileToWrite = CreateObject("Scripting.FileSystemObject").OpenTextFile(logPath,8,true)
        data = Now & "," & OSName & ",Installed," & Version 
        stdOut.WriteLine data
        objFileToWrite.WriteLine(data)
        objFileToWrite.Close
        patchfound = 1
        Set objFileToWrite = Nothing
        'leave the loop early with Exit For to save CPU time
        Exit For
    End If
next


    if patchfound = 0 then
        stdOut.WriteLine "SignIn Assistant not found, installing"
        set objFileToWrite = CreateObject("Scripting.FileSystemObject").OpenTextFile(logPath,8,TristateFalse)
            data = Now & "," & OSName & ",Installing, NA"
            stdOut.WriteLine data
            objFileToWrite.WriteLine(data)
        Set Shell = CreateObject("WScript.Shell")
        set oEnv = Shell.Environment("PROCESS")
            'For XP Machines, need to disable the Open File - Security Warning dialog
            oEnv("SEE_MASK_NOZONECHECKS") = 1
        stdOut.WriteLine "About to install with: " & HotfixPath & " " & params
        Shell.Run "msiexec /i " & HotfixPath & " " & params, 0, True
        objFileToWrite.Close
            'Restore the Open File - Security Warning dialog
            oEnv.Remove("SEE_MASK_NOZONECHECKS")
    End If

'Because we removed WinXP check, this closing if is now not needed
'End If

 