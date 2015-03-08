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
Idle Property WeaponsAndShieldsAnim Auto ;the name of the weapons and shields stripping animation
Idle Property StripFArGl Auto ;the name of the hands stripping animation
Idle Property StripFArHe Auto ;the name of the helmet stripping animation
Idle Property StripFArBo Auto ;the name of the feet stripping animation
Idle Property StripFArChB Auto ;the name of the body stripping animation
Idle Property StripFULB Auto ;the name of the underwear stripping animation
Idle Property OtherAnim Auto ;the name of the "other" stripping animation
Float Property fWeaponsAndShieldsAnimDuration = 0.5 AutoReadOnly ;the duration of the weapons and shields stripping animation
Float Property fHandsAnimDuration = 4.83 Auto ;the duration of the hands stripping animation
Float Property fHelmetAnimDuration = 4.67 Auto ;the duration of the helmet stripping animation
Float Property fFeetAnimDuration = 6.17 Auto ;the duration of the feet stripping animation (increased by 0.5 seconds)
Float Property fBodyAnimDuration = 4.67 Auto ;the duration of the body stripping animation
Float Property fUnderwearAnimDuration = 3.1 Auto ;the duration of the underwear stripping animation
Float Property fOtherAnimDuration = 0.5 AutoReadOnly ;the name of the "other" stripping animation
Float Property fDurationForFullStrip = 2.0 AutoReadOnly ;2 seconds cut-off point of key press: after this duration, the actor will strip fully
Int Property iStripKeyCode = 48 AutoReadOnly ;B - the key that will be used to input stripping commands
Bool Property bFullSerialStripSwitch Auto ;switches to full stripping
Bool Property bIsSheathing Auto ;notifys script that actor is sheathing
Form Property EventSender Auto ;stores the form that initiated the stripping

Event OnInit()
	InitDefaultArrays()
	SerialStripOn()
EndEvent

Function InitDefaultArrays()
	bSlotOverrideDefauList = New Bool[33]
	Int i

	While (i < 33)
		bSlotOverrideDefauList[i] = False
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
	PrepareForStripping(PlayerRef, bSlotOverrideDefauList)
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

Function SingleArrayAnimThenStrip(String asStripArray, String asStrippedArray, Idle akAnimation = None, Float afAnimDuration = 0.0, Bool abDontStop = False)
EndFunction

Function SingleArrayStrip(Actor akActorRef, String asStripArray, String asStrippedArray, Bool abDontStop = False)
EndFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
EndEvent

