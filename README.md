# BPC-DE1 Projekt
<h1>Inteligentný parkovací systém s ultrazvukovými senzormi</h1>
<i>Vysoké učení technické v Brně, Fakulta elektrotechniky a komunikačních technologií, letný semester 2023/2024</i>
<h2>Členovia tímu</h2>

Jakub Kováč (spracovanie údajov senzormi, simulácie...)<br>
Nikita Kolobov (multiplexor, simulácie...)<br>
Martin Kučera (dekóder binary to binary decoded decimal, simulácie...)<br>

<h2>Teoretický popis, vysvetlenie</h2>
<p>
Inteligentný parkovací systém je sám schopný na pravidelne aktualizovaných dátach vyhodnotiť, aký je stav parkovacích miest. Ak použijeme vstupné dáta vzdialenosť, je potrebné zabezpečiť jej pravidelné meranie a priradením určitých hodnôt do určených intervaloch vyhodnocovať obsadenie parkovacieho miesta.
<br><br>
<i>HC-SR04</i> je ultrazvukový senzor, ktorý meria vzdialenosť v rozmedzí od približne 2 cm do 4 m. Princíp merania spočíva vyslaním ultrazvukových pulzov vysielačom, ktoré sa spustia jednorázovým externým pulzom úrovne HIGH minimálnej šírky 10 µs na vstupný pin "trig". Tým sa taktiež na výstupe "echo" zmení úroveň na HIGH a modul čaká na odrazenú vlnu. Prichádzajúca vlna zmení úroveň na výstupe "echo" na LOW. Výsledná vzdialenosť sa prepočíta pomocou vzťahu:
<br><br>
<img src="/obrazky/vzorce/vzdialenost.png" width="63" height="39"><br><br>
kde <i>d</i> je výsledná vzdialenosť v metroch, <i>v</i> je rýchlosť zvuku v metroch za sekundu a <i>t</i> je čas, počas ktorého je úroveň výstupu "echo" HIGH v sekundách. Pretože prichádzajúca vlna naspäť prejde tú istú vzdialenosť dvakrát (2<i>d</i>), výslednú vzdialenosť <i>d</i> získame vydelením rovnice dvojkou.

</p>

<h2>Opis hardverového návrhu</h2>
Návrh parkovacieho systému spočíva v pravidelnom meraní vzdialeností modulmi ultrazvukových senzorov HC-SR04, ktoré budú pripojené k doske s FPGA Nexys A7-50T. Na sedem segmentovom displeji sa zobrazí číslo parkovacieho miesta vzdialenosť, ktorú senzor počas posledného cyklu nameral. Pomocou tlačidla bude možné prepínať medzi rôznymi parkovacími miestami. Na LED-kách sa zobrazí stav obsadenosti parkovacích miest. Zapnutá indikuje, že je parkovacie miesto voľné a vypnutá, že nie. Reset systému bude možné vykonať stlačením iného tlačítka, čím sa vynulujú údaje a započne nový cyklus merania. (PRIDAŤ ILUSTRAČNÝ OBRÁZOK)
<br><br>
Keďže signály dosky Nexys A7-50T pracujú s napätím 3,3 V a senzory s 5 V, senzory sú napájané externe a napätie výstupu echo je znížené pomocou odporového deliča na úroveň 3,3 V pre vstup do dosky (PRIDAŤ SCHÉMU).
</p>

<h2>Popis softvérového riešenia</h2>
<p>
<img src="/obrazky/blok_schema_top_level.png">
<i>obr. 1 Schéma návrhu riešenia</i><br><br>
Funkciu merania a vyhodnotenia vysvetlíme na jednom senzore: Spustením štartovacieho pulzu sa spustí jednorázový impulz, ktorý spustí vyslanie ultrazvukovej vlny a zároveň počítadlo. Počítadlo počíta hodinové cykly. Keď po určitom počte hodinových cykloch dosiahne hodnotu odpovedajúcu približne jednému centimetru, pripočíta sa jeden centimeter do výsledku a počítadlo sa vynuluje a počíta znovu. Keď dorazí odrazená vlna, zastaví sa počítanie, výsledná vzdialenosť sa nasmeruje na spracovanie a následné zobrazenie na displej. Vyvolaním resetu sa všetky počítadlá vynulujú.
</p>

