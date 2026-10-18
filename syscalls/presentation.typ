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
  == Mitmeprotsessilised süsteemid
  #toolbox.side-by-side(columns: (auto, auto))[
    - Näide: Arvutis on jooksmas kolm protsessi
    - Protsessid soovivad ligipääsu
      - Protsessorile
      - Kõvakettale
      - Mikrofonile
      - Internetile
      ...
  ][
    #figure(
      image("./figure_no_os.png", height: 70%),
    )
  ]
]

#slide[
  == #problem[Mis juhtub, kui protsessid saavad otsese ligipääsu riistvarale?]
  - Üks protsessidest hõivab lõputu tsükliga protsessori
  - Kaks protsessi kirjutavad samal ajal kettale
  - Protsess kirjutab teisele protsessile või operatsioonisüsteemile eraldatud mälusse
  - Protsess loeb teisele protsessile või operatsioonisüsteemile eraldatud mälust
]

#slide[
  == Meeldetuletus: Operatsioonisüsteem kui dirigent
  #toolbox.side-by-side(columns: (auto, auto))[
    - Turvalise keskkonna tagamiseks operatsioonisüsteem:
      - Jagab riistvara ligipääsu protsessidele
      - Kontrollib protsesside õiguseid teatud toiminguteks
      - Isoleerib protsessid üksteisest
  ][
    #figure(
      image("figure_os_orchestrator_1.png", height: 40%),
    )
  ]
]


#slide[
  == #problem[Mis takistab protsessil operatsioonisüsteemi ignoreerimast?]
  #toolbox.side-by-side(columns: (1fr, auto))[
    - Operatsioonisüsteem on programm
    - Protsessor täidab lihtsalt käske
  ][
    #figure(
      image("figure_fetch-execute-cycle.png", height: 65%),
      caption: [Protsessori käsutsükkel @Basics2023],
    )
  ]
]

#slide[
  == Protsessori režiimid
  - Idee: Eraldame tavalistele protsessidele ja operatsioonisüsteemile eraldi "tsoonid"
    - Kasutajarežiim
      - Piiratud hulk protsessori käske (`mov`, `jmp` ...)
    - Privileegrežiim
      - Ligipääs laiemale hulgale käskudele (`cli`, `hlt`)
  - Tavalised protsessid saavad opereerida ainult kasutajarežiimis
  - Võib olla ka rohkem režiime!
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
  == Privileegrežiim (kernel mode)
  - Jooksevad süsteemi toimimiseks vajalikud protsessid
    - Draiverid
    - Tulemüür
    - Failisüsteem
    - Teatavad viirusetõrjed/anticheat mootorid
  - Viga privileegrežiimis
    - "With great power comes great responsibility"
    - Kood jookseb ühtses mälu aadressiruumis
      - Privileegrežiimis jooksev programm võib kirjutada valesse kohta mälus
]

#slide[
  #figure(
    image("figure3.jpg"),
    caption: "Potentsiaalne viga privileegrežiimis",
  )
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
  == #problem[Kuidas siseneda privileegrežiimi?]
  - Riistvaraline lahendus
    - Protsessorisse sisse ehitatud spetsiaalne register (mode bit)
      - Mode bit väärtus
        - 1 -> on võimalik käivitada privileegrežiimi käsk
        - 0 -> pole võimalik käivitada privileegrežiimi käsku
  - Kuidas muuta mode-bit väärtust?
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
  == Operatsioonisüsteemi roll privileegrežiimi kontrollimises
  - Katkestustäituri käskude täitmise ajal, seatakse mode-bit väärtus automaatselt 1
  - Katkestustäiturite aadressid ja käsud operatsioonisüsteemi kontrolli all
    - Tavalised protsessid ei saa muuta
      - Katkestustäiturite käske
      - Katkestustäiturite asukohta mälus
    - Säilib operatsioonisüsteemi kontroll privileegrežiimi üle
]

#slide[
  == #problem[Kuidas pääsevad kasutajarežiimi protsessid ligi failidele, internetile...?]
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
  == Süsteemikutsed
  - Linuxis umbes 467 erinevat süsteemikutset @SearchableLinuxSyscall
  #set text(size: 15pt)
  - Failidega opereerimiseks
    - `read`
    - `write`
    - `open`
    - `mkdir`
  - Protsesside haldus
    - `fork`
    - `kill`
    - `exit`
  - Lisainfo saamiseks Linuxi peal: ```bash man 2 syscalls```
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
  == Süsteemikutsete plussid
  - Riistvara on kasutajaprotsesside jaoks abstraheeritud
    - Kiirendab rakendusearendaja tööd
    - Programmid ei pea teadma konkreetsetest seadmetest arvutis
  - Turvalisus
    - Kontrollitud viis, kuidas kasutajarežiimi protsessid saavad kasutada riistvara
    - Vigane või pahatahtlik protsess ei saa süsteemi rikkuda
]

#slide[
  == Süsteemikutsete miinused

  - Jõudluseprobleemid
    - Iga süsteemikutse sunnib protsessorit tegema kontekstivahetust
      - Süsteemikutsete optimeerimine
        - Huvitav lugemine: https://bun.com/blog/behind-the-scenes-of-bun-install
    - Sõltuvus konkreetsest platvormist
      - Erinevatel operatsioonisüsteemidel on erinevad süsteemikutsed
]

