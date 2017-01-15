'Strict

'Include "./partengine061.bmx"

'Incbin "Medias/chars/Seiya/bitmapseiyatr.bmp"
'Incbin "Medias/Sparks/PixieDust.png"


Const CJ_Anim_Ping_Pong = 0			
Const CJ_Anim_Boucle = 1
Const CJ_Anim_Aller_Simple_Down = 2
Const CJ_Anim_Aller_Simple_Hit = 3
Const CJ_Anim_Aller_Retour = 4


Rem

	'================================================================'
	' TFrame
	'================================================================'
	
	Type TFrame
	
	Contient :
		- un numero d'image
		- le temps que celle-ci doit etre affichee
End Rem

Type TFrame
	Field Frame_Num:Int						' Numero de frame
	Field Frame_Temps:Int					' Temps que la frame doit rester affichee
	
	' Creation d'une frame
	Function Create:TFrame(Numero:Int, Temps:Int)
		
		Local f:TFrame = New TFrame
		
			f.Frame_Num = Numero
			f.Frame_Temps = Temps
		
		Return f
		
	End Function
	
End Type


Rem

	'================================================================'
	' TAnim
	'================================================================'
	
	Type TAnim
	
	Contient :
		- Le nom de l'animation
		- [Anim_Timer]
		- Le numéro de la 1ere frame de l'anim
		- Le nombre de frames de l'anim
		- 1 liste qui contient l'ensemble des TFrame composant l'anim
		- Si l'anim doit etre jouee en boucle ou non
		- [Anim_Precedente]
End Rem

Type TAnim
	Field Anim_Nom:String					' Nom de l'animation
	Field Anim_Timer:Int					' Timer pour la gestion des frames
	Field Anim_Debut:Int					' 1ere image de l'animation
	Field Anim_Nb_Image:Int					' Nombre d'images dans l'animation
	Field Anim_Liste_Frame:TList			' Liste des animations
	Field Anim_Type_Anim:Int				' Type de l'animation
	Field Anim_Loop:Byte					' L'animation boucle-t-elle ?
	Field Anim_Precedente:String			' Nom de l'anim précédente pour voir si celle-ci a changé
	
	' Creation d'une animation
	Function Create:TAnim(Nom:String, Debut:Int, Nb_Image:Int, Type_Anim:Int, Loop:Byte)
	
        Local a:TAnim = New TAnim
		
		a.Anim_Nom = Nom
		a.Anim_Debut = Debut
		a.Anim_Nb_Image = Nb_Image
		a.Anim_Liste_Frame:TList = New TList
        a.Anim_Type_Anim = Type_Anim
		a.Anim_Loop:Byte = Loop
        a.Anim_Precedente = ""

        Return a

    End Function

	' Ajouter une frame
	Method AddFrame(Numero:Int, Temps:Int)
	
		Local f:TFrame = TFrame.Create(Numero, Temps)
		
		' On ajoute la frame a la liste de frames
		Anim_Liste_Frame.AddLast(f)
	
	End Method

End Type


Rem

	'================================================================'
	' TSpriteAnime
	'================================================================'
	
	Type TSpriteAnime
	
	Contient :
		- L'image du Sprite anime
		- Le nom de l'animation courante
		- La position du sprite en X
		- La position du sprite en Y
		- 1 liste qui contient l'ensemble des TAnim composant l'anim
		- L'heure de debut de l'animation
		- Le numero de la frame courante
		- Un tableau dynamique qui permet de gerer les anims de type ping pong
End Rem

