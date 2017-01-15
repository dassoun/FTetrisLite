Strict

'Framework BRL.GLMax2D
'Import BRL.Ramstream
'Import BRL.PNGLoader
'Import BRL.BMPLoader
'Import BRL.JPGLoader
'Import BRL.OGGLoader
'Import BRL.FreeTypeFont
'Import BRL.FreeAudioAudio
'Import BRL.Random
'Import BRL.FileSystem
'Import BRL.Retro

Import "ftetris.o"

Include "Inc_Blocks.bmx"
Include "Inc_Score.bmx"
Include "Inc_ScoreEnLigne.bmx"
Include "partengine061.bmx"
Include "iniFileMax.bmx"
Include "ClasseJoueur.bmx"

Incbin "Medias/Gfx/Fontes/Fontout.ttf"
Incbin "Medias/Gfx/Fontes/bonzai.ttf"
Incbin "Medias/Gfx/Fontes/CurseurSaisieNom.png"
Incbin "Medias/Gfx/Promo/BanniereFree.png"
Incbin "Medias/Gfx/Promo/blitz3dfr.jpg"
Incbin "Medias/Gfx/Promo/PartEngine.bmp"
Incbin "Medias/Gfx/Promo/inifilemax.bmp"

Incbin "Medias/Gfx/Menu/fd.png"
Incbin "Medias/Gfx/Menu/1player_on.png"
Incbin "Medias/Gfx/Menu/1player_off.png"
Incbin "Medias/Gfx/Menu/2players_on.png"
Incbin "Medias/Gfx/Menu/2players_off.png"
Incbin "Medias/Gfx/Menu/highscores_on.png"
Incbin "Medias/Gfx/Menu/highscores_off.png"
Incbin "Medias/Gfx/Menu/options_on.png"
Incbin "Medias/Gfx/Menu/options_off.png"
Incbin "Medias/Gfx/Menu/quit_on.png"
Incbin "Medias/Gfx/Menu/quit_off.png"
Incbin "Medias/Gfx/Menu/curseur.png"
Incbin "Medias/Gfx/Menu/NA.png"

'Incbin "Medias/Gfx/Menu/exit_off.png"
'Incbin "Medias/Gfx/Menu/exit_on.png"
'Incbin "Medias/Gfx/Menu/Start_off.png"
'Incbin "Medias/Gfx/Menu/Start_on.png"

Incbin "Medias/Gfx/Fond/Fond2.png"
Incbin "Medias/Gfx/Fond/fdJeu.png"
Incbin "Medias/Gfx/Fond/Portrait1.png"
Incbin "Medias/Gfx/Fond/cadres.png"
Incbin "Medias/Gfx/Fond/Titre.bmp"
Incbin "Medias/Gfx/Fond/name.png"
Incbin "Medias/Gfx/Fond/scores.png"
Incbin "Medias/Gfx/Fond/enter.png"
Incbin "Medias/Gfx/Fond/pause.png"
Incbin "Medias/Gfx/Fond/credits.png"
Incbin "Medias/Gfx/Fond/GameOver.png"
Incbin "Medias/Gfx/Fond/NoConnection.png"
Incbin "Medias/Gfx/Fond/LVL.png"

Incbin "Medias/Gfx/Medias30/BriqueJaune.png"
Incbin "Medias/Gfx/Medias30/BriqueVerte.png"
Incbin "Medias/Gfx/Medias30/BriqueMauve.png"
Incbin "Medias/Gfx/Medias30/BriqueBleue.png"
Incbin "Medias/Gfx/Medias30/BriqueOrange.png"
Incbin "Medias/Gfx/Medias30/BriqueRouge.png"
Incbin "Medias/Gfx/Medias30/BriqueCian.png"
Incbin "Medias/Gfx/Medias30/Particules/bluspark.png"
Incbin "Medias/Gfx/Medias30/Particules/coeurmauve.png"
Incbin "Medias/Gfx/Medias30/Particules/coeurbleu.png"
Incbin "Medias/Gfx/Medias30/Particules/coeurcian.png"
Incbin "Medias/Gfx/Medias30/Particules/coeurjaune.png"
Incbin "Medias/Gfx/Medias30/Particules/coeurorange.png"
Incbin "Medias/Gfx/Medias30/Particules/coeurrouge.png"
Incbin "Medias/Gfx/Medias30/Particules/coeurvert.png"


Incbin "Medias/Gfx/Anims/Fille/fille.png"



Incbin "Medias/Sons/FX/pop2.ogg"
Incbin "Medias/Sons/FX/Tic.ogg"
Incbin "Medias/Sons/FX/SupprLigne.ogg"
Incbin "Medias/Sons/FX/Pose.ogg"


' Globales relatives � la d�finition du jeu
Global LARGEUR:Int = 800
Global HAUTEUR:Int = 600
Global PROFONDEUR:Int = 32


Global Opt_PartActives:Byte = True
Global Opt_CheckIfOnLone:Byte = True
Global Driver:Int = 1			' 1 -> OpenGL
								' 2 -> DirectX


If FileType("CONFIG.INI") = 0 Then
	' Creation du fichier
	iniCreerFichier("CONFIG.INI")
	' Ecriture du mode Graphique
	iniCreerSection("CONFIG.INI", "Screen Mode")
	iniCreerVariableInt("CONFIG.INI", "Screen Mode", "Mode", PROFONDEUR)
	' Ecriture du mode Graphique
	iniCreerSection("CONFIG.INI", "Particles")
	iniCreerVariableInt("CONFIG.INI", "Particles", "Enabled", Opt_PartActives)
	' Ecriture du mode Online
	iniCreerSection("CONFIG.INI", "OnLine")
	iniCreerVariableInt("CONFIG.INI", "OnLine", "Enabled", Opt_CheckIfOnLone)
	' Ecriture du Framework
	iniCreerSection("CONFIG.INI", "Framework")
	iniCreerVariableInt("CONFIG.INI", "Framework", "Driver", 1)
Else
	PROFONDEUR = iniLireVariableInt("CONFIG.INI", "Screen Mode", "Mode")
	Opt_PartActives = iniLireVariableInt("CONFIG.INI", "Particles", "Enabled")
	Opt_CheckIfOnLone = iniLireVariableInt("CONFIG.INI", "OnLine", "Enabled")
	Driver = iniLireVariableInt("CONFIG.INI", "Framework", "Driver")
End If


Select Driver
	Case 1
		SetGraphicsDriver GLMax2DDriver()
	Case 2	
		SetGraphicsDriver D3D7Max2DDriver()
End Select

Const Version:String = "1.02"
Global DerniereVersion:String = Version

AppTitle = "F-Tetris Lite v. " + Version

Graphics LARGEUR, HAUTEUR, PROFONDEUR

HideMouse


'=====================================================
' GFX
'=====================================================

Const NbTotalMedias:Int = 51


' Police
Global Fonte1:TImageFont = LoadImageFont("incbin::Medias/Gfx/Fontes/Fontout.ttf", 20)
Global Fonte2:TImageFont = LoadImageFont("incbin::Medias/Gfx/Fontes/bonzai.ttf", 20)
SetImageFont(Fonte2)
DessinerChargement(0, NbTotalMedias)

DessinerChargement(2, NbTotalMedias)
Global ImgCurseurSaisie:TImage = LoadImage("incbin::Medias/Gfx/Fontes/CurseurSaisieNom.png")

' Image ftprods
DessinerChargement(3, NbTotalMedias)
Global ImgPromoFtprods:TImage = LoadImage("incbin::Medias/Gfx/Promo/BanniereFree.png")
DessinerChargement(4, NbTotalMedias)
Global ImgPromoBlitz3DFr:TImage = LoadImage("incbin::Medias/Gfx/Promo/blitz3dfr.jpg")
DessinerChargement(5, NbTotalMedias)
Global ImgPromoPartEngine:TImage = LoadImage("incbin::Medias/Gfx/Promo/PartEngine.bmp")
DessinerChargement(6, NbTotalMedias)
Global ImgPromoIniFile:TImage = LoadImage("incbin::Medias/Gfx/Promo/inifilemax.bmp")

'SetColor(255, 255, 255)
SetMaskColor(255, 0, 255)

' Sprites du menu
DessinerChargement(7, NbTotalMedias)
Global ImgFondMenu:TImage = LoadImage("incbin::Medias/Gfx/Menu/fd.png")

DessinerChargement(8, NbTotalMedias)
Global Img1player_on:TImage = LoadImage("incbin::Medias/Gfx/Menu/1player_on.png")
DessinerChargement(9, NbTotalMedias)
Global Img1player_off:TImage = LoadImage("incbin::Medias/Gfx/Menu/1player_off.png")
DessinerChargement(10, 48)
Global Img2players_on:TImage = LoadImage("incbin::Medias/Gfx/Menu/2players_on.png")
DessinerChargement(11, NbTotalMedias)
Global Img2players_off:TImage = LoadImage("incbin::Medias/Gfx/Menu/2players_off.png")
DessinerChargement(12, NbTotalMedias)
Global Imghighscores_on:TImage = LoadImage("incbin::Medias/Gfx/Menu/highscores_on.png")
DessinerChargement(13, NbTotalMedias)
Global Imghighscores_off:TImage = LoadImage("incbin::Medias/Gfx/Menu/highscores_off.png")
DessinerChargement(14, NbTotalMedias)
Global Imgoptions_on:TImage = LoadImage("incbin::Medias/Gfx/Menu/options_on.png")
DessinerChargement(15, NbTotalMedias)
Global Imgoptions_off:TImage = LoadImage("incbin::Medias/Gfx/Menu/options_off.png")
DessinerChargement(16, NbTotalMedias)
Global Imgquit_on:TImage = LoadImage("incbin::Medias/Gfx/Menu/quit_on.png")
DessinerChargement(17, NbTotalMedias)
Global Imgquit_off:TImage = LoadImage("incbin::Medias/Gfx/Menu/quit_off.png")

DessinerChargement(18, NbTotalMedias)
Global ImgCurseur:TImage = LoadImage("incbin::Medias/Gfx/Menu/curseur.png")

DessinerChargement(19, NbTotalMedias)
Global ImgNotAvailable:TImage = LoadImage("Incbin::Medias/Gfx/Menu/NA.png")

