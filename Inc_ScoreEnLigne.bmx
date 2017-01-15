' Regarde si on est connecte
Function CheckIfConnected:Byte()
	
	Local in:TStream
	Local Ligne:String = ""

	in=ReadStream(URL_Fichier_Txt+"CheckIfConnected.txt")
	
	If in Then
		CloseStream(in)
		Return True
	Else
		Return False
	End If

End Function


' Enregistrement du score en ligne
Function OL_EnregistrerScore()
	
	Local in:TStream

	in=ReadStream(URL_Rep_Scripts+"Insert.php?Nom="+ChaineNom+"&Level="+Level+"&Points="+Score_NbPoints+"&Lignes="+Score_NbLignes+"&Key="+OL_GetNbEnr())
	
	CloseStream(in)

End Function


' Initialisation du tableau des scores
Function OL_InitTabScore()

	Local in:TStream
	Local i:Int = 0
	Local Ligne:String
	Local PosTab1:Int
	Local PosTab2:Int
	Local PosTab3:Int
	
	in=ReadStream(URL_Rep_Scripts+"Select.php")
	
	While (Not(Eof(in))) And i < 10
		
		Ligne = ReadLine(in)
		
		PosTab1 = Instr(Ligne, Chr(KEY_TAB), 1)
		PosTab2 = Instr(Ligne, Chr(KEY_TAB), PosTab1 + 1)
		PosTab3 = Instr(Ligne, Chr(KEY_TAB), PosTab2 + 1)
		
		If Right(Ligne, Len(Ligne) - PosTab3) <> ""
			Tab_Score[i].Nom = Right(Ligne, Len(Ligne) - PosTab3)
			Tab_Score[i].Score = Int(Left(Ligne, PosTab1 - 1))
			Tab_Score[i].Lignes = Int(Right(Left(Ligne, PosTab2 - 1), (PosTab2 - 1) - (PosTab1)))
			Tab_Score[i].Level = Int(Right(Left(Ligne, PosTab3 - 1), (PosTab3 - 1) - (PosTab2)))
		End If

		i :+ 1
		
	Wend
	
	CloseStream(in)
	
End Function

' Initialisation du tableau des scores du bas
Function OL_InitTabScoreBas()

	Local in:TStream
	Local i:Int = 0
	Local Ligne:String
	Local PosTab1:Int
	Local PosTab2:Int
	Local PosTab3:Int
	
	in=ReadStream(URL_Rep_Scripts+"SelectBas.php?Nom="+ChaineNom+"&Score="+Score_NbPoints)
	
	While (Not(Eof(in))) And i < 4
		
		Ligne = ReadLine(in)
		
		PosTab1 = Instr(Ligne, Chr(KEY_TAB), 1)
		PosTab2 = Instr(Ligne, Chr(KEY_TAB), PosTab1 + 1)
		PosTab3 = Instr(Ligne, Chr(KEY_TAB), PosTab2 + 1)
		
		If Right(Ligne, Len(Ligne) - PosTab3) <> ""
			Tab_Score_Bas[i].Nom = Right(Ligne, Len(Ligne) - PosTab3)
			Tab_Score_Bas[i].Score = Int(Left(Ligne, PosTab1 - 1))
			Tab_Score_Bas[i].Lignes = Int(Right(Left(Ligne, PosTab2 - 1), (PosTab2 - 1) - (PosTab1)))
			Tab_Score_Bas[i].Level = Int(Right(Left(Ligne, PosTab3 - 1), (PosTab3 - 1) - (PosTab2)))
		End If

		i :+ 1
		
	Wend
	
	CloseStream(in)
	
End Function



' Nombre d'enregistrements dans la table Score
Function OL_GetNbEnr:String()
	
	Local in:TStream
	Local nbEnr:String = ""
	
	in=ReadStream(URL_Rep_Scripts+"Count.php")
	
	nbEnr = ReadLine(in)
	
	CloseStream(in)
	
	Return nbEnr

End Function

' Derniere version dispo
Function OL_GetVersion:String()

	Local in:TStream
	Local Version:String = ""
	
	in=ReadStream(URL_Rep_Scripts+"GetVersion.php")
	
	Version = ReadLine(in)
	
	CloseStream(in)
	
	Return Version

End Function
