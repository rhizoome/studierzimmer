# TITLE: Studierzimmer
# AUTHOR: Jean-Louis Fuchs
# THEME: dark

/* Regeln
- Räume zeigen beim Betreten eine Zutandszeile, falls es keinen Zustand gibt, kann man auch nichts anzeigen, je nach Geschack
- Navigations- und Inhaltszeilen heben das wichtige Wort mit Fett hervor, anderer Text im normalfall nicht
- Nutze Symbole
- Sound von Events spielt nur einmal
- Sound von Aktionen jedes mal
- Musik stoppt Vordergrund
*/

/* Ideen
- begiessen als music-once mit Musik
- nach dem man begiesst hat, kann man "Dinge" in der grösse ändern in dem man Sie ins Modell des Zimmer legt oder daraus hinaus nimmt
- gib eine Option zum begissen der anderen Globen, aber mache es nicht: "Keine Umweltkatastrophe auslösen"
*/

/* Todo
- Entferne Giesskanne aus Tasche
- Den "Eine Türe erscheint" Event irgendwann in der Geschichte bestimmt auslösen (nicht nur per Zufall)
*/

/* Outline
- Grosses Ziel: Der Spieler muss die Rätsel und Geheimnisse des Zimmers lösen, um ein kosmisches Gleichgewicht wiederherzustellen.
    - Was ist passiert? Die Kosmische-Verwaltung (Bürokratie) von Scheibenwelt und Erdenwelt wurde aus Kostengründen zusammengelegt. Dabei wurde versehentlich auch TOD zusammengelegt. Jedoch ist dies nicht möglich, der humorvolle TOD der Scheibenwelt würde auf der Erdenwelt zu viel Chaos anrichten.
    - Wie muss es wiederhergestellt werden? TOD muss wieder gespalten werden. Dabei wird wohl der Globus eine zentrale Rolle spielen. Vielleicht kann man einen Avatar von TOD und weitere Anspielungen auf Computertechnik (im Moment haben wir ja Rekursion, Dark/Light-Mode) dazu um TOD zu trennen.
- Teile Kishōtenketsu
    - Einführung (Ki)- Die Welt ohne jegliches Ziel erforschen. Soll mein ursprüngliches Ziel einer Simulation von TODs Studierzimmer entsprechen.
    - Entwicklung (Shō): Der Spieler fängt an das Ziel zu verstehen und sammelt Information und Gegenstände um das Problem zu lösen.
    - Wendepunkt (Ten):  Das grosse Rätsel, dass das Problem löst.
    - Schlussfolgerung (Ketsu): Cinematischer humorfoller Abspann, vielleicht mit beiden TODen, die sich etwas necken.
- Techniken
    - Versuchen eine emergente Geschichte zu erzählen (ähnlich wie Myst), aber nicht zu strikt sein, wenn es klassisches Erzählen braucht, dann ist es halt so.
    - Lasse den Spieler durch auswahl bestimmter Optionen den Charakter der Spielfigure definieren. Nicht versuchen dies in die Rätsel einfliess zu lassen, der Aufwand wäre zu gross. Aber wenn sich eine Kleinigkeit ergibt...
    - Personen für Dialoge: Die kleine Person, Kosmische-Verwaltung übers "Telefon" mit Warteschlange und allen Schickanen die die Bürokratie zu bieten hat.
    - Wenn genügend Zeit vorhanden: Nutze psychoakustik (Eigen plugin) um Sound im Raum zu platzieren
*/

LIST Moden = Mo_Dunkel, Mo_Hell
LIST Ton = To_Schwarz, To_Weiss, To_Duester, To_Sonne, To_Dunkl
LIST GlobusSchalter = (GS_Erde), GS_Scheibenwelt, GS_Studierzimmer
LIST Tasche = Ts_Giesskanne, Ts_Nichts, Ts_Meta
VAR benutze = Ts_Nichts
VAR modus = Mo_Dunkel
VAR lampe_an = 0
VAR audio_standuhr_gespielt = 0
VAR einfach = 0
VAR globus_untersucht = 0
VAR globus_begossen = 0
VAR schrank_offen = 0
VAR tuer_gesehen = 0
CONST ib = "<b>❯</b> Ich betrachte"
CONST in = "<b>▲</b> Ich benutze"
CONST event_wahrscheinlichkeit = 20 // In prozent
CONST debug = 1

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
~ loadSound("events", "tasche", "./458372__Tasche.mp3")
~ loadSound("events", "open-close", "./661997__Open-Close.mp3")
~ loadSound("events", "schrank-open", "./367423__108784__Schrank_Open.mp3")
~ loadSound("events", "schrank-close", "./367423__108784__Schrank_Close.mp3")
~ loadSound("events-fg", "giessen", "./243776__bastipictures__close-rain-and-thunder.mp3")