'Global ImgExitOff = LoadImage("incbin::Medias/Gfx/Menu/exit_off.png")
'Global ImgExitOn = LoadImage("incbin::Medias/Gfx/Menu/exit_on.png")
'Global ImgStartOff = LoadImage("incbin::Medias/Gfx/Menu/Start_off.png")
'Global ImgStartOn = LoadImage("incbin::Medias/Gfx/Menu/Start_on.png")

' Fond
'Global ImgFond = LoadImage("incbin::Medias/Gfx/Fond/Fond2.png")
DessinerChargement(20, NbTotalMedias)
Global ImgFond:TImage = LoadImage("incbin::Medias/Gfx/Fond/fdJeu.png")
SetMaskColor(255, 255, 255)
DessinerChargement(21, NbTotalMedias)
Global ImgCadres:TImage = LoadImage("incbin::Medias/Gfx/Fond/cadres.png")
DessinerChargement(22, NbTotalMedias)
Global ImgPause:TImage = LoadImage("incbin::Medias/Gfx/Fond/pause.png")
MidHandleImage(ImgPause)
DessinerChargement(23, NbTotalMedias)
Global ImgLevelUp:TImage = LoadImage("incbin::Medias/Gfx/Fond/LVL.png")
MidHandleImage(ImgLevelUp)

DessinerChargement(24, NbTotalMedias)
Global ImgScores:TImage = LoadImage("incbin::Medias/Gfx/Fond/scores.png")
DessinerChargement(25, NbTotalMedias)
Global ImgEnter:TImage = LoadImage("incbin::Medias/Gfx/Fond/enter.png")
MidHandleImage(ImgEnter)
DessinerChargement(26, NbTotalMedias)
Global ImgGameOver:TImage = LoadImage("incbin::Medias/Gfx/Fond/GameOver.png")
MidHandleImage(ImgGameOver)
DessinerChargement(27, NbTotalMedias)
Global ImgNoConnection:TImage = LoadImage("incbin::Medias/Gfx/Fond/NoConnection.png")
MidHandleImage(ImgNoConnection)

DessinerChargement(28, NbTotalMedias)
Global ImgPortrait1:TImage = LoadImage("incbin::Medias/Gfx/Fond/Portrait1.png")

SetMaskColor(0, 255, 0)
DessinerChargement(29, NbTotalMedias)
Global ImgFondCredits:TImage = LoadImage("incbin::Medias/Gfx/Fond/credits.png")
DessinerChargement(30, NbTotalMedias)
Global ImgName:TImage = LoadImage("incbin::Medias/Gfx/Fond/name.png")

SetMaskColor(255, 0, 255)
DessinerChargement(31, NbTotalMedias)
Global ImgTitre:TImage = LoadImage("incbin::Medias/Gfx/Fond/Titre.bmp")


' Sprites des briques
DessinerChargement(32, NbTotalMedias)
Global SprBriqueJaune:TImage = LoadImage("incbin::Medias/Gfx/Medias30/BriqueJaune.png")
DessinerChargement(33, NbTotalMedias)
Global SprBriqueVerte:TImage = LoadImage("incbin::Medias/Gfx/Medias30/BriqueVerte.png")
DessinerChargement(34, NbTotalMedias)
Global SprBriqueMauve:TImage = LoadImage("incbin::Medias/Gfx/Medias30/BriqueMauve.png")
DessinerChargement(35, NbTotalMedias)
Global SprBriqueBleue:TImage = LoadImage("incbin::Medias/Gfx/Medias30/BriqueBleue.png")
DessinerChargement(36, NbTotalMedias)
Global SprBriqueOrange:TImage = LoadImage("incbin::Medias/Gfx/Medias30/BriqueOrange.png")
DessinerChargement(37, NbTotalMedias)
Global SprBriqueRouge:TImage = LoadImage("incbin::Medias/Gfx/Medias30/BriqueRouge.png")
DessinerChargement(38, NbTotalMedias)
Global SprBriqueCian:TImage = LoadImage("incbin::Medias/Gfx/Medias30/BriqueCian.png")

' Sprites des particules
SetMaskColor(0, 0, 0)
'Global SprPartCian = LoadImage("incbin::Medias/Gfx/Medias30/Particules/bluspark.png")
'MidHandleImage(SprPartCian) 
DessinerChargement(39, NbTotalMedias)
Global SprPartCMauve:TImage = LoadImage("incbin::Medias/Gfx/Medias30/Particules/coeurmauve.png")
MidHandleImage(SprPartCMauve)
DessinerChargement(40, NbTotalMedias)
Global SprPartCBleu:TImage = LoadImage("incbin::Medias/Gfx/Medias30/Particules/coeurbleu.png")
MidHandleImage(SprPartCBleu)
DessinerChargement(41, NbTotalMedias)
Global SprPartCCian:TImage = LoadImage("incbin::Medias/Gfx/Medias30/Particules/coeurcian.png")
MidHandleImage(SprPartCCian)
DessinerChargement(42, NbTotalMedias)
Global SprPartCJaune:TImage = LoadImage("incbin::Medias/Gfx/Medias30/Particules/coeurjaune.png")
MidHandleImage(SprPartCJaune)
DessinerChargement(43, NbTotalMedias)
Global SprPartCOrange:TImage = LoadImage("incbin::Medias/Gfx/Medias30/Particules/coeurorange.png")
MidHandleImage(SprPartCOrange)
DessinerChargement(44, NbTotalMedias)
Global SprPartCRouge:TImage = LoadImage("incbin::Medias/Gfx/Medias30/Particules/coeurrouge.png")
MidHandleImage(SprPartCRouge)
DessinerChargement(46, NbTotalMedias)
Global SprPartCVert:TImage = LoadImage("incbin::Medias/Gfx/Medias30/Particules/coeurvert.png")
MidHandleImage(SprPartCVert)


' Animations
SetMaskColor(0, 255, 0)
DessinerChargement(47, NbTotalMedias)
Global AnimFille:TImage = LoadAnimImage("incbin::Medias/Gfx/Anims/Fille/fille.png", 92, 92, 0, 11)

Global Anim:TPerso

'=====================================================
' Sons
'=====================================================

' Sons
DessinerChargement(48, NbTotalMedias)
Global Snd_FXPop:TSound = LoadSound("incbin::Medias/Sons/FX/pop2.ogg")
Global CanalPop:TChannel
DessinerChargement(49, NbTotalMedias)
Global Snd_FXTic:TSound = LoadSound("incbin::Medias/Sons/FX/Tic.ogg")
Global CanalTic:TChannel
DessinerChargement(50, NbTotalMedias)
Global Snd_FXSupprLigne:TSound = LoadSound("incbin::Medias/Sons/FX/SupprLigne.ogg")
Global CanalSupprLigne:TChannel
DessinerChargement(51, NbTotalMedias)
Global Snd_FXPose:TSound = LoadSound("incbin::Medias/Sons/FX/Pose.ogg")
Global CanalPose:TChannel

SeedRnd(MilliSecs())

Global Bloc1:T_FT_Bloque			' Bloc courant
Global BlocNext:T_FT_Bloque			' Prochain bloc

Global Emetteur:TEmetteur			' Emetteur de particules

Global Tab_Jeu : Int[20, 30]		' Plateau de jeu
Global Tab_Lignes : Int[30]			' Tableau des lignes completes

Const TEMPS_MOUV:Int = 500			' Temps entre les descentes de pieces
Const ACCELERATION:Int = 30			' 
Global VitesseJeu:Int = 1
Global HeureDernierMouv:Int

Global TempsMouvDown:Int = 300
Global HeureDernierMouvDown:Int
Global TempsMouvLeft:Int = 300
Global HeureDernierMouvLeft:Int
Global TempsMouvRight:Int = 300
Global HeureDernierMouvRight:Int

Global TempsJeu:Int					' Temps de jeu

Global Score_NbLignes:Int = 0		' Nombre de lignes courant
Global Score_NbPoints:Int = 0		' Score courant
Global Level:Int = 0				' Niveau courant
Global AncienLevel:Int = 0
Global HeureCreaBloc:Int

Global FPS_Framerate: Int			
Global FPS_Timer:Int				
Global FPS_Framerate_Temp:Int		

Global RetourMenu:Int = 0			' Selection au niveau du menu

' Options de jeu
Global Opt_BlocNext:Byte = True		' Affichage de la prochaine piece
Global Opt_EnPause:Byte = False		' Pause
Global HeurePause:Int				' Heure de la mise en pause
Global Opt_Son:Byte = True			' Lecture des sons
Global Opt_Memo:Byte = False		' Affichage de la memoire allouee
Global Opt_FPS:Byte = False			' Affichage du FPS

Global Debug:Byte = False			' Precise si on est en debug

Global PresserEspace:Byte = False
Global HeurePressEspace:Int

Local TimerPromo:Int = MilliSecs()
Local AlphaPromo:Float = 0


Global Tab_Score:T_FT_Score[10]		' Tableau des scores
Local i:Int

For i = 0 To 9
	Tab_Score[i] = T_FT_Score.Create()
Next

Global Tab_Score_Bas:T_FT_Score[4]		' Tableau des scores

For i = 0 To 3
	Tab_Score_Bas[i] = T_FT_Score.Create()
Next


Global ChaineNom:String = ""


Global TimerPause:Int = MilliSecs()

Global Perdu:Byte = False
Global TimerPerdu:Int = MilliSecs()


Global URL_Fichier_Txt:String = "http::ftprods.free.fr/"
Global URL_Rep_Scripts_Test:String = "http::127.0.0.1/Scores/"	'Insert.php?Nom="+Nom+"&Level="+Level+"&Points="+Points
Global URL_Rep_Scripts:String = "http::ftprods.free.fr/ScoresFTetris/"



'--------------------------------------------------------------------
' Gestion de la promo
'--------------------------------------------------------------------
SetColor 255, 255, 255

SetBlend ALPHABLEND

SetImageFont(Fonte1)