Type TSpriteAnime
	Field SA_Image:TImage				' Image 
	Field SA_Anim_Defaut:String			' Animation jouee par defaut
	Field SA_Etat:String				' Etat du sprite suivant les actions du joueur
	Field SA_Anim_Courante:String		' Nom de l'animation en cours
	Field SA_PosX:Int					' Position X
	Field SA_PosY:Int					' Position Y
	Field SA_Liste_Anim:TList			' Animations du sprite
	Field SA_H_Debut_Anim:Int			' Heure du debut de l'animation
	Field SA_Frame_Courante:Int			' Frame courante
	Field SA_Flip_H:Byte				' Est'ce qu'il faut dessiner le symetrique par rapport à un axe vertical ?
	Field SA_Tab_Frame:Int[0, 0]		' Tableau des frames pour une animation ping pong
	
	' Fonction de creation d'un TSpriteAnime
	Function Create:TSpriteAnime(Nom:String, Image:TImage, PosX:Int, PosY:Int) Abstract

	' Afectation de l'animation jouee par defaut
	Method SetAnimDefaut(AnimDefaut:String)
	
		self.SA_Anim_Defaut = AnimDefaut
	
	End Method

	' Ajouter une animation
	Method AddAnim(Nom:String, Debut:Int, Nb_Image:Int, Type_Anim:Int, Loop:Byte)
	
		Local a:TAnim = TAnim.Create(Nom, Debut, Nb_Image, Type_Anim, Loop)
		
		' On ajoute l'animation a la liste des animations
		SA_Liste_Anim.AddLast(a)
	
	End Method
	
	' Ajouter une frame a une animation
	Method AddFrame(Nom:String, Numero:Int, Temps:Int)
	
		Local a:TAnim
		
		For a = EachIn SA_Liste_Anim
			If a.Anim_Nom = Nom Then
				' On ajoute l'animation a la liste des animations
				a.AddFrame(Numero, Temps)
			End If
		Next
	
	End Method
	
	' Change l'animation courante
	Method SetAnimCourante(Anim_Courante:String)
	
		Local f:TFrame
		Local a:TAnim
		Local i:Int = 0
		Local j:Int
		Local k:Int = 1
		
		self.SA_Etat = Anim_Courante
		self.SA_Anim_Courante = Anim_Courante
		self.SA_H_Debut_Anim = MilliSecs()
		
		For a = EachIn self.SA_Liste_Anim
			If a.Anim_Nom = Anim_Courante Then
				If a.Anim_Type_Anim = CJ_Anim_Ping_Pong Then
			
					SA_Tab_Frame = New Int[((2 * a.Anim_Nb_Image) - 2), 3]
				
'					Print "nb = " + ((2 * a.Anim_Nb_Image) - 2)
				
					For f = EachIn a.Anim_Liste_Frame
						SA_Tab_Frame[i, 0] = i
						SA_Tab_Frame[i, 1] = f.Frame_Num
						SA_Tab_Frame[i, 2] = f.Frame_Temps
'						Print "i = " + i + ", frame = " + f.Frame_Num + ", Temps = " + f.Frame_Temps
						i :+ 1
					Next
				
					For j = i To ((2 * (i-1)) - 1)
'						Print "j = " + j
						SA_Tab_Frame[j, 0] = j
						SA_Tab_Frame[j, 1] = SA_Tab_Frame[i - (k + 1), 1]
						SA_Tab_Frame[j, 2] = SA_Tab_Frame[i - (k + 1), 2]
						k :+ 1
'						Print "j = " + j + ", frame = " + SA_Tab_Frame[i - k, 1] + ", Temps = " + SA_Tab_Frame[i - k, 2]
					Next 
					
