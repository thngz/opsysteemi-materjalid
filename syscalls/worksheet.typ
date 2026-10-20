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
Vormista vastus *PDF* formaadis failina ja lae Moodle'sse hiljemalt *2026-11-02 23:59*

== NB! praktikumis kasutatavad käsud nõuavad Linux keskkonda

Praktikumi eesmärgid:
- Kinnistada protsessori kasutajarežiimi ja privileegrežiimi (kernel-mode, user mode)
- Analüüsida `strace` käsu abil protsesside tehtavaid süsteemikutseid

#section("Ülesanne - Privileegrežiim ja kasutajarežiim", points: true, number: true)[
  + #question(points: 0.5)[
      - Käivita käsureal: \ ```bash $ ps aux | head -20``` \

      - Kas protsessid, mille nimi on nurksulgudes (nt `[kthreadd]`), jooksevad privileegrežiimis või kasutajarežiimis? Põhjenda oma vastust.
        \ Vihje: Väli VZX näitab, kas protsessile on kasutajarežiimis mälu eraldatud
    ][]
  + #question(points: 0.5)[
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


#section("Ülesanne - strace kasutamine protsesside süsteemikutsete nägemiseks", points: true, number: true)[

  #callout("strace")[
    `strace` on käsurea programm, mis jooksutab parameetriks antud programmi kuniks viimane seisma jääb. Käimise ajal kogub `strace` kokku kõik jälgitava programmi poolt tehtud süsteemikutsed ja kuvab need lõpus. Lisainfo `man strace`
  ]

  + #question(points: 0.5)[
      - Loo C keele programm `hello.c`, mille sisuks on:
        ```c
        #include <stdio.h>
        int main() {
          printf("Tere\n");
        }
        ```

      - Kompileeri see käsuga

        `gcc hello.c -o hello`

      - Käivita programm `strace`-ga

        `strace ./hello`

      - Leia süsteemikutse, mis vastutab teksti kuvamise eest ekraanile
      - Mida tähendavad selle süsteemikutse kolm argumenti?
      - Mida tähendab selle süsteemikutse tagastusväärtus?
      - Kasuta abisaamiseks käsku `man 2 write`
    ][]

  + #question(points: 0.5)[
      - Loo bash skript `test.sh`, mille sisuks on:
        ```bash
          echo tere > a.txt
          strace -e trace=openat,read,write,close cat a.txt
        ```

      #callout("strace -e trace=...")[
        `strace` lubab filtreerida erinevate süsteemikutsete vahel.
        ```bash
        strace -e trace=read ```

        kuvab ainult `read` süsteemikutseid.

        ```bash
        strace -e trace=!read
        ```

        kuvab kõike *peale* `read` süsteemikutse.
      ]

      - Käivita see skript käsuga

        `./test.sh`

      - Mis on `openat` süsteemikutse tagastusväärtus?
      - Kuidas kasutab seda väärtust `read` süsteemikutse?
      - Kuidas kasutab seda väärtust `close` süsteemikutse?
      - Millisesse failideskriptorisse kirjutab `write` süsteemikutse?
    ][]

  + #question(points: 0.5)[
      - Loo järgnevad loengus näidatud C keele programmid: `write.c`, `printf.c`
      ```c
      // write.c
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
      ```
      #line(length: 100%)
      ```c
      // printf.c
      #include <stdio.h>

      int main(void) {
          int x = 42;
          printf("Vastus: %d\n", x);
      }
      ```

      - Kompileeri need programmid kasutades:
        - `gcc ./write.c -o write` (ignoreeri ridu _warning_)
        - `gcc ./printf.c -o printf`

      - Jooksuta need programmid `strace` abiga:
        - `strace -e trace=write ./write`
        - `strace -e trace=write ./printf`

      - Kas `printf` C funktsioon on süsteemikutse või standardteegi funktsioon?
      - Asenda `write.c` failis
      rida
      ```c
      write(1, "Vastus: ", 8);
      ```

      reaga
      ```c
      write(1, "Vastus: ", 6);
      ```
      - Mis muutus? Miks?
      - Miks programmerijad eelistavad standardteegi funktsioone üle otsese süsteemikutsete kasutamise?
    ][]

  + #question(points: 0.5)[
      Jooksuta käsk

      ```bash strace -e trace=openat cat /etc/shadow ```

      - Mis on `openat` süsteemikutse väljund `/etc/shadow` puhul?
      - Kas viga tuleb `cat` käsu või operatsioonisüsteemi poolt? Selgita.
    ][]

  + #question(points: 0.5)[
      - Jooksuta käsureal järgnevad käsud:

        `strace -c dd if=/dev/zero of=/dev/null bs=1 count=1000000`

        `strace -c dd if=/dev/zero of=/dev/null bs=1000000 count=1`
      - Mõlemad käsud kopeerivad ühepalju andmeid. Mitu `read` ja `write` süsteemikutset kummalgi juhul tehti? Kumb oli kiirem? Miks?
      

      #callout("strace -c")[
        `strace -c` loendab tehtud süsteemikutsete kogused ja nendele kuluva aja (privileegrežiimis) ning tagastab nende kohta ülevaate.
      ]
    ][]

]