' ftprods.free.fr
TimerPromo = MilliSecs()
While (MilliSecs() < TimerPromo + 6000) And Not(MouseHit(1))
	Cls
	If MilliSecs() < TimerPromo + 2000 Then
		If AlphaPromo < 1 Then
			AlphaPromo = AlphaPromo + .01
		Else
			AlphaPromo = 1
		End If
	End If
	If MilliSecs() > TimerPromo + 4000 Then
		If AlphaPromo > 0 Then
			AlphaPromo = AlphaPromo - .01
'		Else
'			AlphaPromo = 0
		End If
	End If
	SetAlpha(AlphaPromo)
'	DrawText "A", (GraphicsWidth()/2) - (TextWidth("A")/2), 150
	DrawImage ImgPromoFtprods, 0, 190
	DrawText "Presents", ((GraphicsWidth() - TextWidth("Presents")) / 2), 310
	DrawText "Visit http://ftprods.free.fr", ((GraphicsWidth() - TextWidth("Visit http://ftprods.free.fr")) / 2), 500
	Flip

Wend

FlushKeys()

AlphaPromo = 0

' PartEngine
TimerPromo = MilliSecs()
While (MilliSecs() < TimerPromo + 6000) And Not(MouseHit(1))
	Cls
	If MilliSecs() < TimerPromo + 2000 Then
		If AlphaPromo < 1 Then
			AlphaPromo = AlphaPromo + .01
		Else
			AlphaPromo = 1
		End If
	End If
	If MilliSecs() > TimerPromo + 4000 Then
		If AlphaPromo > 0 Then
			AlphaPromo = AlphaPromo - .01
'		Else
'			AlphaPromo = 0
		End If
	End If
	SetAlpha(AlphaPromo)
	DrawText "Featuring", (GraphicsWidth()/2) - (TextWidth("Featuring")/2), 150
	DrawImage ImgPromoPartEngine, 245, 190
	DrawImage ImgPromoIniFile, 245, 310
	DrawText "Visit http://ftprods.free.fr", (GraphicsWidth()/2) - (TextWidth("Visit http://ftprods.free.fr")/2), 430
	Flip
	
Wend

FlushKeys()

AlphaPromo = 0

' Blitz3dfr
TimerPromo = MilliSecs()
While (MilliSecs() < TimerPromo + 6000) And Not(MouseHit(1))
	Cls
	If MilliSecs() < TimerPromo + 2000 Then
		If AlphaPromo < 1 Then
			AlphaPromo = AlphaPromo + .01
		Else
			AlphaPromo = 1
		End If
	End If
	If MilliSecs() > TimerPromo + 4000 Then
		If AlphaPromo > 0 Then
			AlphaPromo = AlphaPromo - .01
'		Else
'			AlphaPromo = 0
		End If
	End If
	SetAlpha(AlphaPromo)
	DrawText "Special thanks to www.blitz3dfr.com", ((GraphicsWidth() - TextWidth("Special thanks to www.blitz3dfr.com")) / 2), 150
	DrawImage ImgPromoBlitz3DFr, (GraphicsWidth() - ImageWidth(ImgPromoBlitz3DFr)) / 2, 190
	Flip
	
Wend


FlushKeys()

' Fabrication du fichier des scores s'il n'existe pas
If FileType("SCORES.DAT") = 0 Then GenererFichierScores()
If Opt_CheckIfOnLone Then
	If CheckIfConnected() Then
		OL_InitTabScore()
		DerniereVersion = OL_GetVersion()
	Else
		InitTabScore()
	End If
Else		
	InitTabScore()
End If

SetAlpha(1)

' Selection de la police
SetImageFont(Fonte2)

' Boucle principale
While (RetourMenu <> 5) 
	Select RetourMenu
		
		Case 0
			Menu()
			
		Case 1
			' On initialise le jeu
			InitialiserJeu()
			
			' Boucle de jeu
			While Not(KeyHit(KEY_ESCAPE)) And RetourMenu = 1
				MAJJeu()
				DessinerJeu()	
			Wend
			
		Case 4
			If Score_NbPoints > 0 Then
				FlushKeys()
				SaisieNom()
				If ChaineNom <> "" Then
					If Opt_CheckIfOnLone Then
						If CheckIfConnected() Then
							OL_EnregistrerScore()
						Else
							InsererScore()
							EnregistrerScores()
						End If
					Else
						InsererScore()
						EnregistrerScores()
					End If
				End If
			End If
			
			Scores()
			
	End Select
Wend

' Affichage des credits
TimerPromo = MilliSecs()
While (MilliSecs() < TimerPromo + 6000) And Not(MouseHit(1))
	Cls
	If MilliSecs() < TimerPromo + 2000 Then
		If AlphaPromo < 1 Then
			AlphaPromo = AlphaPromo + .01
		Else
			AlphaPromo = 1
		End If
	End If
	If MilliSecs() > TimerPromo + 4000 Then
		If AlphaPromo > 0 Then
			AlphaPromo = AlphaPromo - .01
'		Else
'			AlphaPromo = 0
		End If
	End If
	SetAlpha(AlphaPromo)
	DrawImage ImgFondCredits, 0, 0
	Flip
	
Wend

' Fonction d'initialisation du jeu
Function InitialiserJeu()
	
	' Compteurs de boucles
	Local i, j:Int
	
	SeedRnd(MilliSecs())
	
	' On vide le tableau
	For i = 0 To 19
		For j = 0 To 29
			Tab_Jeu[i, j] = -1
		Next
	Next
	For i = 5 To 14
		For j = 5 To 29
			Tab_Jeu[i, j] = 0
		Next
	Next
	
	For i = 0 To 29
		Tab_Lignes[i] = 0
	Next

	Level = 0
	AncienLevel = 0
	Score_NbLignes = 0
	Score_NbPoints = 0
	VitesseJeu = 1
	HeurePressEspace = MilliSecs()
	HeureDernierMouv = MilliSecs()
	HeureDernierMouvDown = MilliSecs()
	
	
	Bloc1 = T_FT_Bloque.Create(Rand(7), 4, 16, 30)
	HeureCreaBloc = MilliSecs()
	BlocNext = T_FT_Bloque.Create(Rand(7), 14, 12, 30)
	
	PresserEspace = True
	
	Perdu = False
	TimerPerdu = MilliSecs()
	
	Anim = TPerso.Create("Seiya", AnimFille, 640, 470)
	Anim.Initialiser()
	
End Function

' Fonction qui dessine le cadre
Function DessinerCadre()
	SetColor(200, 200, 200)
	SetBlend ALPHAblend
	SetAlpha .5
	DrawRect(220, 50, 30, 500)
	DrawRect(550, 50, 30, 500)
	DrawRect(220, 550, 360, 30)
	SetColor(255, 255, 255)
	SetAlpha 1
End Function

' Fonction qui met a jour le jeu
Function MAJJeu()
	Local x1:Int = Bloc1.PosX + Bloc1.Brique1.PosX + 5
	Local y1:Int = Bloc1.PosY + Bloc1.Brique1.PosY + 5
	Local x2:Int = Bloc1.PosX + Bloc1.Brique2.PosX + 5
	Local y2:Int = Bloc1.PosY + Bloc1.Brique2.PosY + 5
	Local x3:Int = Bloc1.PosX + Bloc1.Brique3.PosX + 5
	Local y3:Int = Bloc1.PosY + Bloc1.Brique3.PosY + 5
	Local x4:Int = Bloc1.PosX + Bloc1.Brique4.PosX + 5
	Local y4:Int = Bloc1.PosY + Bloc1.Brique4.PosY + 5

	Local DescentePossible:Byte = False
	
	Local AjoutScore:Int
	
	CheckOptions()
	
	If Opt_EnPause Then
		HeureDernierMouv :+ (MilliSecs() - HeurePause)
		HeurePause = MilliSecs()
	End If
	
	
	Anim.Update()
	
	' Descente des blocs d'un coup
'	If HeurePressEspace  < MilliSecs() - (TEMPS_MOUV - (VitesseJeu * ACCELERATION)) Then
'		If KeyHit(KEY_SPACE) And Not(Opt_EnPause) Then
'			While CheckMoveAndMove(0, -1, 0, -1, 0, -1, 0, -1)
'				Bloc1.PosY :- 1
'			Wend
'			HeurePressEspace = MilliSecs()
'		End If
'	End If
	
Rem	
	
	If KeyHit(KEY_SPACE) And Not(Opt_EnPause) And CheckMove(0, -1, 0, -1, 0, -1, 0, -1) Then
		If PresserEspace = True
			While CheckMoveAndMove(0, -1, 0, -1, 0, -1, 0, -1)
'				HeureDernierMouv = MilliSecs() - (TEMPS_MOUV - (VitesseJeu * ACCELERATION)) - 5
				Bloc1.PosY :- 1
			Wend
'			PresserEspace = False
			
			HeureDernierMouv = MilliSecs()
			
			Print "---------"
			Print DescentePossible
			Print Bloc1.PosY
			Print "---------"
			
			
		End If
	End If
	
End Rem
	
	If HeureDernierMouv < MilliSecs() - (TEMPS_MOUV - (VitesseJeu * ACCELERATION)) Then 'And Not(KeyDown(KEY_DOWN)) Then
		'On verifie par rapport a la limite basse de l'aire de jeu
		DescentePossible = CheckMove(0, -1, 0, -1, 0, -1, 0, -1)'True

		' Mise a jour de l'aire de jeu avec les briques bloqu�es
		If DescentePossible = False Then
			' On regarde si la partie est finie
			If Bloc1.PosY = 16 Then
'				InsererScore()
'				EnregistrerScores()
				
