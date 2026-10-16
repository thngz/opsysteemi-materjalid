// Get Polylux from the official package repository
#import "@preview/polylux:0.4.0": *

// Make the paper dimensions fit for a presentation and the text larger
#set page(paper: "presentation-16-9")
#set text(size: 20pt, font: "Iosevka Extended")
#set list(
  spacing: 1em,       // vertical gap between items
  indent: 0.5em,      // marker offset from the left edge
  body-indent: 0.6em, // gap between marker and text
  marker: ([•], [–]), // per nesting level
)

// Use #slide to create a slide and style it using your favourite Typst functions
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
      image("./figure1.png", height: 75%)
    )
]

#slide[
  == Meeldetuletus: Operatsioonisüsteem kui orkestraator
  - Operatsioonisüsteem jooksutab mitut protsessi
  - Protsessid soovivad ligipääsu
    - Internetile
    - Kõvakettale
    - Mikrofonile
    ...
  - 
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


// #slide[
//   == This slide changes!
//
//   You can always see this.
//   // Make use of features like #uncover, #only, and others to create dynamic content
//   #uncover(2)[But this appears later!]
// ]
