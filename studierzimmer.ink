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
VAR einfach = 0
CONST ib = "<b>❯</b> Ich betrachte"
CONST in = "<b>▲</b> Ich benutze"
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
~ loadSound("events-fg", "chime", "./163371__chime_reverse.mp3")
~ loadSound("events", "snap", "./477519__snap-button.mp3")
~ loadSound("events-fg", "giessen", "./243776__bastipictures__close-rain-and-thunder.mp3")

->Ankunft

INCLUDE src/frontend_func.ink

// ------ Funktionen

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
- Ts_Meta: ~ return "<b>Tasche</b>"
- else: ~ return "ERROR"
}

=== function taw(wort) ===
{ wort:
- Ts_Giesskanne: ~ return "die Giesskanne"
- Ts_Meta: ~ return "die Tasche"
- else: ~ return "ERROR"
}

=== function iwm(wort) ===
<b>❮</b> Ich lenke meine Aufmerksamkeit {wort} weg.

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
    }
}
~ music_loop()

- ->->

=== Ankunft ===

Benutze einen Kopfhörer. Zuerst wirst Du leise Klänge hören, stelle die Lautstärke so ein, dass Du diese nur leise hörst.

+ Ich will Rätsel lösen.
    ~ einfach = 0
+ Ich will die Fantasiewelt geniessen.
    ~ einfach = 1

- ~ keepSoundAlive()

-> Geschichte

// ------ Geschichte

=== Geschichte ===

"Siehst Du, ich stecke meine Hand hinein und nichts passiert."

* [Ich stecke die Hand nochmal hinein.]
    ~ music_loop()
    ~ playSoundV("loops", "tick", 0.02)
- "Oh Schreck, wo bin ich?"

Es riecht nach dem Raum zwischen den Gedanken, dieser Leere in der sich selbst Geruch einsam fühlt.

~ temp beschreibung = "Aus einer unendlichen Entfernung - die so weit weg ist, dass es sich wie aus jedem meiner Knochen anfühlt - höre ich donnernd und vibrierend:"

 * "Träume ich?" [] {beschreibung} "DU TRÄUMST NICHT."
 * "Bin ich tot?" [] {beschreibung} "DU BIST NICHT TOT."

- ->Studierzimmer.Schau->e->Studierzimmer

=== Studierzimmer ===

Im {modus == Mo_Dunkel:düstern|hellen} Studierzimmer sehe ich: <b>einen Schreibtisch</b>.

-  (Basis)

+ [<b>◉</b> Beschreibung] ->Schau->e->Basis
+ [Schreibtisch] {ib} <b>den Schreibtisch</b>. ->e->Schreibtisch->e->Studierzimmer
+ [{tw(Ts_Meta)}] <b>❯</b> {tw(Ts_Meta)} ->e->Meta->e->Studierzimmer
// + TODO: Ausgang ->e->END

= Schau

Ein hoher {mw(To_Duester)}er Raum, leuchtet in den schrillsten Grautönen, die man sich nur vorstellen kann. Man fühlt mich wie in einem Comic von Frank Miller oder Mike Mignola. An den Wänden ragen majestätische Säulen, die verschlungene, mystische Ornamente kleiden.

- ->->
    
=== Schreibtisch ===

Auf dem Schreibtisch sehe ich: <b>einen Knopf</b>, <b>eine Lampe</b> und <b>einen Globus</b>.

-  (Basis)

+ [<b>◉</b> Beschreibung] In die äusseren Ränder des Schreibtisches aus {mw(To_Schwarz)}em Marmor sind feine, organische Verzierungen gemeisselt. Der Rand der Tischplatte zeigt Gravuren, die an mystische Inschriften erinnern. ->e->Basis
+ [Knopf] {ib} <b>den Knopf</b>. ->e->Knopf->e->Schreibtisch
+ [Lampe] {ib} <b>die Lampe</b>. ->e->Lampe->e->Schreibtisch
+ [Globus] {ib} <b>den Globus</b>. ->e->Globus->e->Schreibtisch
+ [{tw(Ts_Meta)}] <b>❯</b> {tw(Ts_Meta)} ->e->Meta->e->Schreibtisch
+ [<b>▼</b> Zurück] {iwm("vom Schreibtisch")}

- ->->

= Knopf

Die Gravur des Knopfs zeigt das Symbol {modus == Mo_Dunkel:der Sonne|des Mondes}.

-  (KnopfBasis)

+ [<b>◉</b> Beschreibung] In der rechten äusseren Ecke des Schreibtischs ist ein Knopf eingelegt. ->e->KnopfBasis
+ [Ich drücke auf {modus == Mo_Dunkel:die Sonne|den Mond}.]
    <b>↯</b> Ich drücke auf {modus == Mo_Dunkel:die Sonne|den Mond}.
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
    Urplötzlich ist alles was Schwarz ist Weiss und umgekehrt. Die abrupte Veränderung ist schwindelerregend. ->Leuchten->
+ [{tw(Ts_Meta)}] <b>❯</b> {tw(Ts_Meta)} ->e->Meta->e->Knopf
+ [<b>▼</b> Zurück] {iwm("vom Knopf")}

- ->->

= Lampe

Die Lampe ist {lampe_an:an|aus}.

-  (LampeBasis)

+ [<b>◉</b> Beschreibung] Es ist eine Bankerlampe mit einem Schirm aus grellgrauem ungrünen Glas. Wie der Schirm in dieser Monochromen Welt so überzeugt grün sein kann, ist mir unerklärbar. ->e->LampeBasis
+ [Ich schalte Lampe {lampe_an:aus|an}.]
    <b>↯</b> Ich schalte Lampe {lampe_an:aus|an}
    ~ playSoundS("events", "snap")
    ~ lampe_an = !lampe_an
     ->Leuchten->