'				SaisieNom()
'				OL_EnregistrerScore()
				If Perdu = False Then
					TimerPerdu = MilliSecs()
					Perdu = True
					Anim.SetAnimCourante("pleure")
				End If
				
				If TimerPerdu < MilliSecs() - 4000 Then
					RetourMenu = 4
				End If
			Else
				Tab_Jeu[5 + (Bloc1.PosX + Bloc1.Brique1.PosX), 5 + (Bloc1.PosY + Bloc1.Brique1.PosY)] = Bloc1.TypeBrique
				Tab_Jeu[5 + (Bloc1.PosX + Bloc1.Brique2.PosX), 5 + (Bloc1.PosY + Bloc1.Brique2.PosY)] = Bloc1.TypeBrique
				Tab_Jeu[5 + (Bloc1.PosX + Bloc1.Brique3.PosX), 5 + (Bloc1.PosY + Bloc1.Brique3.PosY)] = Bloc1.TypeBrique
				Tab_Jeu[5 + (Bloc1.PosX + Bloc1.Brique4.PosX), 5 + (Bloc1.PosY + Bloc1.Brique4.PosY)] = Bloc1.TypeBrique
				Bloc1 = T_FT_Bloque.Create(BlocNext.TypeBrique, 4, 16, 30) 
				' On augmente le score en fonction de la rapidite a placer la piece
				AjoutScore = ((17 * (TEMPS_MOUV - (VitesseJeu * ACCELERATION)) - (MilliSecs() - HeureCreaBloc)) / 100)
				If AjoutScore > 0 Then
					Score_NbPoints :+ AjoutScore
				End If
				HeureCreaBloc = MilliSecs()
				BlocNext = T_FT_Bloque.Create(Rand(7), 14, 12, 30)
				If Opt_Son Then CanalPose = PlaySound(Snd_FXPose)
			End If
		Else
			Bloc1.PosY :- 1
		End If
		
		SupprimerLignes()
		
		Level = (Score_NbLignes / 10)
		If Level <> AncienLevel Then
			
			Emetteur = P2D_CreateEmetteur(ImgLevelUp, 300, 125, 225, 80, 60, 0, .5, "alpha")
			P2D_ReglerEchelle(Emetteur, 0.5, 0.5, 0.06, 0.06, 0.04, 0.04)
			P2D_ReglerAlpha(Emetteur, 0.9, 0.2, -0.03, 0.02)
			P2D_ReglerVelocite(Emetteur, 0, -0.5, 0, -1)
			P2D_ReglerVie(Emetteur, 1000, 1000)
			
			AncienLevel = Level
		End If
		VitesseJeu = Level
		
		HeureDernierMouv = MilliSecs()
	End If
	
	
'	If KeyHit(KEY_R) Then
'		Emetteur = P2D_CreateEmetteur(ImgLevelUp, 300, 125, 225, 80, 60, 0, .5, "alpha")
'			P2D_ReglerEchelle(Emetteur, 0.5, 0.5, 0.06, 0.06, 0.04, 0.04)
'			P2D_ReglerAlpha(Emetteur, 0.9, 0.2, -0.02, 0.02)
'			P2D_ReglerVelocite(Emetteur, 0, -0.5, 0, -1)
'			P2D_ReglerVie(Emetteur, 1000, 1000)
'	End If
	
	
	
	' Mise a jour des blocs
	
	If KeyDown(KEY_DOWN) And Not(Opt_EnPause) And Not(Perdu) Then
		If HeureDernierMouvDown < (MilliSecs() - TempsMouvDown) Then
			If CheckMove(0, -1, 0, -1, 0, -1, 0, -1) Then
				Bloc1.PosY :- 1
				HeureDernierMouvDown = MilliSecs()
				HeureDernierMouv = MilliSecs()
				If Opt_Son Then CanalTic = PlaySound(Snd_FXTic)
			End If
			If TempsMouvDown > 100 Then
				TempsMouvDown :- 100
			Else
				TempsMouvDown = 50
			End If
		End If
	Else
		TempsMouvDown = 300
		HeureDernierMouvDown = MilliSecs() - (TempsMouvDown + 1)
	End If
	
'	If KeyHit(KEY_DOWN) Then
'		If CheckMove(0, -1, 0, -1, 0, -1, 0, -1) Then
'			Bloc1.PosY :- 1
'		End If
'	End If
	
	
	If KeyDown(KEY_LEFT) And Not(Opt_EnPause) And Not(Perdu) Then
		If HeureDernierMouvLeft < (MilliSecs() - TempsMouvLeft) Then
			If CheckMove(-1, 0, -1, 0, -1, 0, -1, 0) Then
				Bloc1.PosX :- 1
				HeureDernierMouvLeft = MilliSecs()
				If Opt_Son Then CanalTic = PlaySound(Snd_FXTic)
			End If
			If TempsMouvLeft > 100 Then
				TempsMouvLeft :- 100
			Else
				TempsMouvLeft = 50
			End If
		End If
	Else
		TempsMouvLeft = 300
		HeureDernierMouvLeft = MilliSecs() - (TempsMouvLeft + 1)
	End If
	
'	If KeyHit(KEY_LEFT) Then
'		If CheckMove(-1, 0, -1, 0, -1, 0, -1, 0) Then
'			Bloc1.PosX :- 1
'			HeureDernierMouv = MilliSecs()
'		End If
'	End If
	
	If KeyDown(KEY_RIGHT) And Not(Opt_EnPause) And Not(Perdu) Then
		If HeureDernierMouvRight < (MilliSecs() - TempsMouvRight) Then
			If CheckMove(1, 0, 1, 0, 1, 0, 1, 0) Then
				Bloc1.PosX :+ 1
				HeureDernierMouvRight = MilliSecs()
				If Opt_Son Then CanalTic = PlaySound(Snd_FXTic)
			End If
			If TempsMouvRight > 100 Then
				TempsMouvRight :- 100
			Else
				TempsMouvRight = 50
			End If
		End If
	Else
		TempsMouvRight = 300
		HeureDernierMouvRight = MilliSecs() - (TempsMouvRight + 1)
	End If
	
	If KeyDown(KEY_ESCAPE) Then
		RetourMenu = 0
	End If
	
'	If KeyHit(KEY_SPACE) Then
'		CreerParticules(14)
'		Emetteur = P2D_CreateEmetteur(SprPartCian, 300, 750, 500, 60, 60, 0, 1, "light")
'		P2D_ReglerEchelle(Emetteur, 0.4, 0.4, 0.02, 0.02, 0.04, 0.04)
'		P2D_ReglerAlpha(Emetteur, 0.8, 0.2, -0.0818, 0.02)
'		P2D_ReglerVelocite(Emetteur, 0, -0.5, 0, -1)
'		P2D_ReglerVie(Emetteur, 1000, 1000)
'	End If
	
	P2D_Update()
	' Affichage des particules
'	P2D_Afficher()
	
