' Type score
Type T_FT_Score
	Field Nom:String				' Nom du joueur
	Field Score:Int					' Score (nb de points)
	Field Lignes:Int				' Nb de lignes
	Field Level:Int					' Level
	
	' Creation d'un bloque
	Function Create:T_FT_Score(Nom:String = "", Score:Int = 0, Lignes:Int = 0, Level:Int = 0)
		
		Local s:T_FT_Score = New T_FT_Score
				
		s.Nom = Nom
		s.Score = Score
		s.Lignes = Lignes
		s.Level = Level
		
		Return s

	End Function

End Type



Function GenererFichierScores()

	' Creation du fichier
	iniCreerFichier("SCORES.DAT")
	' Ecriture du meilleur score
	iniCreerSection("SCORES.DAT", "Score 01")
	iniCreerVariableStr("SCORES.DAT", "Score 01", "Nom", "ftbass")
	iniCreerVariableInt("SCORES.DAT", "Score 01", "Score", 10000)
	iniCreerVariableInt("SCORES.DAT", "Score 01", "Lignes", 100)
	iniCreerVariableInt("SCORES.DAT", "Score 01", "Level", 10)
	' Ecriture du 2e score
	iniCreerSection("SCORES.DAT", "Score 02")
	iniCreerVariableStr("SCORES.DAT", "Score 02", "Nom", "gerome")
	iniCreerVariableInt("SCORES.DAT", "Score 02", "Score", 9000)
	iniCreerVariableInt("SCORES.DAT", "Score 02", "Lignes", 90)
	iniCreerVariableInt("SCORES.DAT", "Score 02", "Level", 9)
	' Ecriture du 3e score
	iniCreerSection("SCORES.DAT", "Score 03")
	iniCreerVariableStr("SCORES.DAT", "Score 03", "Nom", "ftbass")
	iniCreerVariableInt("SCORES.DAT", "Score 03", "Score", 8000)
	iniCreerVariableInt("SCORES.DAT", "Score 03", "Lignes", 80)
	iniCreerVariableInt("SCORES.DAT", "Score 03", "Level", 8)
	' Ecriture du 4e score
	iniCreerSection("SCORES.DAT", "Score 04")
	iniCreerVariableStr("SCORES.DAT", "Score 04", "Nom", "gerome")
	iniCreerVariableInt("SCORES.DAT", "Score 04", "Score", 7000)
	iniCreerVariableInt("SCORES.DAT", "Score 04", "Lignes", 70)
	iniCreerVariableInt("SCORES.DAT", "Score 04", "Level", 7)
	' Ecriture du 5e score
	iniCreerSection("SCORES.DAT", "Score 05")
	iniCreerVariableStr("SCORES.DAT", "Score 05", "Nom", "ftbass")
	iniCreerVariableInt("SCORES.DAT", "Score 05", "Score", 6000)
	iniCreerVariableInt("SCORES.DAT", "Score 05", "Lignes", 60)
	iniCreerVariableInt("SCORES.DAT", "Score 05", "Level", 6)
	' Ecriture du 6e score
	iniCreerSection("SCORES.DAT", "Score 06")
	iniCreerVariableStr("SCORES.DAT", "Score 06", "Nom", "gerome")
	iniCreerVariableInt("SCORES.DAT", "Score 06", "Score", 5000)
	iniCreerVariableInt("SCORES.DAT", "Score 06", "Lignes", 50)
	iniCreerVariableInt("SCORES.DAT", "Score 06", "Level", 5)
	' Ecriture du 7e score
	iniCreerSection("SCORES.DAT", "Score 07")
	iniCreerVariableStr("SCORES.DAT", "Score 07", "Nom", "ftbass")
	iniCreerVariableInt("SCORES.DAT", "Score 07", "Score", 4000)
	iniCreerVariableInt("SCORES.DAT", "Score 07", "Lignes", 40)
	iniCreerVariableInt("SCORES.DAT", "Score 07", "Level", 4)
	' Ecriture du 8e score
	iniCreerSection("SCORES.DAT", "Score 08")
	iniCreerVariableStr("SCORES.DAT", "Score 08", "Nom", "gerome")
	iniCreerVariableInt("SCORES.DAT", "Score 08", "Score", 3000)
	iniCreerVariableInt("SCORES.DAT", "Score 08", "Lignes", 30)
	iniCreerVariableInt("SCORES.DAT", "Score 08", "Level", 3)
	' Ecriture du 9e score
	iniCreerSection("SCORES.DAT", "Score 09")
	iniCreerVariableStr("SCORES.DAT", "Score 09", "Nom", "ftbass")
	iniCreerVariableInt("SCORES.DAT", "Score 09", "Score", 2000)
	iniCreerVariableInt("SCORES.DAT", "Score 09", "Lignes", 20)
	iniCreerVariableInt("SCORES.DAT", "Score 09", "Level", 2)
	' Ecriture du 10e score
	iniCreerSection("SCORES.DAT", "Score 10")
	iniCreerVariableStr("SCORES.DAT", "Score 10", "Nom", "gerome")
	iniCreerVariableInt("SCORES.DAT", "Score 10", "Score", 1000)
	iniCreerVariableInt("SCORES.DAT", "Score 10", "Lignes", 10)
	iniCreerVariableInt("SCORES.DAT", "Score 10", "Level", 1)
	
