// ------ Funktionen

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
~ return einfach == 0 && Tasche == Ts_Giesskanne && (einfach || benutze != Ts_Giesskanne)

=== function bereit(gegenstand) ===
~ return Tasche == gegenstand && (einfach || benutze == gegenstand)

=== function zeige(gegenstand) ===
~ return Tasche == Ts_Giesskanne && (einfach || benutze != Ts_Giesskanne)

=== function mw(wort) ===
{wort:
- To_Schwarz: {mmd():schwarz|weiss}
- To_Weiss: {mmd():weiss|schwarz}
- To_Duester: {mmd():düster|hell}
- else: ERROR
}

=== function tw(wort) ===
{wort:
- Ts_Giesskanne: ~ return "Giesskanne"
- Ts_Meta: ~ return "Tasche"
- else: ~ return "ERROR"
}

=== function taw(wort) ===
{wort:
- Ts_Giesskanne: ~ return "die Giesskanne"
- Ts_Meta: ~ return "die Tasche"
- else: ~ return "ERROR"
}

=== function iwm(wort) ===
<b>❮</b> Ich lenke meine Aufmerksamkeit <b>{wort}</b> weg.

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
    {currentSound("events-fg") != "globus_lang":
        ~ playSoundS("events", "globus")
    }
- else:
    ~ stopGroup("foreground")
    ~ stopGroup("loop")
    ~ audio_globus_lang_gespielt = 1
    ~ playSoundS("events-fg", "globus_lang")
}


=== function play_musicS(name) ===
~ stopGroup("foreground")
~ playSoundS("music-once", name)

=== function play_musicV(name, volume) ===
~ stopGroup("foreground")
~ playSoundV("music-once", name, volume)

// ------ Events

=== function music_loop() ===
{currentSound("music-once") == "" && currentSound("events-fg") == "":
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
{bienen_bereit == 1 || (bienen_bereit > 2 && bienen_bereit < 6 && currentSound("events-fg") != "giessen"):
    ~ mach_events = 0
    ~ bienen_bereit = 0
    ~ bienen_gesehen = 1
    {playSoundS("events-fg2", "bienen")} Aufgrund des schlechten Wetters kehrt ein Schwarm Bienen in den Bienenkorb direkt neben dem Schrank zurück. Die Bienen fliegen die Formation Sense. Sie bestehen eigentlich nur aus ihren {mmd():pechschwarzen|schneeweissen} Streifen und einer {mmd():schneeweissen|pechschwarzen} Wolke darin. "Der TOD der Bienen", denke ich unweigerlich. Aus einer unendlichen Entfernung - die so weit weg ist, dass es sich wie aus jedem meiner Knochen anfühlt - höre ich: "MIT VERLAUB, DER TOD DES SCHWARMS."  #CLASS: event
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