'	If KeyHit(KEY_RIGHT) Then
'		If CheckMove(1, 0, 1, 0, 1, 0, 1, 0) Then
'			Bloc1.PosX :+ 1
'		End If
'	End If
	
	If KeyHit(KEY_UP) And Not(Opt_EnPause) And Not(Perdu) Then
		Select Bloc1.TypeBrique
			Case 1
				Select Bloc1.Etat
					Case 1
						If CheckMove(1, -1, 0, 0, -1, 1, -2, 2) Then
							Bloc1.Brique1.PosX :+ 1
							Bloc1.Brique1.PosY :- 1
							Bloc1.Brique3.PosX :- 1
							Bloc1.Brique3.PosY :+ 1
							Bloc1.Brique4.PosX :- 2
							Bloc1.Brique4.PosY :+ 2
								
							Bloc1.Etat = 2
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
							
					Case 2
						If CheckMove(1, 1, 0, 0, -1, 1, -2, -2) Then
							Bloc1.Brique1.PosX :+ 1
							Bloc1.Brique1.PosY :+ 1
							Bloc1.Brique3.PosX :- 1
							Bloc1.Brique3.PosY :- 1
							Bloc1.Brique4.PosX :- 2
							Bloc1.Brique4.PosY :- 2
						
							Bloc1.Etat = 3
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					
					Case 3
						If CheckMove(-1, 1, 0, 0, 1, -1, 2, -2) Then
							Bloc1.Brique1.PosX :- 1
							Bloc1.Brique1.PosY :+ 1
							Bloc1.Brique3.PosX :+ 1
							Bloc1.Brique3.PosY :- 1
							Bloc1.Brique4.PosX :+ 2
							Bloc1.Brique4.PosY :- 2
						
							Bloc1.Etat = 4
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
						
					Case 4
						If CheckMove(-1, -1, 0, 0, 1, 1, 2, 2) Then
							Bloc1.Brique1.PosX :- 1
							Bloc1.Brique1.PosY :- 1
							Bloc1.Brique3.PosX :+ 1
							Bloc1.Brique3.PosY :+ 1
							Bloc1.Brique4.PosX :+ 2
							Bloc1.Brique4.PosY :+ 2
						
							Bloc1.Etat = 1
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					
				End Select
				
			Case 3
				Select Bloc1.Etat
					Case 1
						If CheckMove(1, 1, 0, 0, -1, -1, 1, -1) Then
							Bloc1.Brique1.PosX :+ 1
							Bloc1.Brique1.PosY :+ 1
							Bloc1.Brique3.PosX :- 1
							Bloc1.Brique3.PosY :- 1
							Bloc1.Brique4.PosX :+ 1
							Bloc1.Brique4.PosY :- 1
								
							Bloc1.Etat = 2
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 2
						If CheckMove(1, -1, 0, 0, -1, 1, -1, -1) Then
							Bloc1.Brique1.PosX :+ 1
							Bloc1.Brique1.PosY :- 1
							Bloc1.Brique3.PosX :- 1
							Bloc1.Brique3.PosY :+ 1
							Bloc1.Brique4.PosX :- 1
							Bloc1.Brique4.PosY :- 1
						
							Bloc1.Etat = 3
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 3
						If CheckMove(-1, -1, 0, 0, +1, +1, -1, 1) Then
							Bloc1.Brique1.PosX :- 1
							Bloc1.Brique1.PosY :- 1
							Bloc1.Brique3.PosX :+ 1
							Bloc1.Brique3.PosY :+ 1
							Bloc1.Brique4.PosX :- 1
							Bloc1.Brique4.PosY :+ 1
							
							Bloc1.Etat = 4
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 4
						If CheckMove(-1, 1, 0, 0, 1, -1, 1, 1) Then
							Bloc1.Brique1.PosX :- 1
							Bloc1.Brique1.PosY :+ 1
							Bloc1.Brique3.PosX :+ 1
							Bloc1.Brique3.PosY :- 1
							Bloc1.Brique4.PosX :+ 1
							Bloc1.Brique4.PosY :+ 1
							
							Bloc1.Etat = 1
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
				End Select
			Case 4
				Select Bloc1.Etat
					Case 1
						If CheckMove(-1, 1, 0, 0, 1, -1, 0, -2) Then
							Bloc1.Brique1.PosX :- 1
							Bloc1.Brique1.PosY :+ 1
							Bloc1.Brique3.PosX :+ 1
							Bloc1.Brique3.PosY :- 1

							Bloc1.Brique4.PosY :- 2
							
							Bloc1.Etat = 2
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 2
						If CheckMove(-1, -1, 0, 0, 1, 1, -2, 0) Then
							Bloc1.Brique1.PosX :- 1
							Bloc1.Brique1.PosY :- 1
							Bloc1.Brique3.PosX :+ 1
							Bloc1.Brique3.PosY :+ 1
							Bloc1.Brique4.PosX :- 2
							
							Bloc1.Etat = 3
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 3
						If CheckMove(1, -1, 0, 0, -1, 1, 0, 2) Then
							Bloc1.Brique1.PosX :+ 1
							Bloc1.Brique1.PosY :- 1
							Bloc1.Brique3.PosX :- 1
							Bloc1.Brique3.PosY :+ 1

							Bloc1.Brique4.PosY :+ 2
							
							Bloc1.Etat = 4
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 4
						If CheckMove(1, 1, 0, 0, -1, -1, 2, 0) Then
							Bloc1.Brique1.PosX :+ 1
							Bloc1.Brique1.PosY :+ 1
							Bloc1.Brique3.PosX :- 1
							Bloc1.Brique3.PosY :- 1
							Bloc1.Brique4.PosX :+ 2
							
							Bloc1.Etat = 1
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
				End Select
			Case 5
				Select Bloc1.Etat
					Case 1
						If CheckMove(-1, 1, 0, 0, 1, -1, 2, 0) Then
							Bloc1.Brique1.PosX :- 1
							Bloc1.Brique1.PosY :+ 1
							Bloc1.Brique3.PosX :+ 1
							Bloc1.Brique3.PosY :- 1

							Bloc1.Brique4.PosX :+ 2
							
							Bloc1.Etat = 2
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 2
						If CheckMove(-1, -1, 0, 0, 1, 1, 0, -2) Then
							Bloc1.Brique1.PosX :- 1
							Bloc1.Brique1.PosY :- 1
							Bloc1.Brique3.PosX :+ 1
							Bloc1.Brique3.PosY :+ 1

							Bloc1.Brique4.PosY :- 2
							
							Bloc1.Etat = 3
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 3
						If CheckMove(1, -1, 0, 0, -1, 1, -2, 0) Then
							Bloc1.Brique1.PosX :+ 1
							Bloc1.Brique1.PosY :- 1
							Bloc1.Brique3.PosX :- 1
							Bloc1.Brique3.PosY :+ 1

							Bloc1.Brique4.PosX :- 2
							
							Bloc1.Etat = 4
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 4
						
						If CheckMove(1, 1, 0, 0, -1, -1, 0, 2) Then
							Bloc1.Brique1.PosX :+ 1
							Bloc1.Brique1.PosY :+ 1
							Bloc1.Brique3.PosX :- 1
							Bloc1.Brique3.PosY :- 1
							Bloc1.Brique4.PosY :+ 2
							
							Bloc1.Etat = 1
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
				End Select
				
			Case 6
				Select Bloc1.Etat
					Case 1
						If CheckMove(2, 0, 1, -1, 0, 0, -1, -1) Then
							Bloc1.Brique1.PosX :+ 2
							'Bloc1.Brique1.PosY :+ 1
							Bloc1.Brique2.PosX :+ 1
							Bloc1.Brique2.PosY :- 1
							Bloc1.Brique4.PosX :- 1
							Bloc1.Brique4.PosY :- 1
							
							Bloc1.Etat = 2
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 2
						If CheckMove(0, -2, -1, -1, 0, 0, -1, 1) Then
							'Bloc1.Brique1.PosX :- 1
							Bloc1.Brique1.PosY :- 2
							Bloc1.Brique2.PosX :- 1
							Bloc1.Brique2.PosY :- 1
							Bloc1.Brique4.PosX :- 1
							Bloc1.Brique4.PosY :+ 1
							
							Bloc1.Etat = 3
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 3
						If CheckMove(-2, 0, -1, 1, 0, 0, 1, 1) Then
							Bloc1.Brique1.PosX :- 2
							'Bloc1.Brique1.PosY :- 1
							Bloc1.Brique2.PosX :- 1
							Bloc1.Brique2.PosY :+ 1
							Bloc1.Brique4.PosX :+ 1
							Bloc1.Brique4.PosY :+ 1
							
							Bloc1.Etat = 4
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 4
						
						If CheckMove(0, 2, 1, 1, 0, 0, 1, -1) Then
							'Bloc1.Brique1.PosX :+ 1
							Bloc1.Brique1.PosY :+ 2
							Bloc1.Brique2.PosX :+ 1
							Bloc1.Brique2.PosY :+ 1
							Bloc1.Brique4.PosX :+ 1
							Bloc1.Brique4.PosY :- 1
							
							Bloc1.Etat = 1
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
				End Select
				
			Case 7
				Select Bloc1.Etat
					Case 1
						If CheckMove(1, -1, 0, -2, 1, 1, 0, 0) Then
							Bloc1.Brique1.PosX :+ 1
							Bloc1.Brique1.PosY :- 1
							
							Bloc1.Brique2.PosY :- 2
							Bloc1.Brique3.PosX :+ 1
							Bloc1.Brique3.PosY :+ 1
							
							Bloc1.Etat = 2
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 2
						If CheckMove(-1, -1, -2, 0, 1, -1, 0, 0) Then
							Bloc1.Brique1.PosX :- 1
							Bloc1.Brique1.PosY :- 1
							Bloc1.Brique2.PosX :- 2
							
							Bloc1.Brique3.PosX :+ 1
							Bloc1.Brique3.PosY :- 1
							
							Bloc1.Etat = 3
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 3
						If CheckMove(-1, 1, 0, 2, -1, -1, 0, 0) Then
							Bloc1.Brique1.PosX :- 1
							Bloc1.Brique1.PosY :+ 1
							
							Bloc1.Brique2.PosY :+ 2
							Bloc1.Brique3.PosX :- 1
							Bloc1.Brique3.PosY :- 1
							
							Bloc1.Etat = 4
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 4
						
						If CheckMove(1, 1, 2, 0, -1, 1, 0, 0) Then
							Bloc1.Brique1.PosX :+ 1
							Bloc1.Brique1.PosY :+ 1
							Bloc1.Brique2.PosX :+ 2
							
							Bloc1.Brique3.PosX :- 1
							Bloc1.Brique3.PosY :+ 1
							
							Bloc1.Etat = 1
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
				End Select
		End Select
	End If

Rem	
	If KeyHit(KEY_Z) Then
		Select Bloc1.TypeBrique
			Case 1
				Select Bloc1.Etat
					Case 1
						If CheckMoveAndMove(1, 1, 0, 0, -1, -1, -2, -2) Then
							Bloc1.Etat = 4
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
							
					Case 4
						If CheckMoveAndMove(1, -1, 0, 0, -1, 1, -2, 2) Then
							Bloc1.Etat = 3
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					
					Case 3
						If CheckMoveAndMove(-1, -1, 0, 0, 1, 1, 2, 2) Then
							Bloc1.Etat = 2
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
						
					Case 2
						If CheckMoveAndMove(-1, 1, 0, 0, 1, -1, 2, -2) Then
							Bloc1.Etat = 1
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
						
				End Select
				
			Case 3
				Select Bloc1.Etat
					Case 1
						If CheckMoveAndMove(1, -1, 0, 0, -1, 1, -1, -1) Then
							Bloc1.Etat = 4
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
						
					Case 4
						If CheckMoveAndMove(1, 1, 0, 0, -1, -1, 1, -1) Then
							Bloc1.Etat = 3
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
						
					Case 3
						If CheckMoveAndMove(-1, 1, 0, 0, 1, -1, 1, 1) Then
							Bloc1.Etat = 2
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
						
					Case 2
						If CheckMoveAndMove(-1, -1, 0, 0, 1, 1, -1, 1) Then
							Bloc1.Etat = 1
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
						
				End Select
				
			Case 4
				Select Bloc1.Etat
					Case 1
						If CheckMoveAndMove(-1, 1, 0, 0, 1, -1, 0, -2) Then
							Bloc1.Etat = 2
						
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
						
					Case 2
						If CheckMoveAndMove(-1, -1, 0, 0, 1, 1, -2, 0) Then	
							Bloc1.Etat = 3
						
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
						
					Case 3
						If CheckMoveAndMove(1, -1, 0, 0, -1, 1, 0, 2) Then
							Bloc1.Etat = 4
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 4
						If CheckMoveAndMove(1, 1, 0, 0, -1, -1, 2, 0) Then
							Bloc1.Etat = 1
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
				End Select
			Case 5
				Select Bloc1.Etat
					Case 1
						If CheckMoveAndMove(-1, 1, 0, 0, 1, -1, 2, 0) Then
							Bloc1.Etat = 2
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 2
						If CheckMoveAndMove(-1, -1, 0, 0, 1, 1, 0, -2) Then
							Bloc1.Etat = 3
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 3
						If CheckMoveAndMove(1, -1, 0, 0, -1, 1, -2, 0) Then
							Bloc1.Etat = 4
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 4
						
						If CheckMoveAndMove(1, 1, 0, 0, -1, -1, 0, 2) Then
							Bloc1.Etat = 1
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
				End Select
				
			Case 6
				Select Bloc1.Etat
					Case 1
						If CheckMoveAndMove(2, 0, 1, -1, 0, 0, -1, -1) Then
							Bloc1.Etat = 2
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 2
						If CheckMoveAndMove(0, -2, -1, -1, 0, 0, -1, 1) Then
							Bloc1.Etat = 3
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 3
						If CheckMoveAndMove(-2, 0, -1, 1, 0, 0, 1, 1) Then
							Bloc1.Etat = 4
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 4
						
						If CheckMoveAndMove(0, 2, 1, 1, 0, 0, 1, -1) Then
							Bloc1.Etat = 1
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
				End Select
				
			Case 7
				Select Bloc1.Etat
					Case 1
						If CheckMoveAndMove(1, -1, 0, -2, 1, 1, 0, 0) Then
							Bloc1.Etat = 2
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 2
						If CheckMoveAndMove(-1, -1, -2, 0, 1, -1, 0, 0) Then
							Bloc1.Etat = 3
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 3
						If CheckMoveAndMove(-1, 1, 0, 2, -1, -1, 0, 0) Then
							Bloc1.Etat = 4
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
					Case 4
						
						If CheckMoveAndMove(1, 1, 2, 0, -1, 1, 0, 0) Then
							Bloc1.Etat = 1
							
							If Opt_Son Then CanalPop = PlaySound(Snd_FXPop)
						End If
				End Select
		End Select
	End If
