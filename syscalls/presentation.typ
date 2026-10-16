#import "@preview/polylux:0.4.0": *

#set page(paper: "presentation-16-9")
#set text(size: 20pt, font: "Iosevka Extended")
#set list(
  spacing: 1em, // vertical gap between items
  indent: 0.5em, // marker offset from the left edge
  body-indent: 0.6em, // gap between marker and text
  marker: ([•], [–]), // per nesting level
)
#set text(lang: "et")
#let problem-counter = counter("problem")
#let problem(body) = block[
  #problem-counter.step()
  *Probleem #context problem-counter.display()*: #body
]

#slide[
  #set align(horizon)
  = Süsteemikutsed

  Georg Kiviväli

  Oktoober 19, 2026
]

#slide[
  #set align(center + horizon)
  #set text(size: 25pt)
  Kuidas anda käsklusi operatsioonisüsteemile?
]

#slide[
  == Meeldetuletus: Operatsioonisüsteem kui orkestraator
  #figure(
    image("./figure1.png", height: 65%),
    caption: "Erinevad protsessid soovivad ligipääsu erinevatele riistvara komponentidele",
  )
]

#slide[
  == Meeldetuletus: Operatsioonisüsteem kui orkestraator
  - Operatsioonisüsteem jagab riistvara ligipääsu protsessidele
  - Protsessid soovivad ligipääsu
    - Protsessorile
    - Kõvakettale
    - Mikrofonile
    - Internetile
    ...
]

#slide[
  == #problem[Kuidas takistada kasutaja protsesse?]
  - Protsessid mis võivad näiteks:
    - Takistada teistel protsessidel ligipääsu saamist
    - Lugeda ükskõik kelle faile
    - Sulgeda süsteemseid protsesse
]

#slide[
  == Protsessori režiimid
  - Idee: Eraldame tavalistele protsessidele ja operatsioonisüsteemile eraldi "tsoonid"
    - Kasutajarežiim
      - Piiratud hulk protsessori käske
    - Privileegrežiim
      - Piiramatu hulk protsessori käske
  - Tavalised protsessid saavad opereerida ainult kasutajarežiimis
  - Võib-olla ka rohkem režiime!
]

#slide[
  == Protsessori režiimid
  #figure(
    image("figure2.webp", height: 75%),
    caption: [Tavaliselt kujutatakse protsessori režiime ringidega  @ProtectionRingsMost],
  )
]

#slide[
  == Kasutajarežiim
]

#slide[
  == Privileegrežiim
]

#slide[
  == #problem[Kuidas takistada protsesse võtmast privileegrežiimi?]
]

#slide[
  == #problem[Kuidas siis protsessid saavad ligi riistvarale]
]

#slide[
  == Teemade ülevaade

  - Meeldetuletus: Operatsioonisüsteem kui orkestraator
  - Operatsioonisüsteemi turvalisus
  - Süsteemikutsed
    - Kuidas töötavad
    - Erinevad süsteemikutsed

  - Miks ei tööta sama kood Windowsi peal samamoodi nagu Linuxi peal
]

#slide[
  #set text(size: 15pt)
  #bibliography("./references.bib")
]

#slide[
  #set align(center + horizon)
  #set text(size: 25pt)
  Tänan kuulamast! Küsimusi?
]

// #slide[
//   == This slide changes!
//
//   You can always see this.
//   // Make use of features like #uncover, #only, and others to create dynamic content
//   #uncover(2)[But this appears later!]
// ]
