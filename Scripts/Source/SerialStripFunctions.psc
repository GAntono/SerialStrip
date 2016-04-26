ScriptName SerialStripFunctions Extends Quest
{serial undressing: remove one garment at a time, with animations}

Import StorageUtil

String Property SS_Version = "v1.1.2" AutoReadOnly Hidden

Actor Property PlayerRef Auto ;points to the player
;Actor Property kCurrentActor Auto Hidden ;the actor that is currently animating
String Property SS_STRIPPINGACTORS = "APPS.SerialStrip.StrippingActors" AutoReadOnly Hidden

;String Property sCurrentStripArray Auto Hidden ;the array that is currently animating i.e. the actor is playing the animation for stripping from this array
String Property SS_CURRENTSTRIPARRAY = "APPS.SerialStrip.CurrentStripArray" AutoReadOnly Hidden
;String Property sCurrentStrippedArray Auto Hidden ;the array that is currently holding the stripped items
String Property SS_CURRENTSTRIPPEDARRAY = "APPS.SerialStrip.CurrentStrippedArray" AutoReadOnly Hidden

String WeaponsAndShieldsAnim ;the name of the weapons and shields stripping animation
String OtherAnim ;the name of the "other" stripping animation

Bool[] Property bAllTrueList Auto Hidden
Bool[] Property bAllFalseList Auto Hidden
;Bool Property bFullSerialStripSwitch Auto Hidden ;switches to full stripping
String Property SS_FULLSERIALSTRIPSWITCH = "APPS.SerialStrip.FullSerialStripSwitch" AutoReadOnly Hidden
;Bool Property IsSexLabInstalled Auto Hidden
;Bool Property bIsSheathing Auto Hidden ;notifys script that actor is sheathing
String Property SS_ISSHEATHING = "APPS.SerialStrip.IsSheathing" AutoReadOnly Hidden
;Form Property EventSender Auto Hidden ;stores the form that initiated the stripping
String Property SS_EVENTSENDER = "APPS.SerialStrip.EventSender" AutoReadOnly Hidden
String Property SS_SLOTOVERRIDELIST = "APPS.SerialStrip.SlotOverrideList" AutoReadOnly Hidden
Package Property DoNothing Auto
Static Property XMarker Auto
ObjectReference Property Marker Auto Hidden

;/ openFold /;
String Property SS_STRIPLIST_WEAPONSANDSHIELDS_R = "APPS.SerialStripList.WeaponsAndShieldsR" AutoReadOnly  Hidden
String Property SS_STRIPLIST_WEAPONSANDSHIELDS_L = "APPS.SerialStripList.WeaponsAndShieldsL" AutoReadOnly  Hidden
String Property SS_STRIPLIST_GLOVES = "APPS.SerialStripList.Gloves" AutoReadOnly  Hidden
String Property SS_STRIPLIST_HELMET = "APPS.SerialStripList.Helmet" AutoReadOnly  Hidden
String Property SS_STRIPLIST_BOOTS = "APPS.SerialStripList.Boots" AutoReadOnly  Hidden
String Property SS_STRIPLIST_CHESTPIECE = "APPS.SerialStripList.Chestpiece" AutoReadOnly  Hidden
String Property SS_STRIPLIST_NECKLACE = "APPS.SerialStripList.Necklace" AutoReadOnly  Hidden
String Property SS_STRIPLIST_CIRCLET = "APPS.SerialStripList.Circlet" AutoReadOnly  Hidden
String Property SS_STRIPLIST_RING = "APPS.SerialStripList.Ring" AutoReadOnly  Hidden
String Property SS_STRIPLIST_BRA = "APPS.SerialStripList.Bra" AutoReadOnly  Hidden
String Property SS_STRIPLIST_PANTIES = "APPS.SerialStripList.Panties" AutoReadOnly  Hidden
String Property SS_STRIPLIST_OTHER = "APPS.SerialStripList.Other" AutoReadOnly  Hidden

String Property SS_STRIPPEDLIST_WEAPONSANDSHIELDS_R = "APPS.SerialStrippedList.WeaponsAndShieldsR" AutoReadOnly  Hidden
String Property SS_STRIPPEDLIST_WEAPONSANDSHIELDS_L = "APPS.SerialStrippedList.WeaponsAndShieldsL" AutoReadOnly  Hidden
String Property SS_STRIPPEDLIST_GLOVES = "APPS.SerialStrippedList.Gloves" AutoReadOnly  Hidden
String Property SS_STRIPPEDLIST_HELMET = "APPS.SerialStrippedList.Helmet" AutoReadOnly  Hidden
String Property SS_STRIPPEDLIST_BOOTS = "APPS.SerialStrippedList.Boots" AutoReadOnly  Hidden
String Property SS_STRIPPEDLIST_CHESTPIECE = "APPS.SerialStrippedList.Chestpiece" AutoReadOnly  Hidden
String Property SS_STRIPPEDLIST_NECKLACE = "APPS.SerialStrippedList.Necklace" AutoReadOnly  Hidden
String Property SS_STRIPPEDLIST_CIRCLET = "APPS.SerialStrippedList.Circlet" AutoReadOnly  Hidden
String Property SS_STRIPPEDLIST_RING = "APPS.SerialStrippedList.Ring" AutoReadOnly  Hidden
String Property SS_STRIPPEDLIST_BRA = "APPS.SerialStrippedList.Bra" AutoReadOnly  Hidden
String Property SS_STRIPPEDLIST_PANTIES = "APPS.SerialStrippedList.Panties" AutoReadOnly  Hidden
String Property SS_STRIPPEDLIST_OTHER = "APPS.SerialStrippedList.Other" AutoReadOnly  Hidden

String Property SS_KW_GLOVES = "APPS.SerialStripKeyword.Gloves" AutoReadOnly Hidden
String Property SS_KW_HELMET = "APPS.SerialStripKeyword.Helmet" AutoReadOnly Hidden
String Property SS_KW_BOOTS = "APPS.SerialStripKeyword.Boots" AutoReadOnly Hidden
String Property SS_KW_CHESTPIECE = "APPS.SerialStripKeyword.Chestpiece" AutoReadOnly Hidden
String Property SS_KW_NECKLACE = "APPS.SerialStripKeyword.Necklace" AutoReadOnly Hidden
String Property SS_KW_CIRCLET = "APPS.SerialStripKeyword.Circlet" AutoReadOnly Hidden
String Property SS_KW_RING = "APPS.SerialStripKeyword.Ring" AutoReadOnly Hidden
String Property SS_KW_BRA = "APPS.SerialStripKeyword.Bra" AutoReadOnly Hidden
String Property SS_KW_PANTIES = "APPS.SerialStripKeyword.Panties" AutoReadOnly Hidden

String Property SS_ANIM_ARMORGLOVES = "ssFArGl" AutoReadOnly Hidden
String Property SS_ANIM_CLOTHGLOVES = "ssFClGl" AutoReadOnly Hidden
String Property SS_ANIM_ARMORHELMET = "ssFArHe" AutoReadOnly Hidden
String Property SS_ANIM_CLOTHHOOD = "ssFClHo" AutoReadOnly Hidden
String Property SS_ANIM_ARMORBOOTS = "ssFArBo" AutoReadOnly Hidden
String Property SS_ANIM_CLOTHBOOTS = "ssFClBo" AutoReadOnly Hidden
String Property SS_ANIM_ARMORCHESTPIECE = "ssFArChB" AutoReadOnly Hidden
String Property SS_ANIM_CLOTHCHESTPIECE = "ssFClChB" AutoReadOnly Hidden
String Property SS_ANIM_NECKLACE = "ssFJN" AutoReadOnly Hidden
String Property SS_ANIM_CLOTHCIRCLET = "ssFClCi" AutoReadOnly Hidden
String Property SS_ANIM_RING = "ssFJR" AutoReadOnly Hidden
String Property SS_ANIM_BRA = "ssFUUB" AutoReadOnly Hidden
String Property SS_ANIM_PANTIES = "ssFULB" AutoReadOnly Hidden

String Property SS_SEXLAB = "APPS.SerialStripDependency.SexLab" AutoReadOnly Hidden
String Property SS_WAITTIMEAFTERANIM = "APPS.SerialStrip.WaitingTimeAfterAnim" AutoReadOnly Hidden
String Property SS_DEBUGMODE = "APPS.SerialStrip.DebugMode" AutoReadOnly Hidden
;/ closeFold /;