End Rem
	
End Function

' Fonction qui se charge de l'affichage du jeu
Function DessinerJeu()
	' Compteurs de boucles
	Local i, j:Int
	
	Cls
	SetColor(255, 255, 255)
	' Dessine l'air de jeu
	DrawImage(ImgFond, 0, 0)
'	DessinerCadre()
'	DrawImage(ImgPortrait1, 0, 247)
'	Bloc1.Update()

	Bloc1.Draw()
	
'	DrawImage(ImgCadreBloc, 600, 100)
	
	If Opt_BlocNext Then
		SetColor(0, 0, 0)
		DrawText("Next", 610, 110)
		SetColor(255, 255, 255)
		If BlocNext.TypeBrique = 2 Or BlocNext.TypeBrique = 4 Or BlocNext.TypeBrique = 5 Then
			If BlocNext.PosX = 14 Then
				BlocNext.PosX = 13
			End If
		End If
		BlocNext.Draw()
	End If
	
'	DrawImage(ImgCadreBloc, 600, 250)
	SetColor(0, 0, 0)
	DrawText("Level", 610, 260)
	DrawText(Level, 780 - TextWidth(Level), 260)
	DrawText("Lines", 610, 300)
	DrawText(Score_NbLignes, 780 - TextWidth(Score_NbLignes), 300)
	DrawText("Score", 610, 340)
	DrawText(Score_NbPoints, 780 - TextWidth(Score_NbPoints), 340)
	SetColor(255, 255, 255)
	
	' Dessin des blocs deja tombes
	For i = 0 To 19
		For j = 0 To 29
			Select Tab_Jeu[i, j]
				Case 1
					DrawImage(SprBriqueJaune, (250 + ((i - 5) * Bloc1.TailleBrique)), (550 - Bloc1.TailleBrique) - ((j - 5) * Bloc1.TailleBrique))
				Case 2
					DrawImage(SprBriqueVerte, (250 + ((i - 5) * Bloc1.TailleBrique)), (550 - Bloc1.TailleBrique) - ((j - 5) * Bloc1.TailleBrique))
				Case 3
					DrawImage(SprBriqueMauve, (250 + ((i - 5) * Bloc1.TailleBrique)), (550 - Bloc1.TailleBrique) - ((j - 5) * Bloc1.TailleBrique))
				Case 4
					DrawImage(SprBriqueBleue, (250 + ((i - 5) * Bloc1.TailleBrique)), (550 - Bloc1.TailleBrique) - ((j - 5) * Bloc1.TailleBrique))
				Case 5
					DrawImage(SprBriqueOrange, (250 + ((i - 5) * Bloc1.TailleBrique)), (550 - Bloc1.TailleBrique) - ((j - 5) * Bloc1.TailleBrique))
				Case 6
					DrawImage(SprBriqueRouge, (250 + ((i - 5) * Bloc1.TailleBrique)), (550 - Bloc1.TailleBrique) - ((j - 5) * Bloc1.TailleBrique))
				Case 7
					DrawImage(SprBriqueCian, (250 + ((i - 5) * Bloc1.TailleBrique)), (550 - Bloc1.TailleBrique) - ((j - 5) * Bloc1.TailleBrique))
			End Select
		Next
	Next

	
	If Debug
		DrawText(Bloc1.Brique1.Posx, 10, 10)
		DrawText(Bloc1.Posx, 10, 30)
		DrawText(29 - (Bloc1.PosY + Bloc1.Brique1.PosY + 1), 10, 100)
		DrawText(Bloc1.PosY + Bloc1.Brique1.PosY + 2, 10, 120)
		DrawText((Bloc1.PosY + Bloc1.Brique1.PosY), 10, 200)
		DrawText(Tab_Jeu[29 - (Bloc1.PosY + Bloc1.Brique1.PosY), 29 - (Bloc1.PosX + Bloc1.Brique1.PosX)], 10, 220)
		DrawText(Tab_Jeu[0, 0], 10, 240)
		DrawText("y=" + (29 - (Bloc1.PosY + Bloc1.Brique1.PosY)) + " x=" + (Bloc1.PosX + Bloc1.Brique1.PosX), 10, 500)
	End If
	
	If Opt_Memo Then
		DrawText("Memory alloced " + GCMemAlloced(), 0, 20)
	End If
	
	If MilliSecs() > FPS_Timer + 1000 Then
		FPS_Framerate = FPS_Framerate_Temp
		FPS_Framerate_Temp = 0
		FPS_Timer = MilliSecs()
	Else
		FPS_Framerate_Temp :+ 1
	End If
	
	If Opt_FPS Then
		DrawText("FPS " + FPS_Framerate, 0, 0)
	End If
	
	P2D_Afficher()
	
	DrawImage(ImgCadres, 0, 0)
	
'	DrawImage(AnimFilleCouche, 700, 500, (MilliSecs() Mod 400) / 100)
	
	Anim.Draw()
	
	If Opt_EnPause Then
		' Clignotement de "Press Enter to continue"
		If ((MilliSecs() - TimerPause) Mod 1000 < 1000) Then
			SetBlend ALPHABLEND
			SetAlpha(Float(1000 - ((MilliSecs() - TimerPause) Mod 1000)) / 1000.0)
			DrawImage(ImgPause, GraphicsWidth()/2, 400)
			SetAlpha(1)
			'SetBlend MASKBLEND
		End If
	End If
	
	If Perdu Then
		SetBlend ALPHABLEND
		DrawImage(ImgGameOver, GraphicsWidth() / 2, 400)
	End If
	
'	DrawImage(ImgTitre, 600, 20)
	
	Flip
End Function

' Suppression des lignes
Function SupprimerLignes()
'	Local NbBriquesLigne:Int = 0 
	Local i, j:Int
	Local NbLignes:Int = 0
	
	' On r�initialise le tableau des lignes
	ReinitTabLignes()


	For j = 5 To 25
		If Tab_Lignes[j - NbLignes] = 1 Then
			'NbLignes :+ 1
			DescendreBlocsFixes(j - NbLignes + 1)
			ReinitTabLignes()
			NbLignes :+ 1			
		End If
	Next


	If NbLignes > 0 Then
		Score_NbLignes :+ NbLignes
	End If
	
	Select NbLignes
		Case 1
			Score_NbPoints :+ 100
			If Opt_Son Then CanalSupprLigne = PlaySound(Snd_FXSupprLigne)
		Case 2
			Score_NbPoints :+ 220
			If Opt_Son Then CanalSupprLigne = PlaySound(Snd_FXSupprLigne)
		Case 3
			Score_NbPoints :+ 350
			If Opt_Son Then CanalSupprLigne = PlaySound(Snd_FXSupprLigne)
		Case 4
			Score_NbPoints :+ 600
			If Opt_Son Then CanalSupprLigne = PlaySound(Snd_FXSupprLigne)
	End Select
	
End Function

Function CheckMove:Byte(paramX1:Int=0, paramY1:Int=0, paramX2:Int=0, paramY2:Int=0, paramX3:Int=0, paramY3:Int=0, paramX4:Int=0, paramY4:Int=0)
		
	Local CanMove = True
	Local x1:Int = Bloc1.PosX + Bloc1.Brique1.PosX + 5
	Local y1:Int = Bloc1.PosY + Bloc1.Brique1.PosY + 5
	Local x2:Int = Bloc1.PosX + Bloc1.Brique2.PosX + 5
	Local y2:Int = Bloc1.PosY + Bloc1.Brique2.PosY + 5
	Local x3:Int = Bloc1.PosX + Bloc1.Brique3.PosX + 5
	Local y3:Int = Bloc1.PosY + Bloc1.Brique3.PosY + 5
	Local x4:Int = Bloc1.PosX + Bloc1.Brique4.PosX + 5
	Local y4:Int = Bloc1.PosY + Bloc1.Brique4.PosY + 5
	
	If Tab_Jeu[x1 + paramX1, y1 + paramY1] <> 0 Then
		CanMove = False
	End If
	If Tab_Jeu[x2 + paramX2, y2 + paramY2] <> 0 Then
		CanMove = False
	End If
	If Tab_Jeu[x3 + paramX3, y3 + paramY3] <> 0 Then
		CanMove = False
	End If
	If Tab_Jeu[x4 + paramX4, y4 + paramY4] <> 0 Then
		CanMove = False
	End If

	Return CanMove

End Function


Function CheckMoveAndMove:Byte(paramX1:Int=0, paramY1:Int=0, paramX2:Int=0, paramY2:Int=0, paramX3:Int=0, paramY3:Int=0, paramX4:Int=0, paramY4:Int=0)
		
	Local CanMove = True
	Local x1:Int = Bloc1.PosX + Bloc1.Brique1.PosX + 5
	Local y1:Int = Bloc1.PosY + Bloc1.Brique1.PosY + 5
	Local x2:Int = Bloc1.PosX + Bloc1.Brique2.PosX + 5
	Local y2:Int = Bloc1.PosY + Bloc1.Brique2.PosY + 5
	Local x3:Int = Bloc1.PosX + Bloc1.Brique3.PosX + 5
	Local y3:Int = Bloc1.PosY + Bloc1.Brique3.PosY + 5
	Local x4:Int = Bloc1.PosX + Bloc1.Brique4.PosX + 5
	Local y4:Int = Bloc1.PosY + Bloc1.Brique4.PosY + 5
	
	If Tab_Jeu[x1 + paramX1, y1 + paramY1] <> 0 Then
		CanMove = False
	End If
	If Tab_Jeu[x2 + paramX2, y2 + paramY2] <> 0 Then
		CanMove = False
	End If
	If Tab_Jeu[x3 + paramX3, y3 + paramY3] <> 0 Then
		CanMove = False
	End If
	If Tab_Jeu[x4 + paramX4, y4 + paramY4] <> 0 Then
		CanMove = False
	End If

	If CanMove Then
		Bloc1.Brique1.PosX :+ paramX1
		Bloc1.Brique1.PosY :+ paramY1
		Bloc1.Brique2.PosX :+ paramX2
		Bloc1.Brique2.PosY :+ paramY2
		Bloc1.Brique3.PosX :+ paramX3
		Bloc1.Brique3.PosY :+ paramY3
		Bloc1.Brique4.PosX :+ paramX4
		Bloc1.Brique4.PosY :+ paramY4
	End If
	
	Return Canmove

