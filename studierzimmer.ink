#TITLE: Studierzimmer
#AUTHOR: Jean-Louis Fuchs
#THEME: dark

/* Regeln
- Räume zeigen beim Betreten eine Zutandszeile, falls es keinen Zustand gibt, kann man auch nichts anzeigen, je nach Geschack
- Navigations- und Inhaltszeilen heben das wichtige Wort mit Fett hervor, anderer Text im normalfall nicht
- Nutze Symbole
- Sound von Events spielt nur einmal
- Sound von Aktionen jedes mal
*/

/* Ideen
- Safe aus Porzelan
- Verwaltung erst verärgern
- Nur im Hell Modus ist die Stimme an der Hotline gut gelaunt
- Damit die Leute nicht im Hell Modus (visuell) sein müssen gibt es eine Inverterbrille
- Die Inveterbrille ist weggeschlosen
- Rätsel um etwas zu öffnen wo Zeugs drin ist
- nach dem man begiesst hat, kann man "Dinge" in der grösse ändern in dem man Sie ins Modell des Zimmer legt oder daraus hinaus nimmt
- Damit kann man einen Safe verkleinern und vergrössern
*/

/* Todo
- Achievments
- Hotline Rätsel Gegenstände
- Den "Eine Türe erscheint" Event irgendwann in der Geschichte bestimmt auslösen (nicht nur per Zufall)
*/