; -------------------------------------------------------
; ---             Functions for modders               ---
; -------------------------------------------------------

Bool Function SendSerialStripStartEvent(Form akSender, Actor akActor, String asSlotOverrideList = "", String asExceptionList = "", Bool abFullStrip = False)
;/
Sends a SerialStripStart event that will tell SerialStrip to begin stripping the actor.
SerialStrip is always listening for this event.
You can copy this function in your mod, write a similar or call this one from inside SerialStrip
akSender:			the object that sent the event (your mod).
akActor:			the actor than you want to strip.
asSlotOverrideList:	the name of a 33-item-long array which defaults to "". This should be the name of a PapyrusUtil IntArray, stored on the form of your mod
					(akSender). Use the PapyrusUtil function: IntListAdd(Form obj, string key, int value, bool allowDuplicate = true) to build this
					array, where Form obj = your mod (akSender) and String key = asSlotOverrideList.Set any item [i] in your array to 1 to override the user
					configuration for slot i+30 and force-strip it. This allows a modder to selectspecific slots to strip even if SexLab is not installed or
					it allows the modder to override the user's configuration and strip slots despite the user's wishes.
abFullStrip: 		True  = will do a full strip i.e. remove all strippable items.
					False = will do a single strip i.e. remove one group of items.
/;
	;/ beginValidation /;
	If (!akSender)
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] ERROR: SendSerialStripStartEvent() has been passed a none argument for akSender.")
		EndIf
		Return False
	ElseIf (!akActor)
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] ERROR: SendSerialStripStartEvent() has been passed a none argument for akActor.")
		EndIf
		Return False
	EndIf
	;/ endValidation /;

	Int Handle = ModEvent.Create("SerialStripStart")
	If (Handle)
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] Sending SerialStripStart event. akSender is " + akSender + ", akActor is " + akActor.GetLeveledActorBase().GetName() + ", asSlotOverrideList is " + asSlotOverrideList as String + ", abFullStrip is " + abFullStrip + ".")
		EndIf
		ModEvent.PushForm(Handle, akSender)
		ModEvent.PushForm(Handle, akActor)
		ModEvent.PushString(Handle, asSlotOverrideList)
		ModEvent.PushString(Handle, asExceptionList)
		ModEvent.PushBool(Handle, abFullStrip)
		ModEvent.Send(Handle)
		Return True
	Else
		Return False
	EndIf
EndFunction

; -------------------------------------------------------
; ---             Internal use functions              ---
; -------------------------------------------------------

Event OnInit()
	AdjustIntValue(Self, "OnInitCounter", 1)
	If (GetIntValue(Self, "OnInitCounter") == 2)
		PrepareMod()
		RegisterForModEvent("SerialStripStart", "OnSerialStripStart") ;does not need to be called again on every game load.
		SetFloatValue(None, SS_WAITTIMEAFTERANIM, 1.0) ;this is saved on None because it will be used by other mods too. It also has the SS prefix.
		UnSetIntValue(Self, "OnInitCounter")
		Debug.Notification("$SS_INSTALLSSTRIPDONE_NOTIFY")
		Debug.Trace("[SerialStrip] SerialStrip installed.")
	EndIf
EndEvent

Function PrepareMod()
	ShowVersion()
	InitDefaultArrays()
	GetSexLab()
EndFunction

Function ShowVersion()
	Debug.Trace("[SerialStrip] " + SS_VERSION)
EndFunction

Function InitDefaultArrays()
	bAllTrueList = New Bool[33]
	bAllFalseList = New Bool[33]
	Int i

	While (i < 33)
		bAllTrueList[i] = True
		bAllFalseList[i] = False
		i += 1
	EndWhile

	;/ clear our StorageUtil arrays for update compatibility, then fill them with item keywords openFold /;
	StringListClear(Self, SS_KW_HELMET)
	StringListClear(Self, SS_KW_GLOVES)
	StringListClear(Self, SS_KW_BOOTS)
	StringListClear(Self, SS_KW_CHESTPIECE)
	StringListClear(Self, SS_KW_NECKLACE)
	StringListClear(Self, SS_KW_CIRCLET)
	StringListClear(Self, SS_KW_RING)
	StringListClear(Self, SS_KW_BRA)
	StringListClear(Self, SS_KW_PANTIES)

	StringListAdd(Self, SS_KW_HELMET, "Helmet")
	StringListAdd(Self, SS_KW_HELMET, "Hood")
	StringListAdd(Self, SS_KW_HELMET, "ArmorHelmet")
	StringListAdd(Self, SS_KW_HELMET, "ClothingHead")

	StringListAdd(Self, SS_KW_GLOVES, "Gloves")
	StringListAdd(Self, SS_KW_GLOVES, "Gauntlets")
	StringListAdd(Self, SS_KW_GLOVES, "ArmorGauntlets")
	StringListAdd(Self, SS_KW_GLOVES, "ClothingHands")

	StringListAdd(Self, SS_KW_BOOTS, "Boots")
	StringListAdd(Self, SS_KW_BOOTS, "ArmorBoots")
	StringListAdd(Self, SS_KW_BOOTS, "ClothingFeet")

	StringListAdd(Self, SS_KW_CHESTPIECE, "Chestpiece")
	StringListAdd(Self, SS_KW_CHESTPIECE, "ArmorCuirass")
	StringListAdd(Self, SS_KW_CHESTPIECE, "ClothingBody")

	StringListAdd(Self, SS_KW_NECKLACE, "Necklace")
	StringListAdd(Self, SS_KW_NECKLACE, "Amulet")
	StringListAdd(Self, SS_KW_NECKLACE, "ClothingNecklace")

	StringListAdd(Self, SS_KW_CIRCLET, "Circlet")
	StringListAdd(Self, SS_KW_CIRCLET, "ClothingCirclet")

	StringListAdd(Self, SS_KW_RING, "Ring")
	StringListAdd(Self, SS_KW_RING, "ClothingRing")

	StringListAdd(Self, SS_KW_BRA, "Bra")

	StringListAdd(Self, SS_KW_PANTIES, "Panties")
	;/ closeFold /;
EndFunction

Function GetSexLab()
	If (Game.GetModByName("SexLab.esm") != 255)
		SetFormValue(Self, SS_SEXLAB, SexLabUtil.GetAPI()) ;points to the SexLabFramework script so we can use its functions
	Else
		UnSetFormValue(Self, SS_SEXLAB)
	EndIf

	If (HasIntValue(Self, SS_DEBUGMODE))
		Debug.Trace("[SerialStrip] SexLab detected: " + HasFormValue(Self, SS_SEXLAB))
	EndIf
EndFunction

Bool Function SendSerialStripStopEvent(Form akSender, Actor akActor)
	;/ beginValidation /;
	If (!akSender)
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] ERROR: SendSerialStripStopEvent() has been passed a none argument for akSender.")
		EndIf
		Return False
	ElseIf (!akActor)
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] ERROR: SendSerialStripStopEvent() has been passed a none argument for akActor.")
		EndIf
		Return False
	ElseIf (FormListFind(Self, SS_STRIPPINGACTORS, akActor) == -1)
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] ERROR: SendSerialStripStopEvent() - Actor " + akActor.GetLeveledActorBase().GetName() + " was not found in the StrippingActors array.")
		EndIf
		Return False
	ElseIf (GetFormValue(akActor, SS_EVENTSENDER) != akSender)
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] ERROR: SendSerialStripStopEvent() - " + akSender + " cannot instruct actor " + akActor.GetLeveledActorBase().GetName() + " to stop stripping because this actor is being stripped by another object.")
		EndIf
		Return False
	EndIf
	;/ endValidation /;

	Int Handle = ModEvent.Create("SerialStripStop")
	If (Handle)
		ModEvent.PushForm(Handle, akSender)
		ModEvent.PushForm(Handle, akActor)
		ModEvent.Send(Handle)
		ClearStripLists(akActor)
		ClearStrippedLists(akActor)
		FormListClear(akActor, SS_CURRENTSTRIPARRAY)
		FormListClear(akActor, SS_CURRENTSTRIPPEDARRAY)
		UnsetIntValue(akActor, SS_FULLSERIALSTRIPSWITCH)
		UnsetIntValue(akActor, SS_ISSHEATHING)
		UnsetFormValue(akActor, SS_EVENTSENDER)
		FormListRemove(Self, SS_STRIPPINGACTORS, akActor)
		Return True
	Else
		Return False
	EndIf
