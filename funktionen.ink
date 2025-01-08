// ------ Funktionen

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
- To_Schwarz: {modus == Mo_Dunkel:schwarz|weiss}
- To_Weiss: {modus == Mo_Dunkel:weiss|schwarz}
- To_Duester: {modus == Mo_Dunkel:düster|hell}
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

=== function standuhr_schlagen() ===
{ 
    - !audio_standuhr_gespielt:
        ~ audio_standuhr_gespielt = 1
        ~ stopSound("loops")
        ~ playSoundV("events-fg", "chime", 0.2)
}

=== function play_musicS(name) ===
~ stopGroup("foreground")
~ playSoundS("music-once", name)

=== function play_musicV(name, volume) ===
~ stopGroup("foreground")
~ playSoundV("music-once", name, volume)

// ------ Events

=== function music_loop() ===
{ hasFrontend() == 1 && currentSound("music-once") == "":
    { currentSound("music-loop") != "teppich":
        ~ playSoundV("music-loop", "teppich", 0.02)
    }
}

=== e ===
~ keepSoundAlive()
{
    - RANDOM(0, 100) <= event_wahrscheinlichkeit:
    { shuffle:
        - Die letzen Sandkörner einer Sanduhr auf dem Regal links von mir läuft aus. Einen Moment später verschwindet die Sanduhr. # CLASS: event
        - {standuhr_schlagen()} Die grosse Standuhr aus {modus == Mo_Dunkel:dunkelm|hellem} Holz schlägt, darauf folgt ohrenbetäubende Stille. # CLASS: event
        - {tuer_gesehen == 0:
            - Eine Tür erscheint.
            Eine kleine Person mit spitzen Ohren tritt ins Studierzimmer, sieht Dich und gibt einen Aufschrei der Verwunderung von sich: "Oh nein, oh nein," und murmelt zu sich selbst, "das ist nicht der HERR. Welche wunderliche Idee hat ER nun wieder? Was soll ich nur machen? Das geht bestimmt nicht gut. Soll nun diese Person sein Aufgaben übernehmen? Oh nein, oh nein. Bestimmt darf ich am Ende das Raumzeitgefüge wiederherstellen. Was soll ich nur machen?". Für einen Moment scheint die kleine Figur Dich anzusprechen wollen, doch dann besinnt sie sich eines Bessern und verschwindet durch die Tür.
            ~ tuer_gesehen = 1
            - else:
                ~ debug_out("Else for tuer_gesehen happened")
                ->e->
        }
    }
}
~ music_loop()

- ->->