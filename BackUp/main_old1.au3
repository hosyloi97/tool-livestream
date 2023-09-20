#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>


Global $paths[100]
Global $times[100]

#Region
$form = GUICreate("Config livestream", 688, 125, 635, 317)
$quantityLoop = GUICtrlCreateInput('', 40, 56, 457, 24)
$add = GUICtrlCreateButton('add',520,56,115,25)
GUISetState(@SW_SHOW)
#EndRegion

While 1
    $nMsg = GUIGetMsg()
;~ 	MsgBox(0,0,$nMsg)
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit

        Case $add
            MsgBox(0,0,$quantityLoop)

    EndSwitch
WEnd