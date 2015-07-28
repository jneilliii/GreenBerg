'iVision Determine HotFix installation / inventory tool
' Usage  : use this tool as a startup script to determine the newest updates on a machine
' Author : Stephen Owen
' Date   : 05/11/2015


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
    'params = " /quiet /passive /norestart /log:" & "\\localhost\Patches\" & strComputerName & "_PatchInstall.log"
    'testPath
    params = " /quiet /passive /norestart /log:" & "\\localhost\Patches\" & strComputerName & "_PatchInventory.log"
    'Testlab path
    
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")


'Stephen testlab path
  logPath =  "t:\Patches\" & strComputerName & ".log"
'Production below
  'logPath =  "\\localhost\Patches\"& strComputerName & ".log"
Const For_Writing = 2


'Gather OS info
Set OperInfo = objWMIService.ExecQuery("Select * from Win32_OperatingSystem",,48)
 For Each OS in OperInfo
     OSName = OS.Caption
     SPVers = OS.Version
 Next

'check for log file, if not exist, create
if objFSO.FileExists(logPath) then
    stdOut.WriteLine "File exists, proceeding"
  Else
    'make a file'
    stdOut.WriteLine "No log file exists at " & logpath & " creating"
    Set objFileToCreate = objFSO.CreateTextFile(logPath)
    stdOut.WriteLine "Just created " & logPath
    WScript.Sleep 750
    data = "TimeStamp,HotFixID,InstalledDate"
        stdOut.WriteLine "First line to contain " & data
        stdOut.WriteLine "Writing..."
    'Set objFileToWrite = objFSO.OpenTextFile(logPath,2,true)
        objFileToCreate.WriteLine(data)
        objFileToCreate.Close
    
End If

'determine if patch is needed 
'if OSName <> "Microsoft Windows XP Professional" then
'    stdOut.WriteLine "System is not Win XP, patch not needed"
 '   Set objFileToWrite = objFSO.OpenTextFile(logPath,8,true)
 '       data = Now & "," & OSName & ",NA"
  '      stdOut.WriteLine data
   '     objFileToWrite.WriteLine(data)
    '    objFileToWrite.Close
   ' Else

'Gather Patch Info
    Set colItems = objWMIService.ExecQuery("Select * from Win32_QuickFixEngineering",,48)


stdOut.WriteLine "List all patches"
Set objFileToWrite = objFSO.OpenTextFile(logPath,8,true)

'colItems contains all of the hotfixes installed on this machine
For Each objItem in colItems
   ' stdOut.WriteLine objItem.HotfixID & "," & objItem.InstalledOn
   
       
        data = Now & "," & objItem.HotfixID & "," & objItem.InstalledOn
        stdOut.WriteLine data
        objFileToWrite.WriteLine(data)
        
    

next
objFileToWrite.Close



 