End Function

' Function qui baisse tous les blocs � partir d'une ligne
Function DescendreBlocsFixes(NumLigne:Int)

	Local i:Int
	Local j:Int
	
	For i = 5 To 14
		For j = NumLigne To 29
			If j > 5 Then
				Tab_Jeu[i, j - 1] = Tab_Jeu[i, j]
			End If
		Next
	Next

End Function


Function ReinitTabLignes()

	Local NbBriquesLigne:Int = 0 
	Local i, j, k:Int
	Local NbLignes:Int = 0
	
	' On r�initialise le tableau des lignes
	For i = 0 To 29
		Tab_Lignes[i] = 0
	Next
	
	
	For j = 5 To 25
		For i = 5 To 14
			If Tab_Jeu[i, j] <> 0 Then
				NbBriquesLigne :+ 1
			End If
		Next
		If NbBriquesLigne = 10 Then
			Tab_Lignes[j] = 1
			' Cr�ation des particules
			If Opt_PartActives Then
				CreerParticules(j + 5)
				Anim.SetAnimCourante("saute")
			End If
		End If
		NbBriquesLigne = 0
	Next

End Function


Function CheckOptions()
	
	If KeyHit(KEY_N) Then Opt_BlocNext = 1 - Opt_BlocNext
	If KeyHit(KEY_P) Then 
		Opt_EnPause = 1 - Opt_EnPause
		If Opt_EnPause Then
			HeurePause = MilliSecs()
		End If
	End If
	If KeyHit(KEY_S) Then Opt_Son = 1 - Opt_Son
	If KeyHit(KEY_M) Then Opt_Memo = 1 - Opt_Memo
	If KeyHit(KEY_F) Then Opt_FPS = 1 - Opt_FPS
	
End Function


Function Menu()
	Local EtatMenu:Int 

	FlushKeys()
	EtatMenu = 1
	
	While (RetourMenu = 0)
		Cls
		
		DrawImage(ImgFondMenu, 0, 0)
		
		If KeyHit(KEY_ESCAPE)
			RetourMenu = 5
		End If
		
		If (MouseX() > 56) And (MouseX() < 311) And (MouseY() > 429) And (MouseY() < 504) Then
			DrawImage(Img1player_on, 56, 429)
			DrawImage(Img2players_off, 30, 522)
			DrawImage(Imgoptions_off, 534, 416)
			DrawImage(Imghighscores_off, 504, 482)			
			DrawImage(Imgquit_off, 572, 545)
			If MouseHit(1) Then RetourMenu = 1
		Else
			If (MouseX() > 30) And (MouseX() < 333) And (MouseY() > 522) And (MouseY() < 596) Then
				DrawImage(Img1player_off, 56, 429)
				DrawImage(Img2players_on, 30, 522)
				DrawImage(Imgoptions_off, 534, 416)
				DrawImage(Imghighscores_off, 504, 482)			
				DrawImage(Imgquit_off, 572, 545)
				DrawImage(ImgCurseur, MouseX(), MouseY())
				NotAvailable()
			Else
				If (MouseX() > 534) And (MouseX() < 715) And (MouseY() > 416) And (MouseY() < 476) Then
					DrawImage(Img1player_off, 56, 429)
					DrawImage(Img2players_off, 30, 522)
					DrawImage(Imgoptions_on, 534, 416)
					DrawImage(Imghighscores_off, 504, 482)			
					DrawImage(Imgquit_off, 572, 545)
					NotAvailable()
				Else
					If (MouseX() > 504) And (MouseX() < 754) And (MouseY() > 482) And (MouseY() < 541) Then
						DrawImage(Img1player_off, 56, 429)
						DrawImage(Img2players_off, 30, 522)
						DrawImage(Imgoptions_off, 534, 416)
						DrawImage(Imghighscores_on, 504, 482)			
						DrawImage(Imgquit_off, 572, 545)
						If MouseHit(1) Then 
							Score_NbPoints = 0
							ChaineNom = ""
'							' Initialisation du tableau des scores selon qu'on soit connect� ou non
'							If CheckIfConnected() Then
'								OL_InitTabScore()
'							Else
'								InitTabScore()
'							End If
							
							RetourMenu = 4
						End If
					Else
						If (MouseX() > 572) And (MouseX() < 679) And (MouseY() > 545) And (MouseY() < 595) Then
							DrawImage(Img1player_off, 56, 429)
							DrawImage(Img2players_off, 30, 522)
							DrawImage(Imgoptions_off, 534, 416)
							DrawImage(Imghighscores_off, 504, 482)			
							DrawImage(Imgquit_on, 572, 545)
							If MouseHit(1) Then RetourMenu = 5
						Else
							DrawImage(Img1player_off, 56, 429)
							DrawImage(Img2players_off, 30, 522)
							DrawImage(Imgoptions_off, 534, 416)
							DrawImage(Imghighscores_off, 504, 482)
							DrawImage(Imgquit_off, 572, 545)
						End If
					End If
				End If
			End If
		End If
		
		SetColor(0, 0, 0)
		DrawText("v. " + Version, (GraphicsWidth() - TextWidth("v. " + Version)) - 10, 0)
		
		If Version < DerniereVersion Then
			If MilliSecs() Mod 1000 < 500
				DrawText("v. " + DerniereVersion + " now available", (GraphicsWidth() - TextWidth("v. " + DerniereVersion + " now available")) - 10, 20)
			End If
		End If
		
		SetColor(255, 255, 255)
		
		DrawImage(ImgCurseur, MouseX(), MouseY())
		
		FlushKeys()
		
		Flip
	Wend
End Function


Function NotAvailable()

	Local PosX:Int
	Local PosY:Int
	
	If MouseX() + ImageWidth(ImgNotAvailable) > GraphicsWidth() Then 
		PosX = GraphicsWidth() - ImageWidth(ImgNotAvailable)
	Else
		PosX = MouseX()
	End If
	
	If MouseY() + ImageHeight(ImgNotAvailable) < 0 Then 
		PosY = 0
	Else
		PosY = MouseY() - ImageHeight(ImgNotAvailable)
	End If
	
	DrawImage(ImgNotAvailable, PosX, PosY)
	
End Function


Function Scores()

	Local i:Int
	Local TimerPromo = MilliSecs()

	If Opt_CheckIfOnLone Then
		If CheckIfConnected() Then
			OL_InitTabScore()
			OL_InitTabScoreBas()
		Else
			InitTabScore()
		End If
	Else
		InitTabScore()
	End If

	While (RetourMenu = 4)
		Cls
		
		DrawImage(ImgScores, 0, 0)
		
		For i = 0 To 9
			If Tab_Score[i].Nom = ChaineNom And Tab_Score[i].Score = Score_NbPoints Then
				SetColor(0, 100, 200)
			End If
			DrawText(Tab_Score[i].Score, 95 - (TextWidth(Tab_Score[i].Score) / 2), (i * 35) + 50)
			DrawText(Tab_Score[i].Level, 260 - (TextWidth(Tab_Score[i].Level) / 2), (i * 35) + 50)
			DrawText(Tab_Score[i].Lignes, 470 - (TextWidth(Tab_Score[i].Lignes) / 2), (i * 35) + 50)
			DrawText(Tab_Score[i].Nom, 635, (i * 35) + 50)
			If Tab_Score[i].Nom = ChaineNom And Tab_Score[i].Score = Score_NbPoints Then
				SetColor(255, 255, 255)
			End If
		Next
		
		If Opt_CheckIfOnLone Then
			If CheckIfConnected() Then
				For i = 0 To 3
					If Tab_Score_Bas[i].Nom = ChaineNom And Tab_Score_Bas[i].Score = Score_NbPoints Then
						SetColor(0, 100, 200)
					End If
					DrawText(Tab_Score_Bas[i].Score, 95 - (TextWidth(Tab_Score_Bas[i].Score) / 2), (i * 35) + 430)
					DrawText(Tab_Score_Bas[i].Level, 260 - (TextWidth(Tab_Score_Bas[i].Level) / 2), (i * 35) + 430)
					DrawText(Tab_Score_Bas[i].Lignes, 470 - (TextWidth(Tab_Score_Bas[i].Lignes) / 2), (i * 35) + 430)
					DrawText(Tab_Score_Bas[i].Nom, 635, (i * 35) + 430)
					If Tab_Score_Bas[i].Nom = ChaineNom And Tab_Score_Bas[i].Score = Score_NbPoints Then
						SetColor(255, 255, 255)
					End If
				Next
			Else
				DrawImage(ImgNoConnection, GraphicsWidth() / 2, 500)
			End If
		Else
			DrawImage(ImgNoConnection, GraphicsWidth() / 2, 500)
		End If
		
		' Clignotement de "Press Enter to continue"
		If ((MilliSecs() - TimerPromo) Mod 1000 < 1000) Then
			SetBlend ALPHABLEND
			SetAlpha(Float(1000 - ((MilliSecs() - TimerPromo) Mod 1000)) / 1000.0)
			DrawImage(ImgEnter, GraphicsWidth()/2, 400)
			SetAlpha(1)
		End If
		
		If KeyHit(KEY_ENTER) Then
			RetourMenu = 0
		End If
		
		Flip
	Wend
	
End Function