->Ankunft

INCLUDE src/frontend_func.ink
INCLUDE funktionen.ink

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
    ~ playSoundV("loops", "tick", 0.015)
- "Oh Schreck, wo bin ich?"

Es riecht nach dem Raum zwischen den Gedanken, dieser Leere in der sich selbst Geruch einsam fühlt.

~ temp beschreibung = "Aus einer unendlichen Entfernung - die so weit weg ist, dass es sich wie aus jedem meiner Knochen anfühlt - höre ich donnernd und vibrierend:"

 * "Träume ich?" [] {beschreibung} "DU TRÄUMST NICHT."
 * "Bin ich tot?" [] {beschreibung} "DU BIST NICHT TOT."

- Teil Eins - Entdeckung #CLASS: title

->Studierzimmer.Schau->e->Studierzimmer

=== Studierzimmer ===

Im {modus == Mo_Dunkel:düstern|hellen} Studierzimmer sehe ich: <b>einen Schreibtisch</b>, <b>einen Schrank</b>{tuer_gesehen: und <b>eine Tür</b>}.

-  (Basis)

+ [<b>◉</b> Beschreibung] ->Schau->e->Basis
+ [Schreibtisch] {ib} <b>den Schreibtisch</b>. ->e->Schreibtisch->e->Studierzimmer
+ [Schrank] {ib} <b>den Schrank</b>. ->e->Schrank->e->Studierzimmer
+ {tuer_gesehen} [Tür] Huch, die Tür ist wieder verschwunden, nachdem die kleine Person den Raum verliess. ->e->Basis
+ [{tw(Ts_Meta)}] <b>❯ {tw(Ts_Meta)}</b> ->e->Meta->e->Studierzimmer
// + TODO: Ausgang ->e->END

= Schau

Ein hoher {mw(To_Duester)}er Raum leuchtet in den schrillsten Grautönen, die man sich nur vorstellen kann. Es fühlt sich an, als wäre ich in einem Comic von Frank Miller oder Mike Mignola. An den Wänden ragen majestätische Säulen, die verschlungene, mystische Ornamente kleiden.

- ->->

=== Schrank ===

Die <b>Schranktüre</b> ist <b>{schrank_offen:offen|geschlossen}</b>.

-  (Basis) #CTAG: span

{schrank_offen: Der <b>Schrank</b> enthält:}

