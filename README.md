# BPC-DE1 Projekt
<h1>Inteligentný parkovací systém s ultrazvukovými senzormi</h1>
<i>Vysoké učení technické v Brně, Fakulta elektrotechniky a komunikačních technologií, letný semester 2023/2024</i>
<h2>Členovia tímu</h2>

Jakub Kováč (nápad návrhu, spracovanie údajov senzormi, simulácie)<br>
Nikita Kolobov (multiplexor, simulácie)<br>
Martin Kučera (dekóder binary to binary decoded decimal, simulácie)<br>

<h2>Teoretický popis, vysvetlenie</h2>
<p>
Inteligentný parkovací systém je sám schopný na pravidelne aktualizovaných dátach vyhodnotiť, aký je stav parkovacích miest. Ak použijeme vstupný údaj vzdialenosť, je potrebné zabezpečiť jej pravidelné meranie a priradením určitých hodnôt do určených intervaloch vyhodnocovať obsadenie parkovacieho miesta.
<br><br>
<i>HC-SR04</i> je ultrazvukový senzor, ktorý meria vzdialenosť v rozmedzí od približne 2 cm do 4 m. Princíp merania spočíva vyslaním ultrazvukových pulzov vysielačom, ktoré sa spustia jednorázovým externým pulzom úrovne HIGH minimálnej šírky 10 µs na vstupný pin "trig". Tým sa taktiež na výstupe "echo" zmení úroveň na HIGH a modul čaká na odrazenú vlnu. Prichádzajúca vlna zmení úroveň na výstupe "echo" na LOW. Výsledná vzdialenosť sa prepočíta pomocou vzťahu:
<br><br>
<img src="/obrazky/vzorce/vzdialenost.png" width="63" height="39"><br><br>
kde <i>d</i> je výsledná vzdialenosť v metroch, <i>v</i> je rýchlosť zvuku v metroch za sekundu a <i>t</i> je čas, počas ktorého je úroveň výstupu "echo" HIGH v sekundách. Pretože prichádzajúca vlna naspäť prejde tú istú vzdialenosť dvakrát (2<i>d</i>), výslednú vzdialenosť <i>d</i> získame vydelením rovnice dvojkou.
</p>

<h2>Opis hardverového návrhu</h2>
Návrh parkovacieho systému spočíva v pravidelnom meraní vzdialeností modulmi ultrazvukových senzorov HC-SR04, ktoré budú pripojené k doske s FPGA Nexys A7-50T. Na sedem segmentovom displeji sa zobrazí číslo parkovacieho miesta vzdialenosť, ktorú senzor počas posledného cyklu nameral. Pomocou tlačidla bude možné prepínať medzi rôznymi parkovacími miestami. Na LED-kách sa zobrazí stav obsadenosti parkovacích miest. Zapnutá indikuje, že je parkovacie miesto voľné a vypnutá, že nie. Reset systému bude možné vykonať stlačením iného tlačítka, čím sa vynulujú údaje a započne nový cyklus merania.
<br><br>
<img src="/obrazky/blok_schema_top_level.png" alt="Bloková schéma top_level.vhd">
<i>obr. 2 Schéma návrhu riešenia</i>
<br><br>
Keďže signály dosky Nexys A7-50T pracujú s napätím 3,3 V a senzory s 5 V, senzory sú napájané externe pomocou 5V výstupu z Arduina a napätie výstupu echo je znížené pomocou odporového deliča na úroveň 3,3 V pre vstup do dosky.
<br><br>
<img src="/obrazky/ultrasonic_resistors.jpg" alt="Prepojenie senzora s doskov 3,3 V">
<i>obr. 3 Prepojenie HC-SR04 s doskou (zdroj: GitHub <a href="https://github.com/tomas-fryza/vhdl-course/blob/master/lab8-project/images/ultrasonic_resistors.jpg">vhdl-course Tomas Fryza</a>)</i>
<br><br>
<img src="/obrazky/fotografie/senzor_osc.jpg" alt="Simulacia modulu echo_detect">
<i>obr. 4 Ukážka časového priebehu merania senzora</i>
<br>
</p>

