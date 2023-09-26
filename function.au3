#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <Date.au3>
#include <File.au3>

HotKeySet("{Esc}", "_exit")
Func _exit()
	_log('',0)
	Exit 0
EndFunc   ;==>_Exit

Func _get2InputUseGUI($title)
	GUICreate($title, 220, 120, @DesktopWidth / 3 - 160, @DesktopHeight / 2 - 45, -1, $WS_EX_ACCEPTFILES)
	Local $idInput = GUICtrlCreateInput("", 10, 5, 200, 20)
	GUICtrlSetState($idInput, $GUI_SHOW)
	Local $idInput2 = GUICtrlCreateInput("", 10, 35, 200, 20) ; will not accept drag&drop files
	GUICtrlSetState($idInput2, $GUI_SHOW)

	Local $idBtn = GUICtrlCreateButton("Ok", 40, 75, 60, 20)

	GUISetState(@SW_SHOW)
	Local $hDLL = DllOpen("user32.dll")

	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $idBtn
				ExitLoop
		EndSwitch
		If _IsPressed("0D", $hDLL) Then
			ExitLoop
		EndIf
	WEnd
	DllClose($hDLL)
	Local $result[2]
	$result[0] = GUICtrlRead($idInput)
	$result[1] = GUICtrlRead($idInput2)
	return  $result
EndFunc

Func _getInputUseGUI($title, $placeHolder)
	Local $idGUI = GUICreate($title, 320, 120, @DesktopWidth / 2 - 160, @DesktopHeight / 2 - 45, -1, $WS_EX_ACCEPTFILES)
	Local $idInput = GUICtrlCreateInput($placeHolder, 10, 5, 300, 20)
	GUICtrlSetState($idInput, $GUI_SHOW)

	Local $idBtn = GUICtrlCreateButton("Ok", 40, 75, 60, 20)

	GUISetState(@SW_SHOW)
	Local $hDLL = DllOpen("user32.dll")

	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $idBtn
				ExitLoop
		EndSwitch
		If _IsPressed("0D", $hDLL) Then
			ExitLoop
		EndIf
	WEnd
	DllClose($hDLL)
	$result = GUICtrlRead($idInput)
	GUIDelete($idGUI)
	return $result
EndFunc

Func _chooseFile($title, $fileType)
	return  FileOpenDialog($title,'Downloads', $fileType, $FD_FILEMUSTEXIST)
EndFunc
Func _getDiffBetweenTwoTimes($time1, $time2)
	Local $aTemp, $bTemp, $sHour, $sMinute, $sSecond
	$aTemp = StringSplit($time1, ":")
	$bTemp = StringSplit($time2, ":")
	$diffHour = $aTemp[1] - $bTemp[1]
	$diffMinute = $aTemp[2] - $bTemp[2]
	$diffSecond = $aTemp[3]-$bTemp[3]
	Global $diff[3]
	$diff[0] = $diffHour
	$diff[1] = $diffHour*60 + $diffMinute
	$diff[2] = $diffHour * 3600 + $diffMinute * 60 + $diffSecond
	return $diff
EndFunc
Func _getDiffSecondsBetweenTwoTimes($time1, $time2)
	$diffSeconds = _getDiffBetweenTwoTimes($time1, $time2)[2]
	if $diffSeconds < 0 then
		return $diffSeconds + 24*60*60
	Else
		return $diffSeconds
	EndIf
EndFunc
Func _openChrome()
	_log('Step 1: Open chrome')
	Send('{LWIN}')
	Sleep(500)
	Send('Chrome')
	Sleep(400)
	Send('{ENTER}')
	MouseClick('main',502, 364)
	WinWaitActive('New Tab - Google Chrome','',10)
EndFunc
Func _accessLivestreamAndFillValue($title, $description)
	_log('Step 2: Access link livestream Shopee')
	Send('https://live.shopee.vn/pc/setup')
	Send('{Enter}')
	WinWaitActive('Shopee Live - Google Chrome','', 10)
	Sleep(4000)

	_log('Step 3: Fill title, description for livestream')
	MouseClick('main',525, 431)
	Send($title)
	MouseClick('main',532, 527)
	Send($description)

	_log('Step 4: Choose products')
	MouseClick('main',528, 602) ; add product button
	Sleep(1000)
	MouseClick('main',437, 311) ; my shop button
	Sleep(500) ; wait for load products
	MouseMove(656, 379) ; move to first product
	MouseWheel($MOUSE_WHEEL_DOWN,100) ; to load more products
	MouseClick('main', 595, 709) ; choose all products
	MouseClick('main',1114, 712) ; click button Accept

	_log('Step 5: Choose type livestream')
	MouseMove(344, 684)
	MouseWheel($MOUSE_WHEEL_DOWN,100)
	MouseClick('main',602, 511) ; trial 602, 511   | Principal: 488, 514
	MouseClick('main', 526, 574) ; button Next
	Sleep(3000)
EndFunc