+ {schrank_offen && Tasche != Ts_Giesskanne} [{cap(taw(Ts_Giesskanne))}] ->SchauGiesskanne->e->Basis
+ {schrank_offen && Tasche != Ts_Giesskanne} [(nimm) #FLAG: space]
    {einfach == 0: {in} die <b>Giesskanne</b>.}
    ~ Tasche += Ts_Giesskanne
    ->e->Basis
+ [<b>◉</b> Beschreibung #CTAG: p] ->Schau->e->Basis
+ <b>↯</b> Ich {schrank_offen:schliesse|öffne} den Schrank.
    // TODO: sound
    ~ schrank_offen = ! schrank_offen
    {schrank_offen:
        ~ playSoundS("events", "schrank-open")
    - else:
        ~ playSoundS("events", "schrank-close")
    }
     ->Schrank
+ [{tw(Ts_Meta)}] <b>❯ {tw(Ts_Meta)}</b> ->e->Meta->e->Schrank
+ [<b>▼</b> Zurück] {iwm("vom Schrank")}

- ->->

= Schau

Der Schrank wurde von jemandem erbaut, der sonst nur Panzer baut. Die Konstruktion würde einen Bombenangriff überstehen. Dies muss auch dem Erbauer aufgefallen sein, denn er versuchte, mit filigranen Schnitzereien zu kompensieren. Jedoch muss er "filigran" ausschließlich aus dem Wörterbuch kennen, denn die Schnitzereien sind zwar fein, aber nicht zierlich. Vielmehr sind sie geometrisch und starr. Dieser Schrank verkörpert das ideale Hochzeitsgeschenk für einen Borg.

- ->->

=== Schreibtisch ===

Auf dem Schreibtisch sehe ich: <b>einen Knopf</b>, <b>eine Lampe</b> und <b>einen Globus</b>.

-  (Basis)

+ [<b>◉</b> Beschreibung] In die äusseren Ränder des Schreibtisches aus {mw(To_Schwarz)}em Marmor sind feine, organische Verzierungen gemeisselt. Der Rand der Tischplatte zeigt Gravuren, die an mystische Inschriften erinnern. ->e->Basis
+ [Knopf] {ib} <b>den Knopf</b>. ->e->Knopf->e->Schreibtisch
+ [Lampe] {ib} <b>die Lampe</b>. ->e->Lampe->e->Schreibtisch
+ [Globus] {ib} <b>den Globus</b>. ->e->Globus->e->Schreibtisch
+ [{tw(Ts_Meta)}] <b>❯ {tw(Ts_Meta)}</b> ->e->Meta->e->Schreibtisch
+ [<b>▼</b> Zurück] {iwm("vom Schreibtisch")}

- ->->

= Knopf

Die Gravur des Knopfs zeigt das Symbol {modus == Mo_Dunkel:der Sonne|des Mondes}.

-  (KnopfBasis)

+ [<b>◉</b> Beschreibung] In der rechten äusseren Ecke des Schreibtischs ist ein Knopf eingelegt. ->e->KnopfBasis
+ <b>↯</b> Ich drücke auf {modus == Mo_Dunkel:die Sonne|den Mond}.
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
    Urplötzlich ist alles was Schwarz ist Weiss und umgekehrt. Die abrupte Veränderung ist schwindelerregend. ->Leuchten->e->KnopfBasis
+ [{tw(Ts_Meta)}] <b>❯ {tw(Ts_Meta)}</b> ->e->Meta->e->Knopf
+ [<b>▼</b> Zurück] {iwm("vom Knopf")}

- ->->

= Lampe

Die Lampe ist {lampe_an:an|aus}.

-  (LampeBasis)

+ [<b>◉</b> Beschreibung] Es ist eine Bankerlampe mit einem Schirm aus grellgrauem ungrünen Glas. Wie der Schirm in dieser Monochromen Welt so überzeugt grün sein kann, ist mir unerklärbar. ->e->LampeBasis
+ <b>↯</b> Ich schalte Lampe {lampe_an:aus|an}.
    ~ playSoundS("events", "snap")
    ~ lampe_an = !lampe_an
     ->Leuchten->e->LampeBasis
+ [{tw(Ts_Meta)}] <b>❯ {tw(Ts_Meta)}</b> ->e->Meta->e->Lampe
+ [<b>▼</b> Zurück] {iwm("von der Lampe")}

- ->->

= Leuchten

{lampe_an: {modus == Mo_Dunkel:Die Schreibtischlampe strahlt weisses, farbloses Licht aus.|Die Schreibtischlampe leuchtet nun Schwarz und saugt die Helligkeit auf.}}

- ->->

= Globus

->GlobusBeschreibung->

-  (GlobusBasis)

+ [<b>◉</b> Beschreibung]
    ~ globus_untersucht = 1
    ->SchauGlobus->e->GlobusBasis
+ {globus_untersucht && GlobusSchalter != GS_Erde} <b>↯</b> Ich schalte den Globus auf <b>Erdenwelt</b>.
    ~ GlobusSchalter = GS_Erde
    ->SchauGlobus->e->GlobusBasis
+ {globus_untersucht && GlobusSchalter != GS_Scheibenwelt} <b>↯</b> Ich schalte den Globus auf <b>Scheibenwelt</b>.
    ~ GlobusSchalter = GS_Scheibenwelt
    ->SchauGlobus->e->GlobusBasis
+ {globus_untersucht && GlobusSchalter != GS_Studierzimmer} <b>↯</b> Ich schalte den Globus auf <b>Studierzimmer</b>.
    ~ GlobusSchalter = GS_Studierzimmer
    ->SchauGlobus->e->GlobusBasis
+ {bereit(Ts_Giesskanne) && GlobusSchalter == GS_Studierzimmer} <b>↯</b> Ich <b>begiesse</b> den Globus mit der Giesskanne.
    In dem Moment beginnt ein Gewitter, ich höre den Regen auf das Studierzimmer prasseln. Diese Welt verwirrt selbst die Götter der Rekursion. Wie kann das sein?
    ~ globus_begossen = 1
    {playSoundS("events-fg", "giessen")}
    ->e->GlobusBasis
+ {globus_begossen && bereit(Ts_Giesskanne) && GlobusSchalter == GS_Erde} [<b>↯</b> Ich <b>begiesse</b> den Globus mit der Giesskanne.]
    Halt! Nein, ich will keine Umweltkatastrophe auslösen. Wir haben schon genug Probleme mit dem Klima.
    ->e->GlobusBasis
+ {globus_begossen && bereit(Ts_Giesskanne) && GlobusSchalter == GS_Scheibenwelt} [<b>↯</b> Ich <b>begiesse</b> den Globus mit der Giesskanne.]
    Halt! Nein, ich will keine Umweltkatastrophe auslösen.
    ->e->GlobusBasis
+ [{tw(Ts_Meta)}] <b>❯ {tw(Ts_Meta)}</b> ->e->Meta->e->Globus
+ [<b>▼</b> Zurück] {iwm("von der Lampe")}

- ->->

= GlobusBeschreibung

{globus_untersucht: Auf dem Sockel des Globus ruht ein gravierter Schalter, der zwischen drei Welten wechselt: <b>{schalter_pos(GlobusSchalter, GS_Erde, "Erdenwelt")}</b>, <b>{schalter_pos(GlobusSchalter, GS_Scheibenwelt, "Scheibenwelt")}</b>, <b>{schalter_pos(GlobusSchalter, GS_Studierzimmer, "Studierzimmer")}</b>}

- ->->

= SchauGlobus

{GlobusSchalter:
    - GS_Erde:
        Der Globus zeigt eine Karte der Erde in vergibten Grautönen, das Meer ist irgendwie in einem blauen Grau gehalten.
    - GS_Scheibenwelt:
        Aus dem Stockel des Globus ragt eine Stange, die sich in den Bauch einer Schildkröte bohrt. Vier Elefanten auf der Schildkröte tragen eine Scheibe. Ozeane, Berge, Ebenen und alles was eine Welt so braucht in spektakulärer polychromer Farbertracht bilden die Welt. Sie ist das echteste im ganzen Schreibzimmer - ein Moment - über der Scheibe hängen Wolken und sie scheinen sich zu bewegen.
    - GS_Studierzimmer:
        Der Globus zeigt dieses Zimmer in Puppenhausegrösse. Zwei Seiten und die Decke sind aus Glas, damit man das Innenleben betrachen kann. Darin stehe ich. Mit einer Lupe könnte ich wohl auch den Globus betrachen.
}

->GlobusBeschreibung

- ->->

// Globale Beschreibungen (meist Gegenstände)

=== SchauGiesskanne ===

<b>Die Giesskanne von Cordelia Schmiersinn</b>

Ihre Form, eine Symphonie von Natur und Traum,<br>Ein Tanz der Eleganz, so zart wie ein Baum.<br>Der Ausguss wie ein Schwanenhals, sanft geneigt,<br>Lebensstrom spendend, wo die Blüte gedeiht.

Der Korpus gleicht einem Tropfen so rein,<br>Gefangen in ewigem Raum und Sein.<br>Es spricht von der Zeit, als Kunst die Seele lab,<br>Eine Giesskanne, die dem Garten das Leben gab.

So vieles hängt an ihr, die Leben uns bringt,<br>Die Jugendstil-Giesskanne, die Schönheit besingt.

- ->->

=== TuerErscheint ===
~ playSoundS("events", "open-close")
{tuer_gesehen == 0:
    - Eine Tür erscheint.
    Eine kleine Person mit spitzen Ohren tritt ins Studierzimmer, sieht Dich und gibt einen Aufschrei der Verwunderung von sich: "Oh nein, oh nein," und murmelt zu sich selbst, "das ist nicht der HERR. Welche wunderliche Idee hat ER nun wieder? Was soll ich nur machen? Das geht bestimmt nicht gut. Soll nun diese Person seine Aufgaben übernehmen? Oh nein, oh nein. Bestimmt darf ich am Ende das Raumzeitgefüge wiederherstellen. Was soll ich nur machen?". Für einen Moment scheint die kleine Figur Dich anzusprechen wollen, doch dann besinnt sie sich eines Bessern und verschwindet durch die Tür.
    ~ tuer_gesehen = 1
    - else:
        ~ debug_out("Else for tuer_gesehen happened")
        ->e->
}

- ->->

=== Meta ===

// TODO huch wo kommt die Tasche her

~ playSoundV("events", "tasche", 0.1)

- (Basis) #CTAG: span

Meine Tasche enthält:

+ {zeige(Ts_Giesskanne)} [{cap(taw(Ts_Giesskanne))}] ->SchauGiesskanne->e->Basis
+ {benutzer(Ts_Giesskanne)} [(benutze) #FLAG: space]
    {in} die <b>Giesskanne</b>.
    ~ benutze = Ts_Giesskanne
    ->e->Basis
+ {benutze != Ts_Nichts && einfach == 0} [Ich lege {taw(Ts_Giesskanne)} weg. #CTAG: p]
    <b>▼</b> Ich lege <b>{taw(Ts_Giesskanne)}</b> weg.
    ~ benutze = Ts_Nichts
    ->e->Basis
+ [<b>▼</b> Zurück #CTAG: p] {iwm("von der Lampe")}

- ->->
