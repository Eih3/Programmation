#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         TT22

 Script Function:BatchProg
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <GuiEdit.au3>
#include <File.au3>
#include <GuiListView.au3>
#include <String.au3>

If Not FileExists(@UserProfileDir&"\BatchProg") Then;Création du dossier "BatchProg" s'il n'existe pas.
	DirCreate(@UserProfileDir&"\BatchProg")
EndIf

SplashImageOn("",@ScriptDir&"\Resources\img\IMG1.BMP",500,300,-1,-1,1)
Sleep(1000)
SplashOff()

$Langue = IniRead(@ScriptDir&"\Resources\Reglages.ini","langue","langue","Français");Lecture de la langue par défaut.
$Old_Title = "BatchProg ; Projet sans titre"
$File = ""

$Gui = GUICreate("BatchProg ; Projet sans titre",1000,500,0,0,BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX));Création de la GUI.

$Fichier = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier","Fichier"));Début de la création des menus.
$Fichier_Nouveau = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier_nouveau","Nouveau"),$Fichier)
$Fichier_Ouvrir = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier_ouvrir","Ouvrir..."),$Fichier)
$Fichier_Enregistrer = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier_enregistrer","Enregistrer"),$Fichier)
$Fichier_EnregistrerSous = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier_enregistrersous","Enregistrer sous..."),$Fichier)
GUICtrlCreateMenuItem("",$Fichier)
$Fichier_Quitter = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier_quitter","Quitter	Échap"),$Fichier)

