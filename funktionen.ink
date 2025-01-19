// ------ Funktionen

=== function ib() ===
{benutze == Ts_Gletscherbrille:
    ~ benutze = Ts_Nichts
    <b>❯</b> Ich lege die Gletscherbrille ab und betrachte
    - else:
    <b>❯</b> Ich betrachte
}


===function mmd() ===
~ return modus == Mo_Dunkel

=== function schalter_pos(schalter, position, text) ===
{schalter:
- position:
    ~ return "[{text}]"
- else:
    ~ return "{text}"
}

=== function benutzer(gegenstand) ===
~ return einfach == 0 && Tasche ? gegenstand && benutze != gegenstand

=== function bereit(gegenstand) ===
~ return Tasche ? gegenstand && (einfach || benutze == gegenstand)

=== function zeige(gegenstand) ===
~ return Tasche ? gegenstand && (einfach || benutze != gegenstand)

=== function mw(wort) ===
{wort:
- To_Schwarz: {mmd():schwarz|weiss}
- To_Weiss: {mmd():weiss|schwarz}
- To_Duester: {mmd():düster|hell}
- else: ERROR
}

=== function tw(wort) ===
{wort:
- Ts_Schluessel: ~ return "Schlüssel"
- Ts_Gletscherbrille: ~ return "Gletscherbrille"
- Ts_Hammer: ~ return "Hammer"
- Ts_Pinzette: ~ return "Pinzette"
- Ts_Giesskanne: ~ return "Giesskanne"
- Ts_Meta: ~ return "Tasche"
- else: ~ return "ERROR"
}

=== function taw(wort) ===
{wort:
- Ts_Schluessel: ~ return "den Schlüssel"
- Ts_Gletscherbrille: ~ return "die Gletscherbrille"
- Ts_Hammer: ~ return "den Hammer"
- Ts_Pinzette: ~ return "die Pinzette"
- Ts_Giesskanne: ~ return "die Giesskanne"
- Ts_Meta: ~ return "die Tasche"
- else: ~ return "ERROR"
}

=== function iwm(wort) ===
{benutze == Ts_Gletscherbrille:
    ~ benutze = Ts_Nichts
    <b>❮</b> Ich lege die Gletscherbrille ab und lenke meine Aufmerksamkeit <b>{wort}</b> weg.
    - else:
    <b>❮</b> Ich lenke meine Aufmerksamkeit <b>{wort}</b> weg.
}


=== function tee_giessen() ===
~ stopSound("loops")
~ playSoundV("events", "tee", 0.5)

=== function schach_spielen() ===
{- !audio_schach_gespielt:
    ~ audio_schach_gespielt = 1
    ~ playSoundV("events", "schach", 0.5)
}

=== function standuhr_schlagen() ===
{- !audio_standuhr_gespielt:
    ~ audio_standuhr_gespielt = 1
    ~ stopSound("loops")
    ~ playSoundV("events-fg", "chime", 0.2)
}

=== function sanduhr_verschwinden() ===
{- !audio_sanduhr_gespielt:
    ~ audio_sanduhr_gespielt = 1
    ~ playSoundS("events-fg", "sanduhr")
}

=== function globus_spielen() ===
{audio_globus_lang_gespielt:
    {currentSound("events-fg2") != "globus_lang":
        ~ playSoundS("events", "globus")
    }
- else:
    ~ stopGroup("foreground")
    ~ stopGroup("loop")
    ~ audio_globus_lang_gespielt = 1
    ~ playSoundS("events-fg2", "globus_lang")
}


=== function play_musicS(name) ===
~ stopGroup("foreground")
~ playSoundS("music-once", name)

=== function play_musicV(name, volume) ===
~ stopGroup("foreground")
~ playSoundV("music-once", name, volume)

// ------ Events

=== function music_loop() ===
{musik_an && currentSound("music-once") == "" && currentSound("events-fg") == "":
    {currentSound("music-loop") != "teppich":
        ~ playSoundV("music-loop", "teppich", 0.02)
    }
}

=== e ===
~ keepSoundAlive()
~ music_loop()
~ temp mach_events = 1
{bienen_bereit > 1:
    ~ bienen_bereit -= 1
}
{teil_zwei == 0 && Tasche ? (Ts_Giesskanne, Ts_Pinzette, Ts_Hammer, Ts_Gletscherbrille):
    ~ teil_zwei = 1
    ~ mach_events = 0
    Teil Zwei - Verwicklung und Entwicklung #CLASS: title
}
{bienen_gesehen == 0 && (bienen_bereit == 1 || (bienen_bereit > 1 && bienen_bereit < 5 && currentSound("events-fg3") != "giessen")):
    ~ mach_events = 0
    ~ bienen_bereit = 0
    ~ bienen_gesehen = 1
    ~ playSoundS("events-fg2", "bienen")
    Aufgrund des schlechten Wetters kehrt ein Schwarm Bienen in den Bienenkorb gegenüber dem Schrank zurück. Die Bienen fliegen die Formation Sense. Sie bestehen eigentlich nur aus ihren {mmd():pechschwarzen|schneeweissen} Streifen und einer {mmd():schneeweissen|pechschwarzen} Wolke darin. "Der TOD der Bienen", denke ich unweigerlich. {bienen_beschreibung} "MIT VERLAUB, DER TOD DER BIENENSCHWÄRME."  #CLASS: event

}
{
    - mach_events && RANDOM(0, 100) <= event_wahrscheinlichkeit:
    { shuffle:
        - {sanduhr_verschwinden()} Die letzen Sandkörner einer Sanduhr auf dem Regal links von mir läuft aus. Einen Moment später verschwindet die Sanduhr. #CLASS: event
        - {standuhr_schlagen()} Die grosse Standuhr aus {mmd():dunkelm|hellem} Holz schlägt, darauf folgt ohrenbetäubende Stille. #CLASS: event
        - {schach_spielen()} Plötzlich nehme ich am Rande meines Blickfelds Bewegung wahr. Ich gehe hinüber zum Beistelltisch aus dunklem Holz mit ausladenden Schnitzereien im orientalischen Stil. Darauf steht ein Schachspiel, und die Figuren bewegen sich von selbst. Aber halt? Der Zug von Schwarz ist nicht erlaubt und der nächste Zug von Weiss genauso wenig. Beide Seiten mogeln!  #CLASS: event
        - ->TeeMachtSich->
        - ->TuerErscheint->
    }
}

- ->->