Func _openOBS($folderPath, $fileName)
	_log('Step 6: Open OBS')
	Sleep(100)
	Send('{LWIN}')
	Sleep(500)
	Send('OBS Studio')
	Sleep(500)
	Send('{Enter}')
	_log('Openning OBS...')
	WinMove(WinWaitActive('OBS','',15), '',0,0,1094,822)

	MouseClick('main',245, 770) ; add source
	MouseClick('main', 265, 559) ; media source
	Send('Japari')
	Send('{ENTER}') ;OK
	MouseClick('main', 331, 487) ; Checkbox Loop
	MouseClick('main', 808, 452) ; button Browse for inputting local file area
	Sleep(100)
	MouseClick('main', 541, 181) ; path area
	Sleep(100)
	Send($folderPath)
	Send('{ENTER}')
	Sleep(500)
	MouseClick('main',382, 540) ; file name
	Send($fileName)
	Send('{ENTER}')


	MouseClick('main',778, 675) ; OK

	MouseClick('right', 300, 587)  ; media source
	MouseClick('main', 422, 459) ; resize output
	Sleep(200)
	Send('{ENTER}') ; Yes

EndFunc
Func _connectShopeeWithOBS()
	_log('Step 7: Set url and key livestream Shopee to OBS')
	Send('!fs') ; File
	WinWaitActive('Settings','',5)
	MouseClick('main', 114, 118) ;Stream

	Send('!{TAB}') ; back to Chrome
	MouseClick('main',956, 573) ; copy url

	Send('!{TAB}') ; back to OBS
	MouseClick('main', 494, 123) ; url
	Send('^a') ; Ctrl + A
	Send('^v')  ; Ctrl + V

	Send('!{TAB}') ; back to Chrome
	MouseClick('main', 952, 619)  ; copy key
	Send('!{TAB}') ; back to OBS
	MouseClick('main', 509, 163) ; click to input key
	Send('^a') ; Ctrl + A
	Send('^v')  ; Ctrl + V

	MouseClick('main',978, 750) ; Apply
	MouseClick('main', 839, 747) ; OK
	Sleep(100)

	MouseClick('main', 974, 594) ; Start streaming
	Send('!{TAB}') ; back to Chrome
EndFunc
Func _livestreamShopee()
	MouseClick('main', 1122, 681) ; refresh
	MouseClick('main',1466, 182) ; Start
	_log('Step 8: Livestream starting....' &@CRLF)
EndFunc
Func _commentOnLivestream()
	Sleep(5000)
	_log('Start commenting on Livestream')
	MouseMove(1417, 360) ; comment area
	MouseWheel($MOUSE_WHEEL_DOWN,5) ;scroll to last
	MouseClick('main',1215, 794) ; Button pin
	MouseClick('main', 1265, 714) ; input comment area
	Send('Mọi người xem live nhớ ấn lấy voucher để mua hàng')
	MouseClick('main', 1478, 794) ; Button Send
	Sleep(5000)

	MouseClick('main', 1265, 714) ; input comment area
	Send('Mọi người xem live muốn tư vấn sản phẩm nào thì comment báo shop')
	MouseClick('main', 1478, 794) ; Button Send
	_log('Comment complete')
EndFunc

Func _finishLivestream()
	_log('Start finish live')
	Send('!{TAB}') ;back to OBS
	MouseClick('main', 984, 590) ; Stop Streaming

	Send('!{TAB}') ;back to Chrome
	MouseClick('main', 1469, 149) ; button End
	MouseClick('main', 898, 518) ; Button Yes
	Sleep(2000)
	MouseClick('main', 614, 462)
	Sleep(2000)
	WinClose("Shopee Live - Google Chrome")
	_log('Close chrome')
	Sleep(500)

	WinActivate('OBS 29.1.3 - Profile: Untitled - Scenes: Untitled')
	MouseClick('main',305, 585) ; click to source
	Send('{DELETE}') ; delete source
	Sleep(200)
	Send('{ENTER}') ;Yes
	WinClose('OBS 29.1.3 - Profile: Untitled - Scenes: Untitled') ; Close OBS
	_log('Close OBS')
EndFunc

Func _splitPath($path)
	$arr = StringSplit($path, '\')
	Local $result[2]
	$result[1] = $arr[$arr[0]]
	$result[0] = StringLeft($path, StringInStr($path, $result[1]) - 1)
	return $result
EndFunc

Func _findNearestJob($times, $paths)  ;return index, times[$index], diffSeconds from times[$index] to nowTime, url
	Local $diffSeconds[Ubound($times)]
	Local $nowTime = _NowTime(5)
	For $i=0 to UBound($times) - 1 step 1
		$diffSeconds[$i] = _getDiffSecondsBetweenTwoTimes($times[$i], $nowTime)
	Next
	$index = _ArrayMinIndex($diffSeconds)
	Local  $result[4] ;index, value, diffSeconds, url)
	$result[0] = $index
	$result[1] = $times[$index]
	$result[2] = $diffSeconds[$index]
	$result[3] = $paths[$index]
	return $result
EndFunc

Func _updateDiffTime($nearestJob)
	$nearestJob[2] =  _getDiffSecondsBetweenTwoTimes($nearestJob[1], _NowTime(5))
	return $nearestJob
EndFunc

Func _checkKeyExist($time)
	$jobData = _readJob()
	$key = _genKey($time)
	for $i = 0 to UBound($jobData, $UBOUND_ROWS) - 1 Step 1
		if $key = $jobData[$i][0] then ;compare key with value key in file log
			return True
		EndIf
	Next
	return False
EndFunc
Func _genKey($time)
	Local $Y, $M, $D
	$sJulDate = _DayValueToDate(_DateToDayValue(@YEAR, @MON, @MDAY), $Y, $M, $D)
	$date = $Y & $M & $D
	$timeStr = StringReplace($time, ":", "")
	return $date & $timeStr
EndFunc

Func _readJob()
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
Func _log($msg, $flag = -1)  ;1: start, 0: finish, -1: log normal
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

