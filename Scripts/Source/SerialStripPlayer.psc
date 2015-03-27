ScriptName SerialStripPlayer Extends ReferenceAlias
{ensures SerialStrip will be registered for the stripping events after each game load}

SerialStrip Property SS Auto

Event OnPlayerLoadGame()
	SS.PrepareMod()
EndEvent
