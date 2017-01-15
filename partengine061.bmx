	'######################################################################'
	'#	PartEngine Beta v0.6.1
	'#	
	'#	par Julien COIGNET aka ftbass
	'#	email : breddabasse@hotmail.com
	'######################################################################'

	' A FAIRE :
	' - 
	'----------------------------

Rem
################################################################
# Pour en faire un module, enlever les commentaires d'ici...

Strict


Module ftbass.partengine

ModuleInfo "Name: PartEngine"
ModuleInfo "Description: Moteur de particules 2D"
ModuleInfo "Auteur: ftbass"

Import BRL.LinkedList
Import BRL.System
Import BRL.Random
Import BRL.Max2D

# ... a ici.
################################################################
EndRem


Global P2D_ListeEmet:TList = New TList		' Liste des émetteurs


'################################################################
' Type Emetteur
'################################################################
Type TEmetteur

	Field listePart:TList			' Liste des particules creees par cet emetteur
	
	Field image:TImage					' Image affichée par les particules
	Field x:Float, y:Float			' Position de l'emetteur
	Field ecartX:Float			' Ecart de la position en Y des particules a la creation
	Field ecartY:Float			' Ecart de la position en Y des particules a la creation
	Field dx:Float, dy:Float		' Vitesse
	Field accX:Float, accY:Float	' Accélération
	Field age:Int					' Age de l'emetteur
	Field heureCreation:Int		' Heure de creation de l'emetteur
	Field longevite:Int			' Duree apres laquel l'emetteur sera supprime
	Field angle:Float				' Angle d'emission des particules
	Field nbPartFrame:Float		' Nb de particules créé par frame
	Field nbFramePourEmt:Float		' Nb de frames entre chaque emission de particules (si nbPartFrame < 0)
	Field nbFrameRestant:Int		' Nb de frames avant emission (si nbPartFrame < 0)
	Field nbPartCourant:Int		' Nb de particules actuellement en activité
	Field echelleXIni:Float		' Scale X initial
	Field echelleYIni:Float		' Scale Y initial
	Field ecartEchelleXIni:Float	' Ecar(t en X du scale initial
	Field ecartEchelleYIni:Float	' Ecar(t en Y du scale initial
	Field dEchelleX:Float			' Modification du scale X
	Field dEchelleY:Float			' Modification du scale Y
	Field alphaIni:Float			' Alpha initial
	Field ecartAlpha:Float			' Ecart alpha initial
	Field dAlpha:Float			' Evolution de l'alpha
	Field ecartDAlpha:Float		' Ecart dans l'evolution de l'alpha
	Field typeEmt:String			' Type de l'emetteur : alpha / light
	Field viePart:Int				' Duree de vie d'une particule
	Field ecartViePart:Int			' Ecart pour la durée de vie des particules
	
	Field etat:String				' Etat de l'emetteur : actif / supprime
	
	'-----------------------------------------------------------
	' Mise à jour de l'emetteur
	'-----------------------------------------------------------
	Method Update()
	
		Local i:Int
		Local p:TParticule = New TParticule
	
		If longevite = -1 Then
			Select etat
				Case "actif"
					' On met à jour l'age de l'emetteur
					age = (MilliSecs() - heureCreation) '/ 1000
					If nbPartFrame >= 1 Then
						For i = 1 To nbPartFrame
							p = P2D_CreatePart(Self, image, x, y, Rnd(ecartX) - (ecartX / 2), Rnd(ecartY) - (ecartY / 2))', 0, -1, 0, 0)
							p.ReglerEchelle(echelleXIni + (Rnd(ecartEchelleXIni) - (ecartEchelleXIni/2)), echelleYIni + (Rnd(ecartEchelleYIni) - (ecartEchelleYIni/2)), dEchelleX:Float, dEchelleY:Float)
							p.ReglerAlpha(alphaIni + (Rnd(ecartAlpha)  - (ecartAlpha / 2)), dAlpha + (Rnd(ecartDAlpha) - (ecartDAlpha /2)))
							p.ReglerVelocite(dx, dy, accX, accY)
							p.ReglerVie(viePart, ecartViePart)
						Next
					Else
						If nbFrameRestant < 0 Then
							p = P2D_CreatePart(Self, image, x, y, Rnd(ecartX) - (ecartX / 2), Rnd(ecartY) - (ecartY / 2))', 0, -1, 0, 0)
							p.ReglerEchelle(echelleXIni + (Rnd(ecartEchelleXIni) - (ecartEchelleXIni/2)), echelleYIni + (Rnd(ecartEchelleYIni) - (ecartEchelleYIni/2)), dEchelleX:Float, dEchelleY:Float)
							p.ReglerAlpha(alphaIni + (Rnd(ecartAlpha)  - (ecartAlpha / 2)), dAlpha + (Rnd(ecartDAlpha) - (ecartDAlpha /2)))
							p.ReglerVelocite(dx, dy, accX, accY)
							p.ReglerVie(viePart, ecartViePart)
							
							nbFrameRestant = nbFramePourEmt
						Else
							nbFrameRestant = nbFrameRestant - 1
						End If
					End If

				Case "supprime"
					If CountList(listePart) = 0 Then
						ListRemove(P2D_listeEmet, Self)
					End If
			End Select
		Else
			Select etat
				Case "actif"
					' On met à jour l'age de l'emetteur
					age = (MilliSecs() - heureCreation) '/ 1000
					'On compare l'age à la longevite 
					If age => longevite Then
						' Si il a fait son temps, on le supprime
						If CountList(listePart) = 0 Then
							ListRemove(P2D_listeEmet, Self)
						End If
					Else
						' Sinon, on genere les particules
						If nbPartFrame >= 1 Then
							For i = 1 To nbPartFrame
								p = P2D_CreatePart(Self, image, x, y, Rnd(ecartX) - (ecartX / 2), Rnd(ecartY) - (ecartY / 2))', 0, -1, 0, 0)
								p.ReglerEchelle(echelleXIni + (Rnd(ecartEchelleXIni) - (ecartEchelleXIni/2)), echelleYIni + (Rnd(ecartEchelleYIni) - (ecartEchelleYIni/2)), dEchelleX:Float, dEchelleY:Float)
								p.ReglerAlpha(alphaIni + (Rnd(ecartAlpha)  - (ecartAlpha / 2)), dAlpha + (Rnd(ecartDAlpha) - (ecartDAlpha /2)))
								p.ReglerVelocite(dx, dy, accX, accY)
								p.ReglerVie(viePart, ecartViePart)
							Next
						Else
							If nbFrameRestant < 0 Then
								p = P2D_CreatePart(Self, image, x, y, Rnd(ecartX) - (ecartX / 2), Rnd(ecartY) - (ecartY / 2))', 0, -1, 0, 0)
								p.ReglerEchelle(echelleXIni + (Rnd(ecartEchelleXIni) - (ecartEchelleXIni/2)), echelleYIni + (Rnd(ecartEchelleYIni) - (ecartEchelleYIni/2)), dEchelleX:Float, dEchelleY:Float)
								p.ReglerAlpha(alphaIni + (Rnd(ecartAlpha)  - (ecartAlpha / 2)), dAlpha + (Rnd(ecartDAlpha) - (ecartDAlpha /2)))
								p.ReglerVelocite(dx, dy, accX, accY)
								p.ReglerVie(viePart, ecartViePart)
								
								nbFrameRestant = nbFramePourEmt
							Else
								nbFrameRestant = nbFrameRestant - 1
							End If
						End If
					End If
				Case "supprime"
				
			End Select		
		End If

	End Method
	
	'-----------------------------------------------------------
	' Suppression d'un emetteur
	'-----------------------------------------------------------
	Method Supprimer(flag:Int = 0)
		
		Local p:TParticule = New TParticule
		
		Select flag
			Case 0
				etat = "supprime"
			Case 1
				etat = "supprime"
				For p=EachIn listePart
					ListRemove(listePart, p)
				Next
				ListRemove(P2D_listeEmet, Self)
		End Select
	
	End Method
	
	'-----------------------------------------------------------
	' Positionnement d'un emmetteur en x y
	'-----------------------------------------------------------
	Method SetPosition(x:Int, y:Int)
		
		Self.x = x
		Self.y = y
		
	End Method
	
	'-----------------------------------------------------------
	' Reglage de l'echelle
	'-----------------------------------------------------------
	Method ReglerEchelle(echelleXIni:Float, echelleYIni:Float, ecartEchelleXIni:Float, ecartEchelleYIni:Float, dEchelleX:Float, dEchelleY:Float)
		
		Self.echelleXIni = echelleXIni
		Self.echelleYIni = echelleYIni
		Self.ecartEchelleXIni = ecartEchelleXIni
		Self.ecartEchelleYIni = ecartEchelleYIni
		Self.dEchelleX = dEchelleX
		Self.dEchelleY = dEchelleY
		
	End Method
	
	
	'-----------------------------------------------------------
	' Reglage de la velocite
	'-----------------------------------------------------------
	Method ReglerVelocite(dx:Float, dy:Float, accX:Float, accY:Float)
	
		Self.dx = dx
		Self.dy = dy
		Self.accX = accX
		Self.accY = accY
		
	End Method
	
	'-----------------------------------------------------------
	' Reglage de l'alpha
	'-----------------------------------------------------------
	Method ReglerAlpha(alphaIni:Float, ecartAlpha:Float, dAlpha:Float, ecartDAlpha:Float)
		
		Self.alphaIni = alphaIni
		Self.ecartAlpha = ecartAlpha
		Self.dAlpha = dAlpha
		Self.ecartDAlpha = ecartDAlpha
		
	End Method
	
	
	'-----------------------------------------------------------
	' Reglage de la duree de vie des particules
	'-----------------------------------------------------------
	Method ReglerVie(viePart:Int, ecartViePart:Int)
		
		Self.viePart = viePart
		Self.ecartViePart = ecartViePart 
		
	End Method


