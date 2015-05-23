Scriptname SerialStrip_MCM extends SKI_ConfigBase

Import StorageUtil

String Property SS_WAITTIMEAFTERANIM = "APPS.SerialStrip.WaitingTimeAfterAnim" AutoReadOnly Hidden
String Property SS_DEBUGMODE = "APPS.SerialStrip.DebugMode" AutoReadOnly Hidden

Int Property GeneralOptionFlags = 0x00 Auto Hidden ;OPTION_FLAG_NONE from SKI_ConfigBase

Event OnPageReset(String asPage)
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddSliderOptionST("WaitingTimeAfterAnim", "$SS_TIMEBETWEENANIMANDSTRIP", GetFloatValue(None, SS_WAITTIMEAFTERANIM), "{1} sec", GeneralOptionFlags)
	AddEmptyOption()
	AddToggleOptionST("DebugMode", "$SS_DEBUGMODE", HasIntValue(Self, SS_DEBUGMODE))
	SetCursorPosition(20)
	AddToggleOptionST("UninstallSS", "$SS_UNINSTALLSSTRIP", False, GeneralOptionFlags)
EndEvent

State WaitingTimeAfterAnim
	Event OnSliderOpenST()
		SetSliderDialogStartValue(GetFloatValue(None, SS_WAITTIMEAFTERANIM))
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.1)
	EndEvent

	Event OnSliderAcceptST(Float afSelectedValue)
		Float WaitingTimeAfterAnim

		If (0.0 < afSelectedValue && afSelectedValue < 0.5)	;waiting times < 0.5 seconds are prone to errors (Heromaster)
			WaitingTimeAfterAnim = 0.5
		Else
			WaitingTimeAfterAnim = afSelectedValue
		EndIf

		SetSliderOptionValueST(WaitingTimeAfterAnim, "{1} sec")
		SetFloatValue(None, SS_WAITTIMEAFTERANIM, WaitingTimeAfterAnim)
	EndEvent

	Event OnHighlightST()
		SetInfoText("$SS_TIMEBETWEENANIMANDSTRIP_DESC")
	EndEvent
EndState

State DebugMode
	Event OnSelectST()
		If (HasIntValue(Self, SS_DEBUGMODE))
			UnSetIntValue(Self, SS_DEBUGMODE)
			SetToggleOptionValueST(False)
		Else
			SetIntValue(Self, SS_DEBUGMODE, 1)
			SetToggleOptionValueST(True)
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText("$SS_DEBUGMODE_DESC")
	EndEvent
EndState

State UninstallSS
	Event OnSelectST()
		If (ShowMessage("$SS_UNINSTALLSSTRIPCONFIRM_MSG"))
			GeneralOptionFlags = OPTION_FLAG_DISABLED
			ForcePageReset()
			((Self as Quest) as SerialStripFunctions).Uninstall()
			ShowMessage("$SS_UNINSTALLSSTRIPDONE_MSG")
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText("$SS_UNINSTALLSSTRIP_DESC")
	EndEvent
EndState