+ [{tw(Ts_Meta)}] <b>❯</b> {tw(Ts_Meta)} ->e->Meta->e->Lampe
+ [<b>▼</b> Zurück] {iwm("von der Lampe")}

- ->->

= Globus

Auf dem Sockel des Globus gibt es einen Schalter mit folgenden Positionen: <b>Erdenwelt</b>, <b>Scheibenwelt</b>, <b>Studierzimmer</b>

-  (GlobusBasis)

+ [<b>◉</b> Beschreibung] ->SchauGlobus->e->GlobusBasis
+ {GlobusSchalter != GS_Erde} <b>↯</b> Ich schalte den Globus auf <b>Erdenwelt</b>.
    ~ GlobusSchalter = GS_Erde
    ->SchauGlobus->e->GlobusBasis
+ {GlobusSchalter != GS_Scheibenwelt} <b>↯</b> Ich schalte den Globus auf <b>Scheibenwelt</b>.
    ~ GlobusSchalter = GS_Scheibenwelt
    ->SchauGlobus->e->GlobusBasis
+ {GlobusSchalter != GS_Studierzimmer} <b>↯</b> Ich schalte den Globus auf <b>Studierzimmer</b>.
    ~ GlobusSchalter = GS_Studierzimmer
    ->SchauGlobus->e->GlobusBasis
+ {bereit(Ts_Giesskanne) && GlobusSchalter == GS_Studierzimmer} [Ich <b>begiesse</b> den Globus mit der Giesskanne.]
    <b>↯</b> Ich <b>begiesse</b> den Globus mit der Giesskanne.
    In dem Moment beginnt ein Gewitter, ich höre den Regen auf das Studierzimmer prasseln. Diese Welt verwirrt selbst die Götter der Rekursion. Wie kann das sein?
    {playSoundS("events-fg", "giessen")}
+ [{tw(Ts_Meta)}] <b>❯</b> {tw(Ts_Meta)} ->e->Meta->e->Globus
+ [<b>▼</b> Zurück] {iwm("von der Lampe")}

- ->->

= Leuchten

{lampe_an: {modus == Mo_Dunkel:Die Schreibtischlampe strahlt weisses, farbloses Licht aus.|Die Schreibtischlampe leuchtet nun Schwarz und saugt die Helligkeit auf.}}

- ->->

= SchauGlobus

{GlobusSchalter:
    - GS_Erde:
        Der Globus zeigt eine Karte der Erde in Ocker, Beige und vergibtem Blau.
    - GS_Scheibenwelt:
        Aus dem Stockel des Globus ragt eine Stange, die sich in den Bauch einer Schildkröte bohrt. Vier Elefanten auf der Schildkröte tragen eine Scheibe. Ozeane, Berge, Ebenen und alles was eine Welt so braucht in spektakulärer polychromer Farbertracht bilden die Welt. Sie ist das echteste im ganzen Schreibzimmer - ein Moment - über der Scheibe hängen Wolken und sie scheinen sich zu bewegen.
    - GS_Studierzimmer:
        Der Globus zeigt dieses Zimmer in Puppenhausegrösse. Zwei Seiten und die Decke sind aus Glas, damit man das Innenleben betrachen kann. Darin stehe ich. Mit einer Lupe könnte ich wohl auch den Globus betrachen.
}

- ->->

// Globale Beschreibungen

=== SchauGiesskanne ===

<b>Die Giesskanne von Cordelia Schmiersinn</b>

Ihre Form, eine Symphonie von Natur und Traum,<br>Ein Tanz der Eleganz, so zart wie ein Baum.<br>Der Ausguss wie ein Schwanenhals, sanft geneigt,<br>Lebensstrom spendend, wo die Blüte gedeiht.

Der Korpus gleicht einem Tropfen so rein,<br>Gefangen in ewigem Raum und Sein.<br>Es spricht von der Zeit, als Kunst Seele die lab,<br>Eine Giesskanne, die dem Garten das Leben gab.

So vieles hängt an ihr, die Leben uns bringt,<br>Die Jugendstil-Giesskanne, die Schönheit besingt.

- ->->

=== Meta ===

Meine Tasche enthäl:t #TAG: span

+ {zeige(Ts_Giesskanne)} [{cap(taw(Ts_Giesskanne))}] ->SchauGiesskanne->e->Meta
+ {benutzer(Ts_Giesskanne)} [(benutze) #FLAG: space]
    {einfach == 0: {in} die Giesskanne.}
    ~ benutze = Ts_Giesskanne
    ->e->Meta
+ {benutze != Ts_Nichts && einfach == 0} [Ich lege {taw(Ts_Giesskanne)} weg. #TAG: p]
    <b>▼</b> Ich lege {taw(Ts_Giesskanne)} weg.
    ~ benutze = Ts_Nichts
    ->e->Meta
+ [<b>▼</b> Zurück #TAG: p] {iwm("von der Lampe")}

- ->->

/* Regeln
- Räume zeigen beim Betreten eine Zutandszeile, falls es keinen Zustand gibt, kann man auch nichts anzeigen, je nach geschack
- Navigations- und Inhaltszeilen heben das wichtige Wort mit Fett hervor, anderer Text im Normalfall nicht
- Nutze Symbole
- Sound von Events spielt nur einmal
- Sound von Aktionen jedes mal
- Musik stoppt Fordergrund
*/

/* Ideen

- begiessen als music-once mit Musik
- nach dem man begiesst hat, kann man "Dinge" in der grösse ändern in dem man Sie ins Modell des Zimmer legt oder daraus hinaus nimmt
- gib eine Option zum begissen der anderen Globen, aber mache es nicht
*/

/* Todo
- Entferne Giesskanne aus Tasche
*/