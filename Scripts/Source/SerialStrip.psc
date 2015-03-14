ScriptName SerialStrip Extends Quest
{serial undressing: press a button once to remove one garment, keep it depressed to remove all}

Import StorageUtil

SexLabFramework Property SexLab Auto ;points to the SexLab Framework script so we can use its functions
sslSystemConfig Property SexLabSystemConfig Auto ;points to the SexLab's sslSystemConfig.psc script so we can use its functions

Actor Property PlayerRef Auto ;points to the player
Actor Property kCurrentActor Auto ;the actor that is currently animating
String[] Property HelmetKeywords Auto
String[] Property GlovesKeywords Auto
String[] Property BootsKeywords Auto
String[] Property ChestpieceKeywords Auto
String[] Property NecklaceKeywords Auto
String[] Property CircletKeywords Auto
String[] Property RingKeywords Auto
String[] Property BraKeywords Auto
String[] Property PantiesKeywords Auto

String Property SS_STRIPLIST_WEAPONSANDSHIELDS_R = "APPS.SerialStripList.WeaponsAndShieldsR" AutoReadOnly
String Property SS_STRIPLIST_WEAPONSANDSHIELDS_L = "APPS.SerialStripList.WeaponsAndShieldsL" AutoReadOnly
String Property SS_STRIPLIST_GLOVES = "APPS.SerialStripList.Gloves" AutoReadOnly
String Property SS_STRIPLIST_HELMET = "APPS.SerialStripList.Helmet" AutoReadOnly
String Property SS_STRIPLIST_BOOTS = "APPS.SerialStripList.Boots" AutoReadOnly
String Property SS_STRIPLIST_CHESTPIECE = "APPS.SerialStripList.Chestpiece" AutoReadOnly
String Property SS_STRIPLIST_NECKLACE = "APPS.SerialStripList.Necklace" AutoReadOnly
String Property SS_STRIPLIST_CIRCLET = "APPS.SerialStripList.Circlet" AutoReadOnly
String Property SS_STRIPLIST_RING = "APPS.SerialStripList.Ring" AutoReadOnly
String Property SS_STRIPLIST_BRA = "APPS.SerialStripList.Bra" AutoReadOnly
String Property SS_STRIPLIST_PANTIES = "APPS.SerialStripList.Panties" AutoReadOnly
String Property SS_STRIPLIST_OTHER = "APPS.SerialStripList.Other" AutoReadOnly

String Property SS_STRIPPEDLIST_WEAPONSANDSHIELDS_R = "APPS.SerialStrippedList.WeaponsAndShieldsR" AutoReadOnly
String Property SS_STRIPPEDLIST_WEAPONSANDSHIELDS_L = "APPS.SerialStrippedList.WeaponsAndShieldsL" AutoReadOnly
String Property SS_STRIPPEDLIST_GLOVES = "APPS.SerialStrippedList.Gloves" AutoReadOnly
String Property SS_STRIPPEDLIST_HELMET = "APPS.SerialStrippedList.Helmet" AutoReadOnly
String Property SS_STRIPPEDLIST_BOOTS = "APPS.SerialStrippedList.Boots" AutoReadOnly
String Property SS_STRIPPEDLIST_CHESTPIECE = "APPS.SerialStrippedList.Chestpiece" AutoReadOnly
String Property SS_STRIPPEDLIST_NECKLACE = "APPS.SerialStrippedList.Necklace" AutoReadOnly
String Property SS_STRIPPEDLIST_CIRCLET = "APPS.SerialStrippedList.Circlet" AutoReadOnly
String Property SS_STRIPPEDLIST_RING = "APPS.SerialStrippedList.Ring" AutoReadOnly
String Property SS_STRIPPEDLIST_BRA = "APPS.SerialStrippedList.Bra" AutoReadOnly
String Property SS_STRIPPEDLIST_PANTIES = "APPS.SerialStrippedList.Panties" AutoReadOnly
String Property SS_STRIPPEDLIST_OTHER = "APPS.SerialStrippedList.Other" AutoReadOnly

String Property sCurrentStripArray Auto ;the array that is currently animating i.e. the actor is playing the animation for stripping from this array
String Property sCurrentStrippedArray Auto ;the array that is currently holding the stripped items

Idle Property WeaponsAndShieldsAnim Auto ;the name of the weapons and shields stripping animation
Idle Property ssFArGl Auto ;the name of the gloves stripping animation
Idle Property ssFArHe Auto ;the name of the helmet stripping animation
Idle Property ssFArBo Auto ;the name of the boots stripping animation
Idle Property ssFArChB Auto ;the name of the chestpiece stripping animation
Idle Property ssFJN Auto ;the name of the necklace stripping animation
Idle Property ssFClCi Auto ;the name of the circlet stripping animation
Idle Property ssFJR Auto ;the name of the ring stripping animation
Idle Property ssFUUB Auto ;the name of the bra stripping animation
Idle Property ssFULB Auto ;the name of the panties stripping animation
Idle Property OtherAnim Auto ;the name of the "other" stripping animation

