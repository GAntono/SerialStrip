ScriptName SexLabSerialStrip Extends Quest
{serial undressing: press a button once to remove one garment, keep it depressed to remove all}

Import StorageUtil

SexLabFramework Property SexLab Auto ;points to the SexLab Framework script so we can use its functions
sslAnimationFactory Property sslAnimFactory Auto ;points to the SexLab sslAnimationFactory script so we can use its functions and properties
sslAnimationSlots Property sslAnimSlots Auto ;points to the SexLab sslAnimationSlots script so we can use its functions
sslSystemConfig Property SexLabSystemConfig Auto ;points to the SexLab's sslSystemConfig.psc script so we can use its functions

Actor Property PlayerRef Auto ;points to the player
Actor Property kCurrentActor Auto ;the actor that is currently animating
String[] Property HelmetKeywords Auto
String[] Property BodyKeywords Auto
String[] Property HandsKeywords Auto
String[] Property FeetKeywords Auto
String[] Property UnderwearKeywords Auto
Bool[] Property bSlotOverrideDefauList Auto

String Property SLSS_STRIPLIST_WEAPONSANDSHIELDS_R = "APPS.SerialStripList.WeaponsAndShieldsR" AutoReadOnly
String Property SLSS_STRIPLIST_WEAPONSANDSHIELDS_L = "APPS.SerialStripList.WeaponsAndShieldsL" AutoReadOnly
String Property SLSS_STRIPLIST_HANDS = "APPS.SerialStripList.Hands" AutoReadOnly
String Property SLSS_STRIPLIST_HELMET = "APPS.SerialStripList.Helmet" AutoReadOnly
String Property SLSS_STRIPLIST_FEET = "APPS.SerialStripList.Feet" AutoReadOnly
String Property SLSS_STRIPLIST_BODY = "APPS.SerialStripList.Body" AutoReadOnly
String Property SLSS_STRIPLIST_UNDERWEAR = "APPS.SerialStripList.Underwear" AutoReadOnly
String Property SLSS_STRIPLIST_OTHER = "APPS.SerialStripList.Other" AutoReadOnly

String Property SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_R = "APPS.SerialStrippedList.WeaponsAndShieldsR" AutoReadOnly
String Property SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_L = "APPS.SerialStrippedList.WeaponsAndShieldsL" AutoReadOnly
String Property SLSS_STRIPPEDLIST_HANDS = "APPS.SerialStrippedList.Hands" AutoReadOnly
String Property SLSS_STRIPPEDLIST_HELMET = "APPS.SerialStrippedList.Helmet" AutoReadOnly
String Property SLSS_STRIPPEDLIST_FEET = "APPS.SerialStrippedList.Feet" AutoReadOnly
String Property SLSS_STRIPPEDLIST_BODY = "APPS.SerialStrippedList.Body" AutoReadOnly
String Property SLSS_STRIPPEDLIST_UNDERWEAR = "APPS.SerialStrippedList.Underwear" AutoReadOnly
String Property SLSS_STRIPPEDLIST_OTHER = "APPS.SerialStrippedList.Other" AutoReadOnly

String Property sCurrentStripArray Auto ;the array that is currently animating i.e. the actor is playing the animation for stripping from this array
String Property sCurrentStrippedArray Auto ;the array that is currently holding the stripped items
String Property sWeaponsAndShieldsAnim Auto ;the name of the weapons and shields stripping animation
String Property sHandsAnim = "StripFArGl" AutoReadOnly ;the name of the hands stripping animation
String Property sHelmetAnim = "StripFArHe" AutoReadOnly ;the name of the helmet stripping animation
String Property sFeetAnim = "StripFArBo" AutoReadOnly ;the name of the feet stripping animation
String Property sBodyAnim = "StripFArChB" AutoReadOnly ;the name of the body stripping animation
String Property sUnderwearAnim = "StripFULB" AutoReadOnly ;the name of the underwear stripping animation
String Property sOtherAnim Auto ;the name of the "other" stripping animation
Float Property fWeaponsAndShieldsAnimDuration Auto ;the duration of the weapons and shields stripping animation
Float Property fHandsAnimDuration = 4.83 AutoReadOnly ;the duration of the hands stripping animation
Float Property fHelmetAnimDuration = 4.67 AutoReadOnly ;the duration of the helmet stripping animation
Float Property fFeetAnimDuration = 6.17 AutoReadOnly ;the duration of the feet stripping animation
Float Property fBodyAnimDuration = 4.67 AutoReadOnly ;the duration of the body stripping animation
Float Property fUnderwearAnimDuration = 3.1 AutoReadOnly ;the duration of the underwear stripping animation
Float Property fOtherAnimDuration Auto ;the name of the "other" stripping animation
Float Property fDurationForFullStrip = 2.0 Auto ;2 seconds cut-off point of key press: after this duration, the actor will strip fully
Int Property iStripKeyCode = 48 Auto ;B - the key that will be used to input stripping commands

Event OnInit()
	InitDefaultArrays()
	
	PrepareForStripping(PlayerRef, "", bSlotOverrideDefauList)
	SerialStripOn()
EndEvent

Function PrepareForStripping(Actor akActorRef, String asExceptionListKey = "", Bool[] abSlotOverrideList)
;/analyses items worn by akActorRef and puts them into 7 arrays for the actual
	stripping function to use.
