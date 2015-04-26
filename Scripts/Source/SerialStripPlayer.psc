ScriptName SerialStripPlayer Extends ReferenceAlias
{ensures SerialStrip will be registered for the stripping events after each game load}

Event OnPlayerLoadGame()
	(GetOwningQuest() As SerialStripFunctions).PrepareMod()
EndEvent
