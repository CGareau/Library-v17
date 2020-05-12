#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <json.au3>
#include "tools.au3"
#include <Array.au3>

local $addStudentBTN 		= 0x34AE36F2

;~ HotKeySet("{F2}","_Start")

;~ While 1
;~     Sleep(1000)
;~ WEnd

_Start()

Func createStudentIn4D($fname,$lname,$grade)
	local $showAllBTN 			= 0x6EBEB181
	local $validateBTN 			= 0x03B01954
	local $cancelBTN 			= 0xF6E72E38
	local $lnameEdit	 		= 0xE0A47655
	local $fnameEdit	 		= 0xAF9D7849
	local $gradeDropDown	 	= 0x15DE537D

	local $result = 0
;~ bring manage students window to the front
local $manageWindowTitle = "Manage Students"
;~ click add button
	Myclick($addStudentBTN)
	sleep(200)

	Myclick($lnameEdit)
	sleep(200)
	MysendText($lname)

	Myclick($fnameEdit)
	sleep(200)
	MysendText($fname)

	send("{tab}");force edit control to lose focus and validate data
	sleep(50)

;~ $gradeDropDown
	local $gradeContent = MyControlGetText($gradeDropDown)
	local $gradeArr = Json_Decode($gradeContent)
	local $gradIdx = _ArraySearch($gradeArr, $grade,0,0,0,2)
	If $gradIdx == -1 Then
		$result = 301
	Else
		Myclick($gradeDropDown)
		sleep(1000)
		For $i=0 to $gradIdx
			send("{DOWN}")
			sleep(200)
		Next
		send("{ENTER}")
		sleep(200)
;~ 		MsgBox(0,"1","1")
	EndIf
;~ Verfication
	if $result == 0 Then
		local $lnameEdited = MyControlGetText($lnameEdit)
		local $fnameEdited = MyControlGetText($fnameEdit)
		local $gradeEditedIdx = MyDropDownGetSelected($gradeDropDown)

		if ($lnameEdited <> $lname) OR ($fnameEdited<>$fname) Then
			$result = 300
		EndIf

		if ($gradeArr[$gradeEditedIdx] <> $grade) Then
			$result = 302
		EndIf

	EndIf

	if $result == 0 Then
		Myclick($validateBTN)
;~ Myclick($cancelBTN)
	Else
		Myclick($cancelBTN)
	EndIf

	sleep(200)

	return $result
EndFunc

Func createStudent($fname,$lname,$grade)
	local $studentLB 			= 0xAF6892C0
	Local $result = 0
;~ 	verify that the student does not exists
	local $content = MyControlGetText($studentLB)
	local $data = Json_Decode($content)
	local $lnameData = Json_ObjGet($data, "Column1")
	local $fnameData = Json_ObjGet($data, "Column2")
;~ MsgBox(0,"1",$content)
	local $isStudentExists = False
	If IsArray($fnameData) Then
		For $i=0 to UBound($fnameData)-1
			local $fnameLB = $fnameData[$i]
			if $fnameLB == $fname Then
;~ 				MsgBox(0,"2","the student name exists : " & $fname & " " & $fnameLB)
				local $lnameLB = $lnameData[$i]
				if $lnameLB == $lname Then
					$isStudentExists = True
				EndIf
			EndIf
		Next
	EndIf

	if $isStudentExists Then
	;~ student already exists
;~ 		MsgBox(0,"","the student already exists : " & $fname & " " & $lname)
		$result = 100
	Else
	;~ create the student
		$result = createStudentIn4D($fname,$lname,$grade)
	EndIf

	return $result
EndFunc

Func _Start()
	local $result = 0
;~ 	wait 4D
	Local $win4D = WinWait($g4D,20)
	if $win4D==0 Then
;~ 		MsgBox(0," WinWait($g4D,20)","error")
		$result = 1
	Else
		WinActivate($win4D)
		sleep(1000)
		send("^u");shortcut
		sleep(1000)
		Local $winStudents = WinGetHandle ($g4D,$gStudentsWin)
		if $winStudents==0 Then
;~ 			MsgBox(0," WinWait($gStudentsWin,5)","error")
			$result = 2
		Else
			 WinActivate($winStudents)
;~ 			 MsgBox(0,"2","ok")
			 sleep(1000)
			;read students to add in json format
			$fileopen = FileOpen(@ScriptDir & "/addStudents.json")
			$fileRead = FileRead($fileopen)
			$data = Json_Decode($fileRead)
			$studentsData = Json_ObjGet($data, "students")
			If IsArray($studentsData) Then
				For $i=0 to UBound($studentsData)-1
					local $fname = Json_ObjGet($studentsData[$i], "fname")
					local $lname = Json_ObjGet($studentsData[$i], "lname")
					local $grade = Json_ObjGet($studentsData[$i], "grade")
					;add student to 4D
					$result = createStudent($fname,$lname,$grade)
					;~ wait until list form appears
				Next
			EndIf
		EndIf
	EndIf
EndFunc