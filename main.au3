#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <function.au3>
#include <Date.au3>
#include <Array.au3>
#include <File.au3>

fLog('',1)
Local $inputTime = _getInputUseGUI('input list time job run', 'format HH:mm:ss (separate time by ;)')
Global $times = StringSplit($inputTime, ';', $STR_NOCOUNT)
Global $paths[UBound($times)]
For $i= 0 to UBound($times) -1 step 1
	Local $videoPath = _chooseFile('Choose video ' &($i + 1), 'Videos (*.mp4;*.mpg;*.avi)')
	$paths[$i] = $videoPath
Next
fLog('Input times and paths done')
Local $nearestJob = _findNearestJob($times, $paths)
fLog('nearestJob: '& $nearestJob)
Local $STATUS[3] = ['PROCESSING','SUCCESS','FAIL']
While True
	if $nearestJob[2] > 5*60 Then  ; 5 minutes
		fLog('Start sleep '&($nearestJob[2]- 5*60)*1000 &' miliseconds')
		Sleep(($nearestJob[2]- 5*60)*1000)  ; Sleep until the nearest
		$nearestJob = _updateDiffTime($nearestJob)
	ElseIf not checkKeyExist($nearestJob[1]) then
		$pathSplits = _splitPath($nearestJob[3])
		$fileName = $pathSplits[1]
		$folderPath = $pathSplits[0]
		$jobData = readJob()
		$sizeJobData = UBound($jobData, $UBOUND_ROWS)
		Local $log[8] = [genKey($nearestJob[1]), _NowDate(), '','',$nearestJob[3], $STATUS[0],_Now(), _Now()]
		_ArrayAdd($jobData, $log)
		_FileWriteFromArray('.\job.csv', $jobData, Default, Default, ',')
		_openChrome()
		_accessLivestreamAndFillValue('Xem live nhận voucher', 'Vào xem live để nhận voucher và mua hàng nào mọi người ơi')
		_openOBS($folderPath, $fileName)
		_connectShopeeWithOBS()
		_livestreamShopee()
		_commentOnLivestream()
		_finishLivestream()
		$jobData[$sizeJobData -1][2] = _Now()
		$jobData[$sizeJobData -1][5] = $STATUS[1]
		_FileWriteFromArray('.\job.csv', $jobData, Default, Default, ',')
		fLog('Livestream is running')
	EndIf
WEnd
fLog('', 0)



Func checkKeyExist($time)
	$jobData = readJob()
	$key = genKey($time)
	for $i = 0 to UBound($jobData, $UBOUND_ROWS) - 1 Step 1
		if $key = $jobData[$i][0] then ;compare key with value key in file log
			return True
		EndIf
	Next
	return False
EndFunc
Func genKey($time)
	Local $Y, $M, $D
	$sJulDate = _DayValueToDate(_DateToDayValue(@YEAR, @MON, @MDAY), $Y, $M, $D)
	$date = $Y & $M & $D
	$timeStr = StringReplace($time, ":", "")
	return $date & $timeStr
EndFunc

Func readJob()
	Dim $columns = 'key,dateLive,timeStartLive,timeFinishLive,urlLive,status,createdTimestamp,updatedTimestamp'
	If not FileExists('.\job.csv') Then
		If not FileWrite('.\job.csv', $columns&@CRLF) Then
			MsgBox($MB_SYSTEMMODAL, '', 'An error occurred while writing the file')
			Exit
		EndIf
	EndIf
	Local $jobData
	_FileReadToArray('.\job.csv', $jobData, Default, ',')
	return $jobData
EndFunc
Func fLog($msg, $flag = -1)  ;1: start, 0: finish, -1: log normal
	Global $flagMsg = '<------------------------'& ($flag=1?'START':$flag=0?'FINISH':'')&'------------------->'
	Global $path = '.\log.txt'
	Global $hFileOpen = FileOpen($path, 1)
	If $hFileOpen = -1 Then
		ConsoleWrite("An error occurred whilst writing the temporary file.")
		Return False
	EndIf
	if $flag = -1 then
		FileWriteLine($hFileOpen, _Now()&': '& $msg)
		ConsoleWrite( _Now()&': '& $msg &@CRLF)
	ElseIf $flag = 1 then
		FileWriteLine($hFileOpen, '')
		FileWriteLine($hFileOpen, _Now()&': '& $flagMsg)
		ConsoleWrite(@CRLF& _Now()&': '& $flagMsg &@CRLF)

	Else
		FileWriteLine($hFileOpen, _Now()&': '& $flagMsg)
		FileWriteLine($hFileOpen, '')
		ConsoleWrite(_Now()&': '& $flagMsg &@CRLF)
	EndIf
	FileClose($hFileOpen)
EndFunc