<h3>Použité komponenty a simulácie</h3>
<ul>
  <li><a href="/zdrojove_kody/smart_parking/sources_1/new/clock_enable.vhd">clock_enable.vhd</a> - generátor periodických "štartovacích" pulzov</li>
  <p><i>Tento komponent se používá k zapnutí čitaní v komponentech pro výběr segmentu displeje a zapínání trigovacích pulsů pro detektor</i></p>
  <img src="/obrazky/simulace/clock_enable.png" alt="Simulacia modulu clock_enable">
  <i>obr. 2 Simulácia komponentu clock_enable</i><br><br>
  <li><a href="/zdrojove_kody/smart_parking/sources_1/new/trig_pulse.vhd">trig_pulse.vhd</a> - generátor jednorázových pulzov pre ultrazvukový senzor</li>
  <p><i>krátky popis</i></p>
  <img src="/obrazky/simulace/trig_pulse.png" alt="Simulacia modulu trig_pulse">
  <i>obr. 3 Simulácia komponentu trig_pulse</i><br><br>
  <li><a href="/zdrojove_kody/smart_parking/sources_1/new/echo_detect.vhd">echo_detect.vhd</a> - počítadlo a vyhodnotenie vzdialenosti v cm v binárom čísle</li>
  <p><i>krátky popis</i></p>
  <img src="/obrazky/simulace/echo_detect_02.png" alt="Simulacia modulu echo_detect">
  <img src="/obrazky/simulace/echo_detect_01.png" alt="Simulacia modulu echo_detect">
  <i>obr. 4 a 5 Simulácia komponentu clock_enable</i><br><br>
  <li><a href="/zdrojove_kody/smart_parking/sources_1/new/mplx.vhd">mplx.vhd</a> - multiplexor</li>
  <p>Vyberá jeden z viacerých výstupných údajov detektorov, ktoré sa zobrazia na sedem segmentovej jednotke.</p>
  <img src="/obrazky/simulace/mplx.png" alt="Simulacia modulu echo_detect">
  <i>obr. 6 Simulácia komponentu mplx</i><br><br>
  <li><a href="/zdrojove_kody/smart_parking/sources_1/new/bin2bcd9.vhd">bin2bcd9.vhd</a> - prevodník binárneho čísla na kód "Binary to Decimal" pre zobrazenie čísel v desiatkovej sústave na sedem segmentových displejoch</li>
  <p><i>krátky popis</i></p>
  <img src="/obrazky/bin2bcd9.png" alt="Simulacia modulu bin2bcd.vhd">
  <i>obr. 7 Simulácia komponentu bin2bcd9</i><br><br>
  <li><a href="/zdrojove_kody/smart_parking/sources_1/new/seven_seg_disp_drv.vhd">seven_seg_disp_drv.vhd</a> - Ovládač sedemsegmentových jednotiek dosky Nexys A7-50T</li>
  <p><i>Rýchlosť obnovania segmentov je 125 Hz (obnovovacia perióda je 8 ms, každý segment svieti 1 ms). Používa komponenty bin2seg.vhd a clock_enable.vhd</i></p>
  <img src="/obrazky/simulace/seven_seg_disp_drv.png" alt="Simulacia modulu seven_seg_disp_drv.vhd">
  <i>obr. 8 Simulácia komponentu seven_seg_disp_drv/i><br><br>
  
</ul>
<p>Súbory test bench nájdete <a href="/zdrojove_kody/smart_parking/sim_1/new">tu</a>.</p>

<h2>Návod na používanie</h2>
<p><i>Stručné vysvetlenie finálneho produktu, fotografie a video.</i></p>

<h2>Použité zdroje a nástroje</h2>
<ol>
  <li>Moduly s ultrazvukovými senzormi typ HC-SR04, <a href="https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf">katalógový list</a></li>
  <li>Doska s FPGA typ Nexys A7-50T, <a href="https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual">referenčný manuál</a>, <a href="https://raw.githubusercontent.com/Digilent/digilent-xdc/master/Nexys-A7-50T-Master.xdc">súbor constraint</a></li>
  <li>Komponenty <i>clock_enable.vhd</i> a <i>bin2seg.vhd</i> vytvorené počas počítačových cvičení kurzu BPC-DE1</li>
  <li>Inšpirácia pre návrh prevodníku binary to BCD: <a href="https://www.youtube.com/watch?v=VKKGyOc4zRA">video</a>, <a href="/obrazky/bin2bcd.jpg">ukážka návrhu algoritmu</a></li>
  <li>Inšpirácia pre návrh ovládania sedem segmentovej jednotky dosky Nexys A7-50T: <a href="https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual#seven-segment_display">referenčný manuál Nexys A7-50T, kap. 9.1 Seven-Segment Display</a></li>
  <li>Osciloskop Keysight Technologies DSOX3034T (350 MHz, 4 analógové kanály)</li>
  <li><i>... odkazy s nápadmi, kde sme sa inšpirovali, manuály a pod.</i></li>
  
</ol>