End Type


'################################################################
' Type Particule
'################################################################
Type TParticule

	Field pere:TEmetteur				' Emetteur à l'origine de la particule
	Field image:TImage
	Field x:Float, y:Float				' Position
	Field ecartX:Float, ecartY:Float
	Field dx:Float, dy:Float			' Vitesse
	Field accX:Float, accY:Float		' Accélération
	Field EchelleX:Float
	Field EchelleY:Float
	Field dEchelleX:Float				' Modification du scale X
	Field dEchelleY:Float				' Modification du scale Y
	Field Alpha:Float					'
	Field dAlpha:Float
	Field heureCreation:Int			' Heure de cration de la particule
	Field age:Int						' Age de la particule
	Field vie:Int						' Duree de vie de la particule
	
	'-----------------------------------------------------------
	' Mise à jour des particules
	'-----------------------------------------------------------
	Method Update()
	
		dx = dx + accX
		dy = dy + accY
		x = x + dx
		y = y + dy
		echelleX :+ dEchelleX
		echelleY :+ dEchelleY
		
		' Si la particule n'est plus visible, on la supprime
		If (echelleX < 0) Or (echelleY < 0) Then
			ListRemove(pere.listePart, Self)
			pere.nbPartCourant :- 1
		End If
		
		' Si la particule a fait son temps, on la supprime
		If (heureCreation + vie) < MilliSecs() Then
			ListRemove(pere.listePart, Self)
			pere.nbPartCourant :- 1
		End If
		
		
		Select pere.typeEmt
			' Mise à jour de l'alpha
			Case "alpha"
				alpha = alpha + dAlpha
				If dAlpha < 0
					If alpha < .0000 Then
						ListRemove(pere.listePart, Self)
						pere.nbPartCourant :- 1
					End If
				Else
					If dAlpha > 0 Then
						If alpha > 1 Then
							alpha = 1
						End If
					End If
				End If
			Case "light"
				alpha = alpha + dAlpha
				If dAlpha < 0
					If alpha < .0000 Then
						ListRemove(pere.listePart, Self)
						pere.nbPartCourant :- 1
					End If
				Else
					If dAlpha > 0 Then
						If alpha > 1 Then
							alpha = 1
						End If
					End If
				End If
		End Select
		
	End Method
	
	'-----------------------------------------------------------
	' Affichage de la particule
	'-----------------------------------------------------------
	Method Draw()

		Select pere.typeEmt
			Case "alpha"
				SetBlend ALPHABLEND
				SetAlpha(alpha)
			Case "light"
				SetBlend LIGHTBLEND
				SetAlpha(alpha)
		End Select
		
		SetScale(echelleX, echelleY)
		DrawImage image, x, y
		SetScale(1, 1)
		SetAlpha(1)
		SetBlend MASKBLEND
		
	End Method
	
	'-----------------------------------------------------------
	' Reglage de l'echelle
	'-----------------------------------------------------------
	Method ReglerEchelle(echelleXIni:Float, echelleYIni:Float, dEchelleX:Float, dEchelleY:Float)
		
		Self.echelleX = echelleXIni
		Self.echelleY = echelleYIni
		Self.dEchelleX = dEchelleX
		Self.dEchelleY = dEchelleY
		
	End Method
	
	'-----------------------------------------------------------
	' Reglage de l'alpha
	'-----------------------------------------------------------
	Method ReglerAlpha(alpha:Float, dAlpha:Float)
		
		Self.alpha = alpha
		Self.dAlpha = dAlpha
		
	End Method
	
	
	'-----------------------------------------------------------
	' Reglage de la duree de vie des particules
	'-----------------------------------------------------------
	Method ReglerVie(viePart:Int, ecartViePart:Int)
		
		Self.vie = viePart + (Rand(ecartViePart) - (ecartViePart / 2))
		Self.heureCreation = MilliSecs()
		
	End Method
	
	
	'-----------------------------------------------------------
	' Reglage de la velocite
	'-----------------------------------------------------------
	Method ReglerVelocite(dx:Float, dy:Float, accX:Float, accY:Float)
	
		Self.dx = dx
		Self.dy = dy
		Self.accX = accX
		Self.accY = accY
		
	End Method

	
