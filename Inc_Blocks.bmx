
' Type brique
Type T_FT_Brique
	Field Image:TImage				' Image de la brique
	Field PosX:Int				' Distance par rapport au centre de rotation
	Field PosY:Int
	
	' Creation d'un bloque
	Function Create:T_FT_Brique(Image:TImage, PosX:Int, PosY:Int)
		
		Local b:T_FT_Brique = New T_FT_Brique
				
		b.Image = Image
		b.PosX = PosX
		b.PosY = PosY
				
		Return b

	End Function

End Type


' Type bloque
Type T_FT_Bloque
	Field TypeBrique:Int
	Field TailleBrique:Int			' Taille d'une brique
	Field PosX:Float				' Position en x du bloque
	Field PosY:Float				' Position en y du bloque
	Field Etat:Int
	Field Brique1:T_FT_Brique
	Field Brique2:T_FT_Brique
	Field Brique3:T_FT_Brique
	Field Brique4:T_FT_Brique
	Field CanMove:Byte
	
	' Creation d'un bloque
	Function Create:T_FT_Bloque(TypeBrique:Int, PosX:Int, PosY:Int, TailleBrique:Int = 30)
		
		Local b:T_FT_Bloque = New T_FT_Bloque
		
		b.TypeBrique = TypeBrique
		b.PosX = PosX
		b.PosY = PosY
		b.Etat = 1
		b.TailleBrique = TailleBrique
		
		Select TypeBrique
		
			' ####
			Case 1
				b.Brique1 = T_FT_Brique.Create(SprBriqueJaune, -1, 0)
				b.Brique2 = T_FT_Brique.Create(SprBriqueJaune, 0, 0)
				b.Brique3 = T_FT_Brique.Create(SprBriqueJaune, 1, 0)
				b.Brique4 = T_FT_Brique.Create(SprBriqueJaune, 2, 0)
				
			' ##
			' ##
			Case 2
				b.Brique1 = T_FT_Brique.Create(SprBriqueVerte, 0, 0)
				b.Brique2 = T_FT_Brique.Create(SprBriqueVerte, 1, 0)
				b.Brique3 = T_FT_Brique.Create(SprBriqueVerte, 0, 1)
				b.Brique4 = T_FT_Brique.Create(SprBriqueVerte, 1, 1)
			
			'  #
			' ###
			Case 3
				b.Brique1 = T_FT_Brique.Create(SprBriqueMauve, -1, 0)
				b.Brique2 = T_FT_Brique.Create(SprBriqueMauve, 0, 0)
				b.Brique3 = T_FT_Brique.Create(SprBriqueMauve, 1, 0)
				b.Brique4 = T_FT_Brique.Create(SprBriqueMauve, 0, 1)
			
			'   #
			' ###  
			Case 4
				b.Brique1 = T_FT_Brique.Create(SprBriqueBleue, 2, 0)
				b.Brique2 = T_FT_Brique.Create(SprBriqueBleue, 1, 0)
				b.Brique3 = T_FT_Brique.Create(SprBriqueBleue, 0, 0)
				b.Brique4 = T_FT_Brique.Create(SprBriqueBleue, 2, 1)
				
			' #
			' ###  
			Case 5
				b.Brique1 = T_FT_Brique.Create(SprBriqueOrange, 2, 0)
				b.Brique2 = T_FT_Brique.Create(SprBriqueOrange, 1, 0)
				b.Brique3 = T_FT_Brique.Create(SprBriqueOrange, 0, 0)
				b.Brique4 = T_FT_Brique.Create(SprBriqueOrange, 0, 1)
				
			' ##
			'  ##
			Case 6
				b.Brique1 = T_FT_Brique.Create(SprBriqueRouge, -1, 1)
				b.Brique2 = T_FT_Brique.Create(SprBriqueRouge, 0, 1)
				b.Brique3 = T_FT_Brique.Create(SprBriqueRouge, 0, 0)
				b.Brique4 = T_FT_Brique.Create(SprBriqueRouge, 1, 0)
				
			'  ##
			' ##
			Case 7
				b.Brique1 = T_FT_Brique.Create(SprBriqueCian, 0, 1)
				b.Brique2 = T_FT_Brique.Create(SprBriqueCian, 1, 1)
				b.Brique3 = T_FT_Brique.Create(SprBriqueCian, -1, 0)
				b.Brique4 = T_FT_Brique.Create(SprBriqueCian, 0, 0)

		End Select
		
		Return b

	End Function
	
	' Methode qui dessine les blocs
	Method Draw()
		
		DrawImage(Brique1.Image, (250 + ((PosX + Brique1.PosX) * TailleBrique)), (550 - TailleBrique) - ((PosY + Brique1.PosY) * TailleBrique))
		DrawImage(Brique2.Image, (250 + ((PosX + Brique2.PosX) * TailleBrique)), (550 - TailleBrique) - ((PosY + Brique2.PosY) * TailleBrique))
		DrawImage(Brique3.Image, (250 + ((PosX + Brique3.PosX) * TailleBrique)), (550 - TailleBrique) - ((PosY + Brique3.PosY) * TailleBrique))
		DrawImage(Brique4.Image, (250 + ((PosX + Brique4.PosX) * TailleBrique)), (550 - TailleBrique) - ((PosY + Brique4.PosY) * TailleBrique))
		
	End Method

End Type




