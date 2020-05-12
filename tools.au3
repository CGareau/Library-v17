#include <GuiRichEdit.au3>
#include "Memory.au3"
#include <WinAPI.au3>
#include <SendMessage.au3>
#include <WindowsConstants.au3>

Global $g4D = "4D"
Global $gStudentsWin = "Manage Students"

Func Myclick($controlId, $center=true)
	Local $aPos = ControlGetPos($g4D, "", $controlId)

;~ 	MsgBox(0,"",@error)

	if(@error = 1) then
;~ 		MsgBox(0,"","error")
	else
		Local $aDeltaX =0
		Local $aDeltaY =0
		if ($center) Then
			$aDeltaX =$aPos[2]/2
			$aDeltaY =$aPos[3]/2
		EndIf
		MouseClick ( "" , $aPos[0]+$aDeltaX, $aPos[1]+44 +$aDeltaY , 1 , 0 )
		Sleep(10)
	EndIf
EndFunc

Func MysendText($text)
	Local $aCars = StringSplit($text, "")
	local $count
	For $count = 1 To $aCars[0]
		send($aCars[$count])
		sleep(50)
    Next

EndFunc

Func MyControlGetText($controlId)
	return ControlGetText($g4D, "", $controlId)
EndFunc

Func MyDropDownGetSelected($controlId)
	Local $hControl = ControlGetHandle($g4D, "", $controlId)
	local $idx = _SendMessage($hControl, 0x147, 0,0)
	return $idx
EndFunc

Func WaitControl($controlId, $timeout=3000)
	Local $result = 0

;~ 	Local $hControl = ControlGetHandle($g4D, "", $controlId)


	return $result
EndFunc