akActorRef: actor to prepare
asExceptionListKey: name of the StorageUtil array holding items that will NOT be stripped
abSlotOverrideList: a 33-item-long array which defaults to False. Set any item [i] to True to override the user configuration
	for slot i+30 and force-strip it.
Returns a bool array whose 7 items indicate whether to strip from the 7 arrays or not
/;

	;/ beginValidation /;
	If (!akActorRef || abSlotOverrideList.Length != 33) 
		Return
	EndIf
	;/ endValidation /;

	Bool[] bArrayIsActive = new Bool[8]
	;/Activates or deactivates (and clears) the stripping arrays
	bArrayIsActive[0] WeaponsAndShieldsR
	bArrayIsActive[1] WeaponsAndShieldsL
	bArrayIsActive[2] Hands
	bArrayIsActive[3] Helmet
	bArrayIsActive[4] Feet
	bArrayIsActive[5] Body
	bArrayIsActive[6] Underwear
	;bras
	bArrayIsActive[7] Other
	;circlets
	;rings (right)
	;necklaces
	/;

	Int iGender = SexLab.GetGender(akActorRef) ;fetches the gender of the actor

	Bool[] bUserConfigSlots = new Bool[33] ;declares an array to hold the user's configuration

	If (iGender == 0) ;if the actor is male
		bUserConfigSlots = SexLabSystemConfig.GetStrip(IsFemale = False) ;fetch the user's MCM stripping configuration for males
	ElseIf (iGender == 1) ;if the actor is female
		bUserConfigSlots = SexLabSystemConfig.GetStrip(IsFemale = True) ;fetch the user's MCM stripping configuration for females
	EndIf

	;ARMOR

	;CREATING A LOOP to check all the item slots (forwards)
	Int i ;sets i to zero

	While (i <= 32) ;run this loop up to and including the slot 32

		Form kItemRef = akActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30)) ;fetch the item worn in this slot and load it in the kItemRef variable

		If ((FormListFind(None, asExceptionListKey, kItemRef) == -1)) ;if the item is not found in the exception array

			If (i + 30 == 31) || (ItemHasKeyword(kItemRef, HelmetKeywords)) ;if this item is in the hair slot OR has any of the helmet keywords
				FormListAdd(akActorRef, SLSS_STRIPLIST_HELMET, kItemRef, allowDuplicate = False) ;adds this item to the helmet undress list
			ElseIf (i + 30 == 32) || (ItemHasKeyword(kItemRef, BodyKeywords)) ;if this item is in the body slot OR has any of the body keywords
				FormListAdd(akActorRef, SLSS_STRIPLIST_BODY, kItemRef, allowDuplicate = False) ;adds this item to the body undress list
			ElseIf (i + 30 == 33) || (ItemHasKeyword(kItemRef, HandsKeywords)) ;if this item is in the hands slot OR has any of the hands keywords
				FormListAdd(akActorRef, SLSS_STRIPLIST_HANDS, kItemRef, allowDuplicate = False);adds this item to the hands undress list
			ElseIf (i + 30 == 37) || (ItemHasKeyword(kItemRef, FeetKeywords)) ;if this item is in the feet slot OR has any of the feet keywords
				FormListAdd(akActorRef, SLSS_STRIPLIST_FEET, kItemRef, allowDuplicate = False) ;adds this item to the feet undress list
			ElseIf (i + 30 == 52) || (ItemHasKeyword(kItemRef, UnderwearKeywords)) ;if this item is in the underwear slot OR has any of the underwear keywords
				FormListAdd(akActorRef, SLSS_STRIPLIST_UNDERWEAR, kItemRef, allowDuplicate = False) ;adds this item to the underwear undress list
			EndIf

			If (SexLab.IsStrippable(kItemRef) == True) ;if this item is strippable according to SexLab
				If (IsValidSlot(i, bUserConfigSlots, abSlotOverrideList)) ;if either the modder or the user have configured this slot to be strippable
					If ((i + 30 == 31) || FormListFind(akActorRef, SLSS_STRIPLIST_HELMET, kItemRef) != -1) ;if this is the hair slot (checking for helmets) OR we already know the item has one of the helmet keywords
						bArrayIsActive[3] = True ;activate the helmet stripping array
					ElseIf ((i + 30 == 32) || FormListFind(akActorRef, SLSS_STRIPLIST_BODY, kItemRef) != -1) ;if this is the body slot OR we already know the item has one of the body keywords
						bArrayIsActive[5] = True ;activate the body stripping array
					ElseIf ((i + 30 == 33) || FormListFind(akActorRef, SLSS_STRIPLIST_HANDS, kItemRef) != -1) ;if this is the hands slot OR we already know the item has one of the hands keywords
						bArrayIsActive[2] = True ;activate the hands stripping array
					ElseIf ((i + 30 == 37) || FormListFind(akActorRef, SLSS_STRIPLIST_FEET, kItemRef) != -1) ;if this is the feet slot OR we already know the item has one of the feet keywords
						bArrayIsActive[4] = True ;activate the feet stripping array
					ElseIf ((i + 30 == 52) || FormListFind(akActorRef, SLSS_STRIPLIST_UNDERWEAR, kItemRef) != -1) ;if this is the underwear slot OR we already know the item has one of the underwear keywords
						bArrayIsActive[6] = True ;activate the underwear stripping array
					Else
						FormListAdd(akActorRef, SLSS_STRIPLIST_OTHER, kItemRef, allowDuplicate = False) ;adds this item to the "other" undress list
						bArrayIsActive[7] = True ;activate the "other" stripping array
					EndIf
				EndIf
			EndIf
		EndIf
		i += 1 ;moves the loop to check the next slot (forwards)
	EndWhile

	;WEAPONS AND SHIELDS
	;In SexLab's StripFemale and StripMale arrays, this is item 32
	;weapons and shields employ a more economical logic

	Form kItemRef = akActorRef.GetEquippedWeapon(False) ;fetches right-hand weapon and puts it in kItemRef

	If ((FormListFind(None, asExceptionListKey, kItemRef) == -1)) ;if the item is not found in the exception array
		If (SexLab.IsStrippable(kItemRef) == True && IsValidSlot(32, bUserConfigSlots, abSlotOverrideList)) ;if this item is strippable according to SexLab and either the modder or the user have configured this slot to be strippable
			FormListAdd(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R, kItemRef, allowDuplicate = False) ;adds this item to the WeaponsAndShields undress list
			bArrayIsActive[0] = True ;activate the WeaponsAndShieldsR array
		EndIf
	EndIf

	kItemRef = akActorRef.GetEquippedWeapon(True) ;fetches left-hand weapon and puts it in kItemRef

	If ((FormListFind(None, asExceptionListKey, kItemRef) == -1)) ;if the item is not found in the exception array
		If (SexLab.IsStrippable(kItemRef) == True && IsValidSlot(i, bUserConfigSlots, abSlotOverrideList)) ;if this item is strippable according to SexLab and either the modder or the user have configured this slot to be strippable
			FormListAdd(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L, kItemRef, allowDuplicate = False) ;adds this item to the WeaponsAndShields undress list
			bArrayIsActive[1] = True ;activate the WeaponsAndShieldsL array
		EndIf
	EndIf

	;clears the arrays if they are not active (i.e. there's nothing strippable in them)
	ClearIfInactive(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R, bArrayIsActive[0])
	ClearIfInactive(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L, bArrayIsActive[1])
	ClearIfInactive(akActorRef, SLSS_STRIPLIST_HANDS, bArrayIsActive[2])
	ClearIfInactive(akActorRef, SLSS_STRIPLIST_HELMET, bArrayIsActive[3])
	ClearIfInactive(akActorRef, SLSS_STRIPLIST_FEET, bArrayIsActive[4])
	ClearIfInactive(akActorRef, SLSS_STRIPLIST_BODY, bArrayIsActive[5])
	ClearIfInactive(akActorRef, SLSS_STRIPLIST_UNDERWEAR, bArrayIsActive[6])
	ClearIfInactive(akActorRef, SLSS_STRIPLIST_OTHER, bArrayIsActive[7])

EndFunction

Event OnEquipped(Actor akActor)
	;run PrepareForStripping() after equip / unequip event
EndEvent

Function ClearIfInactive(Actor akActorRef, String asArrayName, Bool abIsArrayActive)
;clears the asArrayName array on akActorRef, depending on whether abIsArrayActive
	;/ beginValidation /;
	If (akActorRef == None || asArrayName == "")
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

	If (KeyCode == iStripKeyCode) ;if the key that was released is the key for serial stripping
		If (HoldTime < fDurationForFullStrip) ;if the key has not been held down long enough
			SingleSerialStrip() ;just strip one group of garments
		Else ;if the key has been held down long enough
			FullSerialStrip(PlayerRef) ;do a full strip
		EndIf
	EndIf
EndEvent

Function SingleSerialStrip()
;makes the actor strip one item/group of clothing (one array)

	If (FormListCount(PlayerRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R) > 0 ||  FormListCount(PlayerRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L) > 0) ;if the weapons or shields arrays (Right and Left) are not empty

		If (FormListCount(PlayerRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R) == 0) ;if the right hand array is empty i.e. the left is not empty
			SingleArrayAnimThenStrip(SLSS_STRIPLIST_WEAPONSANDSHIELDS_L, SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_L, sWeaponsAndShieldsAnim, fWeaponsAndShieldsAnimDuration) ;run the function to play the appropriate animation
		ElseIf (FormListCount(PlayerRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L) == 0) ;if the left hand array is empty i.e. the right is not empty
			SingleArrayAnimThenStrip(SLSS_STRIPLIST_WEAPONSANDSHIELDS_R, SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_R, sWeaponsAndShieldsAnim, fWeaponsAndShieldsAnimDuration) ;run the function to play the appropriate animation
		Else ;if both right and left hand arrays are not empty
			SingleArrayAnimThenStrip(SLSS_STRIPLIST_WEAPONSANDSHIELDS_R, SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_R, sWeaponsAndShieldsAnim, fWeaponsAndShieldsAnimDuration) ;run the function to play the appropriate animation
			SingleArrayAnimThenStrip(SLSS_STRIPLIST_WEAPONSANDSHIELDS_L, SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_L, "") ;run the function to just strip the left hand without playing an animation
		EndIf

	ElseIf (FormListCount(PlayerRef, SLSS_STRIPLIST_HANDS) > 0)
		SingleArrayAnimThenStrip(SLSS_STRIPLIST_HANDS, SLSS_STRIPPEDLIST_HANDS, sHandsAnim, fHandsAnimDuration) ;run the function to play the appropriate animation
	ElseIf (FormListCount(PlayerRef, SLSS_STRIPLIST_HELMET) > 0)
		SingleArrayAnimThenStrip(SLSS_STRIPLIST_HELMET, SLSS_STRIPPEDLIST_HELMET, sHelmetAnim, fHelmetAnimDuration) ;run the function to play the appropriate animation
	ElseIf (FormListCount(PlayerRef, SLSS_STRIPLIST_FEET) > 0)
		SingleArrayAnimThenStrip(SLSS_STRIPLIST_FEET, SLSS_STRIPPEDLIST_FEET, sFeetAnim, fFeetAnimDuration) ;run the function to play the appropriate animation
	ElseIf (FormListCount(PlayerRef, SLSS_STRIPLIST_BODY) > 0)
		SingleArrayAnimThenStrip(SLSS_STRIPLIST_BODY, SLSS_STRIPPEDLIST_BODY, sBodyAnim, fBodyAnimDuration) ;run the function to play the appropriate animation
	ElseIf (FormListCount(PlayerRef, SLSS_STRIPLIST_UNDERWEAR) > 0)
		SingleArrayAnimThenStrip(SLSS_STRIPLIST_UNDERWEAR, SLSS_STRIPPEDLIST_UNDERWEAR, sUnderwearAnim, fUnderwearAnimDuration) ;run the function to play the appropriate animation
	ElseIf (FormListCount(PlayerRef, SLSS_STRIPLIST_OTHER) > 0)
		SingleArrayAnimThenStrip(SLSS_STRIPLIST_OTHER, SLSS_STRIPPEDLIST_OTHER, sOtherAnim, fOtherAnimDuration) ;run the function to play the appropriate animation
	EndIf
EndFunction

Function SingleArrayAnimThenStrip(String asStripArray, String asStrippedArray, String asAnimation = "", Float afAnimDuration = 0.0)
;makes the player animate the stripping animation for a single group of clothing, then strips it

	Game.ForceThirdPerson() ;force third person camera mode
	Game.SetPlayerAIDriven(True) ;instead of DisablePlayerControls(True)

	If (PlayerRef.IsWeaponDrawn()) ;if the player has their weapon drawn
		PlayerRef.SheatheWeapon() ;make the player sheath their weapon
	EndIf

	kCurrentActor = PlayerRef ;sets the currently stripping actor to be the player
	sCurrentStripArray = asStripArray ;sets the currently stripping array to be asStripArray
	sCurrentStrippedArray = asStrippedArray ;sets the array currently holding the stripped items to be asStrippedArray

	If (asAnimation != "" && afAnimDuration != 0.0) ;if the function has been given an animation to play
		Debug.SendAnimationEvent(PlayerRef, asAnimation) ;makes the player play the stripping animation
		RegisterForSingleUpdate(afAnimDuration) ;registers to be notified when the animation ends - it will then strip the array by calling SingleArrayStrip()
	Else
		SingleArrayStrip(PlayerRef, sCurrentStripArray, sCurrentStrippedArray) ;go directly to stripping the array without animation
	EndIf
EndFunction

Event OnUpdate()
;when the script receives an update event
	SingleArrayStrip(kCurrentActor, sCurrentStripArray, sCurrentStrippedArray) ;strip this array (without animation - animation has hopefully been already played!)
EndEvent

Function SingleArrayStrip(Actor akActorRef, String asStripArray, String asStrippedArray)
;makes the player strip a single group of clothing

	;/ beginValidation /;
	If (akActorRef == None)
		Return
	EndIf
	;/ endValidation /;

	;WEAPONS, RIGHT HAND (weapons need to be treated differently)
	If (asStripArray == SLSS_STRIPLIST_WEAPONSANDSHIELDS_R) ;if she is stripping from the right hand

		Int i = FormListCount(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R) - 1 ;sets i equal to the length of the array (-1 because FormListCount's result is 1-based while the array is 0 based). this also validates the function i.e. if the array is empty, it will not check the loop.

		While (i >= 0) ;sets the loop to run up to and including position zero in the array (backwards)

			Form kItemRef = FormListGet(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R, i) ;fetches the item stored in i position in the array

			If (kItemRef != None) ;if this is an actual item, i.e. the array has not been cleared
				akActorRef.UnequipItemEX(kItemRef, 1) ;unequips this item from the actor's right hand
				FormListAdd(akActorRef, SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_R, kItemRef) ;adds the item to this array
			EndIf
			
			i -= 1 ;go to the next item in the array (backwards)
		EndWhile

		FormListClear(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R) ;clears the array

	;LEFT HAND
	ElseIf (asStripArray == SLSS_STRIPLIST_WEAPONSANDSHIELDS_L)
	;if she is stripping from the left hand

		Int i = FormListCount(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L) - 1 ;sets i equal to the length of the array (-1 because FormListCount's result is 1-based while the array is 0 based)

		While (i >= 0) ;sets the loop to run up to and including position zero in the array (backwards)

			Form kItemRef = FormListGet(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L, i) ;fetches the item stored in i position in the array

			If (kItemRef != None) ;if this is an actual item, i.e. the array has not been cleared
				akActorRef.UnequipItemEX(kItemRef, 2) ;unequips this item from the actor's right hand
				FormListAdd(akActorRef, SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_L, kItemRef) ;adds the item to this array
			EndIf

			i -= 1 ;go to the next item in the array (backwards)
		EndWhile

		FormListClear(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L) ;clears the array

	Else
	
	;ARMOR (non-weapon items are all handled in the same way)

		Int i = FormListCount(akActorRef, asStripArray) - 1 ;sets i equal to the length of the array (-1 because FormListCount's result is 1-based while the array is 0 based)

		While (i >= 0) ;sets the loop to run up to and including position zero in the array (backwards)
		
			Form kItemRef = FormListGet(akActorRef, asStripArray, i) ;fetches the item stored in i position in the array

			If (kItemRef != None) ;if this is an actual item, i.e. the array has not been cleared
				akActorRef.UnequipItem(kItemRef) ;unequips this item
				FormListAdd(akActorRef, asStrippedArray, kItemRef) ;adds the item to this array
			EndIf

			i -= 1 ;go to the next item in the array (backwards)
		EndWhile

		FormListClear(akActorRef, asStripArray) ;clears the array

	EndIf

	If (akActorRef == PlayerRef) ;if the stripping actor is the player, then we assume their controls have been deactivated by SetPlayerAIDriven(True)
		Game.SetPlayerAIDriven(False) ;give control back to the player
	EndIf

EndFunction

Function FullSerialStrip(Actor akActorRef)
;makes the actor play all the valid stripping animations and undress their corresponding groups of clothing

	;/ beginValidation /;
	If (akActorRef == None)
		Return
	EndIf
	;/ endValidation /;

	Int Stage ;declares a variable we can use to count the stages
	Int WeaponsAndShieldsStage ;the stage for stripping weapons and shields
	Int HandsStage ;the stage for stripping hands
	Int HelmetStage ;the stage for stripping the helmet
	Int FeetStage ;the stage for stripping feet
	Int BodyStage ;the stage for stripping body
	Int UnderwearStage ;the stage for stripping underwear
	Int OtherStage ;the stage for stripping other clothing items
	
	akActorRef.SheatheWeapon() ;makes the actor sheath her weapon

	;CREATE ephemeral animation
	SexLab.NewAnimationObject("FullStrippingAnimation", akActorRef) ;creates a new temporary animation and stores it on akActorRef
	sslBaseAnimation anim = sslAnimSlots.GetByRegistrar("FullStrippingAnimation") ;fetches the animation entry just created and stores it in anim

	If (anim != None) ;if the entry has indeed been created

		Int iGender = SexLab.GetGender(akActorRef) ;fetch the gender of the actor and store it in iGender

		anim.Name = "FullStrippingAnimation" ;set the name of the animation
		anim.SetContent(sslAnimFactory.Misc) ;set the content of the animation

		Int a1 = anim.AddPosition(iGender) ;sets the first (and only) actor in this animation

		If (FormListCount(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R) > 0 || FormListCount(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L) > 0) ;if either the right hand or the left hand weapon array are not empty
			If (sWeaponsAndShieldsAnim != "") ;if there is an animation for stripping weapons and shields
				anim.AddPositionStage(a1, sWeaponsAndShieldsAnim) ;add the weapons stripping as the first stage of the animation
				Stage += 1 ;increases stage by one
				WeaponsAndShieldsStage = Stage ;sets WeaponsAndShieldsStage equal to current stage
			EndIf
		EndIf

		If (FormListCount(akActorRef, SLSS_STRIPLIST_HANDS) > 0) ;if the hands array is not empty
			If (sHandsAnim != "") ;if there is an animation for stripping hands
				anim.AddPositionStage(a1, sHandsAnim) ;add the hands stripping animation as the next stage
				Stage += 1 ;increases stage by one
				HandsStage = Stage
				;sets HandsStage equal to current stage
			EndIf
		EndIf

		If (FormListCount(akActorRef, SLSS_STRIPLIST_HELMET) > 0) ;if the helmbet array is not empty
			If (sHelmetAnim != "") ;if there is an animation for stripping helmets
				anim.AddPositionStage(a1, sHelmetAnim) ;add the helmet stripping animation as the next stage
				Stage += 1 ;increases stage by one
				HelmetStage = Stage ;sets HelmetStage equal to current stage
			EndIf
		EndIf

		If (FormListCount(akActorRef, SLSS_STRIPLIST_FEET) > 0) ;if the feet array is not empty
			If (sFeetAnim != "") ;if there is an animation for stripping feet
				anim.AddPositionStage(a1, sFeetAnim) ;add the feet stripping animation as the next stage
				Stage += 1 ;increases stage by one
				FeetStage = Stage ;sets FeetStage equal to current stage
			EndIf
		EndIf

		If (FormListCount(akActorRef, SLSS_STRIPLIST_BODY) > 0) ;if the body array is not empty
			If (sBodyAnim != "") ;if there is an animation for stripping the body
				anim.AddPositionStage(a1, sBodyAnim) ;add the body stripping animation as the next stage
				Stage += 1 ;increases stage by one
				BodyStage = Stage ;sets BodyStage equal to current stage
			EndIf
		EndIf

		If (FormListCount(akActorRef, SLSS_STRIPLIST_UNDERWEAR) > 0) ;if the underwear array is not empty
			If (sUnderwearAnim != "") ;if there is an animation for stripping underwear
				anim.AddPositionStage(a1, sUnderwearAnim) ;add the underwear stripping animation as the next stage
				Stage += 1 ;increases stage by one
				UnderwearStage = Stage ;sets UnderwearStage equal to current stage
			EndIf
		EndIf

		If (FormListCount(akActorRef, SLSS_STRIPLIST_OTHER) > 0) ;if the "other items" array is not empty
			If (sOtherAnim != "") ;if there is an animation for stripping other
				anim.AddPositionStage(a1, sOtherAnim) ;add the other stripping animation as the next stage
				Stage += 1 ;increases stage by one
				OtherStage = Stage ;sets OtherStage equal to current stage
			EndIf
		EndIf

		anim.Save(sslAnimSlots.FindByName("FullStrippingAnimation")) ;saves the animation (has to be done before setting the timers)

		If (WeaponsAndShieldsStage != 0) ;if there is a weapons and shields stripping stage
			anim.SetStageTimer(WeaponsAndShieldsStage, fWeaponsAndShieldsAnimDuration)
		EndIf

		If (HandsStage != 0) ;if there is a hands stripping animation stage
			anim.SetStageTimer(HandsStage, fHandsAnimDuration)
		EndIf

		If (HelmetStage != 0) ;if there is a helmet stripping animation stage
			anim.SetStageTimer(HelmetStage, fHelmetAnimDuration)
		EndIf

		If (FeetStage != 0) ;if there is a feet stripping animation stage
			anim.SetStageTimer(FeetStage, fFeetAnimDuration)
		EndIf

		If (BodyStage != 0) ;if there is a body stripping animation stage
			anim.SetStageTimer(BodyStage, fBodyAnimDuration)
		EndIf

		If (OtherStage != 0) ;if there is a other stripping animation stage
			anim.SetStageTimer(OtherStage, fOtherAnimDuration)
		EndIf
	EndIf

	;CREATE a new SexLab thread to play the animation
	sslThreadModel thread = SexLab.NewThread();create a new animation thread

	thread.AddActor(akActorRef) ;adds the actor to the thread
	thread.CenterOnObject(akActorRef) ;centers the animation on the position the actor was in
	thread.DisableUndressAnimation(akActorRef, True) ;disables SexLab's default undressing animation. We'll use our own.
	thread.DisableRagdollEnd(akActorRef, True) ;disables SexLab's auto-ragdoll on animation end
	thread.DisableRedress(akActorRef, True) ;disables SexLab's auto redress on animation end
	thread.AddAnimation(SexLab.GetAnimationByName("FullStrippingAnimation")) ;sets the animation for stripping weapons and shields
	thread.SetHook("FullStrippingAnimation") ;sets a hook for this animation so we can selectively catch its events
	RegisterForModEvent("StageStart_FullStrippingAnimation", "OnStripStageStart") ;registers to be notified when each stripping stage begins
	thread.StartThread() ;starts the thread (starts the animation)

EndFunction

Event OnStripStageStart(string eventName, string argString, float argNum, form sender)
;when a stripping animation stage starts

	Actor[] actorList = SexLab.HookActors(argString) ;fetches the list of actors (should be only 1) and stores it into the actorList array

	Actor kActor = actorList[0] ;fetches the first and only entry in the actorList and stores it into kActor

	If (FormListCount(kActor, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R) > 0 || FormListCount(kActor, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L) > 0) ;if either the right hand or the left hand weapon array are not empty
		Utility.Wait(fWeaponsAndShieldsAnimDuration) ;wait until the animation has ended before unequipping items
		SingleArrayStrip(kActor, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R, SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_R) ;strips the actor of this group of clothing and stores stripped items into the array
		SingleArrayStrip(kActor, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L, SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_L) ;strips the actor of this group of clothing and sores stripped items into the array
	ElseIf (FormListCount(kActor, SLSS_STRIPLIST_HELMET) > 0) ;if the helmbet array is not empty
		Utility.Wait(fHelmetAnimDuration)
		SingleArrayStrip(kActor, SLSS_STRIPLIST_HELMET, SLSS_STRIPPEDLIST_HELMET);strips the actor of this group of clothing and stores stripped items into the array
	ElseIf (FormListCount(kActor, SLSS_STRIPLIST_FEET) > 0) ;if the feet array is not empty
		Utility.Wait(fFeetAnimDuration)
		SingleArrayStrip(kActor, SLSS_STRIPLIST_FEET, SLSS_STRIPPEDLIST_FEET) ;strips the actor of this group of clothing and stores stripped items into the array
	ElseIf (FormListCount(kActor, SLSS_STRIPLIST_BODY) > 0) ;if the body array is not empty
		Utility.Wait(fBodyAnimDuration)
		SingleArrayStrip(kActor, SLSS_STRIPLIST_BODY, SLSS_STRIPPEDLIST_BODY) ;strips the actor of this group of clothing and stores stripped items into the array
	ElseIf (FormListCount(kActor, SLSS_STRIPLIST_UNDERWEAR) > 0) ;if the underwear array is not empty
		Utility.Wait(fUnderwearAnimDuration)
		SingleArrayStrip(kActor, SLSS_STRIPLIST_UNDERWEAR, SLSS_STRIPPEDLIST_UNDERWEAR) ;strips the actor of this group of clothing and stores stripped items into the array
	ElseIf (FormListCount(kActor, SLSS_STRIPLIST_OTHER) > 0) ;if the "other items" array is not empty
		Utility.Wait(fOtherAnimDuration)
		SingleArrayStrip(kActor, SLSS_STRIPLIST_OTHER, SLSS_STRIPPEDLIST_OTHER) ;strips the actor of this group of clothing and stores stripped items into the array
	EndIf

EndEvent

Function InitDefaultArrays()
	bSlotOverrideDefauList = New Bool[33]
	
	Int i
	
	While (i < 33)
		bSlotOverrideDefauList[i] = False
		i += 1
	EndWhile
EndFunction

;/ Animation Descriptions & Durations

StripFArGl		Remove Gloves
StripFArGl		Remove Helmet
StripFArBo		Remove Boots
StripFArNoUS	Remove Torso?
StripFArChB		Remove Torso?
StripFClGl		Equip Gloves
StripFClHo		Equip Helmet
StripFClBo		Equip Boots
StripFClCi		Equip Circlet
StripFClChB		Equip Torso
StripFULB		Remove Panties
StripFUUB		Remove Bra
StripFJN		Equip Ring
StripFJC		Remove Ring

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

;/leftover code

Function StripWeaponsAndShields(Actor akActorRef)
;makes the actor strip weapons and shields

	If (akActorRef == None)
	;validation
		Return
	EndIf

	If (akActorRef == PlayerRef)
	;if the actor stripping is the player

		DisablePlayerControls(True)
		;disables player's controls

	EndIf

	sslThreadModel th = SexLab.NewThread()
	;starts a new SexLab thread called "th"

	th.AddActor(akActorRef)
	;adds akActorRef to the thread
	th.DisableUndressAnimation(akActorRef, True)
	;disables SexLab's default undressing animation. We'll use our own.
	th.DisableRagdollEnd(akActorRef, True)
	;disables SexLab's auto-ragdoll on animation end
	th.DisableRedress(akActorRef, True)
	;disables SexLab's auto redress on animation end
	th.SetAnimations(SexLab.GetAnimationByName(sWeaponsAndShieldsAnim))
	;sets the animation for stripping weapons and shields
	th.SetHook("StripWeaponsAndShields")
	;sets a hook for this animation

	RegisterForModEvent("AnimationEnd_StripWeaponsAndShields", "OnWeaponsAndShieldsStripped")

	th.StartThread()

EndFunction

Event OnWeaponsAndShieldsStripped(string eventName, string argString, float argNum, form sender)
;when the animation for stripping weapons and shields has finished

	Actor[] Actors = SexLab.HookActors(argString)
	;fetches the actor that just stripped her weapons and loads her into the array

	Actor akActorRef = Actors[0]

	;RIGHT HAND
	Int i = FormListCount(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R) - 1
	;sets i equal to the length of the array (-1 because FormListCount's result is 1-based while the array is 0 based)

	While i >= 0
	;sets the loop to run up to and including position zero in the array (backwards)

		Form kItemRef = FormListGet(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R, i)
		;fetches the item stored in i position in the array

		akActorRef.UnequipItemEX(kItemRef, 1)
		;unequips this item from the actor's right hand

		FormListAdd(akActorRef, SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_R, kItemRef)
		;adds the item to this array

		i -= 1
		;go to the next item in the array (backwards)

	EndWhile

	FormListClear(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R)
	;clears the array

	;LEFT HAND
	i = FormListCount(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L) - 1
	;sets i equal to the length of the array (-1 because FormListCount's result is 1-based while the array is 0 based)

	While i >= 0
	;sets the loop to run up to and including position zero in the array (backwards)

		Form kItemRef = FormListGet(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L, i)
		;fetches the item stored in i position in the array

		akActorRef.UnequipItemEX(kItemRef, 2)
		;unequips this item from the actor's right hand

		FormListAdd(akActorRef, SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_L, kItemRef)
		;adds the item to this array

		i -= 1
		;go to the next item in the array (backwards)

	EndWhile

	FormListClear(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L)
	;clears the array


	If (akActorRef == PlayerRef)
	;if the actor stripping is the player

		DisablePlayerControls(True)
		;disables player's controls

	EndIf

EndEvent



;/
-----------------------------------------------------------

	STATES

-----------------------------------------------------------
/;

;/
	Form[] ToStrip = new Form[34]
	;declares a 34 item long array to hold the items to be stripped

	Form kItemRef
	;declares this variable to temporarily store each item we're working on

	;ARMORS

		;CREATING A LOOP to run through all the possible slots (backwards)
		Int i = 31
		;sets i equal to 31 in order to run through 32 items in the array (0 -> 31 equals 32).

		While (i >= 0)
		;run this loop up to and including item at position 0

			kItemRef = akActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30)
			;fetch the item worn in this slot and load it in kItemRef

			If ((IsStrippableEnhanced(kItemRef, NoStripKeywords) == False)
			;if the item on this slot is not strippable
			;IF GIVEN NoStripKeywords ARRAY, IT WILL RUN A LOOP
				ToStrip[i] == False
				;mark this slot as not to be stripped
			ElseIf (SlotsToCheck[i] == True || ItemHasKeyword(kItemRef, KeywordsToCheck) == True)
			;if this slot was given in the SlotsToCheck array or has any keyword given in the KeywordsToCheck array
			;TO CHECK ItemHasKeyword IT WILL RUN A LOOP
				ToStrip[i] == True
				;mark this slot to be stripped
			EndIf
			i -= 1
			;move the next item in the loop (backwards)
		EndWhile


	;WEAPONS

		kItemRef = akActorRef.GetEquippedWeapon(False)
		;fetches right-hand weapon and puts it in kItemRef

		If ((IsStrippableEnhanced(kItemRef, NoStripKeywords) == False)
		;if the item on this slot is not strippable
			ToStrip[33] = False
			;marks this slot (hence this item) to not strip
		ElseIf (SlotsToCheck[33] == True || ItemHasKeyword(kItemRef, KeywordsToCheck) == True)
		;if this slot was given in the SlotsToCheck array or has any keyword given in the KeywordsToCheck array
			ToStrip[33] == True
			;marks this slot to strip
		EndIf


		kItemRef = akActorRef.GetEquippedWeapon(True)
		;fetches left-hand weapon and puts it in kItemRef

		If ((IsStrippableEnhanced(kItemRef, NoStripKeywords) == False)
		;if the item on this slot is not strippable
			ToStrip[32] = False
			;marks this slot (hence this item) to not strip
		ElseIf (SlotsToCheck[32] == True || ItemHasKeyword(kItemRef, KeywordsToCheck) == True)
		;if this slot was given in the SlotsToCheck array or has any keyword given in the KeywordsToCheck array
			ToStrip[32] == True
		EndIf

	Return ToStrip
EndFunction
/;

;/
Bool Function IsStrippableEnhanced(Form kItemRef, String[] NoStripKeywords)
;checks the item with SexLab's IsStrippable(), then checks again for NoStripKeywords
;/QUESTION: I put IsStrippable() and ItemHasKeyword() in If/ElseIf block to avoid
running 2 loops if not needed. Is this correct or should I check with an OR clause?


	If (SexLab.IsStrippable(kItemRef) == False)
	;if the item is checked by SexLab's IsStrippable() and is deemed un-strippable
		Return False

	ElseIf (ItemHasKeyword(kItemRef, NoStripKeywords)
	;if this item has any of the NoStripKeywords
		Return False

	Else
		Return True
	EndIf
EndFunction
/;


	;/do a loop into a loop. first loop run through all the slots, second loop through the keywords to check.
	remove items with the keywords we want, then re-check which slots have been left and if they are one of the 4 slots we want, unequip/;

;/SexLab's script
Form[] function StripSlots(Actor ActorRef, bool[] Strip, bool DoAnimate = False, bool AllowNudesuit = True)
	if Strip.Length != 33
		Return None
	endIf
	Int Gender = ActorRef.GetLeveledActorBase().GetSex()
	; Start stripping animation
	if DoAnimate
		Debug.SendAnimationEvent(ActorRef, "Arrok_Undress_G"+Gender)
	endIf
	; Get Nudesuit
	bool UseNudeSuit = Strip[2] && ((Gender == 0 && Config.UseMaleNudeSuit) || (Gender == 1 && Config.UseFemaleNudeSuit))
	if UseNudeSuit && ActorRef.GetItemCount(Config.NudeSuit) < 1
		ActorRef.AddItem(Config.NudeSuit, 1, True)
	endIf
	; Stripped storage
	Form[] Stripped = new Form[34]
	Form kItemRef
	; Strip weapon
	if Strip[32]
		; Right hand
		kItemRef = ActorRef.GetEquippedWeapon(False)
		if IsStrippable(kItemRef)
			ActorRef.UnequipItemEX(kItemRef, 1, False)
			Stripped[33] = kItemRef
		endIf
		; Left hand
		kItemRef = ActorRef.GetEquippedWeapon(True)
		if IsStrippable(kItemRef)
			ActorRef.UnequipItemEX(kItemRef, 2, False)
			Stripped[32] = kItemRef
		endIf
	endIf
	; Strip armors
	Int i = Strip.RFind(True, 31)
	while i >= 0
		if Strip[i]
			; Grab item in slot
			kItemRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30))
			if IsStrippable(kItemRef)
				ActorRef.UnequipItem(kItemRef, False, True)
				Stripped[i] = kItemRef
			endIf
		endIf
		i -= 1
	endWhile
	; Apply Nudesuit
	if UseNudeSuit
		ActorRef.EquipItem(NudeSuit, True, True)
	endIf
	; output stripped items
	Return sslUtility.ClearNone(Stripped)
endFunction
;/

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
StripFArGl		Remove Gloves 4.83 sec
StripFArHe		Remove Helmet 4.67 sec
StripFArBo		Remove Boots 6.17 sec
StripFArNoUS	Remove Torso (no underwear shy)
StripFArChB		Remove Torso 4.67 sec
StripFClGl		Equip Gloves 2.83 sec
StripFClHo		Equip Helmet 2.83 sec
StripFClBo		Equip Boots 6.17 sec
StripFClCi		Equip Circlet 2.83 sec
StripFClChB		Equip Torso 6.03 sec
StripFULB		Remove Panties 3.1 sec
StripFUUB		Remove Bra 3.5 sec
StripFJN		Equip Ring 2.5 sec
StripFJC		Remove Ring 2.5 sec
/;