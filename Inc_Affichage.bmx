' ----------------------------------------
' Fonction qui va afficher les textes à partir des images de fonts
' ----------------------------------------
Function AfficherTexte(Chaine:String, x:Int, y:Int, TailleFonte:Int)
	If Chaine = "" Then
		Return
	Else
		For i = 1 To Len(Chaine)
			DrawImage SprFonte, x + ((i - 1) * TailleFonte), y, NumImage(Right(Left(Chaine, i), 1))
		Next
	End If
End Function

' ----------------------------------------
' Fonction qui va afficher un sinus scroll
' ----------------------------------------
Function SinusScroll(Chaine:String, x:Int, y:Int, TailleFonte:Int, Coeff:Int = 50, Frequence:Float = 2)

Local PosX%

	If Chaine = "" Then
		Return
	Else
		For i = 1 To Len(Chaine)
			PosX = x + ((i - 1) * TailleFonte)
			DrawImage SprFonte, PosX, y + (Cos((PosX - (i - 1) * TailleFonte/Frequence) * Frequence) * Coeff), NumImage(Right(Left(Chaine, i), 1))
		Next
	End If
End Function

' ------------------------------------------------------------
' Fonction qui retourne le numéro de frame en fonction du caractère
' ------------------------------------------------------------
Function NumImage:Int(Char:String)

	If (Char = "a" Or Char = "A") Return 0
	If (Char = "b" Or Char = "B") Return 1
	If (Char = "c" Or Char = "C") Return 2
	If (Char = "d" Or Char = "D") Return 3
	If (Char = "e" Or Char = "E") Return 4
	If (Char = "f" Or Char = "F") Return 5
	If (Char = "g" Or Char = "G") Return 6
	If (Char = "h" Or Char = "H") Return 7
	If (Char = "i" Or Char = "I") Return 8
	If (Char = "j" Or Char = "J") Return 9
	If (Char = "k" Or Char = "K") Return 10
	If (Char = "l" Or Char = "L") Return 11
	If (Char = "m" Or Char = "M") Return 12
	If (Char = "n" Or Char = "N") Return 13
	If (Char = "o" Or Char = "O") Return 14
	If (Char = "p" Or Char = "P") Return 15
	If (Char = "q" Or Char = "Q") Return 16
	If (Char = "r" Or Char = "R") Return 17
	If (Char = "s" Or Char = "S") Return 18
	If (Char = "t" Or Char = "T") Return 19
	If (Char = "u" Or Char = "U") Return 20
	If (Char = "v" Or Char = "V") Return 21
	If (Char = "w" Or Char = "W") Return 22
	If (Char = "x" Or Char = "X") Return 23
	If (Char = "y" Or Char = "Y") Return 24
	If (Char = "z" Or Char = "Z") Return 25
	
'	If Char = "'" Return 26
'	If Char = "." Return 27
'	If Char = "," Return 28
'	If Char = "-" Return 29
'	If Char = "!" Return 30
'	If Char = "?" Return 31
	
	If Char = "0" Return 28
	If Char = "1" Return 29
	If Char = "2" Return 30
	If Char = "3" Return 31
	If Char = "4" Return 32
	If Char = "5" Return 33
	If Char = "6" Return 34
	If Char = "7" Return 35
	If Char = "8" Return 36
	If Char = "9" Return 37

	If Char = " " Return 53

End Function
