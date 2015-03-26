ScriptName SerialStripPlayer Extends ReferenceAlias
{ensures SerialStrip will be registered for the stripping events after each game load}

SerialStrip Property SS Auto

Event OnPlayerLoadGame()
	Debug.Trace("[SerialStrip] v.1.0.2-beta")
	SS.RegisterForModEvent("SerialStripStart", "OnSerialStripStart")
	SS.GetSexLab()
EndEvent