$Commandes = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes","Commandes"))
$Commandes_ExecuterSilencieusementUneCommande = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_executersilencieusementunecommande","Exécuter silencieusement une commande"),$Commandes)
GUICtrlCreateMenuItem("",$Commandes)
$Commandes_Affichage = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_affichage","Affichage"),$Commandes)
$Commandes_Affichage_EffacerLEcran = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_affichage_effacerlecran","Effacer l'écran"),$Commandes_Affichage)
$Commandes_Affichage_AfficherDuTexte = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_affichage_afficherdutexte","Afficher du texte"),$Commandes_Affichage)
$Commandes_Affichage_AfficherUneLigneVide = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_affichage_afficherunelignevide","Afficher une ligne vide"),$Commandes_Affichage)
$Commandes_Affichage_EchoLocalDesactive = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_affichage_echolocaldesactive","Echo local désactivé"),$Commandes_Affichage)
$Commandes_Affichage_EchoLocalActive = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_affichage_echolocalactive","Echo local activé"),$Commandes_Affichage)
$Commandes_Label = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_label","Label"),$Commandes)
$Commandes_Label_AllerAUnLabel = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_label_alleraunlabel","Aller à un label"),$Commandes_Label)
$Commandes_Label_InsererUnLabel = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_label_insererunlabel","Insérer un label"),$Commandes_Label)
$Commandes_Variables = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_variables","Variables"),$Commandes)
$Commandes_Variables_AffecterUneValeurAUneVariable = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_variables_affecterunevaleuraunevariable","Affecter une valeur à une variable"),$Commandes_Variables)
$Commandes_Variables_AffecterUneVariableAUneVariable = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_variables_affecterunevariableaunevariable","Affecter une variable à une variable"),$Commandes_Variables)
$Commandes_Variables_EffacerUneVariable = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_variables_effacerunevariable","Effacer une variable"),$Commandes_Variables)
$Commandes_Variables_DecalerLesVariableDEnvironnement = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_variables_decalerlesvariablesdenvironnement","Décaler les variables d'environnement"),$Commandes_Variables)
$Commandes_Variables_AfficherLesVariablesDEnvironnement = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_variables_afficherlesvariablesdenvironnement","Afficher les variables d'environnement"),$Commandes_Variables)
$Commandes_OperationSurLesFichiers = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers","Opérations sur les fichiers"),$Commandes)
$Commandes_OperationSurLesFichiers_Dossiers = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_dossiers","Dossiers"),$Commandes_OperationSurLesFichiers)
$Commandes_OperationSurLesFichiers_Dossiers_CreerUnDossier = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_dossiers_creerundossier","Créer un dossier"),$Commandes_OperationSurLesFichiers_Dossiers)
$Commandes_OperationSurLesFichiers_Dossiers_SupprimerUnDossier = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_dossiers_supprimerundossier","Supprimer un dossier"),$Commandes_OperationSurLesFichiers_Dossiers)
$Commandes_OperationSurLesFichiers_Dossiers_RenommerUnDossier = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_dossiers_renommerundossier","Renommer un dossier"),$Commandes_OperationSurLesFichiers_Dossiers)
$Commandes_OperationSurLesFichiers_Dossiers_DeplacerUnDossier = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_dossiers_deplacerundossier","Déplacer un dossier"),$Commandes_OperationSurLesFichiers_Dossiers)
$Commandes_OperationSurLesFichiers_Fichiers = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_fichiers","Fichiers"),$Commandes_OperationSurLesFichiers)
$Commandes_OperationSurLesFichiers_Fichiers_SupprimerUnFichier = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_fichiers_supprimerunfichier","Supprimer un fichier"),$Commandes_OperationSurLesFichiers_Fichiers)
$Commandes_OperationSurLesFichiers_Fichiers_RenommerUnFichier = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_fichiers_renommerunfichier","Renommer un fichier"),$Commandes_OperationSurLesFichiers_Fichiers)
$Commandes_OperationSurLesFichiers_Fichiers_DeplacerUnFichier = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_fichiers_deplacerunfichier","Déplacer un fichier"),$Commandes_OperationSurLesFichiers_Fichiers)
$Commandes_OperationSurLesFichiers_Fichiers_AfficherLeContenuDUnFichierTexte = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_fichiers_afficherlecontenudunfichiertexte","Afficher le contenu d'un fichier texte"),$Commandes_OperationSurLesFichiers_Fichiers)
$Commandes_OperationSurLesFichiers_Fichiers_ImprimerUnFichierTexte = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_fichiers_imprimerunfichiertexte","Imprimer un fichier texte"),$Commandes_OperationSurLesFichiers_Fichiers)
$Commandes_OperationSurLesFichiers_Fichiers_CopierUnFichier = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_fichiers_copierunfichier","Copier un fichier"),$Commandes_OperationSurLesFichiers_Fichiers)
$Commandes_OperationSurLesFichiers_Fichiers_ToutSupprimer = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_fichiers_toutsupprimer","Tout supprimer"),$Commandes_OperationSurLesFichiers_Fichiers)
$Commandes_OperationSurLesFichiers_Fichiers_AfficherUnTypeDeFichier = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_fichiers_afficheruntypedefichier","Afficher un type de fichier"),$Commandes_OperationSurLesFichiers_Fichiers)
$Commandes_OperationSurLesFichiers_Fichiers_ReconstituerUnFichier = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_fichiers_reconstituerunfichier","Reconstituer un fichier"),$Commandes_OperationSurLesFichiers_Fichiers)
$Commandes_OperationSurLesFichiers_Ecriture = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_ecriture","Ecriture"),$Commandes_OperationSurLesFichiers)
$Commandes_OperationSurLesFichiers_Ecriture_EcrireDansUnFichierAjout = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_ecriture_ecriredansunfichierajout","Ecrire dans un fichier (ajout)"),$Commandes_OperationSurLesFichiers_Ecriture)
$Commandes_OperationSurLesFichiers_Ecriture_EcrireDansUnFichierEnEffacantLAncienContenu = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_ecriture_ecriredansunfichiereneffacantlanciencontenu","Ecrire dans un fichier (en effaçant l'ancien contenu)"),$Commandes_OperationSurLesFichiers_Ecriture)
$Commandes_OperationSurLesFichiers_Ecriture_EcrireLeResultatDUneCommandeDansUnFichierAjout = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_ecriture_ecrireleresultatdunecommandedansunfichierajout","Ecrire le résultat d'une commande dans un fichier (ajout)"),$Commandes_OperationSurLesFichiers_Ecriture)
$Commandes_OperationSurLesFichiers_Ecriture_EcrireLeResultatDUneCommandeDansUnFichierEnEffacantLAncienContenu = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_ecriture_ecrireleresultatdunecommandedansunfichiereneffacantlanciencontenu","Ecrire le résultat d'une commande dans un fichier (en effaçant l'ancien contenu)"),$Commandes_OperationSurLesFichiers_Ecriture)
$Commandes_OperationSurLesFichiers_LancerUnFichier = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_lancerunfichier","Lancer un fichier"),$Commandes_OperationSurLesFichiers)
$Commandes_OperationSurLesFichiers_LancerUnFichier_FichierBatchCommeSousProgramme = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_lancerunfichier_fichierbatchcommesousprogramme","Fichier batch comme sous-programme"),$Commandes_OperationSurLesFichiers_LancerUnFichier)
$Commandes_OperationSurLesFichiers_LancerUnFichier_FichierBatchPasserLaMain = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_lancerunfichier_fichierbatchpasserlamain","Fichier batch (passer la main)"),$Commandes_OperationSurLesFichiers_LancerUnFichier)
$Commandes_OperationSurLesFichiers_LancerUnFichier_InterpreteurMSDOS = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_lancerunfichier_interpreteurmsdos","Interpreteur MS-DOS"),$Commandes_OperationSurLesFichiers_LancerUnFichier)
$Commandes_OperationSurLesFichiers_LancerUnFichier_AutresFichiers = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_lancerunfichier_autresfichiers","Autres fichiers"),$Commandes_OperationSurLesFichiers_LancerUnFichier)
GUICtrlCreateMenuItem("",$Commandes_OperationSurLesFichiers)
$Commandes_OperationSurLesFichiers_RepertoireRacine = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_repertoireracine","Répertoire racine"),$Commandes_OperationSurLesFichiers)
$Commandes_OperationSurLesFichiers_ChangerLeRepertoireCourant = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_changerlerepertoirecourant","Changer le répertoire courant"),$Commandes_OperationSurLesFichiers)
$Commandes_OperationSurLesFichiers_ToutSupprimerSilencieusement1 = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_tousupprimersilencieusement1","Tout supprimer silencieusement (1)"),$Commandes_OperationSurLesFichiers)
$Commandes_OperationSurLesFichiers_ToutSupprimerSilencieusement2 = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_tousupprimersilencieusement2","Tout supprimer silencieusement (2)"),$Commandes_OperationSurLesFichiers)
$Commandes_OperationSurLesFichiers_Formater = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_formater","Formater"),$Commandes_OperationSurLesFichiers)
$Commandes_OperationSurLesFichiers_TestSiUnLecteurExiste = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_operationsurlesfichiers_testersiunlecteurexiste","Tester si un lecteur existe"),$Commandes_OperationSurLesFichiers)
$Commandes_AttributsDesFichiers = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_attributsdesfichiers","Attributs des fichiers"),$Commandes)
$Commandes_AttributsDesFichiers_InterdireLesModifications = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_attributsdesfichiers_interdirelesmodifications","Interdire les modifications"),$Commandes_AttributsDesFichiers)
$Commandes_AttributsDesFichiers_PermettreLesModifications = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_attributsdesfichiers_permettrelesmodifications","Permettre les modifications"),$Commandes_AttributsDesFichiers)
$Commandes_AttributsDesFichiers_Invisible = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_attributsdesfichiers_invisible","Invisible"),$Commandes_AttributsDesFichiers)
$Commandes_AttributsDesFichiers_Visible = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_attributsdesfichiers_visible","Visible"),$Commandes_AttributsDesFichiers)
$Commandes_AttributsDesFichiers_DefinirCommeArchive = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_attributsdesfichiers_definircommearchive","Définir comme archive"),$Commandes_AttributsDesFichiers)
$Commandes_AttributsDesFichiers_NEstPasUneArchive = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_attributsdesfichiers_nestpasunearchive","N'est pas une archive"),$Commandes_AttributsDesFichiers)
$Commandes_Conditions = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_conditions","Conditions"),$Commandes)
$Commandes_Conditions_SiConditionAlorsIf = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_conditions_siconditionalorsif","Si [condition] alors... (IF)"),$Commandes_Conditions)
$Commandes_Conditions_SiCondistionNEstPasAlorsIfNot = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_conditions_siconditionnestpasalorsifnot","Si [condition] n'est pas alors... (IF NOT)"),$Commandes_Conditions)
$Commandes_Conditions_SiQqchoseExisteAlors = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_conditions_siqqchoseexistealors","Si [qqchose] existe alors..."),$Commandes_Conditions)
$Commandes_Conditions_SiQqchoseNExistePasAlors = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_conditions_siqqchosenexistepasalors","Si [qqchose] n'existe pas alors..."),$Commandes_Conditions)
$Commandes_Conditions_SiErrorlevelQqchoseAlors = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_conditions_sierrorlevelqqchosealors","Si ERRORLEVEL = [qqchose] alors..."),$Commandes_Conditions)
$Commandes_Conditions_SiConditionAlorsIfWinNt = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_conditions_siconditionalorsifwinnt","Si [condition] alors... (IF) - (Win NT)"),$Commandes_Conditions)
$Commandes_Conditions_SiVariableDEnvironnementExisteAlorsWinNt = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_conditions_sivariabledenvironnementexistealorswinnt","Si [variable d'environnement existe] alors... (Win NT)"),$Commandes_Conditions)
$Commandes_Reseau = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_reseau","Réseau"),$Commandes)
$Commandes_Reseau_VoirLesRessourcesDuReseau = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_reseau_voirlesressourcesdureseau","Voir les ressources du réseau"),$Commandes_Reseau)
$Commandes_Reseau_VoirLesRessourcesPartageesDUnPoste = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_reseau_voirlesressourcespartageesdunposte","Voir les ressources partagées d'un poste"),$Commandes_Reseau)
$Commandes_Reseau_MonterUnDisqueResauCommeUnDisqueLocal = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_reseau_monterundisquereseaucommeundisquelocal","Monter un disque réseau comme disque local"),$Commandes_Reseau)
$Commandes_Reseau_DeconnecterUnDisqueResau = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_reseau_deconnecterundisqueresau","Déconnecter un disque réseau"),$Commandes_Reseau)
GUICtrlCreateMenuItem("",$Commandes_Reseau)
$Commandes_Reseau_PingSurUnDomaine = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_reseau_pingsurundomaine","Ping sur un domaine"),$Commandes_Reseau)
$Commandes_Reseau_OuvirUnePageWebAvecIe = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_reseau_ouvrirunepagewebavecie","Ouvrir une page web avec IE"),$Commandes_Reseau)
$Commandes_Reseau_OuvrirFtp = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_reseau_ouvrirftp","Ouvrir FTP"),$Commandes_Reseau)

$Commandes_FonctionsSpeciales = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_fonctionsspeciales","Fonctions spéciales"),$Commandes)
$Commandes_FonctionsSpeciales_InsererUneRemarque = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_fonctionsspeciales_insereruneremarque","Insérer une remarque"),$Commandes_FonctionsSpeciales)
GUICtrlCreateMenuItem("",$Commandes_FonctionsSpeciales)
$Commandes_FonctionsSpeciales_Pause = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_fonctionsspeciales_pause","Pause"),$Commandes_FonctionsSpeciales)
$Commandes_FonctionsSpeciales_ActiverBreak = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_fonctionsspeciales_activerbreak","Activer break"),$Commandes_FonctionsSpeciales)
$Commandes_FonctionsSpeciales_EteindreLOrdinateur = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_fonctionsspeciales_eteindrelordinateur","Eteindre l'ordinateur"),$Commandes_FonctionsSpeciales)
$Commandes_FonctionsSpeciales_ModifierPath = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_fonctionsspeciales_modifierpath","Modifier path"),$Commandes_FonctionsSpeciales)
$Commandes_FonctionsSpeciales_InsereLeRepertoireDeWindows = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_fonctionsspeciales_insererlerepertoiredewindows","Insérer le répertoire de Windows"),$Commandes_FonctionsSpeciales)
$Commandes_FonctionsSpeciales_ConfigurerLaCouleurDeLaFenetreWinNt = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_fonctionsspeciales_configurerlacouleurdelafenetrewinnt","Configurer la couleur de la fenêtre (Win NT)"),$Commandes_FonctionsSpeciales)
$Commandes_FonctionsSpeciales_ConfigurerLeTitreDeLaFenetreWinNt = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_fonctionsspeciales_configurerletitredelafenetrewinnt","Configurer le titre de le fenêtre (Win NT)"),$Commandes_FonctionsSpeciales)
$Commandes_FonctionsSpeciales_AllerALaFinDuFichierWinNt = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_fonctionsspeciales_alleralafindufichierwinnt","Aller à la fin du fichier (Win NT)"),$Commandes_FonctionsSpeciales)
GUICtrlCreateMenuItem("",$Commandes_FonctionsSpeciales)
$Commandes_FonctionsSpeciales_VersionDeDos = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes_fonctionsspeciales_versiondedos","Version de DOS"),$Commandes_FonctionsSpeciales)

$Lancer = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","lancer","Lancer"))
$Lancer_LancerNormalement = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","lancer_lancernormalement","Lancer normalement"),$Lancer)
$Lancer_LancerDans = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","lancer_lancerdans","Lancer dans..."),$Lancer)
$Lancer_LancerLesLignes = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","lancer_lancerleslignes","Lancer les lignes..."),$Lancer)

$Compiler = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","compiler","Compiler"))
$Compiler_CompilerLeFichierOuvert = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","compiler_compilerlefichierouvert","Compiler le fichier ouvert"),$Compiler)
$Compiler_CompilerUnFichier = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","compiler_compilerunfichier","Compiler un fichier"),$Compiler)

$Options = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","options","Options"))
$Options_Langue = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","options_langue","Langues"),$Options)
$Options_Langue_Francais = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","options_langue_francais","Français"),$Options_Langue)
$Options_Langue_Anglais = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","options_langue_anglais","Anglais"),$Options_Langue)
GUICtrlCreateMenuItem("",$Options)
$Options_Aide = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","options_aide","Aide"),$Options)
$Options_APropos = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","options_apropos","À propos de BatchProg"),$Options);Fin de la création des menus.

$Edit = GUICtrlCreateEdit("",40,0,960,480); Création de l'editeur de ligne.
GUICtrlSetFont($Edit,10,15,-1,"Lucida Console");

$NumLine = ""; Numérote les lignes.
For $i = 1 To 70 Step 1
	$NumLine &= $i & @CRLF
Next
$Label = GUICtrlCreateLabel($NumLine,0,2,40,465); Crétaion du Label d'affichage du n° de ligne.
GUICtrlSetFont($Label,10,15,-1,"Lucida Console")
$Old_Ind = 1

GUISetState(@SW_SHOW); Affichage de la GUI,
WinSetState($GUI,"",@SW_MAXIMIZE);          en plein écran.

While 1
	$ind_1 = _GUICtrlEdit_GetFirstVisibleLine($Edit)+1;Lit le n° de la première ligne visible dans l'editeur de texte.
	If $ind_1 <> $Old_Ind Then; Vérifi et change le n° de ligne affiché si un scroll est effectué.
		$NumLine = ""
		For $i = $ind_1 To $ind_1+70 Step 1
			If $i = 666 Then
				$NumLine &= "" & @CRLF
			Else
				$NumLine &= $i & @CRLF
			EndIf
		Next
		GUICtrlSetData($Label,$NumLine)
		$Old_Ind = $ind_1
	EndIf
	$Msg = GUIGetMsg()
	Switch $Msg
	Case $GUI_EVENT_CLOSE; Quitte si la fenêtre est fermée.
		_Exit()
		
	Case $Fichier_Nouveau; Menu du nouveau fichier.
		If FileRead($File) <> GUICtrlRead($Edit) Then
			$Choice = MsgBox(3,"BatchProg",IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","sauvegarde_l1","Attention, le fichier ouvert n'as pas été sauvegardé !")&@CRLF&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","sauvegarde_l2","Voulez-vous le sauvegarder maintenant ?"))
			If $Choice = 6 Then
				_Save($File)
				$File = ""
				GUICtrlSetData($Edit,"")
				WinSetTitle($Old_Title,"","BatchProg ; Projet sans titre")
				$Old_Title = "BatchProg ; Projet sans titre"
			ElseIf $Choice = 7 Then
				$File = ""
				GUICtrlSetData($Edit,"")
				WinSetTitle($Old_Title,"","BatchProg ; Projet sans titre")
				$Old_Title = "BatchProg ; Projet sans titre"
			EndIf
		ElseIf FileRead($File) = GUICtrlRead($Edit) Then
			$File = ""
			GUICtrlSetData($Edit,"")
			WinSetTitle($Old_Title,"","BatchProg ; Projet sans titre")
			$Old_Title = "BatchProg ; Projet sans titre"
		EndIf
		
	Case $Fichier_Ouvrir; Menu d'ouverture d'un fichier.
		If FileRead($File) <> GUICtrlRead($Edit) Then
			$Choice = MsgBox(3,"BatchProg",IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","sauvegarde_l1","Attention, le fichier ouvert n'as pas été sauvegardé !")&@CRLF&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","sauvegarde_l2","Voulez-vous le sauvegarder maintenant ?"))
			If $Choice = 6 Then
				_Save($File)
				$Path = FileOpenDialog(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","ouvrir","Choisissez un fichier à ouvrir :"),@UserProfileDir&"\BatchProg",IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","extensions","Fichiers batch (*.bat)|Tous les fichiers (*.*)"))
				If Not @error = 1 Then
					$String = StringSplit($Path,"\")
					$FileName = $String[UBound($String)-1]
					$File = $Path
					GUICtrlSetData($Edit,FileRead($File))
					WinSetTitle($Old_Title,"","BatchProg ; "&$FileName)
					$Old_Title = "BatchProg ; "&$FileName
				EndIf
			ElseIf $Choice = 7 Then
				$Path = FileOpenDialog(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","ouvrir","Choisissez un fichier à ouvrir :"),@UserProfileDir&"\BatchProg",IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","extensions","Fichiers batch (*.bat)|Tous les fichiers (*.*)"))
				If Not @error = 1 Then
					$String = StringSplit($Path,"\")
					$FileName = $String[UBound($String)-1]
					$File = $Path
					GUICtrlSetData($Edit,FileRead($File))
					WinSetTitle($Old_Title,"","BatchProg ; "&$FileName)
					$Old_Title = "BatchProg ; "&$FileName
				EndIf
			EndIf
		ElseIf FileRead($File) = GUICtrlRead($Edit) Then
			$Path = FileOpenDialog(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","ouvrir","Choisissez un fichier à ouvrir :"),@UserProfileDir&"\BatchProg",IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","extensions","Fichiers batch (*.bat)|Tous les fichiers (*.*)"))
			If Not @error = 1 Then
				$String = StringSplit($Path,"\")
				$FileName = $String[UBound($String)-1]
				$File = $Path
				GUICtrlSetData($Edit,FileRead($File))
				WinSetTitle($Old_Title,"","BatchProg ; "&$FileName)
				$Old_Title = "BatchProg ; "&$FileName
			EndIf
		EndIf
		
	Case $Fichier_Enregistrer; Menu d'enregistrement.
		_Save($File)
		
	Case $Fichier_EnregistrerSous; Menu "Enregistrer Sous".
		$OldFile = $File
		$File = ""
		$Save = _Save($File)
		If $Save = 0 Then
			$File = $File
		EndIf
		
	Case $Fichier_Quitter; Menu quitter
		_Exit()
		
	Case $Commandes_ExecuterSilencieusementUneCommande; Début du menu des commandes.
		Send("[commande]>nul")
		
	Case $Commandes_Affichage_EffacerLEcran
		Send("cls")
		
	Case $Commandes_Affichage_AfficherDuTexte
		Send("echo ")
		
	Case $Commandes_Affichage_AfficherUneLigneVide
		Send("echo."&@CR)
		
	Case $Commandes_Affichage_EchoLocalDesactive
		Send("@echo off"&@CR)
		
	Case $Commandes_Affichage_EchoLocalActive
		Send("@echo on"&@CR)
		
	Case $Commandes_Label_AllerAUnLabel
		Send("goto ")
		
	Case $Commandes_Label_InsererUnLabel
		Send(":")
		
	Case $Commandes_Variables_AffecterUneValeurAUneVariable
		Send("set Variable=[VALEUR]")
		
	Case $Commandes_Variables_AffecterUneVariableAUneVariable
		Send("set Variable1=%Variable2%")
		
	Case $Commandes_Variables_EffacerUneVariable
		Send("set Variable=")
		
	Case $Commandes_Variables_DecalerLesVariableDEnvironnement
		Send("shift"&@CR)
		
	Case $Commandes_Variables_AfficherLesVariablesDEnvironnement
		Send("set"&@CR)
		
	Case $Commandes_OperationSurLesFichiers_Dossiers_CreerUnDossier
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","md","md [NOM_DU_REPERTOIRE]"))
		
	Case $Commandes_OperationSurLesFichiers_Dossiers_SupprimerUnDossier
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","rd","rd [NOM_DU_REPERTOIRE]"))
		
	Case $Commandes_OperationSurLesFichiers_Dossiers_RenommerUnDossier
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","ren","ren [ANCIEN_NOM] [NOUVEAU_NOM]"))
		
	Case $Commandes_OperationSurLesFichiers_Dossiers_DeplacerUnDossier
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","move","move [ANCIEN_EMPLACEMENT] [NOUVEL_EMPLACEMENT]"))
		
	Case $Commandes_OperationSurLesFichiers_Fichiers_SupprimerUnFichier
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","del","del [NOM_DU_FICHIER]"))
		
	Case $Commandes_OperationSurLesFichiers_Fichiers_RenommerUnFichier
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","ren","ren [ANCIEN_NOM] [NOUVEAU_NOM]"))
		
	Case $Commandes_OperationSurLesFichiers_Fichiers_DeplacerUnFichier
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","move","move [ANCIEN_EMPLACEMENT] [NOUVEL_EMPLACEMENT]"))
		
	Case $Commandes_OperationSurLesFichiers_Fichiers_AfficherLeContenuDUnFichierTexte
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","type","type [FICHIER]"))
		
	Case $Commandes_OperationSurLesFichiers_Fichiers_ImprimerUnFichierTexte
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","type2","type [FICHIER]>lpt1 REM lpt1 est le port parallele n°1"))
		
	Case $Commandes_OperationSurLesFichiers_Fichiers_CopierUnFichier
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","copy","copy [EMPLACEMENT_DU_FICHIER_SOURCE] [EMPLACEMENT_DU_FICHIER_COPIE]"))
		
	Case $Commandes_OperationSurLesFichiers_Fichiers_ToutSupprimer
		Send("del *.*"&@CR)
		
	Case $Commandes_OperationSurLesFichiers_Fichiers_AfficherUnTypeDeFichier
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","dirfiltre","dir *.* REM Remplacez *.* par votre filtre")&@CR)
		
	Case $Commandes_OperationSurLesFichiers_Fichiers_ReconstituerUnFichier
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","copy2","copy /b fichier1.txt + fichier2.txt nouveau.txt>nul")&@CR)
		
	Case $Commandes_OperationSurLesFichiers_Ecriture_EcrireDansUnFichierAjout
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","echo","echo [Données]>>[FICHIER]"))
		
	Case $Commandes_OperationSurLesFichiers_Ecriture_EcrireDansUnFichierEnEffacantLAncienContenu
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","echo2","echo [Données]>[FICHIER]"))
		
	Case $Commandes_OperationSurLesFichiers_Ecriture_EcrireLeResultatDUneCommandeDansUnFichierAjout
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","commande","COMMANDE>>[FICHIER]"))
		
	Case $Commandes_OperationSurLesFichiers_Ecriture_EcrireLeResultatDUneCommandeDansUnFichierEnEffacantLAncienContenu
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","commande2","COMMANDE>[FICHIER]"))
		
	Case $Commandes_OperationSurLesFichiers_LancerUnFichier_FichierBatchCommeSousProgramme
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","call","call [FICHIER]"))
		
	Case $Commandes_OperationSurLesFichiers_LancerUnFichier_FichierBatchPasserLaMain
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","fichier","[FICHIER]"))
		
	Case $Commandes_OperationSurLesFichiers_LancerUnFichier_InterpreteurMSDOS
		Send("%comspec%"&@CR)
		
	Case $Commandes_OperationSurLesFichiers_LancerUnFichier_AutresFichiers
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","start","start [FICHIER]"))
		
	Case $Commandes_OperationSurLesFichiers_RepertoireRacine
		Send("cd\")
		
	Case $Commandes_OperationSurLesFichiers_ChangerLeRepertoireCourant
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","cd","cd [CHEMIN]"))
		
	Case $Commandes_OperationSurLesFichiers_ToutSupprimerSilencieusement1
		Send("del *.???"&@CR&"del *.??"&@CR&"del *.?"&@CR)
		
	Case $Commandes_OperationSurLesFichiers_ToutSupprimerSilencieusement2
		Send("echo o | erase *.* >nul"&@CR)
		
	Case $Commandes_OperationSurLesFichiers_Formater
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","format","format [LECTEUR]"))
		
	Case $Commandes_OperationSurLesFichiers_TestSiUnLecteurExiste
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","exlecteur","if exist [LECTEUR]:\NUL echo Le lecteur existe."))
		
	Case $Commandes_AttributsDesFichiers_InterdireLesModifications
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","attrib","Attrib +r [FICHIER]"))
		
	Case $Commandes_AttributsDesFichiers_PermettreLesModifications
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","attrib2","Attrib -r [FICHIER]"))
		
	Case $Commandes_AttributsDesFichiers_Invisible
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","attrib3","Attrib +h [FICHIER]"))
		
	Case $Commandes_AttributsDesFichiers_Visible
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","attrib4","Attrib -h [FICHIER]"))
		
	Case $Commandes_AttributsDesFichiers_DefinirCommeArchive
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","attrib5","Attrib +a [FICHIER]"))
		
	Case $Commandes_AttributsDesFichiers_NEstPasUneArchive
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","attrib6","Attrib -a [FICHIER]"))
		
	Case $Commandes_Conditions_SiConditionAlorsIf
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","cond1",'if "%VARIABLE%"=="VALEUR" [COMMANDE]'))
		
	Case $Commandes_Conditions_SiCondistionNEstPasAlorsIfNot
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","cond2",'if not "%VARIABLE"%=="VALEUR" [COMMANDE]'))
		
	Case $Commandes_Conditions_SiQqchoseExisteAlors
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","cond3",'if exist "FICHIER" [COMMANDE]'))
		
	Case $Commandes_Conditions_SiQqchoseNExistePasAlors
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","cond4",'if not exist "FICHIER" [COMMANDE]'))
		
	Case $Commandes_Conditions_SiErrorlevelQqchoseAlors
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","cond5","if errorlevel 255 Goto LABEL REM Remplacez 255 par la bonne valeur.")&@CR)
		
	Case $Commandes_Conditions_SiConditionAlorsIfWinNt
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","cond6_1",'if "%Variable%"=="Valeur" (')&@CR&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","cond6_2","	REM - Entrez ici le code si la condition est vraie")&@CR&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","cond6_3","	REM - Vous pouvez entrer du code sur plusieures lignes")&@CR&") else ("&@CR&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","cond6_4","	REM - Entrez ici le code si la condition est fausse")&@CR&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","cond6_5","	REM - Vous pouvez entrer du code sur plusieures lignes")&@CR&")")
		
	Case $Commandes_Conditions_SiVariableDEnvironnementExisteAlorsWinNt
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","cond7","if defined Variable_environnement [Commande]"))
		
	Case $Commandes_Reseau_VoirLesRessourcesDuReseau
		Send("net view"&@CR)
		
	Case $Commandes_Reseau_VoirLesRessourcesPartageesDUnPoste
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","netview","net view [\\POSTE] REM Exemple : net view \\S220_M"))
		
	Case $Commandes_Reseau_MonterUnDisqueResauCommeUnDisqueLocal
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","netuse_1","net use [Disque:] [\\POSTE\DOMAINE]")&@CR&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","netuse_2","REM [Disque:] représente une lettre de A à Z suivie de ':' correspondant au disque local à associer à la ressource réseau.")&@CR&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","netuse_3","REM [Disque:] peut-être remplacé par '*' pour désigner le prochain identificateur de disque disponible sur votre poste.")&@CR&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","netuse_4","REM Exemple : net use * \\P220_M\c$"))
		
	Case $Commandes_Reseau_DeconnecterUnDisqueResau
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","deletenet_1","net use [disque:] /DELETE")&@CR&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","deletenet_2","REM Exemple : net use f: /DELETE"))
			
	Case $Commandes_Reseau_PingSurUnDomaine
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","ping","ping [domaine]"))
			
	Case $Commandes_Reseau_OuvirUnePageWebAvecIe
		Send('start explorer "[URL]"'&@CR&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","stratexplorer",'REM P. ex. start explorer "http://www.lecoindaide.com/"'))
			
	Case $Commandes_Reseau_OuvrirFtp
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","ftp_1","ftp -n [Adresse FTP]")&@CR&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","ftp_2",'REM P. ex. "ftp -n ftp.monftp.com"'))
			
	Case $Commandes_FonctionsSpeciales_InsererUneRemarque
		Send("REM ")
			
	Case $Commandes_FonctionsSpeciales_Pause
		Send("pause"&@CR)
			
	Case $Commandes_FonctionsSpeciales_ActiverBreak
		Send("break on"&@CR)
			
	Case $Commandes_FonctionsSpeciales_EteindreLOrdinateur
		MsgBox(48,"BatchProg","Attention, ce programme fermera Windows sans préavis !")
		Send("%windir%\RUNDLL32.EXE User.exe,ExitWindows"&@CR)
			
	Case $Commandes_FonctionsSpeciales_ModifierPath
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","path","%PATH%=%PATH%;[CHEMIN_A_AJOUTER]"))
			
	Case $Commandes_FonctionsSpeciales_InsereLeRepertoireDeWindows
		Send("%windir%")
			
	Case $Commandes_FonctionsSpeciales_ConfigurerLaCouleurDeLaFenetreWinNt
		Send("color 9f"&@CR&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","color_1","REM - Le premier chiffre correspond à la couleur de fond, et le second à celui de premier plan :")&@CR&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","color_2","REM 8 = Gris, 9 = Bleu, A = Vert, B = Cyan, C = Rouge, D = Rose, E = Jaune, F = Blanc ")&@CR&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","color_3","REM 0 = Noir, 1 = Bleu foncé, 2 = Vert, 3 = Bleu-gris, 4 = Marron, 5 = Pourpre, 6 = Kaki, 7 = Gris clair"))
			
	Case $Commandes_FonctionsSpeciales_ConfigurerLeTitreDeLaFenetreWinNt
		Send(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"commandes","title","title [entrez ici le nom de la session]")&@CR)
			
	Case $Commandes_FonctionsSpeciales_AllerALaFinDuFichierWinNt
		Send("goto :EOF"&@CR)
			
	Case $Commandes_FonctionsSpeciales_VersionDeDos
		Send("ver"&@CR); Fin du menu des commandes.
		
	Case $Lancer_LancerNormalement; Menu Lancer.
		$Save = _Save($File)
		If $Save = 1 Then
			ShellExecute($File)
		EndIf
		
	Case $Lancer_LancerDans; Menu "Lancer dans".
		$Dir = FileSelectFolder(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"lancer","lancerdans","Choisissez le dossier où vous souhaitez lancer le fichier :"),"C:\")
		If Not @error = 1 Then
			$Save = _Save($File)
			If $Save = 1 Then
				ShellExecute($File,-1,$Dir)
			EndIf
		EndIf
		
	Case $Lancer_LancerLesLignes; Menu "Lancer les lignes".
		$Save = _Save($File)
		If $Save = 1 Then
			If _FileCountLines($File) > 1 Then
				$Gui2 = GUICreate(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"lancer","guinom","Lignes"),500,500)
				$ListView = GUICtrlCreateListView("",0, 0, 500, 400)
				_GUICtrlListView_SetExtendedListViewStyle($ListView, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES))
				_GUICtrlListView_AddColumn($ListView, IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"lancer","ligne","Ligne"), 500)
				$ButtonLunch = GUICtrlCreateButton(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"lancer","lancer","Lancer"),20,420,460,60)
				SplashTextOn("BatchProg",IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"lancer","chargligne_1","Chargement des lignes...")&@CRLF&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"lancer","chargligne_2","Si votre fichier est long, cette opération peut prendre quelques secondes !"),600,70)
				Local $ListViewItem[_FileCountLines($File)]
				For $i = 1 To _FileCountLines($File) Step 1
					$ListViewItem[$i-1] = _GUICtrlListView_AddItem($ListView,FileReadLine($File,$i),0)
				Next
				SplashOff()
				GUISetState()
				While 1
					$nMsg = GUIGetMsg()
					Switch $nMsg
					Case $GUI_EVENT_CLOSE
						$Ok = False
						GUIDelete($Gui2)
						ExitLoop
					Case $ButtonLunch
						$Ok = True
						ExitLoop
					EndSwitch
				WEnd
				If $Ok = True Then
					SplashTextOn("BatchProg",IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"lancer","prepafichier","Préparation du fichier...")&@CRLF&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"lancer","chargligne_2","Si votre fichier est long, cette opération peut prendre quelques secondes !"),600,70)
					$ListViewReturn = ""
					For $i = 1 To (_FileCountLines($File)) Step 1
						If _GUICtrlListView_GetItemChecked(GUICtrlGetHandle($ListView),$i-1) Then
							$ListViewReturn = $ListViewReturn&FileReadLine($File,$i)&@CRLF
						EndIf
					Next
					SplashOff()
					GUIDelete($Gui2)
					FileDelete(@TempDir&"\templaunchlines.bat")
					FileWrite(@TempDir&"\templaunchlines.bat",$ListViewReturn)
					ShellExecute(@TempDir&"\templaunchlines.bat")
				EndIf
			Else
				MsgBox(64,"BatchProg ; Info","A quoi ça sert de faire ça si tu n'as qu'une ligne ?")
			EndIf
		EndIf
		
	Case $Compiler_CompilerLeFichierOuvert
		$Save = _Save($File)
		If $Save = 1 Then
			$FileS = StringReplace($File," ","*")
			Run(@ScriptDir&"\Resources\Bat2Exe\Bat2Exe.exe "&$FileS)
		EndIf
		
	Case $Compiler_CompilerUnFichier
		Run(@ScriptDir&"\Resources\Bat2Exe\Bat2Exe.exe")
		
	Case $Options_Langue_Francais; Menu de langue : Français.
		If $Langue = "Français" Then
			MsgBox(64,"BatchProg","Vous êtes déjà en Français !")
		ElseIf $Langue = "English" Then
			IniWrite(@ScriptDir&"\Resources\Reglages.ini","langue","langue","Français")
			IniWrite(@ScriptDir&"\Resources\Bat2Exe\Reglages.ini","langue","langue","Français")
			IniWrite(@ScriptDir&"\Resources\Exe2Bat\Reglages.ini","langue","langue","Français")
			MsgBox(64,"BatchProg","Vos modifications ont été enregistrées !"&@CRLF&"Elle prendront effet au prochain démarrage du logiciel.")
		EndIf
		
	Case $Options_Langue_Anglais; Menu de langue : English.
		If $Langue = "English" Then
			MsgBox(64,"BatchProg","You are already in English !")
		ElseIf $Langue = "Français" Then
			IniWrite(@ScriptDir&"\Resources\Reglages.ini","langue","langue","English")
			IniWrite(@ScriptDir&"\Resources\Bat2Exe\Reglages.ini","langue","langue","English")
			IniWrite(@ScriptDir&"\Resources\Exe2Bat\Reglages.ini","langue","langue","English")
			MsgBox(64,"BatchProg","Your changes have been saved !"&@CRLF&"It will take effect at next startup of the software.")
		EndIf
		
	Case $Options_Aide; Affichage de l'aide.
		$Gui3 = GUICreate("BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","titre","Aide"),500,100)
		$Label2 = GUICtrlCreateLabel(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","aide","Choisisez l'élément dont vous souhaitez obtenir l'aide..."),50,25,500,100)
		GUICtrlSetFont($Label2,10,5000)
		
		$FichierA = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier","Fichier"))
		$Fichier_NouveauA = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier_nouveau","Nouveau	Ctrl+N"),$FichierA)
		$Fichier_OuvrirA = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier_ouvrir","Ouvrir...	Ctrl+O"),$FichierA)
		$Fichier_EnregistrerA = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier_enregistrer","Enregistrer	Ctrl+S"),$FichierA)
		$Fichier_EnregistrerSousA = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier_enregistrersous","Enregistrer sous...	Ctrl+Maj+S"),$FichierA)
		GUICtrlCreateMenuItem("",$FichierA)
		$Fichier_QuitterA = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier_quitter","Quitter	Échap"),$FichierA)
		
		$CommandesA = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes","Commandes"))
		$Commandes_CliquezIciPourVoirLAideA = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","cliquezicipourvoirlaide","Cliquez ici pour voir l'aide."),$CommandesA)
		
		$LancerA = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","lancer","Lancer"))
		$Lancer_LancerNormalementA = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","lancer_lancernormalement","Lancer normalement	F5"),$LancerA)
		$Lancer_LancerDansA = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","lancer_lancerdans","Lancer dans...	Ctrl+F5"),$LancerA)
		$Lancer_LancerLesLignesA = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","lancer_lancerleslignes","Lancer les lignes...	L+F5"),$LancerA)
		
		$CompilerA = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","compiler","Compiler"))
		$Compiler_CompilerLeFichierOuvertA = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","compiler_compilerlefichierouvert","Compiler le fichier ouvert"),$CompilerA)
		$Compiler_CompilerUnFichierA = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","compiler_compilerunfichier","Compiler un fichier"),$CompilerA)
		
		$OptionsA = GUICtrlCreateMenu(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","options","Options"))
		$Options_LangueA = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","options_langue","Langues"),$OptionsA)
		GUICtrlCreateMenuItem("",$OptionsA)
		$Options_AideA = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","options_aide","Aide	F1"),$OptionsA)
		$Options_AProposA = GUICtrlCreateMenuItem(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","options_apropos","À propos de BatchProg"),$OptionsA)
		GUISetState(@SW_SHOW)
		While 1
			$nMsg2 = GUIGetMsg()
			Switch $nMsg2
				
			Case $GUI_EVENT_CLOSE
				ExitLoop
				
			Case $Fichier_NouveauA
				MsgBox(64, "BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier_nouveau","Nouveau"), IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","fichier_nouveau","Efface le contenu de l'éditeur de texte et ferme le fichier ouvert.")&@CRLF&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","fichier_nouveau_2","Une confirmation vous sera demandé si le fichier ouvert n'est pas sauvegardé."))
				
			Case $Fichier_OuvrirA
				MsgBox(64, "BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier_ouvrir","Ouvrir..."), IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","fichier_ouvrir","Ouvre un fichier et le charge dans l'éditeur de texte.")&@CRLF&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","fichier_ouvrir_2","Une confirmation vous sera demandé si le fichier ouvert n'est pas sauvegardé."))
				
			Case $Fichier_EnregistrerA
				MsgBox(64, "BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier_enregistrer","Enregistrer"), IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","fichier_enregistrer","Enregistre le fichier ouvert.")&@CRLF&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","fichier_enregistrer_2","Si aucun fichier n'est ouvert, vous devrez entrer un nom."))
				
			Case $Fichier_EnregistrerSousA
				MsgBox(64, "BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier_enregistrersous","Enregistrer sous..."), IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","fichier_enregistrersous","Enregistre le fichier ouvert sous un autre nom."))
				
			Case $Fichier_QuitterA
				MsgBox(64, "BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","fichier_quitter","Quitter	Échap"), IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","fichier_quitter","Quitte BatchProg")&@CRLF&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","fichier_quitter_2","Une confirmation vous sera demandé si le fichier ouvert n'est pas sauvegardé."))
				
			Case $Commandes_CliquezIciPourVoirLAideA
				MsgBox(64, "BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","commandes","Commandes"), IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","commandes","Insert une commande dans l'éditeur de texte.")&@CRLF&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","commandes_2",'Le chargement de certaines commandes (ex : "Temporisation") peut être assez long si elle est longue.'))
				
			Case $Lancer_LancerNormalementA
				MsgBox(64, "BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","lancer_lancernormalement","Lancer normalement"), IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","lancer_lancernormalement","Lance le fichier dans le répertoire où il est enregistré.")&@CRLF&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","lancer_lancernormalement_2","Si aucun fichier n'est ouvert, vous devrez entrer un nom."))
				
			Case $Lancer_LancerDansA
				MsgBox(64, "BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","lancer_lancerdans","Lancer dans..."), IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","lancer_lancerdans","Lance un fichier dans un répertoire spécifique (que vous choisirez).")&@CRLF&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","lancer_lancerdans_2","Si aucun fichier n'est ouvert, vous devrez entrer un nom."))
				
			Case $Lancer_LancerLesLignesA
				MsgBox(64, "BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","lancer_lancerleslignes","Lancer les lignes..."), IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","lancer_lancerleslignes","Lance les lignes spécifiques d'un fichier (que vous choisirez).")&@CRLF&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","lancer_lancerleslignes_2","Si aucun fichier n'est ouvert, vous devrez entrer un nom."))
				
			Case $Compiler_CompilerLeFichierOuvertA
				MsgBox(64, "BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","compiler_compilerlefichierouvert","Compiler le fichier ouvert"), IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","compiler_compilerlefichierouvert","Compile le fichier ouvert dans l'éditeur de texte.")&@CRLF&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","compiler_compilerlefichierouvert_2","Si aucun fichier n'est ouvert, vous devrez entrer un nom."))
				
			Case $Compiler_CompilerUnFichierA
				MsgBox(64, "BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","compiler_compilerunfichier","Compiler un fichier"), IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","compiler_compilerunfichier","Compile un fichier (que vous choisirez)."))
				
			Case $Options_LangueA
				MsgBox(64, "BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","options_langue","Langues"), IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","options_langue","Définis la langue (Français ou Anglais)."))
				
			Case $Options_AideA
				MsgBox(64, "BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","options_aide","Aide"), IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","options_aide","Affiche l'aide (celle que vous êtes entrain de lire)."))
				
			Case $Options_AProposA
				MsgBox(64, "BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","options_apropos","À propos de BatchProg"), IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"aide","options_apropos","Affiche des informations sur BatchProg."))
			
			EndSwitch
		WEnd
		GUIDelete($Gui3)
		
	Case $Options_APropos
		$FileRead = FileRead(@ScriptDir&"\Resources\Langues\APropos\"&$Langue)
		$APropos = _StringBetween(FileRead(@ScriptDir&"\Resources\Langues\"&$Langue),"[APropos]","[/APropos]")
		MsgBox(64,"BatchProg ; "&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","options_apropos","À propos de BatchProg"),$APropos[0])
	EndSwitch
WEnd

Func _Exit(); Fonction de fermeture du programme.
	If FileRead($File) <> GUICtrlRead($Edit) Then
		$Choice = MsgBox(3,"BatchProg",IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","sauvegarde_l1","Attention, le fichier ouvert n'as pas été sauvegardé !")&@CRLF&IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"menu","sauvegarde_l2","Voulez-vous le sauvegarder maintenant ?"))
		If $Choice = 6 Then
			$Save = _Save($File)
			If $Save = 0 Then
				$Choice = MsgBox(4,"BatchProg",IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","attentionnonsauverror","Le fichier n'a pas pu être sauvegardé, voulez-vous vraiment quitter ?"))
				If $Choice = 6 Then
					Exit
				EndIf
			ElseIf $Save = 1 Then
				Exit
			EndIf
		ElseIf $Choice = 7 Then
			Exit
		EndIf
	ElseIf FileRead($File) = GUICtrlRead($Edit) Then
		Exit
	EndIf
EndFunc

Func _Save($fFile); Fonction de sauvegarde.
	If $File = "" Then
		$Path = FileSaveDialog(IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","sauvegarde2","Choisissez le nom du fichier à enregistrer :"),@UserProfileDir&"\BatchProg",IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","extensions","Fichiers batch (*.bat)|Tous les fichiers (*.*)"),-1,".bat")
		If Not @error = 1 Then
			$String = StringSplit($Path,"\")
			$FileName = $String[UBound($String)-1]
			$File = $Path
			FileDelete($File)
			$Write = FileWrite($File,GUICtrlRead($Edit))
			If $Write = 1 Then
				MsgBox(64,"BatchProg",IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","fichiersauv","Le fichier a été sauvegardé !"))
				WinSetTitle($Old_Title,"","BatchProg ; "&$FileName)
				$Old_Title = "BatchProg ; "&$FileName
				Return 1
			ElseIf $Write = 0 Then
				MsgBox(16,"BatchProg",IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","fichiernonsauv","Une erreur s'est produite et le fichier n'a pas été sauvegardé !"))
				Return 0
			EndIf
		EndIf
	ElseIf $File <> "" Then
		FileDelete($File)
		$Write = FileWrite($File,GUICtrlRead($Edit))
		If $Write = 1 Then
			MsgBox(64,"BatchProg",IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","fichiersauv","Le fichier a été sauvegardé !"))
			Return 1
		ElseIf $Write = 0 Then
			MsgBox(16,"BatchProg",IniRead(@ScriptDir&"\Resources\Langues\"&$Langue,"sauvegarde","fichiernonsauv","Une erreur s'est produite et le fichier n'a pas été sauvegardé !"))
			Return 0
		EndIf
	EndIf
EndFunc