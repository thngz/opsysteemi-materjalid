#import "@preview/exm:0.1.0": assignment, question, section
#show: doc => assignment(
  doc,
  courseid: "ITI0106",
  coursename: "Operatsioonisüsteemid ja arvutivõrgud",
  school: "Tallinna Tehnikaülikool",
  semester: "Sügis 2026",
  assignment: "Praktikum",
  title: "Süsteemikutsed (system calls)",
)
Vormista vastus *PDF* formaadis failina ja lae Moodle'sse hiljemalt *2026-11-02, 23:59*

== NB! praktikumis kasutatavad käsud nõuavad Linux keskkonda

Praktikumi eesmärgid:
- Kinnistada protsessori kasutajarežiimi ja privileegrežiimi (kernel-mode, user mode)
- Märgata operatsioonisüsteemi rolli privileegrežiimi käskude kutsumisel kasutajarežiimis
- Analüüsida `strace` käsu abil protsesside tehtavaid süsteemikutseid

#section("Ülesanne - Privileegrežiim ja kasutajarežiim", points: true, number: true)[
  + #question(points: 0.25)[
      Käivita käsureal: \ ```bash $ ps aux | head -20``` \
      
      Kas protsessid, mille nimi on nurksulgudes (nt `[kthreadd]`), jooksevad privileegrežiimis või kasutajarežiimis? Põhjenda oma vastust.
        - Vihje: Väli VZX näitab, kas protsessile on kasutajarežiimis mälu eraldatud
      // + Käivita käsureal `$ ps aux | tail -20`
    ][]
  + #question(points: 0.25)[Kasu][]
  + #question(points: 0.25)[Kasu][]
  + #question(points: 0.25)[Kasu][]
]
