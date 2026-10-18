#import "@preview/exm:0.1.0": assignment, callout, question, section
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
- Analüüsida `strace` käsu abil protsesside tehtavaid süsteemikutseid

#section("Ülesanne - Privileegrežiim ja kasutajarežiim", points: true, number: true)[
  + #question(points: 0.25)[
      - Käivita käsureal: \ ```bash $ ps aux | head -20``` \

      - Kas protsessid, mille nimi on nurksulgudes (nt `[kthreadd]`), jooksevad privileegrežiimis või kasutajarežiimis? Põhjenda oma vastust.
       \ Vihje: Väli VZX näitab, kas protsessile on kasutajarežiimis mälu eraldatud
    ][]
  + #question(points: 0.25)[
      - Loo C keele programm `unprivileged.c`, mille sisuks on:
      ```c
        int main() {
            asm volatile("cli");
        }
      ```

      - Kompileeri see käsuga

      `gcc unprivileged.c -o unprivileged`

      - Käivita programm

      `./unprivileged`

      - Mis on programmi väljund?
      - Kas programm töötaks, kui jooksutada see _superuser_-ina (sudo)?
      #callout("Volatile")[
        C keeles märksõna `volatile` annab kompilaatorile teada, et seda koodiosa ei tohiks optimeerida.
        Tihtipeale proovivad kompilaatorid kasutada igasuguseid nõkse kuidas kompileeritavat koodi efektiivsemaks muuta. Näiteks võib kompilaator lähtekoodi osasid ümber tõsta, kustutada ja ka asendada (masinkoodis, mitte konkreetses lähtekoodi failis).
        See aga võib antud näited katki teha.
      ]
    ][]
  + #question(points: 0.5)[
      - Loo C keele programm `arvuta.c`, mille sisuks on:
        ```c
        int main() {
          for (volatile long i = 0; i < 2000000000L; i++);
        }
        ```

      - Kompileeri see käsuga

        `gcc arvuta.c -o arvuta`

      - Loo bash skript `runner.sh`, mille sisuks on:

      ```bash
      echo "Arvuta väljund:"
      time ./arvuta
      echo "dd väljund:"
      time dd if=/dev/zero of=/dev/null bs=1 count=2000000
      ```

      - Käivita skript `./runner.sh` (ära unusta failile executable õigust anda!)

      - Mida tähendavad read `user` ja `sys`?
      - Miks on `sys` aeg `arvuta` programmi puhul ligikaudu 0?
      - Miks on `sys` aeg `dd` programmi puhul oluliselt suurem?
      - Kas `dd` on privileegrežiimi või kasutajarežiimi programm?
    ][]
]


#section("Ülesanne - strace kasutus", points: true, number: true)[

]
