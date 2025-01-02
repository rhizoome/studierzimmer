# author: Jean-Louis Fuchs
# theme: dark

EXTERNAL setOutsideTheme(dark)

LIST Moden = Dunkel, Hell
LIST Ton = Schwarz, Weiss, Duester, Sonne, Dunkl
VAR modus = Dunkel
VAR lampe_an = 0
VAR tick_an = 0
VAR tick_pause = 0
VAR audio_standuhr_gespielt = 0
CONST ib = "Ich betrachte"
CONST event_wahrscheinlichkeit = 44 // In prozent

{setOutsideTheme(1)}

->Ankunft

// ------ Funktionen

=== function mw(wort) ===
{ wort:
- Schwarz: {modus == Dunkel:schwarz|weiss}
- Weiss: {modus == Dunkel:weiss|schwarz}
- Duester: {modus == Dunkel:düster|hell}
- else: ERROR
}

=== function iwm(wort) ===
Ich lenke meine Aufmerksamkeit {wort} weg.

=== function ensure_tick() ===
{
    - !tick_an and !tick_pause:
        ~ tick_an = 1
        # AUDIOLOOP: 163371__tick_reverse.mp3&0.02
    - tick_pause:
        ~ tick_pause -= 1
}

=== function standuhr_schlagen() ===
{ 
    - !audio_standuhr_gespielt:
        ~ audio_standuhr_gespielt = 1
        # AUDIOLOOP:
        ~ tick_an = 0
        ~ tick_pause = 5
        # AUDIO: 163371__chime_reverse.mp3
}

// ------ Events

=== e ===
{
    - RANDOM(0, 100) <= event_wahrscheinlichkeit:
    { shuffle:
        - Die letzen Sandkörner einer Sanduhr auf dem Regal links von mir läuft aus. Einen Moment später verschwindet die Sanduhr. # CLASS: event
        - {standuhr_schlagen()} Die grosse Standuhr aus {modus == Dunkel:dunkelm|hellem} Holz schlägt, darauf folgt ohrenbetäubende Stille. # CLASS: event
    }
}
~ ensure_tick()
- ->->

=== function setOutsideTheme(dark) ===
Setting outside dark theme to: {dark}

// ------ Geschichte

=== Ankunft ===

"Siehst Du, ich stecke meine Hand hinein und nichts passiert."

* [Ich stecke die Hand nochmal hinein.] # AUDIOBACKGROUND: teppich.mp3&0.02

- "Oh Schreck, wo bin ich?"

Es riecht nach dem Raum zwischen den Gedanken, dieser Leere in der sich selbst Geruch einsam fühlt.

~ temp beschreibung = "Aus einer unendlichen Entfernung - die so weit weg ist, dass es sich wie aus jedem meiner Knochen anfühlt - höre ich donnernd und vibrierend:"

 * "Träume ich?"
    {beschreibung} "DU TRÄUMST NICHT."
 * "Bin ich tot?"
     {beschreibung} "DU BIST NICHT TOT."

- Ein hoher {mw(Duester)}er Raum, leuchtet in den schrillsten Grautönen, die man sich nur vorstellen kann. Man fühlt mich wie in einem Comic von Frank Miller oder Mike Mignola. An den Wänden ragen majestätische Säulen, die verschlungene, mystische Ornamente kleiden. ->e->Studierzimmer

=== Studierzimmer ===

Im {modus == Dunkel:düstern|hellen} Studierzimmer sehe ich: einen Schreibtisch.

+ [Schreibtisch]
    {ib} den Schreibtisch. In die äusseren Ränder des Schreibtisches aus {mw(Schwarz)}em Marmor sind feine, organische Verzierungen gemeisselt. Der Rand der Tischplatte zeigt Gravuren, die an mystische Inschriften erinnern.
    ->Schreibtisch->e->Studierzimmer
+ TODO: Ausgang
    ->e->END
=== Schreibtisch ===

Auf dem Tisch sehe ich: einen Knopf, eine Lampe und einen Globus.

+ [Knopf]
    {ib} den Knopf.
    In der rechten äusseren Ecke des Schreibtischs ist ein Knopf eingelegt. ->Knopf->e->Schreibtisch
+ [Lampe]
    {ib} die Lampe.
    Es ist eine Bankerlampe mit einem Schirm aus grellgrauem ungrünen Glas. Wie der Schirm in dieser Monochromen Welt so überzeugt grün sein kann, ist mir unerklärbar. ->Lampe->e->Schreibtisch
// + [Globus]
+ [Zurück]
    {iwm("vom Schreibtisch")}
    

- ->->

= Knopf

Die Gravur zeigt das Symbol {modus == Dunkel:der Sonne|des Mondes}.

+ Ich drücke auf {modus == Dunkel:die Sonne|den Mond}.
    {
        - modus == Dunkel:
            #AUDIO: 613405__modus-switch.mp3
            ~ modus = Hell
            ~ setOutsideTheme(0)
        - else:
            #AUDIO: 613405__modus-switch-rev.mp3
            ~ modus = Dunkel
            ~ setOutsideTheme(1)
    }
    Urplötzlich ist alles was Schwarz ist Weiss und umgekehrt. Die abrupte Veränderung ist schwindelerregend. ->Leuchten->e->Knopf
+ [Zurück]
    {iwm("vom Knopf")}

- ->->

= Lampe

+ Ich schalte Lampe {lampe_an:aus|an}. #AUDIO: 477519__snap-button.mp3
    ~ lampe_an = !lampe_an
     ->Leuchten->e->Lampe
+ [Zurück]
    {iwm("von der Lampe")}

- ->->

= Leuchten

{lampe_an: {modus == Dunkel:Die Schreibtischlampe strahlt weisses, farbloses Licht aus.|Die Schreibtischlampe leuchtet nun Schwarz und saugt die Helligkeit auf.}}

- ->->