<h2>Popis softvérového riešenia</h2>
<p>
Meranie a vyhodnotenie vysvetlíme na jednom senzore: Spustením štartovacieho pulzu komponentom <i>trig_pulse</i> sa spustí jednorázový impulz, ktorý spustí vyslanie ultrazvukovej vlny a zároveň pripravý počítadlo na v komponente prijímača <i>echo_detect</i>. Keď výstup echo senzora sa nastaví na HIGH, spúšťa sa počítanie hodinových cyklov. Keď po určitom počte hodinových cykloch dosiahne hodnotu odpovedajúcu približne jednému centimetru, pripočíta sa jeden centimeter do výsledku a počítadlo sa vynuluje a počíta znovu. Keď dorazí odrazená vlna, výstup senzora echo sa nastaví na LOW a zastaví sa počítanie. Výsledná vzdialenosť sa nasmeruje na výstup, ktorý je pripojený na komponent <i>multiplexor</i>, ktorým sa volí zobrazenie výslednej hodnoty a čísla zariadenia na displej pomocou tlačítka. Následne údaje vybraného prijímača smerujú k sedemsegmentovému ovládaču <i>seven_seg_disp_drv</i>, ktorý zobrazí hodnoty na sedemsegmentový displej. Číslo zariadenia vstupuje do ovládača priamo a výsledná vzdialenosť až po prevední na BCD kód komponentom <i>bin2bcd9</i>. Vyvolaním resetu sa všetky počítadlá vynulujú a cyklus začína nanovo pre všetky jednotky.
</p>
<p>Zdrojové kódy všetkých komponentov sú k dispozícii <a href="/zdrojove_kody/smart_parking/sources_1/new">tu</a> a súbory pre simulovanie test bench sú k dispozícii <a href="/zdrojove_kody/smart_parking/sim_1/new">tu</a>.</p>
<h3>Použité komponenty a simulácie</h3>
<ul>
  <li><a href="/zdrojove_kody/smart_parking/sources_1/new/trig_pulse.vhd">trig_pulse.vhd</a> - generátor jednorázových pulzov pre ultrazvukový senzor</li>
  <p>Tento komponent sa používá k zapnutiu trigovacích pulsov pre detektory a zároveň spúšťa merania vzdialeností jednotlivých prijímacich komponentov</p>
  <img src="/obrazky/simulace/trig_pulse.png" alt="Simulacia modulu trig_pulse">
  <i>obr. 4 Simulácia komponentu trig_pulse</i><br><br>
  <li><a href="/zdrojove_kody/smart_parking/sources_1/new/echo_detect.vhd">echo_detect.vhd</a> - počítadlo a vyhodnotenie vzdialenosti v cm v binárom čísle</li>
  <p>Komponent počíta počet periód hodinového signálu. Ak počet cyklov je rovný vzdialenosti jedného centimetra, pripočíta sa jeden centimeter na výstup a vnútorné počítadlo sa vynuluje a cyklus sa opakuje, kým je na vstupe echo úroveň HIGH. Výstup v cm je v binárnom vyjadrení. Výpočtom bolo zistené, že pri hodinovom takte 100 MHz a rýchlosti zvuku 343 m/s 1 cm trvá 5827,505827 taktov. Zaokruhľovaním bola vypočítaná chyba na 4 m približne 1 mm.
  </p>
  <img src="/obrazky/simulace/echo_detect_02.png" alt="Simulacia modulu echo_detect">
  <img src="/obrazky/simulace/echo_detect_01.png" alt="Simulacia modulu echo_detect">
  <i>obr. 5 a 6 Simulácia komponentu echo_detect</i><br><br>
  <li><a href="/zdrojove_kody/smart_parking/sources_1/new/mplx.vhd">mplx.vhd</a> - multiplexor</li>
  <p>
    Vyberá jeden z viacerých výstupných údajov detektorov, ktoré sa zobrazia na sedem segmentovej jednotke. Stlačením tlačidla dostane komponent pulz na inkrementovanie vnútorného počítadla a podľa jeho hodnoty sa vybraný vstup nasmeruje na výstup. Po dosiahnutí najvyššej hodnoty sa počítadlo vynuluje a na výstup sa priradí prvý vstup.
  </p>
  <img src="/obrazky/simulace/mplx.png" alt="Simulacia modulu mplx.vhd">
  <i>obr. 7 Simulácia komponentu mplx</i><br><br>
  <li><a href="/zdrojove_kody/smart_parking/sources_1/new/bin2bcd9.vhd">bin2bcd9.vhd</a> - prevodník binárneho čísla na kód "Binary to Decimal" pre zobrazenie čísel v desiatkovej sústave na sedem segmentových displejoch</li>
  <p>
    Na vstup in_bin je privedené 9 bitové binární číslo reprezentujúce nameranú vzdialenosť. Následne je pomocou algoritmu upravené na číslo v BCD formáte. Vďaka tomuto algoritmu je možné zobrazit číslo (najväčšie 511) na troch sedem segmentových displejoch s použitím číslic 0 - 9. Ilustračný princíp algoritmu je ukázaý na <a href="/obrazky/bin2bcd.jpg">obrázku</a>.
  </p>
  <img src="/obrazky/simulace/bin2bcd9_1.png" alt="Simulacia modulu bin2bcd.vhd">
  <i>obr. 8 Simulácia komponentu bin2bcd9</i><br><br>
  <li><a href="/zdrojove_kody/smart_parking/sources_1/new/seven_seg_disp_drv.vhd">seven_seg_disp_drv.vhd</a> - Ovládač sedemsegmentových jednotiek dosky Nexys A7-50T</li>
  <p>
  Sedem segmentové displeje na doske majú spoločné anódy a aktuálny segment sa vyberá zvolením konkrétneho segmentu. Zobrazenie viacerých číslic dosiahneme rýchlym prepínaním segmentov, kedy naše oči nestíhájú zaznamenať prepínanie a javí sa to ako statický obraz. Každým prepnutím sa prepnú aj vstupné dáta, ktoré májú jednotlivé segmenty zobraziť. Rýchlosť obnovania celého displeja (8 sedem segmentov) je 125 Hz (obnovovacia perióda je 8 ms, každý segment svieti 1 ms). Používa komponenty bin2seg.vhd a clock_enable.vhd
  </p>
  <img src="/obrazky/simulace/seven_seg_disp_drv.png" alt="Simulacia modulu seven_seg_disp_drv.vhd">
  <i>obr. 9 Simulácia komponentu seven_seg_disp_drv</i><br><br>