Bool[] Property bAllTrueList Auto
Bool[] Property bAllFalseList Auto
Bool Property bFullSerialStripSwitch Auto ;switches to full stripping
Bool Property bIsSheathing Auto ;notifys script that actor is sheathing
Form Property EventSender Auto ;stores the form that initiated the stripping
Float Property fDurationForFullStrip = 2.0 AutoReadOnly ;2 seconds cut-off point of key press: after this duration, the actor will strip fully
Int Property iStripKeyCode = 48 AutoReadOnly ;B - the key that will be used to input stripping commands

Event OnInit()
	SexLab = Game.GetFormFromFile(0xD62, "SexLab.esm") as SexLabFramework
	SexLabSystemConfig = Game.GetFormFromFile(0xD62, "SexLab.esm") as sslSystemConfig
	InitDefaultArrays()
	SerialStripOn()
EndEvent

Function InitDefaultArrays()
	bAllTrueList = New Bool[33]
	bAllFalseList = New Bool[33]
	Int i

	While (i < 33)
		bAllTrueList[i] = True
		bAllFalseList[i] = False
		i += 1
	EndWhile
EndFunction

Function SerialStripOn(Bool abActivateSerialStrip = True)
;turns on serial stripping. Pass True to run on, off to turn off.

	If (abActivateSerialStrip) ;if serial stripping is set to activate
		RegisterForKey(iStripKeyCode) ;registers to listen for the iStripKeyCode
	Else ;if serial stripping is set to deactivate
		UnRegisterForKey(iStripKeyCode) ;stops listening for the iStripKeyCode
	EndIf
EndFunction

Event OnKeyUp(Int KeyCode, Float HoldTime)
;when the key is released

	If (KeyCode == iStripKeyCode && !Utility.IsInMenuMode()) ;if the key that was released is the key for serial stripping and we are not in a menu
		RegisterForModEvent("SerialStripStart", "OnSerialStripStart")

		If (HoldTime < fDurationForFullStrip) ;if the key has not been held down long enough
			SendSerialStripStartEvent(Self, False)
		Else
			SendSerialStripStartEvent(Self, True)
		EndIf
	EndIf
EndEvent

Bool Function SendSerialStripStartEvent(Form akSender, Bool abFullStrip = False)
	;/ beginValidation /;
	If (!akSender)
		Return False
	EndIf
	;/ endValidation /;

	Int Handle = ModEvent.Create("SerialStripStart")
	If (Handle)
		EventSender = akSender
		ModEvent.PushForm(Handle, akSender)
		ModEvent.PushBool(Handle, abFullStrip)
		ModEvent.Send(Handle)
		Return True
	Else
		Return False
	EndIf
EndFunction

Bool Function SendSerialStripStopEvent()
	;/ beginValidation /;
	If (!EventSender)
		Return False
	EndIf
	;/ endValidation /;

	Int Handle = ModEvent.Create("SerialStripStop")
	If (Handle)
		ModEvent.PushForm(Handle, EventSender)
		ModEvent.Send(Handle)
		EventSender = None ;clears the property holding the form that initiated the stripping
		Return True
	Else
		Return False
	EndIf
EndFunction

Event OnSerialStripStart(Form akSender, Bool abFullStrip)
	GoToState("Stripping")
	bFullSerialStripSwitch = abFullStrip
	PrepareForStripping(PlayerRef, bAllFalseList)
	SerialStrip()
EndEvent

Function PrepareForStripping(Actor akActorRef, Bool[] abSlotOverrideList, String asExceptionList = "")
EndFunction

Function ClearIfInactive(Actor akActorRef, String asArrayName, Bool abIsArrayActive)
EndFunction

Bool Function ItemHasKeyword(Form akItemRef, String[] asKeywords)
EndFunction

Bool Function IsValidSlot(Int aiSlot, Bool[] abIsUserConfigStrippable, Bool[] abIsSlotOverride)
EndFunction

Function SerialStrip()
EndFunction

Function SingleArrayAnimThenStrip(String asStripArray, String asStrippedArray, Idle akAnimation = None, Bool abDontStop = False)
EndFunction

Function SingleArrayStrip(Actor akActorRef, String asStripArray, String asStrippedArray, Bool abDontStop = False)
EndFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
EndEvent