EndFunction

Event OnSerialStripStart(Form akSender, Form akActor, String asSlotOverrideList, String asExceptionList, Bool abFullStrip)
	If (GetState()) ;prevents reacting to this event while not in the default state
		Return
	EndIf

	Actor kActor = akActor as Actor
	If (HasIntValue(Self, SS_DEBUGMODE))
		Debug.Trace("[SerialStrip] OnSerialStripStart() event detected. Sender: " + akSender + ", Actor: " + kActor.GetLeveledActorBase().GetName() + ", asSlotOverrideList: " + asSlotOverrideList as String + ", FullStrip: " + abFullStrip)
	EndIf
	;/ beginValidation /;
	If (kActor.IsOnMount())
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] OnSerialStripStart() on actor + " + kActor.GetLeveledActorBase().GetName() + " aborted because actor is on mount.")
		EndIf
		Return
	ElseIf (kActor.IsSprinting())
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] OnSerialStripStart() on actor + " + kActor.GetLeveledActorBase().GetName() + " aborted because actor is sprinting.")
		EndIf
		Return
	ElseIf (kActor.IsRunning())
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] OnSerialStripStart() on actor + " + kActor.GetLeveledActorBase().GetName() + " aborted because actor is running.")
		EndIf
		Return
	ElseIf (kActor.GetSleepState() > 2)
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] OnSerialStripStart() on actor + " + kActor.GetLeveledActorBase().GetName() + " aborted because actor is sleeping.")
		EndIf
		Return
	ElseIf (kActor.IsInCombat())
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] OnSerialStripStart() on actor + " + kActor.GetLeveledActorBase().GetName() + " aborted because actor is in combat.")
		EndIf
		Return
	ElseIf (kActor.GetSitState() > 2)
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] OnSerialStripStart() on actor + " + kActor.GetLeveledActorBase().GetName() + " aborted because actor is sitting.")
		EndIf
		Return
	ElseIf (kActor.IsSwimming())
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] OnSerialStripStart() on actor + " + kActor.GetLeveledActorBase().GetName() + " aborted because actor is swimming.")
		EndIf
		Return
	ElseIf (kActor.IsSneaking())
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] OnSerialStripStart() on actor + " + kActor.GetLeveledActorBase().GetName() + " aborted because actor is sneaking.")
		EndIf
		Return
	ElseIf (kActor.IsChild())
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] OnSerialStripStart() on actor + " + kActor.GetLeveledActorBase().GetName() + " aborted because actor is not an adult.")
		EndIf
		Return
	EndIf
	;/ endValidation /;

	GoToState("Stripping")
	FormListAdd(Self, SS_STRIPPINGACTORS, kActor)
	SetFormValue(kActor, SS_EVENTSENDER, akSender)
	If (abFullStrip)
		SetIntValue(kActor, SS_FULLSERIALSTRIPSWITCH, 1)
	Else
		UnsetIntValue(kActor, SS_FULLSERIALSTRIPSWITCH)
	EndIf

	PrepareForStripping(akSender, kActor, asSlotOverrideList, asExceptionList)
	SerialStrip(kActor)
EndEvent

Bool[] Function CreatePapyrusSlotOverrideList(String asSlotOverrideList, Form akSender)
EndFunction

Function PrepareForStripping(Form akSender, Actor akActor, String asSlotOverrideList = "", String asExceptionList = "")
EndFunction

Function ClearIfInactive(Actor akActor, String asArrayName, Bool abIsArrayActive)
EndFunction

Bool Function IsStrippableItem(Form akItemRef)
EndFunction

Bool Function ItemHasKeywords(Form akItemRef, String asListName)
EndFunction

;/ Bool Function IsValidSlot(Int aiSlot, Bool[] abIsUserConfigStrippable, Bool[] abIsSlotOverride)
EndFunction /;

Function SerialStrip(Actor akActor)
EndFunction

Bool Function HasClothingItems(Actor akActor, String asArrayName)
EndFunction

Function SingleArrayAnimThenStrip(Actor akActor, String asStripArray, String asStrippedArray, String asAnimation = "", Bool abStripNextArrayToo = False)
EndFunction

Function SingleArrayStrip(Actor akActor, String asStripArray, String asStrippedArray, Bool abStripNextArrayToo = False)
EndFunction

Function ClearStripLists(Actor akActor)
	FormListClear(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_R)
	FormListClear(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_L)
	FormListClear(akActor, SS_STRIPLIST_GLOVES)
	FormListClear(akActor, SS_STRIPLIST_HELMET)
	FormListClear(akActor, SS_STRIPLIST_BOOTS)
	FormListClear(akActor, SS_STRIPLIST_CHESTPIECE)
	FormListClear(akActor, SS_STRIPLIST_NECKLACE)
	FormListClear(akActor, SS_STRIPLIST_CIRCLET)
	FormListClear(akActor, SS_STRIPLIST_RING)
	FormListClear(akActor, SS_STRIPLIST_BRA)
	FormListClear(akActor, SS_STRIPLIST_PANTIES)
	FormListClear(akActor, SS_STRIPLIST_OTHER)
EndFunction

Function ClearStrippedLists(Actor akActor)
	FormListClear(akActor, SS_STRIPPEDLIST_WEAPONSANDSHIELDS_R)
	FormListClear(akActor, SS_STRIPPEDLIST_WEAPONSANDSHIELDS_L)
	FormListClear(akActor, SS_STRIPPEDLIST_GLOVES)
	FormListClear(akActor, SS_STRIPPEDLIST_HELMET)
	FormListClear(akActor, SS_STRIPPEDLIST_BOOTS)
	FormListClear(akActor, SS_STRIPPEDLIST_CHESTPIECE)
	FormListClear(akActor, SS_STRIPPEDLIST_NECKLACE)
	FormListClear(akActor, SS_STRIPPEDLIST_CIRCLET)
	FormListClear(akActor, SS_STRIPPEDLIST_RING)
	FormListClear(akActor, SS_STRIPPEDLIST_BRA)
	FormListClear(akActor, SS_STRIPPEDLIST_PANTIES)
	FormListClear(akActor, SS_STRIPPEDLIST_OTHER)
EndFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
EndEvent