State Stripping

	Function PrepareForStripping(Actor akActorRef, Bool[] abSlotOverrideList, String asExceptionList = "")
	;/analyses items worn by akActorRef and puts them into 7 arrays for the actual
		stripping function to use.
	akActorRef: actor to prepare
	asExceptionList: name of the StorageUtil array holding items that will NOT be stripped
	abSlotOverrideList: a 33-item-long array which defaults to False. Set any item [i] to True to override the user configuration
		for slot i+30 and force-strip it.
	Returns a bool array whose 7 items indicate whether to strip from the 7 arrays or not
	/;

		;/ beginValidation /;
		If (!akActorRef || abSlotOverrideList.Length != 33)
			Return
		EndIf
		;/ endValidation /;

		;clear all the arrays before filling them
		FormListClear(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R)
		FormListClear(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L)
		FormListClear(akActorRef, SLSS_STRIPLIST_HANDS)
		FormListClear(akActorRef, SLSS_STRIPLIST_HELMET)
		FormListClear(akActorRef, SLSS_STRIPLIST_FEET)
		FormListClear(akActorRef, SLSS_STRIPLIST_BODY)
		FormListClear(akActorRef, SLSS_STRIPLIST_UNDERWEAR)
		FormListClear(akActorRef, SLSS_STRIPLIST_OTHER)

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
						FormListAdd(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L, kItemRef, allowDuplicate = False) ;adds this item to the WeaponsAndShields undress list
						bArrayIsActive[1] = True ;activate the WeaponsAndShieldsL array
					EndIf
				EndIf
			ElseIf (akActorRef.GetEquippedItemType(0) && akActorRef.GetEquippedItemType(0) != 9) ;if there is a weapon in the left hand (i.e. not just fists or a spell)
				Form kItemRef = akActorRef.GetEquippedWeapon(True) ;fetches left-hand weapon and puts it in kItemRef

				If ((FormListFind(None, asExceptionList, kItemRef) == -1)) ;if the item is not found in the exception array
					If (SexLab.IsStrippable(kItemRef) == True && IsValidSlot(32, bUserConfigSlots, abSlotOverrideList)) ;if this item is strippable according to SexLab and either the modder or the user have configured this slot to be strippable
						FormListAdd(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L, kItemRef, allowDuplicate = False) ;adds this item to the WeaponsAndShields undress list
						bArrayIsActive[1] = True ;activate the WeaponsAndShieldsL array
					EndIf
				EndIf
			EndIf
		EndIf

		If (akActorRef.GetEquippedItemType(1) && akActorRef.GetEquippedItemType(1) != 9) ;if there is a weapon in the right hand (i.e. not just fists or a spell)
			Form kItemRef = akActorRef.GetEquippedWeapon(False) ;fetches right-hand weapon and puts it in kItemRef

			If ((FormListFind(None, asExceptionList, kItemRef) == -1)) ;if the item is not found in the exception array
				If (SexLab.IsStrippable(kItemRef) == True && IsValidSlot(32, bUserConfigSlots, abSlotOverrideList)) ;if this item is strippable according to SexLab and either the modder or the user have configured this slot to be strippable
					FormListAdd(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R, kItemRef, allowDuplicate = False) ;adds this item to the WeaponsAndShields undress list
					bArrayIsActive[0] = True ;activate the WeaponsAndShieldsR array
				EndIf
			EndIf
		EndIf

		;ARMOR

		;CREATING A LOOP to check all the item slots (forwards)
		Int i ;sets i to zero

		While (i <= 31) ;run this loop up to and including the node 61 (http://www.creationkit.com/Biped_Object)
			Form kItemRef = akActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30)) ;fetch the item worn in this slot and load it in the kItemRef variable

			If (kItemRef && FormListFind(None, asExceptionList, kItemRef) == -1) ;if there is an item in this slot and it is not found in the exception array

				If (i + 30 == 33) || (ItemHasKeyword(kItemRef, HandsKeywords)) ;if this item is in the hands slot OR has any of the hands keywords
					FormListAdd(akActorRef, SLSS_STRIPLIST_HANDS, kItemRef, allowDuplicate = False);adds this item to the hands undress list
				ElseIf (i + 30 == 31) || (ItemHasKeyword(kItemRef, HelmetKeywords)) ;if this item is in the hair slot OR has any of the helmet keywords
					FormListAdd(akActorRef, SLSS_STRIPLIST_HELMET, kItemRef, allowDuplicate = False) ;adds this item to the helmet undress list
				ElseIf (i + 30 == 37) || (ItemHasKeyword(kItemRef, FeetKeywords)) ;if this item is in the feet slot OR has any of the feet keywords
					FormListAdd(akActorRef, SLSS_STRIPLIST_FEET, kItemRef, allowDuplicate = False) ;adds this item to the feet undress list
				ElseIf (i + 30 == 32) || (ItemHasKeyword(kItemRef, BodyKeywords)) ;if this item is in the body slot OR has any of the body keywords
					FormListAdd(akActorRef, SLSS_STRIPLIST_BODY, kItemRef, allowDuplicate = False) ;adds this item to the body undress list
				ElseIf (i + 30 == 52) || (ItemHasKeyword(kItemRef, UnderwearKeywords)) ;if this item is in the underwear slot OR has any of the underwear keywords
					FormListAdd(akActorRef, SLSS_STRIPLIST_UNDERWEAR, kItemRef, allowDuplicate = False) ;adds this item to the underwear undress list
				EndIf

				If (SexLab.IsStrippable(kItemRef) == True) ;if this item is strippable according to SexLab
					If (IsValidSlot(i, bUserConfigSlots, abSlotOverrideList)) ;if either the modder or the user have configured this slot to be strippable
						If ((i + 30 == 33) || FormListFind(akActorRef, SLSS_STRIPLIST_HANDS, kItemRef) != -1) ;if this is the hands slot OR we already know the item has one of the hands keywords
							bArrayIsActive[2] = True ;activate the hands stripping array
						ElseIf ((i + 30 == 31) || FormListFind(akActorRef, SLSS_STRIPLIST_HELMET, kItemRef) != -1) ;if this is the hair slot (checking for helmets) OR we already know the item has one of the helmet keywords
							bArrayIsActive[3] = True ;activate the helmet stripping array
						ElseIf ((i + 30 == 37) || FormListFind(akActorRef, SLSS_STRIPLIST_FEET, kItemRef) != -1) ;if this is the feet slot OR we already know the item has one of the feet keywords
							bArrayIsActive[4] = True ;activate the feet stripping array
						ElseIf ((i + 30 == 32) || FormListFind(akActorRef, SLSS_STRIPLIST_BODY, kItemRef) != -1) ;if this is the body slot OR we already know the item has one of the body keywords
							bArrayIsActive[5] = True ;activate the body stripping array
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

		;clears the arrays if they are not active (i.e. there's nothing strippable in them)
		ClearIfInactive(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R, bArrayIsActive[0])
		ClearIfInactive(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L, bArrayIsActive[1])
		ClearIfInactive(akActorRef, SLSS_STRIPLIST_HANDS, bArrayIsActive[2])
		ClearIfInactive(akActorRef, SLSS_STRIPLIST_HELMET, bArrayIsActive[3])
		ClearIfInactive(akActorRef, SLSS_STRIPLIST_FEET, bArrayIsActive[4])
		ClearIfInactive(akActorRef, SLSS_STRIPLIST_BODY, bArrayIsActive[5])
		ClearIfInactive(akActorRef, SLSS_STRIPLIST_UNDERWEAR, bArrayIsActive[6])
		ClearIfInactive(akActorRef, SLSS_STRIPLIST_OTHER, bArrayIsActive[7])

		Debug.Trace("Array " + SLSS_STRIPLIST_WEAPONSANDSHIELDS_R + " contains " + FormListCount(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R) + " elements.")
		Debug.Trace("Array " + SLSS_STRIPLIST_WEAPONSANDSHIELDS_L + " contains " + FormListCount(akActorRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L) + " elements.")
		Debug.Trace("Array " + SLSS_STRIPLIST_HANDS + " contains " + FormListCount(akActorRef, SLSS_STRIPLIST_HANDS) + " elements.")
		Debug.Trace("Array " + SLSS_STRIPLIST_HELMET + " contains " + FormListCount(akActorRef, SLSS_STRIPLIST_HELMET) + " elements.")
		Debug.Trace("Array " + SLSS_STRIPLIST_FEET + " contains " + FormListCount(akActorRef, SLSS_STRIPLIST_FEET) + " elements.")
		Debug.Trace("Array " + SLSS_STRIPLIST_BODY + " contains " + FormListCount(akActorRef, SLSS_STRIPLIST_BODY) + " elements.")
		Debug.Trace("Array " + SLSS_STRIPLIST_UNDERWEAR + " contains " + FormListCount(akActorRef, SLSS_STRIPLIST_UNDERWEAR) + " elements.")
		Debug.Trace("Array " + SLSS_STRIPLIST_OTHER + " contains " + FormListCount(akActorRef, SLSS_STRIPLIST_OTHER) + " elements.")
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

		If (FormListCount(PlayerRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R) > 0 ||  FormListCount(PlayerRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L) > 0) ;if the weapons or shields arrays (Right and Left) are not empty

			;until we have special weapons stripping animation, this is being deprecated later on in SingleArrayAnimThenStrip()
			If (FormListCount(PlayerRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_R) == 0) ;if the right hand array is empty i.e. the left is not empty
				SingleArrayAnimThenStrip(SLSS_STRIPLIST_WEAPONSANDSHIELDS_L, SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_L, WeaponsAndShieldsAnim, fWeaponsAndShieldsAnimDuration) ;run the function to play the appropriate animation
			ElseIf (FormListCount(PlayerRef, SLSS_STRIPLIST_WEAPONSANDSHIELDS_L) == 0) ;if the left hand array is empty i.e. the right is not empty
				SingleArrayAnimThenStrip(SLSS_STRIPLIST_WEAPONSANDSHIELDS_R, SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_R, WeaponsAndShieldsAnim, fWeaponsAndShieldsAnimDuration) ;run the function to play the appropriate animation
			Else ;if both right and left hand arrays are not empty
				SingleArrayAnimThenStrip(SLSS_STRIPLIST_WEAPONSANDSHIELDS_R, SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_R, WeaponsAndShieldsAnim, fWeaponsAndShieldsAnimDuration, abDontStop = True) ;run the function to play the appropriate animation and continue to strip the left hand too
				SingleArrayAnimThenStrip(SLSS_STRIPLIST_WEAPONSANDSHIELDS_L, SLSS_STRIPPEDLIST_WEAPONSANDSHIELDS_L) ;run the function to just strip the left hand without playing an animation
			EndIf
		ElseIf (FormListCount(PlayerRef, SLSS_STRIPLIST_HANDS) > 0)
			SingleArrayAnimThenStrip(SLSS_STRIPLIST_HANDS, SLSS_STRIPPEDLIST_HANDS, StripFArGl, fHandsAnimDuration) ;run the function to play the appropriate animation
		ElseIf (FormListCount(PlayerRef, SLSS_STRIPLIST_HELMET) > 0)
			SingleArrayAnimThenStrip(SLSS_STRIPLIST_HELMET, SLSS_STRIPPEDLIST_HELMET, StripFArHe, fHelmetAnimDuration) ;run the function to play the appropriate animation
		ElseIf (FormListCount(PlayerRef, SLSS_STRIPLIST_FEET) > 0)
			SingleArrayAnimThenStrip(SLSS_STRIPLIST_FEET, SLSS_STRIPPEDLIST_FEET, StripFArBo, fFeetAnimDuration) ;run the function to play the appropriate animation
		ElseIf (FormListCount(PlayerRef, SLSS_STRIPLIST_BODY) > 0)
			SingleArrayAnimThenStrip(SLSS_STRIPLIST_BODY, SLSS_STRIPPEDLIST_BODY, StripFArChB, fBodyAnimDuration) ;run the function to play the appropriate animation
		ElseIf (FormListCount(PlayerRef, SLSS_STRIPLIST_UNDERWEAR) > 0)
			SingleArrayAnimThenStrip(SLSS_STRIPLIST_UNDERWEAR, SLSS_STRIPPEDLIST_UNDERWEAR, StripFULB, fUnderwearAnimDuration) ;run the function to play the appropriate animation
		ElseIf (FormListCount(PlayerRef, SLSS_STRIPLIST_OTHER) > 0)
			SingleArrayAnimThenStrip(SLSS_STRIPLIST_OTHER, SLSS_STRIPPEDLIST_OTHER, OtherAnim, fOtherAnimDuration) ;run the function to play the appropriate animation
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

	Function SingleArrayAnimThenStrip(String asStripArray, String asStrippedArray, Idle akAnimation = None, Float afAnimDuration = 0.0, Bool abDontStop = False)
	;makes the player animate the stripping animation for a single group of clothing, then strips it

		kCurrentActor = PlayerRef ;sets the currently stripping actor to be the player
		sCurrentStripArray = asStripArray ;sets the currently stripping array to be asStripArray
		sCurrentStrippedArray = asStrippedArray ;sets the array currently holding the stripped items to be asStrippedArray

		If (akAnimation && afAnimDuration) ;if the function has been given an animation to play
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

StripFArGl		Remove Armor Gloves
StripFArHe		Remove Armor Helmet
StripFArBo		Remove Armor Boots
StripFArNoUS	Remove it - Thats an incomplete chest "shy" version
StripFArChB		Remove Armor chestpiece
StripFClGl		Remove Cloth Gloves
StripFClHo		Remove Cloth Hood
StripFClBo		Remove Cloth Boots
StripFClCi		Remove Cloth Circlet
StripFClChB		Remove Cloth Dress
StripFULB		Remove Panties
StripFUUB		Remove Bra
StripFJN		Remove Necklace
StripFJR		Remove Ring

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