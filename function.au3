#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <Date.au3>

HotKeySet("{Esc}", "_exit")
Func _exit()
	Exit 0
EndFunc   ;==>_Exit

Func _getInputUseGUI($msg)
	GUICreate($msg, 220, 120, @DesktopWidth / 3 - 160, @DesktopHeight / 2 - 45, -1, $WS_EX_ACCEPTFILES)
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

Func _chooseFile($title, $fileType)
	return  FileOpenDialog($title,@WindowsDir & "\", $fileType, $FD_FILEMUSTEXIST)
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

Func _openChrome()
	ConsoleWrite('Step 1: Open chrome' & @CRLF)

	MouseClick('main',834, 840)
	WinWaitActive('New Tab - Google Chrome','',10)
EndFunc

;~ _openChrome()
;~ _accessLivestreamAndFillValue('Xem live nhận voucher', 'Vào xem live để nhận voucher và mua hàng nào mọi người ơi')
;~ _openOBS()
;~ _connectShopeeWithOBS()
;~ _livestreamShopee()

Func _accessLivestreamAndFillValue($title, $description)
	ConsoleWrite('Step 2: Access link livestream Shopee' & @CRLF)
	Send('https://live.shopee.vn/pc/setup')
	Send('{Enter}')
	WinWaitActive('Shopee Live - Google Chrome','', 10)
	Sleep(5000)

	ConsoleWrite('Step 3: Fill title, description for livestream' & @CRLF)
	MouseClick('main',525, 431)
	Send($title)
	MouseClick('main',532, 527)
	Send($description)

	ConsoleWrite('Step 4: Choose products' & @CRLF)
	MouseClick('main',528, 602) ; add product button
	Sleep(1000)
	MouseClick('main',437, 311) ; my shop button
	Sleep(500) ; wait for load products
	MouseMove(656, 379) ; move to first product
	MouseWheel($MOUSE_WHEEL_DOWN,100) ; to load more products
	MouseClick('main', 595, 709) ; choose all products
	MouseClick('main',1114, 712) ; click button Accept

	ConsoleWrite('Step 5: Choose type livestream' & @CRLF)
	MouseMove(344, 684)
	MouseWheel($MOUSE_WHEEL_DOWN,100)
	MouseClick('main',602, 511) ; trial 602, 511   | Principal: 488, 514
	MouseClick('main', 526, 574) ; button Next
	Sleep(3000)
EndFunc

Func _openOBS($folderPath, $fileName)
	ConsoleWrite('Step 6: Open OBS' & @CRLF)
	Sleep(100)
	Send('{LWIN}')
	Sleep(500)
	Send('OBS Studio')
	Sleep(100)
	Send('{Enter}')
	ConsoleWrite('Openning OBS...')
	WinWaitActive('OBS','',15)


	MouseClick('main',248, 715) ; add source
	MouseClick('main', 323, 498) ; media source
	Send('Japari')
	MouseClick('main',602, 513) ;OK
	MouseClick('main', 330, 459) ; Checkbox Loop
	MouseClick('main', 829, 425) ; input local file area
	Sleep(100)
	MouseClick('main', 600, 157) ; path area
	Sleep(100)
	Send($folderPath)
	Send('{ENTER}')
	Sleep(500)
	MouseClick('main',594, 512) ; file name
	Send($fileName)
	Send('{ENTER}')


	MouseClick('main',780, 646) ; OK

	MouseClick('right', 283, 530)  ; media source
	MouseClick('main', 438, 466) ; resize output
	MouseClick('main', 693, 430) ; Yes

EndFunc
Func _connectShopeeWithOBS()
	ConsoleWrite('Step 7: Set url and key livestream Shopee to OBS' & @CRLF)
	Send('!fs') ; File
	WinWaitActive('Settings','',5)
	MouseClick('main', 112, 102) ;Stream

	MouseClick('main',795, 842) ; click to input url
	MouseClick('main',954, 572) ; copy url

	Send('!{TAB}') ; back to OBS
	MouseClick('main', 649, 106) ; url
	Send('^a') ; Ctrl + A
	Send('^v')  ; Ctrl + V

	Send('!{TAB}') ; back to Chrome
	MouseClick('main', 952, 619)  ; copy key
	Send('!{TAB}') ; back to OBS
	MouseClick('main', 781, 146) ; click to input key
	Send('^a') ; Ctrl + A
	Send('^v')  ; Ctrl + V

	MouseClick('main',986, 737) ; Apply
	MouseClick('main', 839, 731) ; OK
	Sleep(100)

	MouseClick('main', 979, 536) ; Start streaming
	Send('!{TAB}') ; back to Chrome
EndFunc
Func _livestreamShopee()
	MouseClick('main', 1122, 681) ; refresh
	MouseClick('main',1466, 182) ; Start
	ConsoleWrite('Step 8: Livestream starting....' &@CRLF)
EndFunc
Func _commentOnLivestream()
EndFunc

Func _closeChrome()
;~ 	WinClose
EndFunc

Func _splitPath($path)
	$arr = StringSplit($path, '\')
	Local $result[2]
	$result[1] = $arr[$arr[0]]
	$result[0] = StringLeft($path, StringInStr($path, $result[1]) - 1)
	return $result
EndFunc
