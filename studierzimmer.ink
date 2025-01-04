# TITLE: Studierzimmer
# AUTHOR: Jean-Louis Fuchs
# THEME: dark

LIST Moden = Dunkel, Hell
LIST Ton = Schwarz, Weiss, Duester, Sonne, Dunkl, Weta
LIST GlobusSchalter = (GS_Erde), GS_Scheibenwelt, GS_Studierzimmer
VAR modus = Dunkel
VAR lampe_an = 0
VAR audio_standuhr_gespielt = 0
CONST ib = "Ich betrachte"
CONST event_wahrscheinlichkeit = 25 // In prozent
CONST debug = 0

INCLUDE src/frontend.ink

~ setTheme("dark")
~ createSlot("loops", true, "loop")
~ createSlot("music-loop", true, "foreground, loop")
~ createSlot("music-once", false, "foreground")
~ createSlot("events", false, "")
~ createSlot("events-fg", false, "foreground")
~ loadSound("music-loop", "teppich", "./teppich.mp3")
~ loadSound("loops", "tick", "./163371__tick_reverse.mp3")
~ loadSound("events", "modus-switch", "./613405__modus-switch.mp3")
~ loadSound("events", "modus-switch-rev", "./613405__modus-switch-rev.mp3")
~ loadSound("events", "chime", "./163371__chime_reverse.mp3")
~ loadSound("events", "snap", "./477519__snap-button.mp3")

->Ankunft

INCLUDE src/frontend_func.ink

// ------ Funktionen

=== function mw(wort) ===
{ wort:
- Schwarz: {modus == Dunkel:schwarz|weiss}
- Weiss: {modus == Dunkel:weiss|schwarz}
- Duester: {modus == Dunkel:düster|hell}
- Weta: {modus == Dunkel:Tasche|Tasche}
- else: ERROR
}

=== function iwm(wort) ===
Ich lenke meine Aufmerksamkeit {wort} weg.

=== function standuhr_schlagen() ===
{ 
    - !audio_standuhr_gespielt:
        ~ audio_standuhr_gespielt = 1
        ~ stopSound("loops")
        ~ playSoundS("events", "chime")
}

=== function play_musicS(name) ===
~ stopGroup("foreground")
~ playSoundS("music-once", name)

=== function play_musicV(name, volume) ===
~ stopGroup("foreground")
~ playSoundV("music-once", name, volume)

// ------ Events

=== function music_loop() ===
{ hasFrontend() == 1 && currentSound("music-once") =="":
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
        - {standuhr_schlagen()} Die grosse Standuhr aus {modus == Dunkel:dunkelm|hellem} Holz schlägt, darauf folgt ohrenbetäubende Stille. # CLASS: event
    }
}
~ music_loop()

- ->->

// ------ Geschichte

=== Ankunft ===

"Siehst Du, ich stecke meine Hand hinein und nichts passiert."

* [Ich stecke die Hand nochmal hinein.]
    ~ music_loop()
    ~ playSoundV("loops", "tick", 0.02)
- "Oh Schreck, wo bin ich?"

Es riecht nach dem Raum zwischen den Gedanken, dieser Leere in der sich selbst Geruch einsam fühlt.

~ temp beschreibung = "Aus einer unendlichen Entfernung - die so weit weg ist, dass es sich wie aus jedem meiner Knochen anfühlt - höre ich donnernd und vibrierend:"

 * "Träume ich?"
    {beschreibung} "DU TRÄUMST NICHT."
 * "Bin ich tot?"
     {beschreibung} "DU BIST NICHT TOT."

- Ein hoher {mw(Duester)}er Raum, leuchtet in den schrillsten Grautönen, die man sich nur vorstellen kann. Man fühlt mich wie in einem Comic von Frank Miller oder Mike Mignola. An den Wänden ragen majestätische Säulen, die verschlungene, mystische Ornamente kleiden. ->e->Studierzimmer

=== Studierzimmer ===

Im {modus == Dunkel:düstern|hellen} Studierzimmer sehe ich: _einen Schreibtisch_.

+ [Schreibtisch]
    {ib} _den Schreibtisch_. In die äusseren Ränder des Schreibtisches aus {mw(Schwarz)}em Marmor sind feine, organische Verzierungen gemeisselt. Der Rand der Tischplatte zeigt Gravuren, die an mystische Inschriften erinnern. ->e->Schreibtisch->e->Studierzimmer
+ [{mw(Weta)}] ->e->Meta->e->Studierzimmer
+ TODO: Ausgang ->e->END
    
=== Schreibtisch ===

Auf dem Tisch sehe ich: _einen Knopf_, _eine Lampe_ und _einen Globus_.

+ [Knopf]
    {ib} _den Knopf_.
    In der rechten äusseren Ecke des Schreibtischs ist ein Knopf eingelegt. ->e->Knopf->e->Schreibtisch
+ [Lampe]
    {ib} _die Lampe_.
    Es ist eine Bankerlampe mit einem Schirm aus grellgrauem ungrünen Glas. Wie der Schirm in dieser Monochromen Welt so überzeugt grün sein kann, ist mir unerklärbar. ->e->Lampe->e->Schreibtisch
+ [Globus] {ib} _den Globus_. {GlobusBeschreibung()} ->e->Globus->e->Schreibtisch
+ [{mw(Weta)}] ->e->Meta->e->Schreibtisch
+ [Zurück] {iwm("vom Schreibtisch")}

- ->->

= Knopf

Die Gravur zeigt das Symbol {modus == Dunkel:der Sonne|des Mondes}.

+ Ich drücke auf {modus == Dunkel:die Sonne|den Mond}.
    {
        - modus == Dunkel:
            ~ playSoundS("events", "modus-switch-rev")
            ~ modus = Hell
            ~ setTheme("light")
        - else:
            ~ playSoundS("events", "modus-switch")
            ~ modus = Dunkel
            ~ setTheme("dark")
    }
    Urplötzlich ist alles was Schwarz ist Weiss und umgekehrt. Die abrupte Veränderung ist schwindelerregend. ->e->Leuchten->e->Knopf
+ [{mw(Weta)}] ->e->Meta->e->Knopf
+ [Zurück] {iwm("vom Knopf")}

- ->->

= Lampe

+ Ich schalte Lampe {lampe_an:aus|an}.
    ~ playSoundS("events", "snap")
    ~ lampe_an = !lampe_an
     ->e->Leuchten->e->Lampe
+ [{mw(Weta)}] ->e->Meta->e->Lampe
+ [Zurück] {iwm("von der Lampe")}

- ->->

= Globus

hallo

- ->->

= Leuchten

{lampe_an: {modus == Dunkel:Die Schreibtischlampe strahlt weisses, farbloses Licht aus.|Die Schreibtischlampe leuchtet nun Schwarz und saugt die Helligkeit auf.}}

- ->->

=== function GlobusBeschreibung() ===
{GlobusSchalter:
    - GS_Erde:
        Der Globus zeigt eine Karte der Erde in Ocker, Beige und vergibtem Blau.
    - GS_Scheibenwelt:
        Aus dem Stockel des Globus ragt eine Stange, die sich in den Bauch einer Schildkröte bohrt. Vier Elefanten auf der Schildkröte tragen eine Scheibe. Ozeane, Berge, Ebenen und alles was eine Welt so braucht in aller polychrome Farbertracht bilden die Schreibe. Sie ist das echteste im ganzen Schreibzimmer - ein Moment - es über der Scheibe hängen Wolken und sie scheinen sich zu bewegen.
}

=== Meta ===

In meiner Tasche ist: _nichts_

- ->->