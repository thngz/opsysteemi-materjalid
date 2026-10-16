#import "@preview/polylux:0.4.0": *

#set page(paper: "presentation-16-9", footer: align(right, text(size: 14pt)[
  #toolbox.slide-number / #toolbox.last-slide-number
]))
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
    - Takistada teistel protsessidel riistvarale ligipääsu saamist
    - Lugeda ükskõik mis faile
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
  == Kasutajarežiim (user mode)
  - Jooksevad tavalised protsessid
    - brauser
    - mängud
    - terminal
    - kasutajaliides
  - Puudub võimalus:
    - Lugeda teiste protsesside mälu
    - Otse ligi saada riistvarale
  - Viga kasutajarežiimis: Konkreetne protsess sureb
]

#slide[
  == Privileegrežiim (kernel mode)
  - Jooksevad süsteemi toimimiseks vajalikud protsessid
    - Draiverid
    - Tulemüür
    - Failisüsteem
  - Viga privileegrežiimis
    - "With great power comes great responsibility"
    - Kood jookseb ühtses mälu aadressiruumis
      - Privileegrežiimis jooksev programm võib kogemata kirjutada valesse mäluaadressisse
    - Süsteemiülene krahh
]
#slide[
  #figure(
    image("figure3.jpg"),
    caption: "Potentsiaalne viga privileegrežiimis",
  )
]

#slide[
  == #problem[Kuidas takistada suvalisi protsesse võtmast privileegrežiimi?]
  - Riistvaraline lahendus
    - Kui protsessorisse sisse ehitatud spetsiaalse registri (mode bit) väärtus on
      - 1 -> on võimalik käivitada privileegrežiimi käsk
      - 0 -> pole võimalik käivitada privileegrežiimi käsku
  - Tarkvaraline lahendus
    - Katkestused
]

#slide[
  == Katkestustest (interrupts) lühidalt
  #toolbox.side-by-side(columns: (auto, auto))[
    - Viis kuidas ajutiselt panna protsessor täitma mõnda muud ülesannet
    - Riistvara kasutab seda protsessoriga suhtlemisel
    - Protsessor täidab järjest oma ülesannet käsk-käsu haaval: @interrupt
  ][
    #figure(
      image("figure4.png", height: 60%),
      caption: [Katkestuseta protsessori töövoog @Lecture11Interrupts],
    )<interrupt>
  ]

  #toolbox.side-by-side(columns: (auto, auto))[
    + Katkestuse puhul salvestab protsessor praeguse ülesande täitmise oleku
    + Protsessor hakkab täitma katkestustäituri (interrupt handler) käske
    + Protsessor loeb sisse varasemalt salvestatud oleku
    + Protsessor jätkab ülesande täitmist
  ][
    #figure(image("figure5.png", height: 70%), caption: [Protsessori töövoog katkestusega @Lecture11Interrupts])
  ]
]

#slide[
  == Katkestuste roll mode bit väärtuse vahetamisel
  - Katkestustäituri käskude täitmise ajal muutub mode-bit automaatselt 1
  - Katkestuse
]

#slide[
  == #problem[Kuidas siis protsessid saavad ligi riistvarale?]

  Süsteemikutsed
]

#slide[
  == Kuidas süsteemikutsed töötavad
]

#slide[
  == Miks ei saa Windowsi programmi jooksutada Linuxi peal
  - Suur põhjus: Windowsi ja Linux operatsioonisüsteemide süsteemikutsed erinevad
  - Lahendused:
    - Võimalik konverteerida ühe platvormi süsteemikutsed teise omadeks
      - Mõned projektid: Wine @WineHQRunWindows
      - WSL (Window's subsystem for Linux v1)
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
  #bibliography("./references.bib", full: true)
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