Function SaisieNom()

	While Not(KeyHit(KEY_ENTER))
		Cls
		
		DrawImage(ImgName, 0, 0)
		
		If Len(ChaineNom) < 10 Then
			If KeyDown(KEY_LSHIFT) Or KeyDown(KEY_LSHIFT) Then
				If KeyHit(KEY_A) Then ChaineNom :+ "A"
				If KeyHit(KEY_Z) Then ChaineNom :+ "Z"
				If KeyHit(KEY_E) Then ChaineNom :+ "E"
				If KeyHit(KEY_R) Then ChaineNom :+ "R"
				If KeyHit(KEY_T) Then ChaineNom :+ "T"
				If KeyHit(KEY_Y) Then ChaineNom :+ "Y"
				If KeyHit(KEY_U) Then ChaineNom :+ "U"
				If KeyHit(KEY_I) Then ChaineNom :+ "I"
				If KeyHit(KEY_O) Then ChaineNom :+ "O"
				If KeyHit(KEY_P) Then ChaineNom :+ "P"
				If KeyHit(KEY_Q) Then ChaineNom :+ "Q"
				If KeyHit(KEY_S) Then ChaineNom :+ "S"
				If KeyHit(KEY_D) Then ChaineNom :+ "D"
				If KeyHit(KEY_F) Then ChaineNom :+ "F"
				If KeyHit(KEY_G) Then ChaineNom :+ "G"
				If KeyHit(KEY_H) Then ChaineNom :+ "H"
				If KeyHit(KEY_J) Then ChaineNom :+ "J"
				If KeyHit(KEY_K) Then ChaineNom :+ "K"
				If KeyHit(KEY_L) Then ChaineNom :+ "L"
				If KeyHit(KEY_M) Then ChaineNom :+ "M"
				If KeyHit(KEY_W) Then ChaineNom :+ "W"
				If KeyHit(KEY_X) Then ChaineNom :+ "X"
				If KeyHit(KEY_C) Then ChaineNom :+ "C"
				If KeyHit(KEY_V) Then ChaineNom :+ "V"
				If KeyHit(KEY_B) Then ChaineNom :+ "B"
				If KeyHit(KEY_N) Then ChaineNom :+ "N"
		
				If KeyHit(KEY_1) Then ChaineNom :+ "1"
				If KeyHit(KEY_2) Then ChaineNom :+ "2"
				If KeyHit(KEY_3) Then ChaineNom :+ "3"
				If KeyHit(KEY_4) Then ChaineNom :+ "4"
				If KeyHit(KEY_5) Then ChaineNom :+ "5"
				If KeyHit(KEY_6) Then ChaineNom :+ "6"
				If KeyHit(KEY_7) Then ChaineNom :+ "7"
				If KeyHit(KEY_8) Then ChaineNom :+ "8"
				If KeyHit(KEY_9) Then ChaineNom :+ "9"
				If KeyHit(KEY_0) Then ChaineNom :+ "0"

			Else
				If KeyHit(KEY_A) Then ChaineNom :+ "a"
				If KeyHit(KEY_Z) Then ChaineNom :+ "z"
				If KeyHit(KEY_E) Then ChaineNom :+ "e"
				If KeyHit(KEY_R) Then ChaineNom :+ "r"
				If KeyHit(KEY_T) Then ChaineNom :+ "t"
				If KeyHit(KEY_Y) Then ChaineNom :+ "y"
				If KeyHit(KEY_U) Then ChaineNom :+ "u"
				If KeyHit(KEY_I) Then ChaineNom :+ "i"
				If KeyHit(KEY_O) Then ChaineNom :+ "o"
				If KeyHit(KEY_P) Then ChaineNom :+ "p"
				If KeyHit(KEY_Q) Then ChaineNom :+ "q"
				If KeyHit(KEY_S) Then ChaineNom :+ "s"
				If KeyHit(KEY_D) Then ChaineNom :+ "d"
				If KeyHit(KEY_F) Then ChaineNom :+ "f"
				If KeyHit(KEY_G) Then ChaineNom :+ "g"
				If KeyHit(KEY_H) Then ChaineNom :+ "h"
				If KeyHit(KEY_J) Then ChaineNom :+ "j"
				If KeyHit(KEY_K) Then ChaineNom :+ "k"
				If KeyHit(KEY_L) Then ChaineNom :+ "l"
				If KeyHit(KEY_M) Then ChaineNom :+ "m"
				If KeyHit(KEY_W) Then ChaineNom :+ "w"
				If KeyHit(KEY_X) Then ChaineNom :+ "x"
				If KeyHit(KEY_C) Then ChaineNom :+ "c"
				If KeyHit(KEY_V) Then ChaineNom :+ "v"
				If KeyHit(KEY_B) Then ChaineNom :+ "b"
				If KeyHit(KEY_N) Then ChaineNom :+ "n"
		
				If KeyHit(KEY_1) Then ChaineNom :+ "&"
				If KeyHit(KEY_2) Then ChaineNom :+ "�"
				'If KeyHit(KEY_3) Then ChaineNom :+ ""
				If KeyHit(KEY_4) Then ChaineNom :+ "'"
				If KeyHit(KEY_5) Then ChaineNom :+ "("
				If KeyHit(KEY_6) Then ChaineNom :+ "-"
				If KeyHit(KEY_7) Then ChaineNom :+ "�"
				If KeyHit(KEY_8) Then ChaineNom :+ "_"
				If KeyHit(KEY_9) Then ChaineNom :+ "�"
				If KeyHit(KEY_0) Then ChaineNom :+ "�"
			End If
	
			If KeyHit(KEY_SPACE) Then ChaineNom :+ " "
	
			If KeyHit(KEY_NUM0) Then ChaineNom :+ "0"
			If KeyHit(KEY_NUM1) Then ChaineNom :+ "1"
			If KeyHit(KEY_NUM2) Then ChaineNom :+ "2"
			If KeyHit(KEY_NUM3) Then ChaineNom :+ "3"
			If KeyHit(KEY_NUM4) Then ChaineNom :+ "4"
			If KeyHit(KEY_NUM5) Then ChaineNom :+ "5"
			If KeyHit(KEY_NUM6) Then ChaineNom :+ "6"
			If KeyHit(KEY_NUM7) Then ChaineNom :+ "7"
			If KeyHit(KEY_NUM8) Then ChaineNom :+ "8"
			If KeyHit(KEY_NUM9) Then ChaineNom :+ "9"
		End If
	
		If KeyHit(KEY_BACKSPACE) Then ChaineNom = Left(ChaineNom, Len(ChaineNom) - 1)
	
'		DrawText("Please enter your name", GraphicsWidth() / 2 - (TextWidth("Please enter your name") / 2), 260)
		DrawText(ChaineNom, GraphicsWidth() / 2 - (TextWidth(ChaineNom) / 2), 280)
		
		If MilliSecs() Mod 400 <= 200 Then
			DrawImage(ImgCurseurSaisie, GraphicsWidth() / 2 + (TextWidth(ChaineNom) / 2), 280)
		End If
		
		Flip
	Wend
	
	If Len(ChaineNom) > 10 Then ChaineNom = Left(ChaineNom, 10)

End Function


Function CreerParticules(NumLigne:Int)
	
	Local i:Int
	Local PosX:Int
	Local PosY:Int
	Local Couleur:Int
	
	PosY = (550 - Bloc1.TailleBrique) - ((NumLigne - 5) * Bloc1.TailleBrique) - (Bloc1.TailleBrique / 2) + 185
	
	For i = 0 To 9
		PosX = (250 + ((i - 5) * Bloc1.TailleBrique)) + (2 * Bloc1.TailleBrique) + 107
		
		'Print i + 5 + ", " + NumLigne
		'Print Tab_Jeu[i + 5, NumLigne]
		'Print Numligne
		
		Couleur = Rand(7)
		
		Select Couleur
			Case 1
				Emetteur = P2D_CreateEmetteur(SprPartCJaune, 300, PosX, PosY, 80, 60, 0, .5, "light")
			Case 2
				Emetteur = P2D_CreateEmetteur(SprPartCVert, 300, PosX, PosY, 80, 60, 0, .5, "light")
			Case 3
				Emetteur = P2D_CreateEmetteur(SprPartCMauve, 300, PosX, PosY, 80, 60, 0, .5, "light")
			Case 4
				Emetteur = P2D_CreateEmetteur(SprPartCBleu, 300, PosX, PosY, 80, 60, 0, .5, "light")
			Case 5
				Emetteur = P2D_CreateEmetteur(SprPartCOrange, 300, PosX, PosY, 80, 60, 0, .5, "light")
			Case 6
				Emetteur = P2D_CreateEmetteur(SprPartCRouge, 300, PosX, PosY, 80, 60, 0, .5, "light")
			Case 7
				Emetteur = P2D_CreateEmetteur(SprPartCCian, 300, PosX, PosY, 80, 60, 0, .5, "light")
		End Select
			
'		Emetteur = P2D_CreateEmetteur(SprPartCMauve, 300, PosX, PosY, 80, 60, 0, 1, "light")
		P2D_ReglerEchelle(Emetteur, 0.5, 0.5, 0.06, 0.06, 0.04, 0.04)
		P2D_ReglerAlpha(Emetteur, 0.8, 0.2, -0.05, 0.02)
		P2D_ReglerVelocite(Emetteur, 0, -0.5, 0, -1)
		P2D_ReglerVie(Emetteur, 1000, 1000)
	Next
	
End Function


Function DessinerChargement(Nb:Int = 0, Total:Int)
	
	Local Taille:Float
	
	Cls
	
	DrawText "Loading", ((GraphicsWidth() - TextWidth("Loading")) / 2), 270
	
	SetColor(255, 171, 252)
	DrawLine(198, 308, 602, 308)
	DrawLine(198, 332, 602, 332)
	DrawLine(198, 308, 198, 332)
	DrawLine(602, 308, 602, 332)
	
	Taille = 400.0 * (Float(Nb) / Float(Total))
	SetColor(162, 210, 255)
	DrawRect(200, 310, Taille, 20)
	
	SetColor(255, 171, 252)
	DrawText String(Int((Float(Nb) / Float(Total)) * 100) + " %"), ((GraphicsWidth() - TextWidth(String(Int(Float(Nb) / Float(Total)) * 100) + " %")) / 2), 310
	
	SetColor(255, 255, 255)
	
	Flip
	
End Function
