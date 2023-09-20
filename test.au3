#include <MsgBoxConstants.au3>

; Retrieve the character position of where the string 'white' first occurs in the sentence.
Local $iPosition = StringSplit("C:\Users\mrloiho\Downloads\Sạch gàu hết ngứa bí quyết do đâu - Dầu gội dược liệu Nguyên Xuân.mp4", "\")
for $i = 1 to $iPosition[0]
	MsgBox(0,0,'index '&$i&' is: '& $iPosition[$i])
Next
