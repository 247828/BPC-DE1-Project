# BPC-DE1 Projekt
<h1>Inteligentný parkovací systém s ultrazvukovými senzormi</h1>
<i>Vysoké učení technické v Brně, Fakulta elektrotechniky a komunikačních technologií, letný semester 2023/2024</i>
<h2>Členovia tímu</h2>

Jakub Kováč (kód a simulácie)<br>
Nikita Kolobov (responsible for ...)<br>
Martin Kučera (responsible for ...)<br>

<h2>Teoretický popis, vysvetlenie</h2>
<p>
Inteligentný parkovací systém je sám schopný na pravidelne aktualizovaných dátach vyhodnotiť, aký je stav parkovacích miest. Ak použijeme vstupné dáta vzdialenosť, je potrebné zabezpečiť jej pravidelné meranie a priradením určitých hodnôt do určených intervaloch vyhodnocovať obsadenie parkovacieho miesta.
<br><br>
<i>HC-SR04</i> je ultrazvukový senzor, ktorý meria vzdialenosť v rozmedzí od približne 2 cm do 4 m. Princíp merania spočíva vyslaním ultrazvukových pulzov vysielačom, ktoré sa spustia jednorázovým externým pulzom úrovne HIGH minimálnej šírky 10 µs na vstupný pin "trig". Tým sa taktiež na výstupe "echo" zmení úroveň na HIGH a modul čaká na odrazenú vlnu. Prichádzajúca vlna zmení úroveň na výstupe "echo" na LOW. Výsledná vzdialenosť sa prepočíta pomocou vzťahu:
<br>
<img src="/obrazky/vzorce/vzdialenost.png">
<br>
kde <i>d</i> je výsledná vzdialenosť v metroch, <i>v</i> je rýchlosť zvuku v metroch za sekundu a <i>t</i> je čas, počas ktorého je úroveň výstupu "echo" HIGH v sekundách.

</p>

<h2>Opis hardverového návrhu</h2>
Návrh parkovacieho systému spočíva v pravidelnom meraní vzdialeností modulmi ultrazvukových senzorov HC-SR04, ktoré budú pripojené k doske s FPGA Nexys A7-50T. Na sedem segmentovom displeji sa zobrazí číslo parkovacieho miesta vzdialenosť, ktorú senzor počas posledného cyklu nameral. Pomocou tlačidla bude možné prepínať medzi rôznymi parkovacími miestami. Na LED-kách sa zobrazí stav obsadenosti parkovacích miest. Zapnutá indikuje, že je parkovacie miesto voľné a vypnutá, že nie. Pri aktuálne zobrazených údajoch o parkovacom mieste na sedem segmentovom displeji bude taktiež svietiť RGB LED-ka, ktorá obsadené parkovacie miesto oznámi červenou farbou a voľné zelenou. Reset systému bude možné vykonať stlačením iného tlačítka, čím sa vynulujú údaje a započne nový cyklus merania.
</p>

<h2>Popis softvérového riešenia</h2>
<p>
<i>... vložiť schému návrhu Top Level</i>
<br><br>
Funkciu merania a vyhodnotenia vysvetlíme na jednom senzore: Spustením štartovacieho pulzu sa spustí jednorázový impulz, ktorý spustí vyslanie ultrazvukovej vlny a zároveň počítadlo. Počítadlo počíta hodinové cykly. Keď po určitom počte hodinových cykloch dosiahne hodnotu odpovedajúcu približne jednému centimetru, pripočíta sa jeden centimeter do výsledku a počítadlo sa vynuluje a počíta znovu. Keď dorazí odrazená vlna, zastaví sa počítanie, výsledná vzdialenosť sa nasmeruje na spracovanie a následné zobrazenie na displej. Vyvolaním resetu sa všetky počítadlá vynulujú.
</p>

<h3>Použité komponenty a simulácie</h3>
<ul>
  <li>clock_enable.vhd - generátor periodických "štartovacích" pulzov</li>
  <p><i>krátky popis</i></p>
  <img src="/obrazky/simulace/clock_enable.png" alt="Simulacia modulu clock_enable">
  <i>obr. 2 Simulácia komponentu clock_enable</i><br><br>
  <li>trig_pulse.vhd - generátor jednorázových pulzov pre ultrazvukový senzor</li>
  <p><i>krátky popis</i></p>
  <img src="/obrazky/simulace/trig_pulse.png" alt="Simulacia modulu trig_pulse">
  <i>obr. 3 Simulácia komponentu trig_pulse</i><br><br>
  <li>echo_detector.vhd - počítadlo a vyhodnotenie vzdialenosti v cm v binárom čísle</li>
  <p><i>krátky popis</i></p>
  <img src="/obrazky/simulace/echo_detect_02.png" alt="Simulacia modulu echo_detect">
  <img src="/obrazky/simulace/echo_detect_01.png" alt="Simulacia modulu echo_detect">
  <i>obr. 4 a 5 Simulácia komponentu clock_enable</i><br><br>
  <li>bin2bcd9.vhd - prevodník binárneho čísla na kód "Binary to Decimal" pre zobrazenie čísel v desiatkovej sústave na sedem segmentových displejoch</li>
  <p><i>krátky popis</i></p>
  <li>bin2seg.vhd - prevodník binárneho čísla na zobrazenie na sedem segmentovom displeji</li>
  <p><i>krátky popis</i></p>
  
</ul>
<i>... a ďalšie budú pridané postupne</i>

<h2>Návod na používanie</h2>
<p><i>Stručné vysvetlenie finálneho produktu, fotografie a video.</i></p>

<h2>Použité zdroje a nástroje</h2>
<ol>
  <li>Modul s ultrazvukovými senzormi typ HC-SR04, <a href="https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf">katalógový list</a></li></li>
  <li>Doska s FPGA typ Nexys A7-50T, <a href="https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual">referenčný manuál</a></li>
  <li>Komponenty <i>clock_enable.vhd</i> a <i>bin2seg.vhd</i> vytvorené počas počítačových cvičení predmetu</li>
  <li><i>... odkazy s nápadmi, kde sme sa inšpirovali, manuály a pod.</i></li>
  
</ol>
