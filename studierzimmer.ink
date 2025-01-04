# TITLE: Studierzimmer
# AUTHOR: Jean-Louis Fuchs
# THEME: dark

LIST Moden = Mo_Dunkel, Mo_Hell
LIST Ton = To_Schwarz, To_Weiss, To_Duester, To_Sonne, To_Dunkl
LIST GlobusSchalter = (GS_Erde), GS_Scheibenwelt, GS_Studierzimmer
LIST Tasche = (Ts_Giesskanne), Ts_Nichts, Ts_Meta
VAR benutze = Ts_Nichts
VAR modus = Mo_Dunkel
VAR lampe_an = 0
VAR audio_standuhr_gespielt = 0
CONST ib = "Ich betrachte"
CONST in = "Ich benutze"
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
        - {standuhr_schlagen()} Die grosse Standuhr aus {modus == Mo_Dunkel:dunkelm|hellem} Holz schlägt, darauf folgt ohrenbetäubende Stille. # CLASS: event
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

- Ein hoher {mw(To_Duester)}er Raum, leuchtet in den schrillsten Grautönen, die man sich nur vorstellen kann. Man fühlt mich wie in einem Comic von Frank Miller oder Mike Mignola. An den Wänden ragen majestätische Säulen, die verschlungene, mystische Ornamente kleiden. ->e->Studierzimmer

=== Studierzimmer ===

Im {modus == Mo_Dunkel:düstern|hellen} Studierzimmer sehe ich: _einen Schreibtisch_.

+ [Schreibtisch]
    {ib} _den Schreibtisch_. In die äusseren Ränder des Schreibtisches aus {mw(To_Schwarz)}em Marmor sind feine, organische Verzierungen gemeisselt. Der Rand der Tischplatte zeigt Gravuren, die an mystische Inschriften erinnern. ->e->Schreibtisch->e->Studierzimmer
+ [{tw(Ts_Meta)}] ->e->Meta->e->Studierzimmer
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
+ [{tw(Ts_Meta)}] ->e->Meta->e->Schreibtisch
+ [Zurück] {iwm("vom Schreibtisch")}

- ->->

= Knopf

Die Gravur zeigt das Symbol {modus == Mo_Dunkel:der Sonne|des Mondes}.

+ Ich drücke auf {modus == Mo_Dunkel:die Sonne|den Mond}.
    {
        - modus == Mo_Dunkel:
            ~ playSoundS("events", "modus-switch-rev")
            ~ modus = Mo_Hell
            ~ setTheme("light")
        - else:
            ~ playSoundS("events", "modus-switch")
            ~ modus = Mo_Dunkel
            ~ setTheme("dark")
    }
    Urplötzlich ist alles was Schwarz ist Weiss und umgekehrt. Die abrupte Veränderung ist schwindelerregend. ->e->Leuchten->e->Knopf
+ [{tw(Ts_Meta)}] ->e->Meta->e->Knopf
+ [Zurück] {iwm("vom Knopf")}

- ->->

= Lampe

+ Ich schalte Lampe {lampe_an:aus|an}.
    ~ playSoundS("events", "snap")
    ~ lampe_an = !lampe_an
     ->e->Leuchten->e->Lampe
+ [{tw(Ts_Meta)}] ->e->Meta->e->Lampe
+ [Zurück] {iwm("von der Lampe")}

- ->->

= Globus

Auf dem Sockel des Globus gibt es einen Schalter mit folgenden Positionen: _Erdenwelt_, _Scheibenwelt_, _Studierzimmer_

+ {GlobusSchalter != GS_Erde} Ich schalte den Globus auf _Erdenwelt_.
    ~ GlobusSchalter = GS_Erde
    {GlobusBeschreibung()} ->e->Globus
+ {GlobusSchalter != GS_Scheibenwelt} Ich schalte den Globus auf _Scheibenwelt_.
    ~ GlobusSchalter = GS_Scheibenwelt
    {GlobusBeschreibung()} ->e->Globus
+ {GlobusSchalter != GS_Studierzimmer} Ich schalte den Globus auf _Studierzimmer_.
    ~ GlobusSchalter = GS_Studierzimmer
    {GlobusBeschreibung()} ->e->Globus
+ [{tw(Ts_Meta)}] ->e->Meta->e->Lampe
+ [Zurück] {iwm("von der Lampe")}

- ->->

= Leuchten

{lampe_an: {modus == Mo_Dunkel:Die Schreibtischlampe strahlt weisses, farbloses Licht aus.|Die Schreibtischlampe leuchtet nun Schwarz und saugt die Helligkeit auf.}}

- ->->

=== function GlobusBeschreibung() ===
{GlobusSchalter:
    - GS_Erde:
        Der Globus zeigt eine Karte der Erde in Ocker, Beige und vergibtem Blau.
    - GS_Scheibenwelt:
        Aus dem Stockel des Globus ragt eine Stange, die sich in den Bauch einer Schildkröte bohrt. Vier Elefanten auf der Schildkröte tragen eine Scheibe. Ozeane, Berge, Ebenen und alles was eine Welt so braucht in spektakulärer polychromer Farbertracht bilden die Welt. Sie ist das echteste im ganzen Schreibzimmer - ein Moment - über der Scheibe hängen Wolken und sie scheinen sich zu bewegen.
    - GS_Studierzimmer:
        Der Globus zeigt dieses Zimmer in Puppenhausegrösse. Zwei Seiten und die Decke sind aus Glas, damit man das Innenleben betrachen kann. Darin stehe ich. Mit einer Lupe könnte ich wohl auch den Globus betrachen.
}

=== Meta ===

In meiner Tasche ist: #TAG: span

+ {Tasche == Ts_Giesskanne && benutze != Ts_Giesskanne} [{cap(taw(Ts_Giesskanne))}]
    ~ benutze = Ts_Giesskanne
    {in} die Giesskanne. ->e->Meta
+ {benutze != Ts_Nichts} Ich lege {taw(Ts_Giesskanne)} weg. #TAG: p
    ~ benutze = Ts_Nichts
    ->e->Meta
+ [Zurück #TAG: p] {iwm("von der Lampe")}

- ->->