State Stripping

	Function PrepareForStripping(Actor akActorRef, Bool[] abSlotOverrideList, String asExceptionList = "")
	;/analyses items worn by akActorRef and puts them into arrays for the actual
		stripping function to use.
	akActorRef: actor to prepare
	asExceptionList: name of the StorageUtil array holding items that will NOT be stripped
	abSlotOverrideList: a 33-item-long array which defaults to False. Set any item [i] to True to override the user configuration
		for slot i+30 and force-strip it.
	/;

		;/ beginValidation /;
		If (!akActorRef || abSlotOverrideList.Length != 33)
			Return
		EndIf
		;/ endValidation /;

		;clear all the arrays before filling them
		FormListClear(akActorRef, SS_STRIPLIST_WEAPONSANDSHIELDS_R)
		FormListClear(akActorRef, SS_STRIPLIST_WEAPONSANDSHIELDS_L)
		FormListClear(akActorRef, SS_STRIPLIST_GLOVES)
		FormListClear(akActorRef, SS_STRIPLIST_HELMET)
		FormListClear(akActorRef, SS_STRIPLIST_BOOTS)
		FormListClear(akActorRef, SS_STRIPLIST_CHESTPIECE)
		FormListClear(akActorRef, SS_STRIPLIST_NECKLACE)
		FormListClear(akActorRef, SS_STRIPLIST_CIRCLET)
		FormListClear(akActorRef, SS_STRIPLIST_RING)
		FormListClear(akActorRef, SS_STRIPLIST_BRA)
		FormListClear(akActorRef, SS_STRIPLIST_PANTIES)
		FormListClear(akActorRef, SS_STRIPLIST_OTHER)

		Bool[] bArrayIsActive = new Bool[12]
		;/Activates or deactivates (and clears) the stripping arrays
		bArrayIsActive[0] WeaponsAndShieldsR
		bArrayIsActive[1] WeaponsAndShieldsL
		bArrayIsActive[2] Gloves
		bArrayIsActive[3] Helmet
		bArrayIsActive[4] Boots
		bArrayIsActive[5] Chestpiece
		bArrayIsActive[6] Necklace
		bArrayIsActive[7] Circlet
		bArrayIsActive[8] Ring
		bArrayIsActive[9] Bra
		bArrayIsActive[10] Panties
		bArrayIsActive[11] Other
		/;

		Bool[] bUserConfigSlots = new Bool[33] ;declares an array to hold the user's configuration

		If (SexLab)
			Int iGender = SexLab.GetGender(akActorRef) ;fetches the gender of the actor

			If (iGender == 0) ;if the actor is male
				bUserConfigSlots = SexLabSystemConfig.GetStrip(IsFemale = False) ;fetch the user's MCM stripping configuration for males
			ElseIf (iGender == 1) ;if the actor is female
				bUserConfigSlots = SexLabSystemConfig.GetStrip(IsFemale = True) ;fetch the user's MCM stripping configuration for females
			EndIf
		Else
			bUserConfigSlots = bAllTrueList
		EndIf

		;WEAPONS AND SHIELDS
		;In SexLab's StripFemale and StripMale arrays, this is item 32
		;weapons and shields employ a different logic than the other items

		If (akActorRef.GetEquippedItemType(1) && \
		akActorRef.GetEquippedItemType(1) != 5 && \
		akActorRef.GetEquippedItemType(1) != 6 && \
		akActorRef.GetEquippedItemType(1) != 7 && \
		akActorRef.GetEquippedItemType(1) != 8 && \
		akActorRef.GetEquippedItemType(1) != 9 && \
		akActorRef.GetEquippedItemType(1) != 12) ;if there is a weapon in the right hand but it's not a two-handed one, then we also need to check the left hand

			If (akActorRef.GetEquippedItemType(0) == 10) ;if the left hand is holding a shield
				Form kItemRef = akActorRef.GetEquippedShield()

				If ((FormListFind(None, asExceptionList, kItemRef) == -1)) ;if the item is not found in the exception array
					If (SexLab.IsStrippable(kItemRef) == True && IsValidSlot(32, bUserConfigSlots, abSlotOverrideList)) ;if this item is strippable according to SexLab and either the modder or the user have configured this slot to be strippable
						FormListAdd(akActorRef, SS_STRIPLIST_WEAPONSANDSHIELDS_L, kItemRef, allowDuplicate = False) ;adds this item to the WeaponsAndShields undress list
						bArrayIsActive[1] = True ;activate the WeaponsAndShieldsL array
					EndIf
				EndIf
			ElseIf (akActorRef.GetEquippedItemType(0) && akActorRef.GetEquippedItemType(0) != 9) ;if there is a weapon in the left hand (i.e. not just fists or a spell)
				Form kItemRef = akActorRef.GetEquippedWeapon(True) ;fetches left-hand weapon and puts it in kItemRef

				If ((FormListFind(None, asExceptionList, kItemRef) == -1)) ;if the item is not found in the exception array
					If (SexLab.IsStrippable(kItemRef) == True && IsValidSlot(32, bUserConfigSlots, abSlotOverrideList)) ;if this item is strippable according to SexLab and either the modder or the user have configured this slot to be strippable
						FormListAdd(akActorRef, SS_STRIPLIST_WEAPONSANDSHIELDS_L, kItemRef, allowDuplicate = False) ;adds this item to the WeaponsAndShields undress list
						bArrayIsActive[1] = True ;activate the WeaponsAndShieldsL array
					EndIf
				EndIf
			EndIf
		EndIf

		If (akActorRef.GetEquippedItemType(1) && akActorRef.GetEquippedItemType(1) != 9) ;if there is a weapon in the right hand (i.e. not just fists or a spell)
			Form kItemRef = akActorRef.GetEquippedWeapon(False) ;fetches right-hand weapon and puts it in kItemRef

			If ((FormListFind(None, asExceptionList, kItemRef) == -1)) ;if the item is not found in the exception array
				If (SexLab.IsStrippable(kItemRef) == True && IsValidSlot(32, bUserConfigSlots, abSlotOverrideList)) ;if this item is strippable according to SexLab and either the modder or the user have configured this slot to be strippable
					FormListAdd(akActorRef, SS_STRIPLIST_WEAPONSANDSHIELDS_R, kItemRef, allowDuplicate = False) ;adds this item to the WeaponsAndShields undress list
					bArrayIsActive[0] = True ;activate the WeaponsAndShieldsR array
				EndIf
			EndIf
		EndIf

		;ARMOR

		;CREATING A LOOP to check all the item slots (forwards)
		Int i ;sets i to zero

		While (i <= 31) ;run this loop up to and including node 61 (http://www.creationkit.com/Biped_Object)
			Form kItemRef = akActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30)) ;fetch the item worn in this slot and load it in the kItemRef variable

			If (kItemRef && FormListFind(None, asExceptionList, kItemRef) == -1) ;if there is an item in this slot and it is not found in the exception array

				If (i + 30 == 33) || (ItemHasKeyword(kItemRef, GlovesKeywords)) ;if this item is in the gloves slot OR has any of the gloves keywords
					FormListAdd(akActorRef, SS_STRIPLIST_GLOVES, kItemRef, allowDuplicate = False);adds this item to the gloves undress list
				ElseIf (i + 30 == 31) || (ItemHasKeyword(kItemRef, HelmetKeywords)) ;if this item is in the hair slot OR has any of the helmet keywords
					FormListAdd(akActorRef, SS_STRIPLIST_HELMET, kItemRef, allowDuplicate = False) ;adds this item to the helmet undress list
				ElseIf (i + 30 == 37) || (ItemHasKeyword(kItemRef, BootsKeywords)) ;if this item is in the boots slot OR has any of the boots keywords
					FormListAdd(akActorRef, SS_STRIPLIST_BOOTS, kItemRef, allowDuplicate = False) ;adds this item to the boots undress list
				ElseIf (i + 30 == 32) || (ItemHasKeyword(kItemRef, ChestpieceKeywords)) ;if this item is in the chestpiece slot OR has any of the chestpiece keywords
					FormListAdd(akActorRef, SS_STRIPLIST_CHESTPIECE, kItemRef, allowDuplicate = False) ;adds this item to the chestpiece undress list
				ElseIf (i + 30 == 35) || (ItemHasKeyword(kItemRef, NecklaceKeywords)) ;if this item is in the necklace slot OR has any of the necklace keywords
					FormListAdd(akActorRef, SS_STRIPLIST_NECKLACE, kItemRef, allowDuplicate = False) ;adds this item to the necklace undress list
				ElseIf (i + 30 == 42) || (ItemHasKeyword(kItemRef, CircletKeywords)) ;if this item is in the circlet slot OR has any of the circlet keywords
					FormListAdd(akActorRef, SS_STRIPLIST_CIRCLET, kItemRef, allowDuplicate = False) ;adds this item to the circlet undress list
				ElseIf (i + 30 == 36) || (ItemHasKeyword(kItemRef, RingKeywords)) ;if this item is in the ring slot OR has any of the ring keywords
					FormListAdd(akActorRef, SS_STRIPLIST_RING, kItemRef, allowDuplicate = False) ;adds this item to the ring undress list
				ElseIf (i + 30 == 56) || (ItemHasKeyword(kItemRef, BraKeywords)) ;if this item is in the bra slot OR has any of the bra keywords
					FormListAdd(akActorRef, SS_STRIPLIST_BRA, kItemRef, allowDuplicate = False) ;adds this item to the bra undress list
				ElseIf (i + 30 == 52) || (ItemHasKeyword(kItemRef, PantiesKeywords)) ;if this item is in the panties slot OR has any of the panties keywords
					FormListAdd(akActorRef, SS_STRIPLIST_PANTIES, kItemRef, allowDuplicate = False) ;adds this item to the panties undress list
				EndIf

				If (SexLab.IsStrippable(kItemRef) == True) ;if this item is strippable according to SexLab
					If (IsValidSlot(i, bUserConfigSlots, abSlotOverrideList)) ;if either the modder or the user have configured this slot to be strippable
						If ((i + 30 == 33) || FormListFind(akActorRef, SS_STRIPLIST_GLOVES, kItemRef) != -1) ;if this is the gloves slot OR we already know the item has one of the gloves keywords
							bArrayIsActive[2] = True ;activate the gloves stripping array
						ElseIf ((i + 30 == 31) || FormListFind(akActorRef, SS_STRIPLIST_HELMET, kItemRef) != -1) ;if this is the hair slot (checking for helmets) OR we already know the item has one of the helmet keywords
							bArrayIsActive[3] = True ;activate the helmet stripping array
						ElseIf ((i + 30 == 37) || FormListFind(akActorRef, SS_STRIPLIST_BOOTS, kItemRef) != -1) ;if this is the boots slot OR we already know the item has one of the boots keywords
							bArrayIsActive[4] = True ;activate the boots stripping array
						ElseIf ((i + 30 == 32) || FormListFind(akActorRef, SS_STRIPLIST_CHESTPIECE, kItemRef) != -1) ;if this is the chestpiece slot OR we already know the item has one of the chestpiece keywords
							bArrayIsActive[5] = True ;activate the chestpiece stripping array
						ElseIf ((i + 30 == 35) || FormListFind(akActorRef, SS_STRIPLIST_NECKLACE, kItemRef) != -1) ;if this is the necklace slot OR we already know the item has one of the necklace keywords
							bArrayIsActive[6] = True ;activate the necklace stripping array
						ElseIf ((i + 30 == 42) || FormListFind(akActorRef, SS_STRIPLIST_CIRCLET, kItemRef) != -1) ;if this is the circlet slot OR we already know the item has one of the circlet keywords
							bArrayIsActive[7] = True ;activate the circlet stripping array
						ElseIf ((i + 30 == 36) || FormListFind(akActorRef, SS_STRIPLIST_RING, kItemRef) != -1) ;if this is the ring slot OR we already know the item has one of the ring keywords
							bArrayIsActive[8] = True ;activate the ring stripping array
						ElseIf ((i + 30 == 56) || FormListFind(akActorRef, SS_STRIPLIST_BRA, kItemRef) != -1) ;if this is the bra slot OR we already know the item has one of the bra keywords
							bArrayIsActive[9] = True ;activate the bra stripping array
						ElseIf ((i + 30 == 52) || FormListFind(akActorRef, SS_STRIPLIST_PANTIES, kItemRef) != -1) ;if this is the panties slot OR we already know the item has one of the panties keywords
							bArrayIsActive[10] = True ;activate the panties stripping array
						Else
							FormListAdd(akActorRef, SS_STRIPLIST_OTHER, kItemRef, allowDuplicate = False) ;adds this item to the "other" undress list
							bArrayIsActive[11] = True ;activate the "other" stripping array
						EndIf
					EndIf
				EndIf
			EndIf
			i += 1 ;moves the loop to check the next slot (forwards)
		EndWhile

		;clears the arrays if they are not active (i.e. there's nothing strippable in them)
		ClearIfInactive(akActorRef, SS_STRIPLIST_WEAPONSANDSHIELDS_R, bArrayIsActive[0])
		ClearIfInactive(akActorRef, SS_STRIPLIST_WEAPONSANDSHIELDS_L, bArrayIsActive[1])
		ClearIfInactive(akActorRef, SS_STRIPLIST_GLOVES, bArrayIsActive[2])
		ClearIfInactive(akActorRef, SS_STRIPLIST_HELMET, bArrayIsActive[3])
		ClearIfInactive(akActorRef, SS_STRIPLIST_BOOTS, bArrayIsActive[4])
		ClearIfInactive(akActorRef, SS_STRIPLIST_CHESTPIECE, bArrayIsActive[5])
		ClearIfInactive(akActorRef, SS_STRIPLIST_NECKLACE, bArrayIsActive[6])
		ClearIfInactive(akActorRef, SS_STRIPLIST_CIRCLET, bArrayIsActive[7])
		ClearIfInactive(akActorRef, SS_STRIPLIST_RING, bArrayIsActive[8])
		ClearIfInactive(akActorRef, SS_STRIPLIST_BRA, bArrayIsActive[9])
		ClearIfInactive(akActorRef, SS_STRIPLIST_PANTIES, bArrayIsActive[10])
		ClearIfInactive(akActorRef, SS_STRIPLIST_OTHER, bArrayIsActive[11])

		Debug.Trace("Array " + SS_STRIPLIST_WEAPONSANDSHIELDS_R + " contains " + FormListCount(akActorRef, SS_STRIPLIST_WEAPONSANDSHIELDS_R) + " elements.")
		Debug.Trace("Array " + SS_STRIPLIST_WEAPONSANDSHIELDS_L + " contains " + FormListCount(akActorRef, SS_STRIPLIST_WEAPONSANDSHIELDS_L) + " elements.")
		Debug.Trace("Array " + SS_STRIPLIST_GLOVES + " contains " + FormListCount(akActorRef, SS_STRIPLIST_GLOVES) + " elements.")
		Debug.Trace("Array " + SS_STRIPLIST_HELMET + " contains " + FormListCount(akActorRef, SS_STRIPLIST_HELMET) + " elements.")
		Debug.Trace("Array " + SS_STRIPLIST_BOOTS + " contains " + FormListCount(akActorRef, SS_STRIPLIST_BOOTS) + " elements.")
		Debug.Trace("Array " + SS_STRIPLIST_CHESTPIECE + " contains " + FormListCount(akActorRef, SS_STRIPLIST_CHESTPIECE) + " elements.")
		Debug.Trace("Array " + SS_STRIPLIST_NECKLACE + " contains " + FormListCount(akActorRef, SS_STRIPLIST_NECKLACE) + " elements.")
		Debug.Trace("Array " + SS_STRIPLIST_CIRCLET + " contains " + FormListCount(akActorRef, SS_STRIPLIST_CIRCLET) + " elements.")
		Debug.Trace("Array " + SS_STRIPLIST_RING + " contains " + FormListCount(akActorRef, SS_STRIPLIST_RING) + " elements.")
		Debug.Trace("Array " + SS_STRIPLIST_BRA + " contains " + FormListCount(akActorRef, SS_STRIPLIST_BRA) + " elements.")
		Debug.Trace("Array " + SS_STRIPLIST_PANTIES + " contains " + FormListCount(akActorRef, SS_STRIPLIST_PANTIES) + " elements.")
		Debug.Trace("Array " + SS_STRIPLIST_OTHER + " contains " + FormListCount(akActorRef, SS_STRIPLIST_OTHER) + " elements.")
	EndFunction

	Function ClearIfInactive(Actor akActorRef, String asArrayName, Bool abIsArrayActive)
	;clears the asArrayName array on akActorRef, depending on whether abIsArrayActive
		;/ beginValidation /;
		If (!akActorRef || asArrayName == "")
			Return
		EndIf
		;/ endValidation /;

		If (!abIsArrayActive) ;if the array is not active
			FormListClear(akActorRef, asArrayName) ;clear the array by the name asArrayName on akActorRef
		EndIf
	EndFunction

	Bool Function ItemHasKeyword(Form akItemRef, String[] asKeywords)
	;checks whether akItemRef has any of the keywords stored in the Keywords array
		;/ beginValidation /;
		If (!akItemRef || !asKeywords)
			Return False
		EndIf
		;/ endValidation /;

		Int i = asKeywords.Length - 1 ;sets i to the length of the asKeywords array (-1 because arrays are zero based while length's result is 1-based)

		While (i >= 0) ;runs this loop up to and including the first item (backwards)
			String sKeywordRef = asKeywords[i] ;fetch the keyword in this position in the array

			If (SexLabUtil.HasKeywordSub(akItemRef, sKeywordRef)) ;if the item has this keyword
				Return True
			EndIf

		i -= 1 ;go to the next item in the loop (backwards)
		EndWhile

		Return False
	EndFunction

	Bool Function IsValidSlot(Int aiSlot, Bool[] abIsUserConfigStrippable, Bool[] abIsSlotOverride)
	;Returns True if either the modder or the user have designated this slot as strippable
		If (abIsSlotOverride[aiSlot]) ;if the modder has overridden this slot to strippable
			Return True
		ElseIf (abIsUserConfigStrippable) ;if the user has configured this slot as strippable
			Return True
		Else
			Return False
		EndIf
	EndFunction

	Function SerialStrip()
	;makes the actor strip one item/group of clothing (one array) and then strip the next one and so on. To be used for button taps.

		Game.ForceThirdPerson() ;force third person camera mode
		Game.SetPlayerAIDriven(True) ;instead of DisablePlayerControls(True)

		If (PlayerRef.IsWeaponDrawn()) ;if the player has their weapon drawn
			bIsSheathing = True
			PlayerRef.SheatheWeapon() ;make the player sheath their weapon
			RegisterForAnimationEvent(PlayerRef, "IdleStop") ;listening for when the player stops sheathing to continue
			Return
		Else
			bIsSheathing = False
		EndIf
		
		;WEAPONS
		If (FormListCount(PlayerRef, SS_STRIPLIST_WEAPONSANDSHIELDS_R) > 0 ||  FormListCount(PlayerRef, SS_STRIPLIST_WEAPONSANDSHIELDS_L) > 0) ;if the weapons or shields arrays (Right and Left) are not empty

			;until we have special weapons stripping animation, this is being deprecated later on in SingleArrayAnimThenStrip()
			If (FormListCount(PlayerRef, SS_STRIPLIST_WEAPONSANDSHIELDS_R) == 0) ;if the right hand array is empty i.e. the left is not empty
				SingleArrayAnimThenStrip(SS_STRIPLIST_WEAPONSANDSHIELDS_L, SS_STRIPPEDLIST_WEAPONSANDSHIELDS_L, WeaponsAndShieldsAnim) ;run the function to play the appropriate animation
			ElseIf (FormListCount(PlayerRef, SS_STRIPLIST_WEAPONSANDSHIELDS_L) == 0) ;if the left hand array is empty i.e. the right is not empty
				SingleArrayAnimThenStrip(SS_STRIPLIST_WEAPONSANDSHIELDS_R, SS_STRIPPEDLIST_WEAPONSANDSHIELDS_R, WeaponsAndShieldsAnim) ;run the function to play the appropriate animation
			Else ;if both right and left hand arrays are not empty
				SingleArrayAnimThenStrip(SS_STRIPLIST_WEAPONSANDSHIELDS_R, SS_STRIPPEDLIST_WEAPONSANDSHIELDS_R, WeaponsAndShieldsAnim, abDontStop = True) ;run the function to play the appropriate animation and continue to strip the left hand too
				SingleArrayAnimThenStrip(SS_STRIPLIST_WEAPONSANDSHIELDS_L, SS_STRIPPEDLIST_WEAPONSANDSHIELDS_L) ;run the function to just strip the left hand without playing an animation
			EndIf
		;ARMOR
		ElseIf (FormListCount(PlayerRef, SS_STRIPLIST_GLOVES) > 0)
			SingleArrayAnimThenStrip(SS_STRIPLIST_GLOVES, SS_STRIPPEDLIST_GLOVES, ssFArGl) ;run the function to play the appropriate animation
		ElseIf (FormListCount(PlayerRef, SS_STRIPLIST_HELMET) > 0)
			SingleArrayAnimThenStrip(SS_STRIPLIST_HELMET, SS_STRIPPEDLIST_HELMET, ssFArHe) ;run the function to play the appropriate animation
		ElseIf (FormListCount(PlayerRef, SS_STRIPLIST_BOOTS) > 0)
			SingleArrayAnimThenStrip(SS_STRIPLIST_BOOTS, SS_STRIPPEDLIST_BOOTS, ssFArBo) ;run the function to play the appropriate animation
		ElseIf (FormListCount(PlayerRef, SS_STRIPLIST_CHESTPIECE) > 0)
			SingleArrayAnimThenStrip(SS_STRIPLIST_CHESTPIECE, SS_STRIPPEDLIST_CHESTPIECE, ssFArChB) ;run the function to play the appropriate animation
		ElseIf (FormListCount(PlayerRef, SS_STRIPLIST_NECKLACE) > 0)
			SingleArrayAnimThenStrip(SS_STRIPLIST_NECKLACE, SS_STRIPPEDLIST_NECKLACE, ssFJN) ;run the function to play the appropriate animation
		ElseIf (FormListCount(PlayerRef, SS_STRIPLIST_CIRCLET) > 0)
			SingleArrayAnimThenStrip(SS_STRIPLIST_CIRCLET, SS_STRIPPEDLIST_CIRCLET, ssFClCi) ;run the function to play the appropriate animation
		ElseIf (FormListCount(PlayerRef, SS_STRIPLIST_RING) > 0)
			SingleArrayAnimThenStrip(SS_STRIPLIST_RING, SS_STRIPPEDLIST_RING, ssFJR) ;run the function to play the appropriate animation
		ElseIf (FormListCount(PlayerRef, SS_STRIPLIST_BRA) > 0)
			SingleArrayAnimThenStrip(SS_STRIPLIST_BRA, SS_STRIPPEDLIST_BRA, ssFUUB) ;run the function to play the appropriate animation
		ElseIf (FormListCount(PlayerRef, SS_STRIPLIST_PANTIES) > 0)
			SingleArrayAnimThenStrip(SS_STRIPLIST_PANTIES, SS_STRIPPEDLIST_PANTIES, ssFULB) ;run the function to play the appropriate animation
		ElseIf (FormListCount(PlayerRef, SS_STRIPLIST_OTHER) > 0)
			SingleArrayAnimThenStrip(SS_STRIPLIST_OTHER, SS_STRIPPEDLIST_OTHER, OtherAnim) ;run the function to play the appropriate animation
		Else ;if nothing to strip
			If (bFullSerialStripSwitch)
				Game.SetPlayerAIDriven(False) ;give control back to the player
				UnRegisterForModEvent("SerialStripStart")
				UnRegisterForAnimationEvent(PlayerRef, "IdleStop")
				GoToState("")
				SendSerialStripStopEvent()
			EndIf
		EndIf
	EndFunction

	Function SingleArrayAnimThenStrip(String asStripArray, String asStrippedArray, Idle akAnimation = None, Bool abDontStop = False)
	;makes the player animate the stripping animation for a single group of clothing, then strips it

		kCurrentActor = PlayerRef ;sets the currently stripping actor to be the player
		sCurrentStripArray = asStripArray ;sets the currently stripping array to be asStripArray
		sCurrentStrippedArray = asStrippedArray ;sets the array currently holding the stripped items to be asStrippedArray

		If (akAnimation) ;if the function has been given an animation to play
			PlayerRef.PlayIdle(akAnimation) ;makes the player play the stripping animation
			RegisterForAnimationEvent(PlayerRef, "IdleStop")
		Else
			SingleArrayStrip(PlayerRef, sCurrentStripArray, sCurrentStrippedArray, abDontStop) ;go directly to stripping the array without animation

			If (bFullSerialStripSwitch)
				SerialStrip()
			EndIf
		EndIf
	EndFunction

	Function SingleArrayStrip(Actor akActorRef, String asStripArray, String asStrippedArray, Bool abDontStop = False)
	;makes the player strip a single group of clothing

		;/ beginValidation /;
		If (!akActorRef)
			Return
		EndIf
		;/ endValidation /;

		FormListClear(akActorRef, asStrippedArray) ;clears the array that will store the stripped items before refilling it

		Int i = FormListCount(akActorRef, asStripArray) - 1 ;sets i equal to the length of the array (-1 because FormListCount's result is 1-based while the array is 0 based)

		While (i >= 0) ;sets the loop to run up to and including position zero in the array (backwards)

			Form kItemRef = FormListGet(akActorRef, asStripArray, i) ;fetches the item stored in i position in the array

			If (kItemRef) ;if this is an actual item, i.e. the array has not been cleared
				akActorRef.UnequipItem(kItemRef) ;unequips this item
				FormListAdd(akActorRef, asStrippedArray, kItemRef) ;adds the item to this array
			EndIf

			i -= 1 ;go to the next item in the array (backwards)
		EndWhile

		FormListClear(akActorRef, asStripArray) ;clears the array

		If (!bFullSerialStripSwitch && !abDontStop) ;if this is a single array strip and we have not been instructed to continue
			Game.SetPlayerAIDriven(False) ;give control back to the player
			UnRegisterForModEvent("SerialStripStart")
			UnRegisterForAnimationEvent(PlayerRef, "IdleStop")
			GoToState("")
			SendSerialStripStopEvent()
		EndIf
	EndFunction

	Event OnAnimationEvent(ObjectReference akSource, string asEventName)
		If (akSource == PlayerRef && asEventName == "IdleStop")
			If (!bFullSerialStripSwitch && !bIsSheathing)
				SingleArrayStrip(kCurrentActor, sCurrentStripArray, sCurrentStrippedArray) ;strip this array (without animation - animation has hopefully been already played!)
			Else
				SingleArrayStrip(kCurrentActor, sCurrentStripArray, sCurrentStrippedArray) ;strip this array (without animation - animation has hopefully been already played!)
				Utility.Wait(1.0)
				SerialStrip()
			EndIf
		EndIf
	EndEvent

EndState

;/ Animation Descriptions & Durations

FArGl		Remove Armor Gloves
FArHe		Remove Armor Helmet
FArBo		Remove Armor Boots
FArNoUS	Remove it - Thats an incomplete chest "shy" version
FArChB		Remove Armor chestpiece
FClGl		Remove Cloth Gloves
FClHo		Remove Cloth Hood
FClBo		Remove Cloth Boots
FClCi		Remove Cloth Circlet
FClChB		Remove Cloth Dress
FULB		Remove Panties
FUUB		Remove Bra
FJN		Remove Necklace
FJR		Remove Ring

FArBo 185 frames - 6.17 sec

FArChB 140 frames - 4.67 sec

FArGl 145 frames - 4.83 sec

FArHe 140 frames - 4.67 sec

FClBo 185 frames - 6.17 sec

FClChB 181 frames - 6.03 sec

FClCi 85 frames - 2.83 sec

FClGl 85 frames - 2.83 sec

FClHo 85 frames - 2.83 sec

FULB 93 frames - 3.1 sec

FUUB 105 frames - 3.5 sec

FJR 74 frames - 2.5 sec

FJN 74 frames - 2.5 sec

/;

;/DUMMY SCRIPT
Int ActiveSlot
Int[] Function GetUsedSlots(Bool UndressAccessoirs)
    Get EquippedSlots
;31 and 42 = Helmet
;42 = Circlet
;33 = Gloves
;37 = Boots
;32 = Chest
;52 = Panties (no undress animation yet)
#1: Head
#2: Hands
#3: Feet
#4: Body
#5: Wait 1 second -> Do again in case of underwear, recognizing SL keywords (for DD f.e.)
OR #5: Wait 1 second -> call alternative (old) SexLab undress
EndFunction

Function UnDressSlot(Int SlotNr)
    ;Undress specified slot
EndFunction

Event UnDressKey()
    ;if key is pressed, play first animation and on it’s end undress the part
    ;if the key is hold, fill the temporary animations with all appropriate animations
;and on StageEnd remove the clothing part
EndEvent
;/

0. SexLab.Strip.Undress.WeaponsAndShields[]
1. SexLab.Strip.UndressList.Gloves[]
2. SexLab.Strip.UndressList.Helmet[]
3. SexLab.Strip.UndressList.Boots[]
4. SexLab.Strip.UndressList.Armor[]
5. SexLab.Strip.UndressList.Pants[]

Summary:    First build a complete new array of slots which can be undressed
        Second loop through

A. if weapon drawn, holster
B. unequip shields and weapons
C. Clear all SexLab.Strip arrays

Function SlotsToStrip(Actor ActorRef, Form[] akExceptionList)

0. Int i = 1
1. Loop through all possible slots (Int AmountOfSlots = 31)
2. Check for NoStrip (inStr)
2.1 if NoStrip = True goto 1
2.2 Check for optional array if it should be unstripped or not
2.2.1 if no modder selection → Check MCM User Configuration
3. i + until i = AmountOfSlots ;we know which slot we’re at
3.1 Check if directly supported Slot (hardcoded if)
3.1.1 if known slot → save in appropriate array (armor to Strip.Armor)
3.1.2 if not known slot → check for supported Keywords (array with KeyW f.e., hardcoded)
3.1.3 if Keyword known (armor f.e.) → save in appropriate array (armor to Strip.Armor)
4. call strip function
/;
;/
STRIP ANIMATIONS DESCRIPTIONS
ssFArGl		Remove Gloves 4.83 sec
ssFArHe		Remove Helmet 4.67 sec
ssFArBo		Remove Boots 6.17 sec
StripFArNoUS	Remove Torso (no underwear shy)
ssFArChB		Remove Torso 4.67 sec
StripFClGl		Equip Gloves 2.83 sec
StripFClHo		Equip Helmet 2.83 sec
StripFClBo		Equip Boots 6.17 sec
StripFClCi		Equip Circlet 2.83 sec
StripFClChB		Equip Torso 6.03 sec
ssFULB		Remove Panties 3.1 sec
StripFUUB		Remove Bra 3.5 sec
StripFJN		Equip Ring 2.5 sec
StripFJC		Remove Ring 2.5 sec
/;