'					For j = 0 To ((2 * (i-1)) - 1)
'						Print "j = " + j + ", frame = " + SA_Tab_Frame[j, 1] + ", Temps = " + SA_Tab_Frame[j, 2]
'					Next
					
				End If
			End If
		Next
	
	End Method
	
	' Determine la frame a afficher
	Method UpdateAnim()
		
		Local f:TFrame
		Local a:TAnim
		Local TempsDepuisDebutAnim:Int		' Temps qui s'est écoule depuis le debut de l'animation
		Local TempsCalcul:Int = 0			' Temps qui nous permet de savoir quelle frame doit etre affichee
		Local FrameTrouvee:Byte = False		' Nous indique si la frame qui doit etre affichee a ete trouvee
		Local FrameCalcul:Int				' Nous permet de calculer la frame qui doit etre affichee
		Local i:Int
		
		TempsDepuisDebutAnim = MilliSecs() - self.SA_H_Debut_Anim
		
		For a = EachIn self.SA_Liste_Anim
			If a.Anim_Nom = self.SA_Anim_Courante Then
				FrameCalcul = a.Anim_Debut
				
				
				Select a.Anim_Type_Anim
				
					' Animation jouee en boucle
					Case CJ_Anim_Boucle
					
						For f = EachIn a.Anim_Liste_Frame
							TempsCalcul :+ f.Frame_Temps
							FrameCalcul :+ 1
							If (TempsDepuisDebutAnim < TempsCalcul) And (FrameTrouvee = False) Then
								SA_Frame_Courante = FrameCalcul - 1
								FrameTrouvee = True
							End If
						Next
						
						If (TempsDepuisDebutAnim > TempsCalcul) And (FrameTrouvee = False) Then
							If a.Anim_Loop = True
								SA_Frame_Courante = a.Anim_Debut
								self.SA_H_Debut_Anim = MilliSecs()
							Else
								self.SetAnimCourante(SA_Anim_Defaut)
							End If
						End If
						
					' Animation de type ping pong
					Case CJ_Anim_Ping_Pong 

						For i = 0 To ((2 * (a.Anim_Nb_Image)) - 2) - 1
							TempsCalcul :+ SA_Tab_Frame[i, 2]
'							FrameCalcul :+ 1
							If (TempsDepuisDebutAnim < TempsCalcul) And (FrameTrouvee = False) Then
'								Print TempsCalcul
								SA_Frame_Courante = SA_Tab_Frame[i, 1]
								FrameTrouvee = True
							End If
						Next
						
						If (TempsDepuisDebutAnim > TempsCalcul) And (FrameTrouvee = False) Then
							If a.Anim_Loop = True
								SA_Frame_Courante = SA_Tab_Frame[0, 1]
								self.SA_H_Debut_Anim = MilliSecs()
							Else
								self.SetAnimCourante(SA_Anim_Defaut)
							End If
							'DrawText 
						End If

					' Animation qui reste figee sur la derniere image
					Case CJ_Anim_Aller_Simple_Down
						
						For f = EachIn a.Anim_Liste_Frame
							TempsCalcul :+ f.Frame_Temps
							FrameCalcul :+ 1
							If (TempsDepuisDebutAnim < TempsCalcul) And (FrameTrouvee = False) Then
								SA_Frame_Courante = f.Frame_Num 'FrameCalcul - 1
								FrameTrouvee = True
							End If
							
						Next
					
					Case CJ_Anim_Aller_Simple_Hit
					
						For f = EachIn a.Anim_Liste_Frame
							TempsCalcul :+ f.Frame_Temps
							FrameCalcul :+ 1
							If (TempsDepuisDebutAnim < TempsCalcul) And (FrameTrouvee = False) Then
								SA_Frame_Courante = f.Frame_Num 'FrameCalcul - 1
								FrameTrouvee = True
							End If
							
						Next

						If FrameTrouvee = False
							self.SetAnimCourante(SA_Anim_Defaut)
						End If
						