State Stripping

	Bool[] Function CreatePapyrusSlotOverrideList(String asSlotOverrideList, Form akSender)
	;creates a papyrus array from the SlotOverrideList's name
		;/ beginValidation /;
		If (!akSender)
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] ERROR: CreatePapyrusSlotOverrideList() has been passed a none argument for akSender.")
			EndIf
			Return bAllFalseList
		ElseIf (IntListCount(akSender, asSlotOverrideList) != 33)
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] ERROR: CreatePapyrusSlotOverrideList() has been passed an array for asSlotOverrideList which is not 33 items long.")
			EndIf
			Return bAllFalseList
		EndIf
		;/ endValidation /;

		Bool[] bSlotOverrideList = New Bool[33]
		Int i

		While (i < 33)
			bSlotOverrideList[i] = (IntListGet(akSender, asSlotOverrideList, i) == 1)	;puts True in place of 1 and False in place of 0
			i += 1
		EndWhile

		Return bSlotOverrideList
	EndFunction

	Function PrepareForStripping(Form akSender, Actor akActor, String asSlotOverrideList = "", String asExceptionList = "")
	;/analyses items worn by akActor and puts them into arrays for the actual
		stripping function to use.
	akSender: the mod (form) that initiated the stripping
	akActor: actor to prepare
	asSlotStripList: name of a 33-item-long StorageUtil int array that the mod used to override user config. 1 means "Strip", 0 means "DontStrip"
	asExceptionList: name of a StorageUtil form array holding items that will NOT be stripped
	/;

		;/ beginValidation /;
		If (!akActor)
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] ERROR: PrepareForStripping() has been passed a none object for akActor.")
			EndIf
		Return
		EndIf
		;/ endValidation /;

		;clear all the arrays before filling them
		ClearStripLists(akActor)

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

		Bool[] bSlotStripList = new Bool[33] ;declares an array to hold the actual slots that will be stripped

		If (asSlotOverrideList) ;if the modder has pased a an array to override user configuration
			bSlotStripList = CreatePapyrusSlotOverrideList(asSlotOverrideList, akSender)
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] Slots set to strippable according to mod" + akSender as Form)
			EndIf
		ElseIf (HasFormValue(Self, SS_SEXLAB))	;if SexLab is installed
			Int iGender = (GetFormValue(Self, SS_SEXLAB) As SexLabFramework).GetGender(akActor as Actor) ;fetches the gender of the actor

			If (iGender == 0) ;if the actor is male
				bSlotStripList = (GetFormValue(Self, SS_SEXLAB) As SexLabFramework).Config.GetStrip(IsFemale = False) ;fetch the user's MCM stripping configuration for males
			ElseIf (iGender == 1) ;if the actor is female
				bSlotStripList = (GetFormValue(Self, SS_SEXLAB) As SexLabFramework).Config.GetStrip(IsFemale = True) ;fetch the user's MCM stripping configuration for females
			EndIf
		Else ;otherwise consider all slots as strippable
			bSlotStripList = bAllTrueList
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] SexLab not installed, all slots set to strippable")
			EndIf
		EndIf

		;WEAPONS AND SHIELDS
		;In SexLab's StripFemale and StripMale arrays, weapon is item 32 & shield is item 9. Add 30 to find the slot mask.
		;weapons and shields employ a different logic than the other items

		If (akActor.GetEquippedItemType(1) && \
		akActor.GetEquippedItemType(1) != 5 && \
		akActor.GetEquippedItemType(1) != 6 && \
		akActor.GetEquippedItemType(1) != 7 && \
		akActor.GetEquippedItemType(1) != 8 && \
		akActor.GetEquippedItemType(1) != 9 && \
		akActor.GetEquippedItemType(1) != 12) ;if there is a weapon in the right hand but it's not a two-handed one, then we also need to check the left hand

			If (akActor.GetEquippedItemType(0) == 10) ;if the left hand is holding a shield
				Form kItemRef = akActor.GetEquippedShield()

				If ((FormListFind(akSender, asExceptionList, kItemRef) == -1)) ;if the item is not found in the exception array
					If (IsStrippableItem(kItemRef) == True && bSlotStripList[9]) ;if this item is strippable according to SexLab and either the modder or the user have configured this slot to be strippable
						FormListAdd(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_L, kItemRef, allowDuplicate = False) ;adds this item to the WeaponsAndShields undress list
						If (HasIntValue(Self, SS_DEBUGMODE))
							Debug.Trace("[SerialStrip] Shield detected: " + kItemRef.GetName() + " on actor: " + akActor.GetLeveledActorBase().GetName())
						EndIf
						bArrayIsActive[1] = True ;activate the WeaponsAndShieldsL array
					EndIf
				EndIf
			ElseIf (akActor.GetEquippedItemType(0) && akActor.GetEquippedItemType(0) != 9) ;if there is a weapon in the left hand (i.e. not just fists or a spell)
				Form kItemRef = akActor.GetEquippedWeapon(True) ;fetches left-hand weapon and puts it in kItemRef

				If ((FormListFind(akSender, asExceptionList, kItemRef) == -1)) ;if the item is not found in the exception array
					If (IsStrippableItem(kItemRef) == True && bSlotStripList[32]) ;if this item is strippable according to SexLab and either the modder or the user have configured this slot to be strippable
						FormListAdd(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_L, kItemRef, allowDuplicate = False) ;adds this item to the WeaponsAndShields undress list
						If (HasIntValue(Self, SS_DEBUGMODE))
							Debug.Trace("[SerialStrip] Left-hand weapon detected: " + kItemRef.GetName() + " on actor: " + akActor.GetLeveledActorBase().GetName())
						EndIf
						bArrayIsActive[1] = True ;activate the WeaponsAndShieldsL array
					EndIf
				EndIf
			EndIf
		EndIf

		If (akActor.GetEquippedItemType(1) && akActor.GetEquippedItemType(1) != 9) ;if there is a weapon in the right hand (i.e. not just fists or a spell)
			Form kItemRef = akActor.GetEquippedWeapon(False) ;fetches right-hand weapon and puts it in kItemRef

			If ((FormListFind(akSender, asExceptionList, kItemRef) == -1)) ;if the item is not found in the exception array
				If (IsStrippableItem(kItemRef) == True && bSlotStripList[32]) ;if this item is strippable according to SexLab and either the modder or the user have configured this slot to be strippable
					FormListAdd(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_R, kItemRef, allowDuplicate = False) ;adds this item to the WeaponsAndShields undress list
					If (HasIntValue(Self, SS_DEBUGMODE))
						Debug.Trace("[SerialStrip] Right-hand weapon detected: " + kItemRef.GetName() + " on actor: " + akActor.GetLeveledActorBase().GetName())
					EndIf
					bArrayIsActive[0] = True ;activate the WeaponsAndShieldsR array
				EndIf
			EndIf
		EndIf

		;ARMOR

		;CREATING A LOOP to check all the item slots (forwards)
		Int i = 30 ;sets i to 30

		While (i <= 61) ;run this loop up to and including node 61 (http://www.creationkit.com/Biped_Object)
			Form kItemRef = akActor.GetWornForm(Armor.GetMaskForSlot(i)) ;fetch the item worn in this slot and load it in the kItemRef variable

			If (kItemRef && FormListFind(akSender, asExceptionList, kItemRef) == -1) ;if there is an item in this slot and it is not found in the exception array

				If (i == 33) || (ItemHasKeywords(kItemRef, SS_KW_GLOVES)) ;if this item is in the gloves slot OR has any of the gloves keywords
					FormListAdd(akActor, SS_STRIPLIST_GLOVES, kItemRef, allowDuplicate = False);adds this item to the gloves undress list
					If (HasIntValue(Self, SS_DEBUGMODE))
						Debug.Trace("[SerialStrip] Gloves detected: " + kItemRef.GetName() + " on actor: " + akActor.GetLeveledActorBase().GetName())
					EndIf
				ElseIf (i == 31) || (ItemHasKeywords(kItemRef, SS_KW_HELMET)) ;if this item is in the hair slot OR has any of the helmet keywords
					FormListAdd(akActor, SS_STRIPLIST_HELMET, kItemRef, allowDuplicate = False) ;adds this item to the helmet undress list
					If (HasIntValue(Self, SS_DEBUGMODE))
						Debug.Trace("[SerialStrip] Helmet detected: " + kItemRef.GetName() + " on actor: " + akActor.GetLeveledActorBase().GetName())
					EndIf
				ElseIf (i == 37) || (ItemHasKeywords(kItemRef, SS_KW_BOOTS)) ;if this item is in the boots slot OR has any of the boots keywords
					FormListAdd(akActor, SS_STRIPLIST_BOOTS, kItemRef, allowDuplicate = False) ;adds this item to the boots undress list
					If (HasIntValue(Self, SS_DEBUGMODE))
						Debug.Trace("[SerialStrip] Boots detected: " + kItemRef.GetName() + " on actor: " + akActor.GetLeveledActorBase().GetName())
					EndIf
				ElseIf ((i == 32 || ItemHasKeywords(kItemRef, SS_KW_CHESTPIECE)) && i != 56 && i != 52) ;if this item is in the chestpiece slot OR has any of the chestpiece keywords and if it is not in the bra or panties slot (because underwear items may have chestpiece keywords)
					FormListAdd(akActor, SS_STRIPLIST_CHESTPIECE, kItemRef, allowDuplicate = False) ;adds this item to the chestpiece undress list
					If (HasIntValue(Self, SS_DEBUGMODE))
						Debug.Trace("[SerialStrip] Chestpiece detected: " + kItemRef.GetName() + " on actor: " + akActor.GetLeveledActorBase().GetName())
					EndIf
				ElseIf (i == 35) || (ItemHasKeywords(kItemRef, SS_KW_NECKLACE)) ;if this item is in the necklace slot OR has any of the necklace keywords
					FormListAdd(akActor, SS_STRIPLIST_NECKLACE, kItemRef, allowDuplicate = False) ;adds this item to the necklace undress list
					If (HasIntValue(Self, SS_DEBUGMODE))
						Debug.Trace("[SerialStrip] Necklace detected: " + kItemRef.GetName() + " on actor: " + akActor.GetLeveledActorBase().GetName())
					EndIf
				ElseIf (i == 42) || (ItemHasKeywords(kItemRef, SS_KW_CIRCLET)) ;if this item is in the circlet slot OR has any of the circlet keywords
					FormListAdd(akActor, SS_STRIPLIST_CIRCLET, kItemRef, allowDuplicate = False) ;adds this item to the circlet undress list
					If (HasIntValue(Self, SS_DEBUGMODE))
						Debug.Trace("[SerialStrip] Circlet detected: " + kItemRef.GetName() + " on actor: " + akActor.GetLeveledActorBase().GetName())
					EndIf
				ElseIf (i == 36) || (ItemHasKeywords(kItemRef, SS_KW_RING)) ;if this item is in the ring slot OR has any of the ring keywords
					FormListAdd(akActor, SS_STRIPLIST_RING, kItemRef, allowDuplicate = False) ;adds this item to the ring undress list
					If (HasIntValue(Self, SS_DEBUGMODE))
						Debug.Trace("[SerialStrip] Ring detected: " + kItemRef.GetName() + " on actor: " + akActor.GetLeveledActorBase().GetName())
					EndIf
				ElseIf (i == 56) || (ItemHasKeywords(kItemRef, SS_KW_BRA)) ;if this item is in the bra slot OR has any of the bra keywords
					FormListAdd(akActor, SS_STRIPLIST_BRA, kItemRef, allowDuplicate = False) ;adds this item to the bra undress list
					If (HasIntValue(Self, SS_DEBUGMODE))
						Debug.Trace("[SerialStrip] Bra detected: " + kItemRef.GetName() + " on actor: " + akActor.GetLeveledActorBase().GetName())
					EndIf
				ElseIf (i == 52) || (ItemHasKeywords(kItemRef, SS_KW_PANTIES)) ;if this item is in the panties slot OR has any of the panties keywords
					FormListAdd(akActor, SS_STRIPLIST_PANTIES, kItemRef, allowDuplicate = False) ;adds this item to the panties undress list
					If (HasIntValue(Self, SS_DEBUGMODE))
						Debug.Trace("[SerialStrip] Panties detected: " + kItemRef.GetName() + " on actor: " + akActor.GetLeveledActorBase().GetName())
					EndIf
				EndIf

				If (IsStrippableItem(kItemRef) == True) ;if this item is strippable according to us or SexLab
					If (bSlotStripList[i - 30]) ;if either the modder or the user have configured this slot to be strippable
						If ((i == 33) || FormListFind(akActor, SS_STRIPLIST_GLOVES, kItemRef) != -1) ;if this is the gloves slot OR we already know the item has one of the gloves keywords
							bArrayIsActive[2] = True ;activate the gloves stripping array
						ElseIf ((i == 31) || FormListFind(akActor, SS_STRIPLIST_HELMET, kItemRef) != -1) ;if this is the hair slot (checking for helmets) OR we already know the item has one of the helmet keywords
							bArrayIsActive[3] = True ;activate the helmet stripping array
						ElseIf ((i == 37) || FormListFind(akActor, SS_STRIPLIST_BOOTS, kItemRef) != -1) ;if this is the boots slot OR we already know the item has one of the boots keywords
							bArrayIsActive[4] = True ;activate the boots stripping array
						ElseIf ((i == 32) || FormListFind(akActor, SS_STRIPLIST_CHESTPIECE, kItemRef) != -1) ;if this is the chestpiece slot OR we already know the item has one of the chestpiece keywords (we have already excluded underwear from this array)
							bArrayIsActive[5] = True ;activate the chestpiece stripping array
						ElseIf ((i == 35) || FormListFind(akActor, SS_STRIPLIST_NECKLACE, kItemRef) != -1) ;if this is the necklace slot OR we already know the item has one of the necklace keywords
							bArrayIsActive[6] = True ;activate the necklace stripping array
						ElseIf ((i == 42) || FormListFind(akActor, SS_STRIPLIST_CIRCLET, kItemRef) != -1) ;if this is the circlet slot OR we already know the item has one of the circlet keywords
							bArrayIsActive[7] = True ;activate the circlet stripping array
						ElseIf ((i == 36) || FormListFind(akActor, SS_STRIPLIST_RING, kItemRef) != -1) ;if this is the ring slot OR we already know the item has one of the ring keywords
							bArrayIsActive[8] = True ;activate the ring stripping array
						ElseIf ((i == 56) || FormListFind(akActor, SS_STRIPLIST_BRA, kItemRef) != -1) ;if this is the bra slot OR we already know the item has one of the bra keywords
							bArrayIsActive[9] = True ;activate the bra stripping array
						ElseIf ((i == 52) || FormListFind(akActor, SS_STRIPLIST_PANTIES, kItemRef) != -1) ;if this is the panties slot OR we already know the item has one of the panties keywords
							bArrayIsActive[10] = True ;activate the panties stripping array
						Else
							FormListAdd(akActor, SS_STRIPLIST_OTHER, kItemRef, allowDuplicate = False) ;adds this item to the "other" undress list
							bArrayIsActive[11] = True ;activate the "other" stripping array
						EndIf
					EndIf
				EndIf
			EndIf
			i += 1 ;moves the loop to check the next slot (forwards)
		EndWhile

		;clears the arrays if they are not active (i.e. there's nothing strippable in them)
		ClearIfInactive(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_R, bArrayIsActive[0])
		ClearIfInactive(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_L, bArrayIsActive[1])
		ClearIfInactive(akActor, SS_STRIPLIST_GLOVES, bArrayIsActive[2])
		ClearIfInactive(akActor, SS_STRIPLIST_HELMET, bArrayIsActive[3])
		ClearIfInactive(akActor, SS_STRIPLIST_BOOTS, bArrayIsActive[4])
		ClearIfInactive(akActor, SS_STRIPLIST_CHESTPIECE, bArrayIsActive[5])
		ClearIfInactive(akActor, SS_STRIPLIST_NECKLACE, bArrayIsActive[6])
		ClearIfInactive(akActor, SS_STRIPLIST_CIRCLET, bArrayIsActive[7])
		ClearIfInactive(akActor, SS_STRIPLIST_RING, bArrayIsActive[8])
		ClearIfInactive(akActor, SS_STRIPLIST_BRA, bArrayIsActive[9])
		ClearIfInactive(akActor, SS_STRIPLIST_PANTIES, bArrayIsActive[10])
		ClearIfInactive(akActor, SS_STRIPLIST_OTHER, bArrayIsActive[11])

		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] Array " + SS_STRIPLIST_WEAPONSANDSHIELDS_R + " on actor: " + akActor.GetLeveledActorBase().GetName() + " contains " + FormListCount(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_R) + " elements.")
			Debug.Trace("[SerialStrip] Array " + SS_STRIPLIST_WEAPONSANDSHIELDS_L + " on actor: " + akActor.GetLeveledActorBase().GetName() + " contains " + FormListCount(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_L) + " elements.")
			Debug.Trace("[SerialStrip] Array " + SS_STRIPLIST_GLOVES + " on actor: " + akActor.GetLeveledActorBase().GetName() + " contains " + FormListCount(akActor, SS_STRIPLIST_GLOVES) + " elements.")
			Debug.Trace("[SerialStrip] Array " + SS_STRIPLIST_HELMET + " on actor: " + akActor.GetLeveledActorBase().GetName() + " contains " + FormListCount(akActor, SS_STRIPLIST_HELMET) + " elements.")
			Debug.Trace("[SerialStrip] Array " + SS_STRIPLIST_BOOTS + " on actor: " + akActor.GetLeveledActorBase().GetName() + " contains " + FormListCount(akActor, SS_STRIPLIST_BOOTS) + " elements.")
			Debug.Trace("[SerialStrip] Array " + SS_STRIPLIST_CHESTPIECE + " on actor: " + akActor.GetLeveledActorBase().GetName() + " contains " + FormListCount(akActor, SS_STRIPLIST_CHESTPIECE) + " elements.")
			Debug.Trace("[SerialStrip] Array " + SS_STRIPLIST_NECKLACE + " on actor: " + akActor.GetLeveledActorBase().GetName() + " contains " + FormListCount(akActor, SS_STRIPLIST_NECKLACE) + " elements.")
			Debug.Trace("[SerialStrip] Array " + SS_STRIPLIST_CIRCLET + " on actor: " + akActor.GetLeveledActorBase().GetName() + " contains " + FormListCount(akActor, SS_STRIPLIST_CIRCLET) + " elements.")
			Debug.Trace("[SerialStrip] Array " + SS_STRIPLIST_RING + " on actor: " + akActor.GetLeveledActorBase().GetName() + " contains " + FormListCount(akActor, SS_STRIPLIST_RING) + " elements.")
			Debug.Trace("[SerialStrip] Array " + SS_STRIPLIST_BRA + " on actor: " + akActor.GetLeveledActorBase().GetName() + " contains " + FormListCount(akActor, SS_STRIPLIST_BRA) + " elements.")
			Debug.Trace("[SerialStrip] Array " + SS_STRIPLIST_PANTIES + " on actor: " + akActor.GetLeveledActorBase().GetName() + " contains " + FormListCount(akActor, SS_STRIPLIST_PANTIES) + " elements.")
			Debug.Trace("[SerialStrip] Array " + SS_STRIPLIST_OTHER + " on actor: " + akActor.GetLeveledActorBase().GetName() + " contains " + FormListCount(akActor, SS_STRIPLIST_OTHER) + " elements.")
		EndIf
	EndFunction

	Function ClearIfInactive(Actor akActor, String asArrayName, Bool abIsArrayActive)
	;clears the asArrayName array on akActor, depending on whether abIsArrayActive
		;/ beginValidation /;
		If (!akActor || asArrayName == "")
			Return
		EndIf
		;/ endValidation /;

		If (!abIsArrayActive) ;if the array is not active
			FormListClear(akActor, asArrayName) ;clear the array by the name asArrayName on akActor
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] " + asArrayName + " on actor " + akActor.GetLeveledActorBase().GetName() + " cleared.")
			EndIf
		EndIf
	EndFunction

	Bool Function IsStrippableItem(Form akItemRef)
	;checks whether akItemRef has the "NoStrip" keyword
		;/ beginValidation /;
		If (!akItemRef)
			Return False
		EndIf
		;/ endValidation /;

		If (HasFormValue(Self, SS_SEXLAB))
			If ((GetFormValue(Self, SS_SEXLAB) As SexLabFramework).IsStrippable(akItemRef))
				If (HasIntValue(Self, SS_DEBUGMODE))
					Debug.Trace("[SerialStrip] Item " + akItemRef.GetName() + " is strippable according to SL IsStrippable()")
				EndIf
				Return True
			EndIf
		Else
			If (!akItemRef.HasKeyword(Keyword.GetKeyword("NoStrip")))
				If (HasIntValue(Self, SS_DEBUGMODE))
					Debug.Trace("[SerialStrip] Item " + akItemRef.GetName() + " is strippable because it does not contain the NoStrip keyword")
				EndIf
				Return True
			EndIf
		EndIf

		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] Item " + akItemRef.GetName() + " is not strippable because we or SL detected the NoStrip keyword")
		EndIf
		Return False
	EndFunction

	Bool Function ItemHasKeywords(Form akItemRef, String asListName)
	;checks whether akItemRef has any of the keywords stored in the StorageUtil array
		;/ beginValidation /;
		If (!akItemRef || !asListName)
			Return False
		EndIf
		;/ endValidation /;

		Int KeywordCount = StringListCount(Self, asListName)
		Int i

		If (HasFormValue(Self, SS_SEXLAB)) ;if SexLab is installed, use its advanced SKSE keyword searching function
			While (i < KeywordCount)
				String sKeywordRef = StringListGet(Self, asListName, i) ;fetch the keyword in this position in the array

				If (SexLabUtil.HasKeywordSub(akItemRef, sKeywordRef)) ;if the item has this keyword (more advanced than vanilla HasKeyword)
					If (HasIntValue(Self, SS_DEBUGMODE))
						Debug.Trace("[SerialStrip] Keyword " + sKeywordRef + " found on item " + akItemRef.GetName() + " by SexLab's HasKeywordSub()")
					EndIf
					Return True
				EndIf

				i += 1 ;go to the next item in the loop
			EndWhile
		Else
			While (i < KeywordCount)
				String sKeywordRef = StringListGet(Self, asListName, i) ;fetch the keyword in this position in the array

				If (akItemRef.HasKeyword(Keyword.GetKeyword(sKeywordRef))) ;if the item has this keyword (first it gets the keyword that matches our sKeywordRef)
					If (HasIntValue(Self, SS_DEBUGMODE))
						Debug.Trace("[SerialStrip] Keyword " + sKeywordRef + " found on item " + akItemRef.GetName() + " by vanilla HasKeyword()")
					EndIf
					Return True
				EndIf

				i += 1 ;go to the next item in the loop (backwards)
			EndWhile
		EndIf

		Return False
	EndFunction

	;/ Bool Function IsValidSlot(Int aiSlot, Bool[] abIsUserConfigStrippable, Bool[] abIsSlotOverride)
	;Returns True if either the modder or the user have designated this slot as strippable
		Int Slot = aiSlot - 30

		If (abIsSlotOverride[slot]) ;if the modder has overridden this slot to strippable
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] Item in slot " + aiSlot + " is strippable because of modder override")
			EndIf
			Return True
		ElseIf (abIsUserConfigStrippable[slot]) ;if the user has configured this slot as strippable
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] Item in slot " + aiSlot + " is strippable because of user slot configuration")
			EndIf
			Return True
		Else
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] item in slot " + aiSlot + " is not strippable because of user slot configuration")
			EndIf
			Return False
		EndIf
	EndFunction /;

	Function SerialStrip(Actor akActor)
	;makes the actor strip one item/group of clothing (one array) and then strip the next one and so on. To be used for button taps.
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] SerialStrip() called on " + akActor.GetLeveledActorBase().GetName())
		EndIf

		;fetching all item counts once and storing them so we don't do this over and over again
		Int WeaponsAndShieldsRCount = FormListCount(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_R)
		Int WeaponsAndShieldsLCount = FormListCount(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_L)
		Int GlovesCount = FormListCount(akActor, SS_STRIPLIST_GLOVES)
		Int BootsCount = FormListCount(akActor, SS_STRIPLIST_BOOTS)
		Int ChestpieceCount = FormListCount(akActor, SS_STRIPLIST_CHESTPIECE)
		Int NecklaceCount =  FormListCount(akActor, SS_STRIPLIST_NECKLACE)
		Int CircletCount = FormListCount(akActor, SS_STRIPLIST_CIRCLET)
		Int RingCount = FormListCount(akActor, SS_STRIPLIST_RING)
		Int BraCount = FormListCount(akActor, SS_STRIPLIST_BRA)
		Int PantiesCount = FormListCount(akActor, SS_STRIPLIST_PANTIES)
		Int OtherCount = FormListCount(akActor, SS_STRIPLIST_OTHER)

		;if nothing to strip, return now
		If (WeaponsAndShieldsRCount + \
			WeaponsAndShieldsLCount + \
			GlovesCount + \
			BootsCount + \
			ChestpieceCount + \
			NecklaceCount + \
			CircletCount + \
			RingCount + \
			BraCount + \
			PantiesCount + \
			OtherCount == 0)
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] Nothing to strip on " + akActor.GetLeveledActorBase().GetName() + ". Aborting.")
			EndIf

			If (akActor == PlayerRef)
				Game.SetPlayerAIDriven(False) ;give control back to the player
			Else
				ActorUtil.RemovePackageOverride(akActor, DoNothing)
				akActor.EvaluatePackage()
				akActor.SetRestrained(False)
				akActor.SetDontMove(False)
				akActor.SetVehicle(None)
				Marker.Disable()
				Marker.Delete()
			EndIf

			UnRegisterForAnimationEvent(akActor, "IdleStop")
			GoToState("")
			SendSerialStripStopEvent(GetFormValue(akActor, SS_EVENTSENDER), akActor)
			Return
		EndIf

		;/ Debug.SendAnimationEvent(akActor, "IdleForceDefaultState"); DO NOT USE - PREVENTS SHEATHING /;

		If (akActor == PlayerRef)
			Game.ForceThirdPerson() ;force third person camera mode
			Game.SetPlayerAIDriven(True) ;instead of DisablePlayerControls(True)
		Else
			ActorUtil.AddPackageOverride(akActor, DoNothing, 100, 1)
			akActor.EvaluatePackage()
			akActor.SetRestrained(true)
			akActor.SetDontMove(true)
			If (!Marker)
				Marker = akActor.PlaceAtMe(XMarker)
			EndIf
			Marker.Enable()
			Marker.MoveTo(akActor)
			akActor.StopTranslation()
			akActor.SetVehicle(Marker)
		EndIf

		If (akActor.IsWeaponDrawn()) ;if the actor has their weapon drawn
			SetIntValue(akActor, SS_ISSHEATHING, 1)
			akActor.SheatheWeapon() ;make the actor sheathe their weapon
			RegisterForAnimationEvent(akActor, "IdleStop") ;listening for when the actor stops sheathing to continue
			Return
		Else
			UnsetIntValue(akActor, SS_ISSHEATHING)
		EndIf

		;WEAPONS
		If (WeaponsAndShieldsRCount > 0 ||  WeaponsAndShieldsLCount > 0) ;if the weapons or shields arrays (Right and Left) are not empty

			;until we have special weapons stripping animation, this is being deprecated later on in SingleArrayAnimThenStrip()
			If (WeaponsAndShieldsRCount == 0) ;if the right hand array is empty i.e. the left is not empty
				SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_L, SS_STRIPPEDLIST_WEAPONSANDSHIELDS_L, WeaponsAndShieldsAnim) ;run the function to play the appropriate animation
			ElseIf (WeaponsAndShieldsLCount == 0) ;if the left hand array is empty i.e. the right is not empty
				SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_R, SS_STRIPPEDLIST_WEAPONSANDSHIELDS_R, WeaponsAndShieldsAnim) ;run the function to play the appropriate animation
			Else ;if both right and left hand arrays are not empty
				SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_R, SS_STRIPPEDLIST_WEAPONSANDSHIELDS_R, WeaponsAndShieldsAnim, abStripNextArrayToo = True) ;run the function to play the appropriate animation and continue to strip the left hand too
			EndIf
		;ARMOR
		ElseIf (GlovesCount > 0)
			If (!RingCount) ;if there are no rings equipped, remove gloves
				If (HasClothingItems(akActor, SS_STRIPLIST_GLOVES))
					SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_GLOVES, SS_STRIPPEDLIST_GLOVES, SS_ANIM_CLOTHGLOVES)
				Else
					SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_GLOVES, SS_STRIPPEDLIST_GLOVES, SS_ANIM_ARMORGLOVES) ;run the function to play the appropriate animation
				EndIf
			Else ;if there are rings equipped, remove them first because in Skyrim they are worn over the gloves
				SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_RING, SS_STRIPPEDLIST_RING, SS_ANIM_RING) ;run the function to play the appropriate animation
			EndIf
		ElseIf (FormListCount(akActor, SS_STRIPLIST_HELMET) > 0)
			If (HasClothingItems(akActor, SS_STRIPLIST_HELMET))
				SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_HELMET, SS_STRIPPEDLIST_HELMET, SS_ANIM_CLOTHHOOD)
			Else
				SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_HELMET, SS_STRIPPEDLIST_HELMET, SS_ANIM_ARMORHELMET) ;run the function to play the appropriate animation
			EndIf
		ElseIf (BootsCount > 0)
			If (HasClothingItems(akActor, SS_STRIPLIST_BOOTS))
				SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_BOOTS, SS_STRIPPEDLIST_BOOTS, SS_ANIM_CLOTHBOOTS)
			Else
				SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_BOOTS, SS_STRIPPEDLIST_BOOTS, SS_ANIM_ARMORBOOTS) ;run the function to play the appropriate animation
			EndIf
		ElseIf (ChestpieceCount > 0)
			If (HasClothingItems(akActor, SS_STRIPLIST_CHESTPIECE))
				SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_CHESTPIECE, SS_STRIPPEDLIST_CHESTPIECE, SS_ANIM_CLOTHCHESTPIECE)
			Else
				SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_CHESTPIECE, SS_STRIPPEDLIST_CHESTPIECE, SS_ANIM_ARMORCHESTPIECE) ;run the function to play the appropriate animation
			EndIf
		ElseIf (NecklaceCount > 0)
			SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_NECKLACE, SS_STRIPPEDLIST_NECKLACE, SS_ANIM_NECKLACE) ;run the function to play the appropriate animation
		ElseIf (CircletCount > 0)
			SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_CIRCLET, SS_STRIPPEDLIST_CIRCLET, SS_ANIM_CLOTHCIRCLET) ;run the function to play the appropriate animation
		ElseIf (RingCount > 0)
			SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_RING, SS_STRIPPEDLIST_RING, SS_ANIM_RING) ;run the function to play the appropriate animation
		ElseIf (BraCount > 0)
			SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_BRA, SS_STRIPPEDLIST_BRA, SS_ANIM_BRA) ;run the function to play the appropriate animation
		ElseIf (PantiesCount > 0)
			SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_PANTIES, SS_STRIPPEDLIST_PANTIES, SS_ANIM_PANTIES) ;run the function to play the appropriate animation
		ElseIf (OtherCount > 0)
			SingleArrayAnimThenStrip(akActor, SS_STRIPLIST_OTHER, SS_STRIPPEDLIST_OTHER, OtherAnim) ;run the function to play the appropriate animation
		EndIf
	EndFunction

	Bool Function HasClothingItems(Actor akActor, String asArrayName)
		Int itemCount = FormListCount(akActor, asArrayName)
		Int i

		While (i < itemCount)
			Armor kItemRef = FormListGet(akActor, asArrayName, i) as Armor
			If (kItemRef.IsClothing())
				Return True
			Else
				i += 1
			EndIf
		EndWhile

		Return False
	EndFunction

	Function SingleArrayAnimThenStrip(Actor akActor, String asStripArray, String asStrippedArray, String asAnimation = "", Bool abStripNextArrayToo = False)
	;makes the actor animate the stripping animation for a single group of clothing, then strips it
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] SingleArrayAnimThenStrip() called for " + asStripArray + " on actor " + akActor.GetLeveledActorBase().GetName() + ". abStripNextArrayToo is " + abStripNextArrayToo)
		EndIf

		SetStringValue(akActor, SS_CURRENTSTRIPARRAY, asStripArray)
		SetStringValue(akActor, SS_CURRENTSTRIPPEDARRAY, asStrippedArray)

		If (asAnimation) ;if the function has been given an animation to play
			Debug.SendAnimationEvent(akActor, asAnimation)
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] Actor " + akActor.GetLeveledActorBase().GetName() + " playing animation " + asAnimation)
			EndIf
			RegisterForAnimationEvent(akActor, "IdleStop")
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] Registered for IdleStop")
			EndIf
		Else
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] Stripping " + asStripArray + " on actor " + akActor.GetLeveledActorBase().GetName() + " without animating")
			EndIf

			SingleArrayStrip(akActor, asStripArray, asStrippedArray, abStripNextArrayToo) ;go directly to stripping the array without animation
			If (HasIntValue(akActor, SS_FULLSERIALSTRIPSWITCH) || abStripNextArrayToo)
				If (HasIntValue(Self, SS_DEBUGMODE))
					Debug.Trace("[SerialStrip] SingleArrayAnimThenStrip() calling SerialStrip() again because FullSerialStripSwitch is " + HasIntValue(akActor, SS_FULLSERIALSTRIPSWITCH) + " and abStripNextArrayToo is " + abStripNextArrayToo)
				EndIf
				SerialStrip(akActor)
			EndIf
		EndIf
	EndFunction

	Function SingleArrayStrip(Actor akActor, String asStripArray, String asStrippedArray, Bool abStripNextArrayToo = False)
	;makes the actor strip a single group of clothing
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] SingleArrayStrip() called for " + asStripArray + " on actor " + akActor.GetLeveledActorBase().GetName() + ". abStripNextArrayToo is " + abStripNextArrayToo)
		EndIf

		;/ beginValidation /;
		If (!akActor)
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] ERROR: SingleArrayStrip() has been passed a none object for akActor.")
			EndIf
			Return
		EndIf
		;/ endValidation /;

		FormListClear(akActor, asStrippedArray) ;clears the array that will store the stripped items before refilling it

		Int i = FormListCount(akActor, asStripArray) - 1 ;sets i equal to the length of the array (-1 because FormListCount's result is 1-based while the array is 0 based)

		While (i >= 0) ;sets the loop to run up to and including position zero in the array (backwards)

			Form kItemRef = FormListGet(akActor, asStripArray, i) ;fetches the item stored in i position in the array

			If (kItemRef) ;if this is an actual item, i.e. the array has not been cleared
				akActor.UnequipItem(kItemRef) ;unequips this item
				FormListAdd(akActor, asStrippedArray, kItemRef) ;adds the item to this array
			EndIf

			i -= 1 ;go to the next item in the array (backwards)
		EndWhile

		FormListClear(akActor, asStripArray) ;clears the array

		If (!HasIntValue(akActor, SS_FULLSERIALSTRIPSWITCH) && !abStripNextArrayToo) ;if this is a single array strip and we have not been instructed to strip the next array too.
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] Sending SerialStripStop because FullSerialStripSwitch is " + HasIntValue(akActor, SS_FULLSERIALSTRIPSWITCH) + " and abStripNextArrayToo is " + abStripNextArrayToo)
			EndIf

			If (akActor == PlayerRef)
				Game.SetPlayerAIDriven(False) ;give control back to the player
			Else
				ActorUtil.RemovePackageOverride(akActor, DoNothing)
				akActor.EvaluatePackage()
				akActor.SetRestrained(False)
				akActor.SetDontMove(False)
				akActor.SetVehicle(None)
				Marker.Disable()
				Marker.Delete()
			EndIf

			UnRegisterForAnimationEvent(akActor, "IdleStop")
			GoToState("")
			SendSerialStripStopEvent(GetFormValue(akActor, SS_EVENTSENDER), akActor)
		EndIf
	EndFunction

	Function ClearStripLists(Actor akActor)
		FormListClear(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_R)
		FormListClear(akActor, SS_STRIPLIST_WEAPONSANDSHIELDS_L)
		FormListClear(akActor, SS_STRIPLIST_GLOVES)
		FormListClear(akActor, SS_STRIPLIST_HELMET)
		FormListClear(akActor, SS_STRIPLIST_BOOTS)
		FormListClear(akActor, SS_STRIPLIST_CHESTPIECE)
		FormListClear(akActor, SS_STRIPLIST_NECKLACE)
		FormListClear(akActor, SS_STRIPLIST_CIRCLET)
		FormListClear(akActor, SS_STRIPLIST_RING)
		FormListClear(akActor, SS_STRIPLIST_BRA)
		FormListClear(akActor, SS_STRIPLIST_PANTIES)
		FormListClear(akActor, SS_STRIPLIST_OTHER)
	EndFunction

	Event OnAnimationEvent(ObjectReference akSource, string asEventName)
		If (HasIntValue(Self, SS_DEBUGMODE))
			Debug.Trace("[SerialStrip] AnimationEvent detected")
		EndIf

		If (FormListFind(Self, SS_STRIPPINGACTORS, akSource) != -1 && asEventName == "IdleStop")
			If (HasIntValue(Self, SS_DEBUGMODE))
				Debug.Trace("[SerialStrip] Actor " + (akSource as Actor).GetLeveledActorBase().GetName() + " is valid and AnimationEvent is IdleStop")
			EndIf
			UnregisterForAnimationEvent(akSource as Actor, "IdleStop")
			If (!HasIntValue(akSource, SS_ISSHEATHING)) ;only strip if actor has finished sheathing
				SingleArrayStrip(akSource as Actor, GetStringValue(akSource, SS_CURRENTSTRIPARRAY), GetStringValue(akSource, SS_CURRENTSTRIPPEDARRAY)) ;strip this array (without animation - animation has hopefully been already played!)
			EndIf
			If (HasIntValue(akSource, SS_FULLSERIALSTRIPSWITCH) || HasIntValue(akSource, SS_ISSHEATHING))
				If (HasFloatValue(None, SS_WAITTIMEAFTERANIM))
					If (HasIntValue(Self, SS_DEBUGMODE))
						Debug.Trace("[SerialStrip] Waiting for " + GetFloatValue(None, SS_WAITTIMEAFTERANIM) + " seconds as configured by user.")
					EndIf
					Utility.Wait(GetFloatValue(None, SS_WAITTIMEAFTERANIM))
				Else
					If (HasIntValue(Self, SS_DEBUGMODE))
						Debug.Trace("[SerialStrip] Waiting for 1 seconds by default")
					EndIf
					Utility.Wait(1.0)
				EndIf
				SerialStrip(akSource as Actor)
			EndIf
		EndIf
	EndEvent

