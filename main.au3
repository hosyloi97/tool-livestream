#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <function.au3>
#include <Date.au3>



Global $paths[100]
Global $times[100]

$paths[0] = _chooseFile('Choose video', 'Videos (*.mp4;*.mpg;*.avi)')
$pathSplits = _splitPath($paths[0])
$fileName = $pathSplits[1]
$folderPath = $pathSplits[0]


$times[0] = '12:00:00'
$diffSeconds = _getDiffBetweenTwoTimes($times[0], _NowTime(5))[2]
MsgBox(0,0,$diffSeconds)
if $diffSeconds > 0 then
	_openChrome()
	_accessLivestreamAndFillValue('Xem live nhận voucher', 'Vào xem live để nhận voucher và mua hàng nào mọi người ơi')
	_openOBS($folderPath, $fileName)
	_connectShopeeWithOBS()
	_livestreamShopee()
EndIf