End Type


'----------------------------------------------------------------
' Creation d'une particule
'----------------------------------------------------------------
Function P2D_CreatePart:TParticule(pere:TEmetteur, image:TImage, x#, y#, ecartX%, ecartY%)', dx#, dy#, accX#, accY#)

	Local p:TParticule = New TParticule

	pere.nbPartCourant :+ 1

	p.pere = pere
	p.image = image
	MidHandleImage(p.image)
	p.x = x + (Rnd(ecartX) - (ecartX/2))
	p.y = y + (Rnd(ecartY) - (ecartY/2))
	ListAddFirst pere.listePart, p

	Return p

End Function
	


'----------------------------------------------------------------
' Creation d'un emetteur
'----------------------------------------------------------------
Function P2D_CreateEmetteur:TEmetteur(image:TImage, longevite:Int, x:Float, y:Float, ecartX:Float, ecartY:Float, angle:Float, nbPartFrame:Float, typeEmt:String = "light")
	
	Local e:TEmetteur = New TEmetteur

	e.image = image
	e.longevite = longevite
	e.heureCreation = MilliSecs()
	e.x = x
	e.y = y
	e.ecartX = ecartX
	e.ecartY = ecartY
	e.angle = angle
	e.nbPartFrame = nbPartFrame
	If e.nbPartFrame < 1 Then
		e.nbFramePourEmt = 1 / nbPartFrame		' Nb de frames entre chaque emission de particules (si nbPartFrame < 0)
		e.nbFrameRestant = 0
	End If
	e.typeEmt = typeEmt
	e.etat = "actif"
	e.listePart:TList = New TList
	ListAddFirst P2D_ListeEmet, e
	
	Return e
	
End Function

'----------------------------------------------------------------
' Mise à jour de l'ensemble des particules / emetteurs
'----------------------------------------------------------------
Function P2D_Update()

	Local e:TEmetteur = New TEmetteur
	Local p:TParticule = New TParticule
	
	For e=EachIn P2D_ListeEmet
		e.Update()
		For p=EachIn e.listePart
			p.Update()
		Next
	Next

End Function


'----------------------------------------------------------------
' Affichage de l'ensemble des particules
'----------------------------------------------------------------
Function P2D_Afficher()

	Local e:TEmetteur = New TEmetteur
	Local p:TParticule = New TParticule
	
	For e=EachIn P2D_ListeEmet
		For p=EachIn e.ListePart
			p.Draw()
		Next
	Next

End Function


'----------------------------------------------------------------
' Positionnement d'un emetteur en x y
'----------------------------------------------------------------
Function P2D_ReglerPosition(e:TEmetteur, x:Int, y:Int)
	
	e.x = x
	e.y = y
	
End Function


'-----------------------------------------------------------
' Reglage de l'echelle
'-----------------------------------------------------------
Function P2D_ReglerEchelle(e:TEmetteur, echelleXIni:Float, echelleYIni:Float, ecartEchelleXIni:Float, ecartEchelleYIni:Float, dEchelleX:Float, dEchelleY:Float)
	
	e.echelleXIni = echelleXIni
	e.echelleYIni = echelleYIni
	e.ecartEchelleXIni = ecartEchelleXIni
	e.ecartEchelleYIni = ecartEchelleYIni
	e.dEchelleX = dEchelleX
	e.dEchelleY = dEchelleY
		
End Function


'-----------------------------------------------------------
' Reglage de l'alpha
'-----------------------------------------------------------
Function P2D_ReglerAlpha(e:TEmetteur, alphaIni:Float, ecartAlpha:Float, dAlpha:Float, ecartDAlpha:Float)
		
	e.alphaIni = alphaIni
	e.ecartAlpha = ecartAlpha
	e.dAlpha = dAlpha
	e.ecartDAlpha = ecartDAlpha
	
End Function


'-----------------------------------------------------------
' Reglage de la velocite
'-----------------------------------------------------------
Function P2D_ReglerVelocite(e:TEmetteur, dx:Float, dy:Float, accX:Float, accY:Float)
		
	e.dx = dx
	e.dy = dy
	e.accX = accX
	e.accY = accY
	
End Function


'-----------------------------------------------------------
' Reglage de la vie des particules
'-----------------------------------------------------------
Function P2D_ReglerVie(e:TEmetteur, viePart:Int, ecartViePart:Int)
		
		e.viePart = viePart
		e.ecartViePart = ecartViePart 
		
End Function



'----------------------------------------------------------------
' Suppression d'un emetteur
'----------------------------------------------------------------
Function P2D_SupprEmt(e:TEmetteur, flag:Int = 0)

	Local p:TParticule = New TParticule
		
	Select flag
		Case 0
			e.etat = "supprime"
		Case 1
			e.etat = "supprime"
			For p=EachIn e.listePart
				ListRemove(e.listePart, p)
			Next
			ListRemove(P2D_listeEmet, e)
	End Select

End Function
 