/* Outline
- TODs Reich basiert nun zum Teil aus der Logik der Physik und zum Teil aus der alten Scheibenwelt Logik. Es ist als ob TOD einige Physikbücher gelesen hätte um sein Reich den neuen Gegebenheiten anzupassen. Wie üblich versteht er so einiges falsch oder zu Wörtlich.
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
LIST Tasche = Ts_Schluessel, Ts_Gletscherbrille, Ts_Hammer, Ts_Giesskanne, Ts_Pinzette, Ts_Nichts, Ts_Meta
VAR benutze = Ts_Nichts
VAR modus = Mo_Dunkel
VAR lampe_an = 0
VAR musik_an = 1
VAR audio_standuhr_gespielt = 0
VAR audio_sanduhr_gespielt = 0
VAR audio_globus_lang_gespielt = 0
VAR audio_schach_gespielt = 0
VAR einfach = 0
VAR globus_untersucht = 0
VAR globus_begossen = 0
VAR schrank_offen = 0
VAR schrank_gesehen = 0
VAR tuer_gesehen = 0
VAR tasche_gesehen = 0
VAR tee_erschienen = 0
VAR bienen_bereit = 0
VAR bienen_gesehen = 0
VAR bienen_versuch = 0
VAR teil_zwei = 0
VAR einschlagen_versuch = 0
CONST in = "<b>▲</b> Ich benutze"
CONST inn = "<b>▲</b> Ich nehme"
CONST event_wahrscheinlichkeit = 20 // In Prozent
CONST debug = 0
CONST cheats = 0
CONST bienen_beschreibung = "Aus einer unendlichen Entfernung - die so weit weg ist, dass es sich wie aus jedem meiner Knochen anfühlt - höre ich donnernd und vibrierend:"

INCLUDE src/frontend.ink

~ setTheme("dark")
~ createSlot("loops", true, "loop")
~ createSlot("music-loop", true, "foreground, loop")
~ createSlot("music-once", false, "foreground")
~ createSlot("events", false, "")
~ createSlot("events-fg", false, "foreground")
~ createSlot("events-fg2", false, "foreground")
~ createSlot("events-fg3", false, "foreground")
~ loadSound("music-loop", "teppich", "./teppich.mp3")
~ loadSound("loops", "tick", "./163371__tick_reverse.mp3")
~ loadSound("events", "modus-switch", "./613405__modus-switch.mp3")
~ loadSound("events", "modus-switch-rev", "./613405__modus-switch-rev.mp3")
~ loadSound("events", "snap", "./477519__snap-button.mp3")
~ loadSound("events", "tasche", "./458372__Tasche.mp3")
~ loadSound("events", "tasche-zu", "./467604__close-bag.mp3")
~ loadSound("events-fg", "chime", "./163371__chime_reverse.mp3")
~ loadSound("events-fg", "open-close", "./661997__Open-Close.mp3")
~ loadSound("events", "schrank-open", "./367423__108784__Schrank_Open.mp3")
~ loadSound("events", "schrank-close", "./367423__108784__Schrank_Close.mp3")
~ loadSound("events-fg", "sanduhr", "./416478__low-swoosh.mp3")
~ loadSound("events-fg3", "giessen", "./243776__close-rain-and-thunder.mp3")
~ loadSound("events-fg2", "globus_lang", "./717147__Globus.mp3")
~ loadSound("events", "schach", "./733927__Chess.mp3")
~ loadSound("events", "globus", "./717147__Globus-Short.mp3")
~ loadSound("events", "take", "./428748__taking.mp3")
~ loadSound("events", "tee", "./324937__Tea.mp3")
~ loadSound("events-fg2", "bienen", "./73370__Bienen.mp3")
~ loadSound("loops", "bienenkorb", "./73370__Bienenkorb.mp3")

->Ankunft

INCLUDE src/frontend_func.ink
INCLUDE funktionen.ink

=== Ankunft ===

Benutze einen Kopfhörer. Zuerst wirst Du leise Klänge hören, stelle die Lautstärke so ein, dass Du diese nur leise hörst.

<b>Eine deutsche interaktive Fangeschichte.</b> Du kannst das Fandom selbst erraten. Wenn Du schon einmal vom B-Raum gehört hast, dann schau doch rein.

{cheats:
    ~ keepSoundAlive()
    ->Cheats->
}

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

 * "Träume ich?" [] {bienen_beschreibung} "DU TRÄUMST NICHT."
 * "Bin ich tot?" [] {bienen_beschreibung} "DU BIST NICHT TOT."

- Teil Eins - Entdeckung #CLASS: title

->Studierzimmer.Schau->e->Studierzimmer

=== Studierzimmer ===

Im {mmd():düstern|hellen} Studierzimmer sehe ich: <b>einen Schreibtisch</b>, <b>einen Schrank</b>{tuer_gesehen: und <b>eine Tür</b>}.

-  (Basis)

+ [<b>◉</b> Beschreibung] ->Schau->e->Basis
+ [Schreibtisch] {ib()} <b>den Schreibtisch</b>. ->e->Schreibtisch->e->Studierzimmer
+ [Schrank] {ib()} <b>den Schrank</b>. ->e->Schrank->e->Studierzimmer
+ {tuer_gesehen} [Tür] Huch, die Tür ist wieder verschwunden, nachdem die kleine Person den Raum verliess. ->e->Basis
+ {bienen_gesehen} [Bienenkorb] {ib()} <b>den Bienenkorb</b>
    ~ musik_an = 0
    ->e->Bienenkorb->Studierzimmer
+ {schrank_gesehen} [Panzerschrank] {ib()} <b>den Panzerschrank</b> ->e->Panzerschrank->Studierzimmer
+ [{tw(Ts_Meta)}] <b>❯ {tw(Ts_Meta)}</b> ->e->Meta->e->Studierzimmer
// + TODO: Ausgang ->e->END

= Schau

Ein hoher {mw(To_Duester)}er Raum leuchtet in den schrillsten Grautönen, die man sich nur vorstellen kann. Es fühlt sich an, als wäre ich in einem Comic von Frank Miller oder Mike Mignola. An den Wänden ragen majestätische Säulen, die verschlungene, mystische Ornamente kleiden.

- ->->

=== Schrank ===

Die <b>Schranktüre</b> ist <b>{schrank_offen:offen|geschlossen}</b>.

-  (Basis) #CTAG: span

{schrank_offen:Der <b>Schrank</b> enthält{Tasche ? (Ts_Giesskanne, Ts_Hammer): nichts.|:}}

+ {schrank_offen && Tasche !? Ts_Giesskanne} [Eine Giesskanne]  ->SchauGiesskanne->e->Basis
+ {schrank_offen && Tasche !? Ts_Giesskanne} [(nimm) #FLAG: space] {inn} die <b>Giesskanne</b>.
    ~ Tasche += Ts_Giesskanne
    ~ playSoundV("events", "take", 0.25)
    ->e->Basis
+ {schrank_offen && Tasche !? Ts_Hammer} [Ein Hammer]  ->SchauHammer->e->Basis
+ {schrank_offen && Tasche !? Ts_Hammer} [(nimm) #FLAG: space] {inn} die <b>Giesskanne</b>.
    ~ Tasche += Ts_Hammer
    ~ playSoundV("events", "take", 0.25)
    ->e->Basis
+ {schrank_offen && Tasche !? Ts_Gletscherbrille} [Eine Gletscherbrille]  ->SchauGletscherbrille->e->Basis
+ {schrank_offen && Tasche !? Ts_Gletscherbrille} [(nimm) #FLAG: space] {inn} die <b>Gletscherbrille</b>.
    ~ Tasche += Ts_Gletscherbrille
    ~ playSoundV("events", "take", 0.25)
    ->e->Basis
+ [<b>◉</b> Beschreibung #CTAG: p] ->Schau->e->Basis
+ <b>↯</b> Ich {schrank_offen:schliesse|öffne} den Schrank.
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

Der Schrank wurde von jemandem erbaut, der sonst nur Panzer baut. Die Konstruktion würde einen Bombenangriff überstehen. Dies muss dem Erbauer auch aufgefallen sein, denn er versuchte, mit filigranen Schnitzereien zu kompensieren. Jedoch muss er das Wort "filigran" ausschliesslich aus dem Wörterbuch kennen, denn die Schnitzereien sind zwar fein, aber nicht zierlich. Vielmehr sind sie geometrisch und starr. Dieser Schrank verkörpert das ideale Hochzeitsgeschenk für einen Borg.

{schrank_gesehen == 0:
    ~ schrank_gesehen = 1
    An der gegenüberliegen Wand steht ein Panzerschrank, der auf unerklärliche Weise das Gegenteil des Schrank darstellt. Er ist aus Porzellan. Verwirrt schüttle ich den Kopf.
}

- ->->

=== Schreibtisch ===

Auf dem Schreibtisch sehe ich: <b>einen Knopf</b>, <b>eine Lampe</b> und <b>einen Globus</b>.

-  (Basis)

+ [<b>◉</b> Beschreibung] In die äusseren Ränder des Schreibtisches aus {mw(To_Schwarz)}em Marmor sind feine, organische Verzierungen gemeisselt. Der Rand der Tischplatte zeigt Gravuren, die an mystische Inschriften erinnern. ->e->Basis
+ [Knopf] {ib()} <b>den Knopf</b>. ->e->Knopf->e->Schreibtisch
+ [Lampe] {ib()} <b>die Lampe</b>. ->e->Lampe->e->Schreibtisch
+ [Globus] {ib()} <b>den Globus</b>. ->e->Globus->e->Schreibtisch
+ [{tw(Ts_Meta)}] <b>❯ {tw(Ts_Meta)}</b> ->e->Meta->e->Schreibtisch
+ [<b>▼</b> Zurück] {iwm("vom Schreibtisch")}

- ->->

= Knopf

Die Gravur des Knopfs zeigt das Symbol {mmd():der Sonne|des Mondes}.

-  (KnopfBasis)

+ [<b>◉</b> Beschreibung] In der rechten äusseren Ecke des Schreibtischs ist ein Knopf eingelegt. ->e->KnopfBasis
+ <b>↯</b> Ich drücke auf {mmd():die Sonne|den Mond}.
    {
        - mmd():
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

{lampe_an: {mmd():Die Schreibtischlampe strahlt weisses, farbloses Licht aus.|Die Schreibtischlampe leuchtet nun Schwarz und saugt die Helligkeit auf.}}

- ->->

= Globus

->GlobusBeschreibung->

-  (GlobusBasis)

+ [<b>◉</b> Beschreibung]
    ~ globus_untersucht = 1
    ->SchauGlobus->e->GlobusBasis
+ {globus_untersucht && GlobusSchalter != GS_Erde} <b>↯</b> Ich schalte den Globus auf <b>Erdenwelt</b>.
    ~ GlobusSchalter = GS_Erde
    ~ globus_spielen()
    ->SchauGlobus->e->GlobusBasis
+ {globus_untersucht && GlobusSchalter != GS_Scheibenwelt} <b>↯</b> Ich schalte den Globus auf <b>Scheibenwelt</b>.
    ~ GlobusSchalter = GS_Scheibenwelt
    ~ globus_spielen()
    ->SchauGlobus->e->GlobusBasis
+ {globus_untersucht && GlobusSchalter != GS_Studierzimmer} <b>↯</b> Ich schalte den Globus auf <b>Studierzimmer</b>.
    ~ GlobusSchalter = GS_Studierzimmer
    ~ globus_spielen()
    ->SchauGlobus->e->GlobusBasis
+ {bereit(Ts_Giesskanne) && GlobusSchalter == GS_Studierzimmer} <b>↯</b> Ich <b>begiesse</b> den Globus mit der Giesskanne.
    In dem Moment beginnt ein Gewitter, ich höre den Regen auf das Studierzimmer prasseln. Diese Welt verwirrt selbst die Götter der Rekursion. Wie kann das sein?
    ~ globus_begossen = 1
    ~ bienen_bereit = 7
    {playSoundV("events-fg3", "giessen", 0.3)}
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
        Der Globus zeigt eine Karte der Erde in vergilbten Grautönen, das Meer ist gewissermassen in einem blauen Grau gehalten.
    - GS_Scheibenwelt:
        Aus dem Sockel des Globus ragt eine Stange, die sich in den Bauch einer Schildkröte bohrt. Vier Elefanten auf der Schildkröte tragen eine Scheibe. Ozeane, Berge, Ebenen und alles, was eine Welt so braucht, erstrahlen in spektakulär polychromer Farbenpracht. Sie ist das Echteste im ganzen Schreibzimmer. Ein Moment - über der Scheibe hängen Wolken und sie scheinen sich zu bewegen.
    - GS_Studierzimmer:
        Der Globus zeigt dieses Zimmer in Puppenhausegrösse. Zwei Seiten und die Decke sind aus Glas, damit man das Innenleben betrachen kann. Darin stehe ich. Mit einer Lupe könnte ich wohl auch den Globus betrachen.
}

->GlobusBeschreibung

- ->->

=== Bienenkorb ===

~ musik_an = 0
~ stopSound("music-loop")
~ playSoundV("loops", "bienenkorb", 0.20)

-  (Oben) #CTAG: span

{Tasche !? Ts_Schluessel:An einem Nagel am Bienenkorb hängt ein silberner Schlüssel.}

{Tasche ? Ts_Pinzette:Ein Bienenkorb.|Neben dem Bienenkorb liegt:}

-  (Basis) #CTAG: span

+ {Tasche !? Ts_Pinzette} [Eine Pinzette] ->SchauPinzette->e->Basis
+ {Tasche !? Ts_Pinzette} [(nimm) #FLAG: space] {inn} die <b>Pinzette</b>.
    ~ Tasche += Ts_Pinzette
    ~ playSoundV("events", "take", 0.25)
    ->e->Basis
+ [<b>◉</b> Beschreibung #CTAG: p] Bei näherer Betrachtung stelle ich fest, die Bienen bewegen sich wie Teilchen. Zwei kleine Bienen verbinden sich zu einer grossen Biene und trennen sich wieder zu zwei kleinen Bienen. Aus dem Nichts taucht eine Biene auf, fliegt zwanzig Zentimeter weit und verschwindet wieder. "Bienen aus Vakuumenergie!", denke ich unvermittelt. {bienen_beschreibung} "DAS VAKUUM BESTEHT AUS MIR!". Ich wünschte, diese Bienen wären nicht dauernd in meinem Kopf. Mit Schrecken stelle ich fest, dass die Bienen durch ihre Fähigkeiten tatsächlich in meinen Kopf eindringen können. Postwendend höre ich ein Brummen in meinem Kopf.->e->Basis
+ {Tasche !? Ts_Schluessel} <b>↯</b> Ich nehme den Schlüssel
    {(bienen_versuch && einfach && Tasche ? Ts_Gletscherbrille) || benutze == Ts_Gletscherbrille:
        {einfach:
            Ich setze die Gletscherbrille auf. Die Bienen verstummen und ich nehme den Schlüssel. Woher wusste ich, was ich tun sollte? Irgendwie hat sich das Rätsel für mich gelöst.
        - else:
            Sind die Bienen wirklich weg wenn man sie nicht mehr sieht? Zumindest sind sie still. Ich versuche, den Schlüssel zu nehmen, und diesmal gelingt es mir.
        }
        ~ Tasche += Ts_Schluessel
        Die Bienen scheinen den Welle-Teilchen-Dualismus aus der Physik falsch zu verstehen und existieren nur, wenn man sie beobachtet. In dieser Welt ist alles ein wenig verrückt. {bienen_beschreibung} "GERNEGESCHEHEN!" Erschrocken antworte ich: "Ihr habt mich erwischt!“, denn die Bienen erinnern mich damit in ihrer unmittelbaren Art, dass sie doch noch irgendwo existieren. ->e->Basis
    - else:
        ->NimmDialog->e->Basis
    }
+ [{tw(Ts_Meta)}] <b>❯ {tw(Ts_Meta)}</b> ->e->Meta->e->Brillencheck->Oben
+ [<b>▼</b> Zurück] {iwm("vom Bienenkorb")}
    ~ musik_an = 1
    ~ stopSound("loops")
    ~ music_loop()

- ->->

= Brillencheck
{benutze == Ts_Gletscherbrille && currentSound("loops") == "bienenkorb":
    Nanu, plötzlich verstummen die Bienen.
    ~ stopSound("loops")
}
{benutze != Ts_Gletscherbrille && currentSound("loops") != "bienenkorb":
    Nun summen die Bienen wieder.
    ~ playSoundV("loops", "bienenkorb", 0.20)
}

- ->->

= NimmDialog

Die Bienen werden nervös, fliegen immer schneller, bis der Bienenkorb in eine art Energiefeld eingehüllt ist.

- (NimmBasis)

* {!bienen_versuch} <b>↯</b> Ich nehme den Schlüssel trotzdem.
    Hui, das kribbelt. Ich brauche immer mehr Kraft, bis ich schliesslich feststecke. Keine Chance.
* Ich versuche nicht an den Schlüssel zu denken.
    <>Die Bienen werden ruhig und das Feld verschwindet.
    ** <b>↯</b> Ich nehme den Schlüssel.
    Die Bienen fliegen wieder schneller. Hui, das kribbelt. Ich brauche immer mehr Kraft, bis ich schliesslich feststecke. Keine Chance.
    ~ bienen_versuch = 1
+ <b>▼</b> Ich gebe auf
    ~ bienen_versuch = 1
    ->->

- ->NimmBasis->e

->->

=== Panzerschrank ===

Der Panzerschrank ist verschlossen.

- (Basis) #CTAG: span

+ [<b>◉</b> Beschreibung #CTAG: p] ->e->Schau->Basis
+ {einschlagen_versuch < 2 && bereit(Ts_Hammer)} <b>↯</b> Ich schlage den Panzerschrank {einschlagen_versuch:<b>trotzdem</b>} mit dem Hammer ein.
    {einschlagen_versuch != 1:Nein, das kann ich nicht tun, um alles in der Welt das ist Porzellan!}
    {einschlagen_versuch == 1:Autsch!! Der Schlag meines Hammers wird vom Panzerschrank abrupt gestoppt. Der Hammerschlag gab nicht einmal ein Geräusch von sich, wie durch eine unsichtbare Kraft wurde ihm jeglicher Impuls genommen. Mein Arm und meine Hand haben das leider nicht mitbekommen, es schmerzt sehr. Ich werde es nicht noch einmal versuchen. Am Panzerschrank kann ich nicht einmal einen Kratzer entdecken.}
    ~ einschlagen_versuch += 1
    ->e->Basis
+ [{tw(Ts_Meta)}] <b>❯ {tw(Ts_Meta)}</b> ->e->Meta->e->Panzerschrank
+ [<b>▼</b> Zurück] {iwm("vom Panzerschrank")}

- ->->

= Schau

Dieser Panzerschrank aus feinstem {mmd():weissem|schwarzen} Meissner Porzellan ist das Zierlichste, was ich je gesehen habe. Ein wunderschönes Dekor in bezaubernder Kobaltmalerei ergänzt die Goldverzierungen an den Rändern, auch wenn es sich dabei um Graugold handelt. In die Tür ist ein Schloss aus 925er Sterlingsilber eingelassen. Von ihm geht ein silberner Zierbeschlag aus, der an keltische zoomorphe Ornamente erinnert. Horst Lichter würde vor Entzücken in Ohnmacht fallen. "Der Panzerschrank wird kaum geeignet sein, um Wertsachen darin einzuschliessen", stelle ich nachdenklich fest. Verlegen wird mir klar, dass ich zu oft Trödelshows anschaue.

- ->->

// Globale Beschreibungen (meist Gegenstände)

=== SchauGletscherbrille ===

Eine Gletscherbrille aus dem 19. Jahrhundert mit {mmd():schwarzen|weissen} Gläsern. Das Fehlen jeglicher Eleganz - nein die ungeheure negative Eleganz - lässt alles um die der Brille herum elegant erscheinen. Ein netter Trick, so kann man in Trainerhosen an einen Ball gehen. Wenigstens fällt die Trainerhose dann nicht auf.

- ->->

=== SchauHammer ===

Ein beeindruckender Hammer. Er scheint einen eisernen Willen in seinem {mmd():schwarzen|weissen} Kopf zu haben.

- ->->

=== SchauPinzette ===

Eine hochwertige Pinzette aus Edelstahl mit einer {mmd():schwarzen|weissen} Karbonspitze. Modernstes Design - sie passt in diese Welt wie ein Teleprompter auf die Titanic. Darauf eingraviert kann ich lesen: "Für Terry, Du gabst mir die Perspektive, die ich brauchte - JLF". Dieser JLF muss die Pinzette absichtlich {Tasche ? Ts_Pinzette:beim Bienenkorb|hier} platziert haben.

- ->->

=== SchauGiesskanne ===

<b>Die Giesskanne von Cordelia Schmiersinn</b>

Ihre Form, eine Symphonie von Natur und Traum,<br>Ein Tanz der Eleganz, so zart wie ein Baum.<br>Der Ausguss wie ein Schwanenhals, sanft geneigt,<br>Lebensstrom spendend, wo die Blüte gedeiht.

Der Körper fällt wie ein Tropfen so rein,<br>Gefangen in ewigem Raum und Sein.<br>Es spricht von der Zeit, als Kunst die Seele lab,<br>Eine Giesskanne, die dem Garten das Leben gab.

So vieles hängt an ihr, die Leben uns bringt,<br>Die Jugendstil-Giesskanne, die Schönheit besingt.

- ->->

=== TuerErscheint ===
{tuer_gesehen == 0:
    ~ playSoundS("events-fg", "open-close")
    Eine Tür erscheint. #CLASS: event
    Eine kleine Person mit spitzen Ohren tritt ins Studierzimmer, sieht mich und gibt einen Aufschrei der Verwunderung von sich: "Oh nein, oh nein," und murmelt zu sich selbst, "das ist nicht der HERR. Welche wunderliche Idee hat ER nun wieder? Was soll ich nur machen? Das geht bestimmt nicht gut. Soll nun diese Person seine Aufgaben übernehmen? Oh nein, oh nein. Bestimmt darf ich am Ende das Raumzeitgefüge wiederherstellen. Was soll ich nur machen?" Für einen Moment scheint die kleine Figur mich anzusprechen wollen, doch dann besinnt sie sich eines Bessern und verschwindet durch die Tür. #CLASS: event
    ~ tuer_gesehen = 1
- else:
        ~ debug_out("Else for tuer_gesehen happened")
        ->e->
}

- ->->

=== TeeMachtSich ===

{tee_erschienen == 0:
    {tee_giessen()} Unvermittelt erscheint eine kleine {mmd():schwarze|weisse} gusseiserne japanische Teekanne. Aus dem Ausguss dampft ein herrlicher Duft von Pfefferminze. Daneben erschent eine {mmd():weisse|schwarze} Tasse mit der Aufschrift: "Unser TOD ist der Beste". Wie von Geisterhand wird der Tee eingeschenkt. #CLASS: event
    ~ tee_erschienen = 1
- else:
    Der Tee wird langsam kalt. Mit einer ruckartigen Bewegung entleert sich die {mmd():weisse|schwarze} Tasse auf den Boden und die Teekanne giesst Tee nach. Merkwürdig, auf dem Boden ist kein Tee zu sehen. #CLASS: event
}

- ->->

=== Meta ===

{tasche_gesehen == 0:
    ~ tasche_gesehen = 1
    Hoppla, seit wann trage ich eine Kuriertasche? Damit komme ich mir wie ein Archeologe vor. Oh, in der Tasche befindet sich ein Tagebuch.
}

// TODO Tagebuch zeigt Leistungen (Achievments)

~ playSoundV("events", "tasche", 0.4)

- (Basis) #CTAG: span

Meine Tasche enthält:

+ {zeige(Ts_Giesskanne)} [Eine Gieskanne] ->SchauGiesskanne->e->Basis
+ {benutzer(Ts_Giesskanne)} [(benutze) #FLAG: space]
    {in} die <b>Giesskanne</b>.
    ~ benutze = Ts_Giesskanne
    ~ playSoundV("events", "take", 0.25)
    ->e->Basis
+ {zeige(Ts_Pinzette)} [Eine Pinzette] ->SchauPinzette->e->Basis
+ {benutzer(Ts_Pinzette)} [(benutze) #FLAG: space]
    {in} die <b>Pinzette</b>.
    ~ benutze = Ts_Pinzette
    ~ playSoundV("events", "take", 0.25)
    ->e->Basis
+ {zeige(Ts_Hammer)} [Ein Hammer] ->SchauHammer->e->Basis
+ {benutzer(Ts_Hammer)} [(benutze) #FLAG: space]
    {in} den <b>Hammer</b>.
    ~ benutze = Ts_Hammer
    ~ playSoundV("events", "take", 0.25)
    ->e->Basis
+ {zeige(Ts_Gletscherbrille)} [Eine Gletscherbrille] ->SchauGletscherbrille->e->Basis
+ {benutzer(Ts_Gletscherbrille)} [(aufsetzen) #FLAG: space]
    Ich setze die <b>Gletscherbrille</b> auf. Nanu, die Gläser der Gletscherbrille sind undurchsichtig. Ich bin total blind.
    ~ benutze = Ts_Gletscherbrille
    ~ playSoundV("events", "take", 0.25)
    ->e->Basis
+ {einfach == 0 && benutze != Ts_Nichts} [Ich lege {taw(benutze)} weg. #CTAG: p]
    <b>▼</b> Ich lege <b>{taw(benutze)}</b> weg.
    ~ benutze = Ts_Nichts
    ~ playSoundV("events", "take", 0.25)
    ->e->Basis
+ {cheats} [Cheats #CTAG: p] ->Cheats->e->Basis
+ {cheats} [{einfach:Rätselmode|Genussmode}]
    ~ einfach = !einfach
    ->e->Basis
+ [<b>▼</b> Zurück #CTAG: p] <b>❮</b> Ich lenke meine Aufmerksamkeit von <b>der Tasche</b> weg.
~ playSoundV("events", "tasche-zu", 0.1)

- ->->

=== Cheats ===

Psst, möchtest Du mogeln?

+ Zum Bienenkorb
    ~ bienen_gesehen = 1
    ~ schrank_gesehen = 1
    ~ Tasche += (Ts_Giesskanne, Ts_Pinzette, Ts_Hammer, Ts_Gletscherbrille)
    ->Studierzimmer
+ Nein, danke

- ->->
