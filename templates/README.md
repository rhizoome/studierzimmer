# Studierzimmer

Eine deutsche interaktive Fangeschichte. Du kannst das Fandom selbst erraten.
Wenn Du schon einmal vom B-Raum gehört hast, dann schau doch rein.

## Contributing (Beitragen)

- Wenn Du neue Inhalte vorschlagen möchtest, beschreibe bitte zuerst in einem
  Issue, was Du vorhast. Beim Inhalt kann ich sehr sensibel sein, schliesslich ist
  es meine Vision.
- Rechtschreibfehler kannst Du jederzeit korrigieren. Bitte bedenke, dass ich
  Schweizer bin und das Eszett nicht kenne. Eszett wird immer mit einem doppelten
  S korrigiert.
- Fehlerkorrekturen nehme ich in der Regel an, wenn Du Dir unsicher
  bist, eröffne lieber vorher ein Issue.
- Anregungen und konstruktive Kritik als Issues sind sehr willkommen.
- Wenn Dir die interaktive Geschichte nicht gefällt, kannst Du gerne den Code in
  diesem Repository verwenden, um Deine eigene Geschichte zu erstellen.

## License

### Story

The story and its assets is licensed under:

- <p xmlns:cc="http://creativecommons.org/ns#" xmlns:dct="http://purl.org/dc/terms/"><a property="dct:title" rel="cc:attributionURL" href="https://github.com/rhizoome/studierzimmer/blob/main/studierzimmer.ink">Studierzimmer (./*.ink) in this repository</a> by <a rel="cc:attributionURL dct:creator" property="cc:attributionName" href="https://rhizoome.ch">Jean-Louis Fuchs</a> is licensed under <a href="https://creativecommons.org/licenses/by/4.0/?ref=chooser-v1" target="_blank" rel="license noopener noreferrer" style="display:inline-block;">Creative Commons Attribution 4.0 International<img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1" alt=""><img style="height:22px!important;margin-left:3px;vertical-align:text-bottom;" src="https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1" alt=""></a></p>
- See LICENSE.text

### Code

I wrote a new ink frontend in typescript this is dual licensed under APACHE/MIT:

- ./src/*.ts
- ./src/*.ink
- ./src/*.css
- ./src/*.html
- ./src/**/*
- ./server.py
- See LICENSE-MIT.code and LICENSE-APACHE.code

This is standard rust-lang style dual-licensing. Google what it means if you want to contribute.

### Third party assets

{% for item in attribution -%}
- {{ item }}
{% endfor %}