End Function


Function InitTabScore()

	Local i:Int
	Local iString:String

	For i = 0 To 9

		If i + 1 < 10 Then
			iString = "0" + String(i + 1)
		Else
			iString = String(i + 1)
		End If

		Tab_Score[i].Nom = iniLireVariableStr("SCORES.DAT", "Score " + iString, "Nom")
		Tab_Score[i].Score = iniLireVariableInt("SCORES.DAT", "Score " + iString, "Score")
		Tab_Score[i].Lignes = iniLireVariableInt("SCORES.DAT", "Score " + iString, "Lignes")
		Tab_Score[i].Level = iniLireVariableInt("SCORES.DAT", "Score " + iString, "Level")
	Next
	
End Function


Function InsererScore()
	
	Local i:Int
	Local iString:String
	Local Rang:Int
	Local Trouve:Byte = False
	
	For i = 0 To 9
		If (Tab_Score[i].Score < Score_NbPoints) And (trouve = False) Then
			Rang = i
			Trouve = True
		End If
	Next
	
	If Trouve = True Then
		For i = 8 To Rang Step -1
			Tab_Score[i + 1].Score = Tab_Score[i].Score
			Tab_Score[i + 1].Nom = Tab_Score[i].Nom
			Tab_Score[i + 1].Lignes = Tab_Score[i].Lignes
			Tab_Score[i + 1].Level = Tab_Score[i].Level
		Next
		
		Tab_Score[Rang].Score = Score_NbPoints
		Tab_Score[Rang].Nom = ChaineNom
		Tab_Score[Rang].Lignes = Score_NbLignes
		Tab_Score[Rang].Level = Level
	End If
	
End Function


Function EnregistrerScores()

	Local i:Int
	Local iString:String
	
	DeleteFile("SCORES.DAT")

	' Creation du fichier
	iniCreerFichier("SCORES.DAT")

	For i = 0 To 9

		If i + 1 < 10 Then
			iString = "0" + String(i + 1)
		Else
			iString = String(i + 1)
		End If
		
		iniCreerSection("SCORES.DAT", "Score " + iString)
		iniCreerVariableStr("SCORES.DAT", "Score " + iString, "Nom", Tab_Score[i].Nom)
		iniCreerVariableInt("SCORES.DAT", "Score " + iString, "Score", Tab_Score[i].Score)
		iniCreerVariableInt("SCORES.DAT", "Score " + iString, "Lignes", Tab_Score[i].Lignes)
		iniCreerVariableInt("SCORES.DAT", "Score " + iString, "Level", Tab_Score[i].Level)

	Next

End Function