EndState

Bool Function Uninstall()
	Debug.Trace("SerialStrip uninstalling")
	GoToState("")

	Int i

	While (i < FormListCount(Self, SS_STRIPPINGACTORS))
		Actor kActor = FormListGet(Self, SS_STRIPPINGACTORS, i) as Actor
		UnregisterForAnimationEvent(kActor, "IdleStop")
		ActorUtil.RemovePackageOverride(kActor, DoNothing)
		kActor.EvaluatePackage()
		kActor.SetRestrained(False)
		kActor.SetDontMove(False)
		kActor.SetVehicle(None)
		Marker.Disable()
		Marker.Delete()
		SendSerialStripStopEvent(GetFormValue(kActor, SS_EVENTSENDER), kActor)

		i += 1
	EndWhile

	Game.SetPlayerAIDriven(False)
	UnRegisterForModEvent("SerialStripStart")

	FormListClear(Self, SS_STRIPPINGACTORS)

	UnSetFormValue(Self, SS_ANIM_ARMORGLOVES)
	UnSetFormValue(Self, SS_ANIM_CLOTHGLOVES)
	UnSetFormValue(Self, SS_ANIM_ARMORHELMET)
	UnSetFormValue(Self, SS_ANIM_CLOTHHOOD)
	UnSetFormValue(Self, SS_ANIM_ARMORBOOTS)
	UnSetFormValue(Self, SS_ANIM_CLOTHBOOTS)
	UnSetFormValue(Self, SS_ANIM_ARMORCHESTPIECE)
	UnSetFormValue(Self, SS_ANIM_CLOTHCHESTPIECE)
	UnSetFormValue(Self, SS_ANIM_NECKLACE)
	UnSetFormValue(Self, SS_ANIM_CLOTHCIRCLET)
	UnSetFormValue(Self, SS_ANIM_RING)
	UnSetFormValue(Self, SS_ANIM_BRA)
	UnSetFormValue(Self, SS_ANIM_PANTIES)

	StringListClear(Self, SS_KW_HELMET)
	StringListClear(Self, SS_KW_GLOVES)
	StringListClear(Self, SS_KW_BOOTS)
	StringListClear(Self, SS_KW_CHESTPIECE)
	StringListClear(Self, SS_KW_NECKLACE)
	StringListClear(Self, SS_KW_CIRCLET)
	StringListClear(Self, SS_KW_RING)
	StringListClear(Self, SS_KW_BRA)
	StringListClear(Self, SS_KW_PANTIES)

	UnSetFormValue(Self, SS_SEXLAB)
	UnSetFormValue(None, SS_WAITTIMEAFTERANIM)
	UnsetIntValue(Self, SS_DEBUGMODE)

	ClearAllPrefix("APPS.SerialStrip")

	Debug.Trace("SerialStrip uninstalled")
	Return True
EndFunction

;/ Animation Descriptions & Durations

FArGl		Remove Armor Gloves
FArHe		Remove Armor Helmet
FArBo		Remove Armor Boots
FArNoUS		Remove it - Thats an incomplete chest "shy" version
FArChB		Remove Armor chestpiece
FClGl		Remove Cloth Gloves
FClHo		Remove Cloth Hood
FClBo		Remove Cloth Boots
FClCi		Remove Cloth Circlet
FClChB		Remove Cloth Dress
FULB		Remove Panties
FUUB		Remove Bra
FJN			Remove Necklace
FJR			Remove Ring

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
