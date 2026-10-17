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
  == #problem[Kuidas takistada protsesse?]
  - Protsessid võivad näiteks:
    - Takistada teistel protsessidel riistvarale ligipääsu saamist
    - Lugeda kõiki faile
    - Sulgeda süsteemseid protsesse
]

#slide[
  == Protsessori režiimid
  - Idee: Eraldame tavalistele protsessidele ja operatsioonisüsteemile eraldi "tsoonid"
    - Kasutajarežiim
      - Piiratud hulk protsessori käske (`mov`, `jmp` ...)
    - Privileegrežiim
      - Ligipääs laiemale hulgale käskudele (`cli`, `hlt`)
  - Tavalised protsessid saavad opereerida ainult kasutajarežiimis
  - Võib-olla ka rohkem režiime!
]

#slide[
  == Protsessori režiimid

  #toolbox.side-by-side(columns: (auto, auto))[
    #figure(
      image("figure2.webp", height: 50%),
    )
  ][
    #figure(
      image("figure2.1.webp", height: 50%),
    )

  ]
  Tavaliselt kujutatakse protsessori režiime ringidega @ProtectionRingsMost @UploadwikimediaorgWikipediaCommons
]
#slide[
  == Kasutajarežiim (user mode)
  - Jooksevad tavalised protsessid
    - Brauser
    - Mängud
    - Terminal
    - Kasutajaliides
  - Puudub võimalus:
    - Lugeda teiste protsesside mälu
    - Otse ligi saada riistvarale
  - Viga kasutajarežiimis: Konkreetne protsess sureb
]

#slide[
  #set align(horizon)
  #toolbox.side-by-side(columns: (1fr, auto, 1fr))[
    #figure(
      ```c
      int main() {
          asm volatile("cli");
      }
      ```,
    )
  ][
    #text(size: 40pt)[→]
  ][
    #figure(
      ```
      Program terminated by signal SIGSEGV (Address boundary error)
      ```,
    )
  ]

  #set align(horizon + center)
  Privileegrežiimi käsk kasutajarežiimis
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
  == #problem[Kuidas takistada suvalisi protsesse minemast privileegrežiimi?]
  - Riistvaraline lahendus
    - Kui protsessorisse sisse ehitatud spetsiaalse registri (mode bit) väärtus on
      - 1 -> on võimalik käivitada privileegrežiimi käsk
      - 0 -> pole võimalik käivitada privileegrežiimi käsku
  - Katkestused (interrupts)
]

#slide[
  == Katkestustest lühidalt
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
  == Tarkvaraline lahendus
  - Katkestustäituri käskude täitmise ajal, seatakse mode-bit väärtus automaatselt 1
  - Katkestustäiturite aadressid ja käsud operatsioonisüsteemi kontrolli all
    - Tavalised protsessid ei saa muuta
      - Katkestustäiturite käske
      - Aadresseid mälus
    - Säilib operatsioonisüsteemi kontroll privileegrežiimi üle
]

#slide[
  == #problem[Kuidas siis protsessid kasutaja protsessid üldse midagi teha saavad?]
  - Idee: Anda võimalus kasutajarežiimis töötavatele programmidele saada piiratud kujul ligipääs privileegrežiimi funktsionaalsustele
    - Kasutajaprotsessid saavad kutsuda ainult kindlaid funktsioone
      - Kindlad sisendid
      - Kindel väljund
    - Operatsioonisüsteem kontrollib, kas funktsiooni saab käivitada või mitte
]

#slide[
  == Süsteemikutsed
  - Annavad kasutajaprotsessidele ligipääsu privileegrežiimi funktsioonidele
  - Defineerivad lepingu kasutajaprotsesside ja operatsioonisüsteemi vahel
  - Kasutajaprotses palub operatsioonisüsteemil tegeleda ise riistvara ja privileegrežiimi käskudega
    - Katkestused
      - `int 0x80`, `iretq`
      - `syscall`, `sysret`
    - Operatsioonisüsteem tagastab tulemuse või veakoodi
]

#slide[
  == Süsteemikutsed

  #set text(size: 15pt)
  - Rakendusliides (API) operatsioonisüsteemi ja kasutajaprotsesside vahel
    - Leping
      - Funktsioon @Open2LinuxManual
        ```c // The open() system call opens the file specified by path
        int open(const char *path, int flags, ...  );```
      - Sisend(id)
        - ```c const char *path, int flags```
      - Väljund(id)
        - ```c /* The return value of open() is a file descriptor, a small,
          nonnegative integer that is an index to an entry in the process's
          table of open file descriptors */```
]

#slide[
  == #problem[Süsteemikutsete otsene kasutamine]
  - Soov kuvada numbrit ekraanil
  - `write` süsteemikutse @Write2LinuxManual
    - ```c /*write() writes up to count bytes from the buffer starting at buf
      to the file referred to by the file descriptor fd. */
      ssize_t write(size_t count;
                    int fd, const void buf[count], size_t count);
      ```
]

#slide[
  #figure(
    ```c
    #include <unistd.h>

    int main() {
        int x = 42;
        char buf[16];
        int i = sizeof buf;

        buf[--i] = '\n';
        do {
            buf[--i] = '0' + x % 10;
            x /= 10;
        } while (x > 0);

        write(1, "Vastus: ", 8);
        write(1, buf + i, sizeof buf - i);
    }
    ```,
    caption: [Numbri kuvamine `write` süsteemikutsega],
  )

]


#slide[
  == Lahendus: operatsioonisüsteemi standardteegid (standard library)
  - Programmeerija võimsaim tööriist: abstraktsioon
  - "Usually,
       system calls are not invoked directly: instead, most system calls
       have corresponding C library wrapper functions which perform the
       steps required @Intro2LinuxManual"
  - Operatsioonisüsteemi standardteek (standard library)
    - Linux: libc
    - Windows: Windows API
]

#slide[
  #show raw.where(block: true): set text(size: 12pt)

  #toolbox.side-by-side(columns: (1fr, auto, 1fr))[
    #figure(
      ```c
      #include <unistd.h>

      int main(void) {
          int x = 42;
          char buf[16];
          int i = sizeof buf;

          buf[--i] = '\n';
          do {
              buf[--i] = '0' + x % 10;
              x /= 10;
          } while (x > 0);

          write(1, "Vastus: ", 8);
          write(1, buf + i, sizeof buf - i);
      }
      ```,
    )
  ][

    #text(size: 40pt)[→]
  ][
    #figure(
      ```c
      #include <stdio.h>

      int main(void) {
          int x = 42;
          printf("Vastus: %d\n", x);
      }
      ```,
    )
  ]

  #set align(horizon + center)
  Operatsioonisüsteemi standardteek abstraheerib süsteemikutsed lihtsasti kasutatavate funktsioonide taha
]

#slide[
  #figure(
    image("./figure6.png", height: 75%),
    caption: "Operatsioonisüsteem kui orkestraator",
  )
]


#slide[
  == Mõned levinumad süsteemikutsed

  `fork`
  `open`
  `write`
  `kill`
  `exit`
]

#slide[
  == Süsteemikutsete plussid
]

#slide[
  == Süsteemikutsete miinused
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
  == POSIX
]

#slide[
  == Vanguard
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