'						If (TempsDepuisDebutAnim > TempsCalcul) And (FrameTrouvee = False) Then
'							If a.Anim_Loop = True
'								SA_Frame_Courante = FrameCalcul - 1
'							Else
'								self.SetAnimCourante("standing")
'							End If
'						End If
						
				End Select
				
			End If
		Next
		
	End Method
	
	
	' Mise a jour du joueur
	Method Update(Flag:Int = 1)
		
		Select Flag
			
			' On ne prend plus les mises a jour d'action
			Case 0
				If self.SA_Etat <> self.SA_Anim_Courante Then
					self.SetAnimCourante(self.SA_Etat)
				End If
				self.UpdateAnim()
				
			' On prend les mises a jour d'action	
			Case 1
				If self.SA_Etat <> self.SA_Anim_Courante Then
					self.SetAnimCourante(self.SA_Etat)
				End If
				self.UpdateAnim()
				
		End Select
		
	End Method

	' Affichage
	Method Draw()
		
		If SA_Flip_H = False Then
			DrawImage(self.SA_Image, self.SA_PosX, self.SA_PosY, self.SA_Frame_Courante)
		Else
			SetScale -1, 1
			DrawImage(self.SA_Image, self.SA_PosX, self.SA_PosY, self.SA_Frame_Courante)
			SetScale 1, 1
		End If
		
	End Method
		
End Type


' Type TPerso: Perso d'un jeu de baston
Type TPerso Extends TSpriteAnime
	
	Field Perso_Nom:String					' Nom du perso
	Field Perso_Vie:Float					' Niveau de vie du perso
	Field Perso_Controleur:String			' clavier ou joystick
	Field Perso_Tab_Combo:Int[5, 2]			' Tableau qui enregistre la sequence des entrees du joueur
	Field Perso_En_Attaque:Byte				' Indique si un perso est en attaque
	
	Const PERSO_DROITE = 0

	' Creation d'un sprite
	Function Create:TPerso(Nom:String, Image:TImage, PosX:Int, PosY:Int)
		
		Local p:TPerso = New TPerso
		Local i:Int
		
		p.Perso_Nom = Nom
		p.SA_Image = Image
		p.SA_PosX = PosX
		p.SA_PosY = PosY
		p.SA_Liste_Anim:TList = New TList
		p.SA_H_Debut_Anim = MilliSecs()
		p.SA_Flip_H = False
		
		For i = 0 To 4
			p.Perso_Tab_Combo[i, 0] = -1
			p.Perso_Tab_Combo[i, 1] = MilliSecs()
		Next
		
		p.Perso_Vie = 1000
		p.Perso_En_Attaque = False
		
		
		Return p

	End Function
	
	' Initialisation des joueurs
	Method Initialiser()
	
		' Animation de chaque perso
		self.AddAnim("couche", 0, 4, CJ_Anim_Boucle, True)
		self.AddFrame("couche", 0, 100)
		self.AddFrame("couche", 1, 100)
		self.AddFrame("couche", 2, 100)
		self.AddFrame("couche", 3, 100)
				
		self.AddAnim("saute", 4, 4, CJ_Anim_Aller_Simple_Hit, False)
		self.AddFrame("saute", 4, 150)
		self.AddFrame("saute", 5, 150)
		self.AddFrame("saute", 6, 150)
		self.AddFrame("saute", 7, 150)
				
		self.AddAnim("pleure", 8, 3, CJ_Anim_Ping_Pong, True)
		self.AddFrame("pleure", 8, 100)
		self.AddFrame("pleure", 9, 100)
		self.AddFrame("pleure", 10, 100)
				
		self.SetAnimDefaut("couche")
		'self.SetAnimCourante("couche")
		self.SetAnimCourante(self.SA_Anim_Defaut)
				
			
	End Method
	
	' Mise a jour du joueur
	Method Update(Flag:Int = 1)
		
		super.Update(Flag)
		UpdateCoord()
		
	End Method
	
	
	
	Method UpdateCoord()
	
		' Mise a jour des coordonnées pendant le saut
	    If SA_Anim_Courante = "saute" Then
			SA_PosY = 470 - (50 * Sin((180 * (MilliSecs() - SA_H_Debut_Anim))/600))
		End If
		
		If SA_Anim_Courante = "couche" Then
			SA_PosY = 470
		End If
		
		If SA_Anim_Courante = "pleure" Then
			SA_PosY = 470
		End If
		
	End Method

	


End Type

