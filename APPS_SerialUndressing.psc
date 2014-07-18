ScriptName APPS_SerialUndressing Extends ReferenceAlias
{serial undressing: press a button once to remove one garment, keep it depressed to remove all}

Function PrepareForStripping(Actor ActorRef, Form[] ExceptionArray)
;/analyses items worn by ActorRef and puts them in 6 arrays for the actual
stripping function to use.
ActorRef: actor to prepare
ExceptionArray: forms passed within this array will NOT be stripped
/;

	If (ActorRef == none)
	;validation
		return none
	EndIf
	
	;CREATING A LOOP
	Int i = 31
	;sets i for 31 (the total number of slots)
	
	While i >= 1
	;run this loop up to and including the first slot
	
		Form ItemRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30)
		;fetch the item worn in this slot and load it in the ItemRef variable
	
	
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
			ElseIf (SlotsToCheck[i] == True || bItemHasKeyword(ItemRef, KeywordsToCheck) == True)
			;if this slot was given in the SlotsToCheck array or has any keyword given in the KeywordsToCheck array
			;TO CHECK bItemHasKeyword IT WILL RUN A LOOP
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
		ElseIf (SlotsToCheck[33] == True || bItemHasKeyword(ItemRef, KeywordsToCheck) == True)
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
		ElseIf (SlotsToCheck[32] == True || bItemHasKeyword(ItemRef, KeywordsToCheck) == True)
		;if this slot was given in the SlotsToCheck array or has any keyword given in the KeywordsToCheck array
			ToStrip[32] == True			
		EndIf
	
	return ToStrip
EndFunction
/;
	
Bool Function bItemHasKeyword(Form ItemRef, String[] Keywords)
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

Bool Function IsStrippableEnhanced(Form ItemRef, String[] NoStripKeywords)
;checks the item with SexLab's IsStrippable(), then checks again for NoStripKeywords
;/QUESTION: I put IsStrippable() and bItemHasKeyword() in If/ElseIf block to avoid
running 2 loops if not needed. Is this correct or should I check with an OR clause?
/;

	If (SexLab.IsStrippable(ItemRef) == False)
	;if the item is checked by SexLab's IsStrippable() and is deemed un-strippable
		Return False
			
	ElseIf (bItemHasKeyword(ItemRef, NoStripKeywords)
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
#5: Wait 1s -> Do again in case of underwear, recognizing SL keywords (for DD f.e.)
OR #5: Wait 1s -> call alternative (old) SexLab undress
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

Function SlotsToStrip(Actor ActorRef, Form[] ExceptionArray)

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
