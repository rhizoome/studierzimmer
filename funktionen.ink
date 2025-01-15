// ------ Funktionen

===function mmd() ===
~ return modus == Mo_Dunkel

=== function schalter_pos(schalter, position, text) ===
{ schalter:
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
{ wort:
- To_Schwarz: {mmd():schwarz|weiss}
- To_Weiss: {mmd():weiss|schwarz}
- To_Duester: {mmd():düster|hell}
- else: ERROR
}

=== function tw(wort) ===
{ wort:
- Ts_Giesskanne: ~ return "Giesskanne"
- Ts_Meta: ~ return "Tasche"
- else: ~ return "ERROR"
}

=== function taw(wort) ===
{ wort:
- Ts_Giesskanne: ~ return "die Giesskanne"
- Ts_Meta: ~ return "die Tasche"
- else: ~ return "ERROR"
}

=== function iwm(wort) ===
<b>❮</b> Ich lenke meine Aufmerksamkeit <b>{wort}</b> weg.

=== function schach_spielen() ===
{- !audio_schach_gespielt:
    ~ audio_schach_gespielt = 1
    ~ stopSound("loops")
    ~ playSoundV("events-fg", "schach", 0.5)
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
{ hasFrontend() == 1 && currentSound("music-once") == "" && currentSound("events-fg") == "":
    { currentSound("music-loop") != "teppich":
        ~ playSoundV("music-loop", "teppich", 0.02)
    }
}

=== e ===
~ keepSoundAlive()
{
    - RANDOM(0, 100) <= event_wahrscheinlichkeit:
    { shuffle:
        - {sanduhr_verschwinden()} Die letzen Sandkörner einer Sanduhr auf dem Regal links von mir läuft aus. Einen Moment später verschwindet die Sanduhr. #CLASS: event
        - {standuhr_schlagen()} Die grosse Standuhr aus {mmd():dunkelm|hellem} Holz schlägt, darauf folgt ohrenbetäubende Stille. #CLASS: event
        - {schach_spielen()} Plötzlich nehme ich am Rande meines Blickfelds Bewegung wahr. Ich gehe hinüber zum Beistelltisch aus dunklem Holz mit ausladenden Schnitzereien im orientalischen Stil. Darauf steht ein Schachspiel, und die Figuren bewegen sich von selbst. Aber halt? Der Zug von Schwarz ist nicht erlaubt und der nächste Zug von Weiss genauso wenig. Beide Seiten mogeln!  #CLASS: event
        - TODO Tee macht sich selbst
        - ->TuerErscheint->
    }
}
~ music_loop()

- ->->