</ul>

<h2>Inštrukcie</h2>
<p>
<img src="/obrazky/fotografie/01.jpg" alt="Ukážka zapojenia">
<i>obr. 10 Ukážka výsledného zapojenia inteligentného parkovacieho systému</i>
<br><br>
K doske Nexys A7-50T je možné zapojiť štyri ultrazvukové senzory HC-SR04 pomocou Pmod konektorov: piny 1-4 konektoru JC sa používajú na pripojenie jednlotlivých vstupom "trig" a piny 1-5 konektoru JD na pripojenie jednotlivých výstupov "echo", ktoré sa pripájajú cez rezistorový delič (zníženie úrovne napätia z 5 V na 3,3 V). Senzory sú napájené externým zdrojom 5 V (Arduino). Na sedemsegmentovom displeji sa zobrazuje aktuálna vzdialenosť zvoleného zariadenia v metroch. Prepínanie medzi zobrazením vzdialeností jednotlivých senzorov sa vykonáva stlačením stredného tlačidla označeného BTNC. Štyrmi zelenými LED-kami sa indikuje obsadenie parkovacieho miesta (svieti - je voľné, nesvieti - obsadené). Meranie vzdialeností prebieha 5x za sekundu. Reset celého zariadenia sa vykonáva tlačidlom BTND.
<br>
<img src="/obrazky/fotografie/02_popis.png" alt="Pohľad zhora a popis zapojenia">
<i>obr. 11 Popis zapojenia</i>
<br><br>
<i><a href="https://youtu.be/t4LYXKCEKfI">Odkaz na video</a></i> 
</p>

<h2>Použité zdroje a nástroje</h2>
<ol>
  <li>Moduly s ultrazvukovými senzormi typ HC-SR04, <a href="https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf">katalógový list</a></li>
  <li>Doska s FPGA typ Nexys A7-50T, <a href="https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual">referenčný manuál</a>, <a href="https://raw.githubusercontent.com/Digilent/digilent-xdc/master/Nexys-A7-50T-Master.xdc">súbor constraint</a></li>
  <li>Komponenty <i>clock_enable.vhd</i>, <i>bin2seg.vhd</i> a <i>debounce.vhd</i> vytvorené počas počítačových cvičení kurzu BPC-DE1, GitHub <a href="https://github.com/tomas-fryza/vhdl-course">vhdl-course Tomas Fryza</a></li>
  <li>Inšpirácia pre návrh prevodníku binary to BCD: <a href="https://www.youtube.com/watch?v=VKKGyOc4zRA">video</a>, <a href="/obrazky/bin2bcd.jpg">návrh algoritmu</a></li>
  <li>Inšpirácia pre návrh ovládania sedem segmentovej jednotky dosky Nexys A7-50T: <a href="https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual#seven-segment_display">referenčný manuál Nexys A7-50T, kap. 9.1 Seven-Segment Display</a></li>
  <li>Osciloskop Keysight Technologies DSOX3034T (350 MHz, 4 analógové kanály)</li>
  <li>Rezistory 1k a 2k (napäťový delič), nepájivé pole, prepojovacie vodiče</li>
</ol>
