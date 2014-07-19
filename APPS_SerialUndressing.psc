ScriptName APPS_SerialUndressing Extends ReferenceAlias
{serial undressing: press a button once to remove one garment, keep it depressed to remove all}

SexLabFramework Property SexLab Auto
;points to the SexLab Framework script so we can use its functions

sslSystemConfig Property SexLabSystemConfig Auto
;points to the SexLab's sslSystemConfig.psc script so we can use its functions

Function PrepareForStripping(Actor akActorRef, String asExceptionListKey, Form[] afExceptionList, Bool[] abSlotOverrideList = True)
;/analyses items worn by ActorRef and puts them in 6 arrays for the actual
stripping function to use.
ActorRef: actor to prepare
afExceptionList: forms passed within this array will NOT be stripped
abSlotOverrideList: a 33-item-long array which defaults to false. Set any item [i] to true to override the user configuration
	for slot i+30 and force-strip it.
/;

	If (akActorRef == none)
	;validation
		return none
	EndIf
	
	Int Gender = SexLab.GetGender(akActorRef)
	;fetches the gender of the actor
	
	Bool[] UserConfigSlots = new Bool[33]
	
	If Gender = 0
	;if the actor is male
	
		UserConfigSlots = SexLabSystemConfig.GetStrip(IsFemale = False)
		;fetch the user's MCM stripping configuration for males
		
	ElseIf Gender = 1
	;if the actor is female
	
		UserConfigSlots = SexLabSystemConfig.GetStrip(IsFemale = True)
		;fetch the user's MCM stripping configuration for females
		
	EndIf
	
	;ARMOR
	
	;CREATING A LOOP to check all the item slots (backwards)
	Int i
	;sets i to zero
	
	While (i <= 32)
	;run this loop up to and including the slot 32
	
		Form ItemRef = akActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30))
		;fetch the item worn in this slot and load it in the ItemRef variable
	
		If (SexLab.IsStrippable(ItemRef) == true)
		;if this item is strippable according to SexLab
	
			If ((StorageUtil.FormListFind(None, asExceptionListKey, ItemRef) As Form) == -1)
			;if this item is not found in the exception array
				
				If (i + 30 == 32 && IsValidSlot(i, UserConfigSlots, abSlotOverrideList))
				;if this is the hair slot (checking for helmets)
				;and both the modder and the user has configured this slot to be strippable
				
					StorageUtil.FormListAdd(akActorRef, "APPS.SerialUndressList.Helmet", ItemRef, allowDuplicate = false)
					;adds this item to the helmet undress list
					
				ElseIf (i + 30 == 32 && IsValidSlot(i, UserConfigSlots, abSlotOverrideList))
				;if this is the body slot
				;and both the modder and the user has configured this slot to be strippable
				
					StorageUtil.FormListAdd(akActorRef, "APPS.SerialUndressList.Body", ItemRef, allowDuplicate = false)
					;adds this item to the body undress list
				
				ElseIf (i + 30 == 33) && IsValidSlot(i, UserConfigSlots, abSlotOverrideList))
				;if this is the hands slot
				;and both the modder and the user has configured this slot to be strippable
				
					StorageUtil.FormListAdd(akActorRef, "APPS.SerialUndressList.Hands", ItemRef, allowDuplicate = false)
					;adds this item to the hands undress list
				
				ElseIf (i + 30 == 37) && IsValidSlot(i, UserConfigSlots, abSlotOverrideList))
				;if this is the feet slot
				;and both the modder and the user has configured this slot to be strippable
					
					StorageUtil.FormListAdd(akActorRef, "APPS.SerialUndressList.Feet", ItemRef, allowDuplicate = false)
					;adds this item to the feet undress list
					
				ElseIf (i + 30 == 52) && IsValidSlot(i, UserConfigSlots, abSlotOverrideList))
				;if this is the underwear slot
				;and both the modder and the user has configured this slot to be strippable
				
					StorageUtil.FormListAdd(akActorRef, "APPS.SerialUndressList.Underwear", ItemRef, allowDuplicate = false)
					;adds this item to the underwear undress list
					
				Else
				
					If (ItemHasKeyword(ItemRef, HelmetKeywords)) && IsValidSlot(i, UserConfigSlots, abSlotOverrideList))
					;if this item has any of the helmet keywords
					;and both the modder and the user has configured this slot to be strippable
					
						StorageUtil.FormListAdd(akActorRef, "APPS.SerialUndressList.Helmet", ItemRef, allowDuplicate = false)
						;adds this item to the helmet undress list
					
					ElseIf (ItemHasKeyword(ItemRef, BodyKeywords)) && IsValidSlot(i, UserConfigSlots, abSlotOverrideList))
					;if this item has any of the body keywords
					;and both the modder and the user has configured this slot to be strippable
					
						StorageUtil.FormListAdd(akActorRef, "APPS.SerialUndressList.Body", ItemRef, allowDuplicate = false)
						;adds this item to the body undress list
					
					ElseIf (ItemHasKeyword(ItemRef, HandsKeywords)) && IsValidSlot(i, UserConfigSlots, abSlotOverrideList))
					;if this item has any of the hands keywords
					;and both the modder and the user has configured this slot to be strippable
					
						StorageUtil.FormListAdd(akActorRef, "APPS.SerialUndressList.Hands", ItemRef, allowDuplicate = false)
						;adds this item to the hands undress list
					
					ElseIf (ItemHasKeyword(ItemRef, FeetKeywords)) && IsValidSlot(i, UserConfigSlots, abSlotOverrideList))
					;if this item has any of the feet keywords
					;and both the modder and the user has configured this slot to be strippable
					
						StorageUtil.FormListAdd(akActorRef, "APPS.SerialUndressList.Feet", ItemRef, allowDuplicate = false)
						;adds this item to the feet undress list
					
					ElseIf (ItemHasKeyword(ItemRef, UnderwearKeywords)) && IsValidSlot(i, UserConfigSlots, abSlotOverrideList))
					;if this item has any of the underwear keywords
					;and both the modder and the user has configured this slot to be strippable
					
						StorageUtil.FormListAdd(akActorRef, "APPS.SerialUndressList.Underwear", ItemRef, allowDuplicate = false)
						;adds this item to the underwear undress list
						
					ElseIf (IsValidSlot(i, UserConfigSlots, abSlotOverrideList
						
						StorageUtil.FormListAdd(akActorRef, "APPS.SerialUndressList.Other", ItemRef, allowDuplicate = false)
						;adds this item to the "other" undress list
						
					EndIf
				EndIf
			EndIf
		EndIf
		i += 1
		;moves the loop to check the next slot (backwards)
	EndWhile
	
	;WEAPONS AND SHIELDS
	;In SexLab's StripFemale and StripMale arrays, this is item 32
	
	Form ItemRef = akActorRef.GetEquippedWeapon(false)
	;fetches right-hand weapon and puts it in ItemRef
	
		If (SexLab.IsStrippable(ItemRef) == true && afExceptionList.Find(ItemRef) == -1)
		;if this item is strippable according to SexLab and is not found in the exception array
		
			StorageUtil.FormListAdd(akActorRef, "APPS.SerialUndressList.WeaponsAndShields", ItemRef, allowDuplicate = false)
			;adds this item to the WeaponsAndShields undress list
			
		EndIf
		
	Form ItemRef = akActorRef.GetEquippedWeapon(true)
	;fetches left-hand weapon and puts it in ItemRef
	
		If (SexLab.IsStrippable(ItemRef) == true && afExceptionList.Find(ItemRef) == -1)
		;if this item is strippable according to SexLab and is not found in the exception array
		
			StorageUtil.FormListAdd(akActorRef, "APPS.SerialUndressList.WeaponsAndShields", ItemRef, allowDuplicate = false)
			;adds this item to the WeaponsAndShields undress list
			
		EndIf
		
	Form ItemRef = akActorRef.GetEquippedShield()
	;fetches shield and puts it in ItemRef
	
		If (SexLab.IsStrippable(ItemRef) == true && afExceptionList.Find(ItemRef) == -1)
		;if this item is strippable according to SexLab and is not found in the exception array
		
			StorageUtil.FormListAdd(akActorRef, "APPS.SerialUndressList.WeaponsAndShields", ItemRef, allowDuplicate = false)
			;adds this item to the WeaponsAndShields undress list
			
		EndIf
EndFunction

Bool Function ItemHasKeyword(Form akItemRef, String[] asKeywords)
;checks whether ItemRef has any of the keywords stored in the Keywords array

	If (ItemRef == none || Keywords == none)
	;validation
		return false
	EndIf

	;CREATING A LOOP to run through all of the item's keywords (backwards)
	Int i = ItemRef.GetNumKeywords()
	;fetches the number of keywords this item has and stores it in i				
	
	While (i > 0)
	;run this loop up to and including first keyword				
		Keyword KeywordRef = ItemRef.GetNthKeyword(i)
		;the actual keyword this loop is looking at with each pass
		If (Keywords.Find(KeywordRef.GetString()) >= 0)
		;if this actual keyword exists in the Keywords array
			Return True		
		EndIf
		
		i -= 1		
		;go to the next item in the loop (backwards)
		
	EndWhile
	
	Return False
EndFunction

Bool Function IsValidSlot(int aiSlot, Bool[] abIsUserConfigStrippable, Bool[] abIsSlotOverride)
;returns true if both the user and the modder have designated this slot as strippable

	If (abIsSlotOverride[aiSlot])
	;if the modder has overridden this slot to strippable
		return true
		
	ElseIf (abIsUserConfigStrippable)
	;if the user has configured this slot as strippable
		return true
		
	Else
		return false
		
	EndIf
EndFunction


	
				
	
	;/
	Form[] ToStrip = new Form[34]
	;declares a 34 item long array to hold the items to be stripped
	
	Form ItemRef
	;declares this variable to temporarily store each item we're working on

	;ARMORS
	
		;CREATING A LOOP to run through all the possible slots (backwards)
		Int i = 31
		;sets i equal to 31 in order to run through 32 items in the array (0 -> 31 equals 32).
		
		While (i >= 0)
		;run this loop up to and including item at position 0
			
			ItemRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30)
			;fetch the item worn in this slot and load it in ItemRef
			
			If ((IsStrippableEnhanced(ItemRef, NoStripKeywords) == False)
			;if the item on this slot is not strippable
			;IF GIVEN NoStripKeywords ARRAY, IT WILL RUN A LOOP
				ToStrip[i] == False
				;mark this slot as not to be stripped
			ElseIf (SlotsToCheck[i] == True || ItemHasKeyword(ItemRef, KeywordsToCheck) == True)
			;if this slot was given in the SlotsToCheck array or has any keyword given in the KeywordsToCheck array
			;TO CHECK ItemHasKeyword IT WILL RUN A LOOP
				ToStrip[i] == True		
				;mark this slot to be stripped
			EndIf
			i -= 1
			;move the next item in the loop (backwards)
		EndWhile
	
	
	;WEAPONS
	
		ItemRef = ActorRef.GetEquippedWeapon(false)
		;fetches right-hand weapon and puts it in ItemRef
		
		If ((IsStrippableEnhanced(ItemRef, NoStripKeywords) == False)
		;if the item on this slot is not strippable
			ToStrip[33] = False
			;marks this slot (hence this item) to not strip
		ElseIf (SlotsToCheck[33] == True || ItemHasKeyword(ItemRef, KeywordsToCheck) == True)
		;if this slot was given in the SlotsToCheck array or has any keyword given in the KeywordsToCheck array
			ToStrip[33] == True
			;marks this slot to strip
		EndIf
		
		
		ItemRef = ActorRef.GetEquippedWeapon(true)
		;fetches left-hand weapon and puts it in ItemRef
		
		If ((IsStrippableEnhanced(ItemRef, NoStripKeywords) == False)
		;if the item on this slot is not strippable
			ToStrip[32] = False
			;marks this slot (hence this item) to not strip
		ElseIf (SlotsToCheck[32] == True || ItemHasKeyword(ItemRef, KeywordsToCheck) == True)
		;if this slot was given in the SlotsToCheck array or has any keyword given in the KeywordsToCheck array
			ToStrip[32] == True			
		EndIf
	
	return ToStrip
EndFunction
/;
	


Bool Function IsStrippableEnhanced(Form ItemRef, String[] NoStripKeywords)
;checks the item with SexLab's IsStrippable(), then checks again for NoStripKeywords
;/QUESTION: I put IsStrippable() and ItemHasKeyword() in If/ElseIf block to avoid
running 2 loops if not needed. Is this correct or should I check with an OR clause?
/;

	If (SexLab.IsStrippable(ItemRef) == False)
	;if the item is checked by SexLab's IsStrippable() and is deemed un-strippable
		Return False
			
	ElseIf (ItemHasKeyword(ItemRef, NoStripKeywords)
	;if this item has any of the NoStripKeywords
		Return False
	
	Else
		Return True
	EndIf
EndFunction

	
	
	;/do a loop into a loop. first loop run through all the slots, second loop through the keywords to check.
	remove items with the keywords we want, then re-check which slots have been left and if they are one of the 4 slots we want, unequip/;

;/SexLab's script
Form[] function StripSlots(Actor ActorRef, bool[] Strip, bool DoAnimate = false, bool AllowNudesuit = true)
	if Strip.Length != 33
		return none
	endIf
	int Gender = ActorRef.GetLeveledActorBase().GetSex()
	; Start stripping animation
	if DoAnimate
		Debug.SendAnimationEvent(ActorRef, "Arrok_Undress_G"+Gender)
	endIf
	; Get Nudesuit
	bool UseNudeSuit = Strip[2] && ((Gender == 0 && Config.UseMaleNudeSuit) || (Gender == 1 && Config.UseFemaleNudeSuit))
	if UseNudeSuit && ActorRef.GetItemCount(Config.NudeSuit) < 1
		ActorRef.AddItem(Config.NudeSuit, 1, true)
	endIf
	; Stripped storage
	Form[] Stripped = new Form[34]
	Form ItemRef
	; Strip weapon
	if Strip[32]
		; Right hand
		ItemRef = ActorRef.GetEquippedWeapon(false)
		if IsStrippable(ItemRef)
			ActorRef.UnequipItemEX(ItemRef, 1, false)
			Stripped[33] = ItemRef
		endIf
		; Left hand
		ItemRef = ActorRef.GetEquippedWeapon(true)
		if IsStrippable(ItemRef)
			ActorRef.UnequipItemEX(ItemRef, 2, false)
			Stripped[32] = ItemRef
		endIf
	endIf
	; Strip armors
	int i = Strip.RFind(true, 31)
	while i >= 0
		if Strip[i]
			; Grab item in slot
			ItemRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30))
			if IsStrippable(ItemRef)
				ActorRef.UnequipItem(ItemRef, false, true)
				Stripped[i] = ItemRef
			endIf
		endIf
		i -= 1
	endWhile
	; Apply Nudesuit
	if UseNudeSuit
		ActorRef.EquipItem(NudeSuit, true, true)
	endIf
	; output stripped items
	return sslUtility.ClearNone(Stripped)
endFunction
;/

;/DUMMY SCRIPT
int ActiveSlot
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

Function SlotsToStrip(Actor ActorRef, Form[] afExceptionList)

0. int i = 1
1. Loop through all possible slots (int AmountOfSlots = 31)
2. Check for NoStrip (inStr)
2.1 if NoStrip = true goto 1
2.2 Check for optional array if it should be unstripped or not
2.2.1 if no modder selection → Check MCM User Configuration
3. i + until i = AmountOfSlots ;we know which slot we’re at
3.1 Check if directly supported Slot (hardcoded if)
3.1.1 if known slot → save in appropriate array (armor to StorageUtil.Strip.Armor)
3.1.2 if not known slot → check for supported Keywords (array with KeyW f.e., hardcoded)
3.1.3 if Keyword known (armor f.e.) → save in appropriate array (armor to StorageUtil.Strip.Armor)
4. call strip function