#slide[
  == Operatsioonisüsteem dirigendina
  #set align(horizon)
  #toolbox.side-by-side(columns: (1fr, auto, 1fr, auto, 2fr), gutter: 0.5em)[
    #figure(image("figure_no_os.png", width: 100%))
  ][
    #text(size: 40pt)[→]
  ][
    #figure(image("figure_os_orchestrator_1.png", width: 100%))
  ][
    #text(size: 40pt)[→]
  ][
    #figure(image("figure_os_orchestrator_2.png", width: 100%))
  ]
]

#slide[
  == Sõltuvus konkreetsest platvormist
  - Kaks identset arvutit:
    - Üks Windows
    - Teine Linux
  - Kas Windowsil kompileeritud programm jookseb ka Linuxil?
  #only("2-")[- Ei. Aga miks, kui protsessor on sama?]
]

#slide[
  == Mis on sama, mis on erinev?
  - Sama: protsessori käsud (`mov`, `add`, `jmp`, ...)
    - Puhtad arvutused töötaksid mõlemal ühtemoodi
  - Erineb kõik, mis vajab operatsioonisüsteemi:
    - Süsteemikutsed (nimed, numbrid, argumendid)
    - Programmifaili formaat: PE (`.exe`) vs ELF
    - Teegid: `kernel32.dll` vs `libc.so`
]

#slide[
  == Süsteemikutsed Windowsil ja Linuxil
  #figure(
    image("figure7.jpg", height: 80%),
    caption: [Windowsi vs Unixi süsteemikutsed @OperatingSystemsStructures],
  )
]

#slide[
  == Kas macOS-il kompileeritud programm töötab ka Linuxil?
  #only("2-")[- Samuti ei: erinevad süsteemikutsed, failiformaat (Mach-O vs ELF)]
  #only("3-")[- Aga lähtekood kompileerub Linuxil üldiselt ilma muudatusteta]
  #only("4-")[- Miks? #sym.arrow POSIX]
]

#slide[
  == POSIX
  - #strong[P]ortable #strong[O]perating #strong[S]ystem #strong[I]nterface
  - "POSIX defines a standard operating system interface and environment, including a command interpreter (or "shell"), and common utility programs to support applications portability at the source code level." @BaseSpecificationsIssue
  - IEEE standard operatsioonisüsteemidele
    - Ühised funktsioonid
      - C funktsioonid: `open`, `read`
      - Käsurida ja tööriistad: `sh`, `ls`, `grep`
      - Failide õigused
]

#slide[
  == POSIX
  - "Definitions for system service functions and subroutines, language-specific system services for the C programming language" @BaseSpecificationsIssue
  - Sama kood kompileerub Linuxil ja macOS-il
  - NB! Kompileeritud programm töötab ainult ühel neist
  - POSIXiga ühilduvad operatsioonisüsteemid:
    - macOS, Linux, FreeBSD
  - Windows ei ole POSIX ühilduv
]

#slide[
  == Ühilduvuskihid
  #set text(size: 17pt)
  #table(
    columns: (auto, auto, auto),
    inset: 0.5em,
    stroke: none,
    table.header([*Kiht*], [*Mis jookseb kus*], [*Mida tõlgib*]),
    table.hline(),
    [Wine / Proton], [Windows → Linux], [Windowsi teegid (`kernel32.dll`, `ntdll.dll`)],
    [WSL1], [Linux → Windows], [Linuxi süsteemikutsed Windowsis],
    [Darling], [macOS → Linux], [macOS-i teegid ja süsteemikutsed],
    [Cygwin / MSYS2], [POSIX → Windows], [POSIX funktsioonid Win32 peale (lähtekood)],
  )
]

#slide[
  == Varia: Tarkvara privileegrežiimis
  - Rootkit
  - Vanguard anticheat mootor
    - Privileegrežiimis jooksev anticheat
    - Jookseb pidevalt taustal alates arvuti töölepanemisest
  - CrowdStrike viirusetõrje
    - Privileegrežiimis suudab viirusetõrje
      - Uurida ühendatud seadmeid
      - Uurida teiste protsesside mälu
]

#slide[
  == Probleemid tarkvaraga privileegrežiimis
  - https://en.wikipedia.org/wiki/2024_CrowdStrike-related_IT_outages


    "On 19 July 2024, the American cybersecurity company CrowdStrike distributed a faulty update to its Falcon Sensor security software that caused widespread problems with Microsoft Windows computers running the software. As a result, roughly 8.5 million systems crashed and were unable to properly restart[1] in what has been called the largest outage in the history of information technology[2] and "historic in scale".[3]"
]

#slide[
  == Probleemid tarkvaraga privileegrežiimis
  - Privaatsus
    - Kolmanda osapoole protsess saab lugeda kõikide protsesside mälu
    - Kolmanda osapoole protsess saab ligi kõikidele arvutiga ühenduses olevatele seadmetele (kaamera, mikrofon)
    - Suletud lähtekood, puudub auditeerimisvõimalus
  - Turvalisus
    - Mis juhtub, kui häkkerid sellisele tarkvarale ligi saavad?
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
