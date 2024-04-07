# BPC-DE1 Projekt
<h1>Inteligentný parkovací systém s ultrazvukovými senzormi</h1>
<i>VUT, letný semester 2023/2024</i>
<h2>Členovia tímu</h2>

Jakub Kováč (kód a simulácie)<br>
Nikita Kolobov (responsible for ...)<br>
Martin Kučera (responsible for ...)<br>

<h2>Teoretický popis, vysvetlenie</h2>

<i>Inteligentný parkovací systém s ultrazvukovými senzormi</i><br>
<p>
<i>HC-SR04</i> je ultrazvukový senzor, ktorý meria vzdialenosť v rozmedzí od približne 2 cm do 4 m. Princíp merania spočíva vyslaním ultrazvukových pulzov vysielačom, ktoré sa spustia jednorázovým externým pulzom minimálnej šírky 10 µs na vstupný pin "trig". Odrazením pulzov od objektu vlna dorazí na prijímač a signál sa privedie na výstupny pin "echo". Výsledná vzdialenosť sa vypočíta z rozdielu času medzi vyslaním pulzov a ich prijatím.
<br><br>
<i>...</i>
</p>

<h2>Opis hardverového návrhu</h2>
Tento parkovací systém by mal pracovať periodicky, kde periódu uvádza jednorazový "štartovací" pulz, ktorý spúšťa meracie cykly jednotlivých senzorov a následne zobrazenie a vyhodnotenie, či sa objekt nachádza na parkovacom mieste alebo nie. Na 7 segmetových displejoch sa zobrazí číslo aktuálneho parkovacieho miesta, symbol stavu obsadenosti a aktuálna meraná vzdialenosť senzora vybraného miesta. Prepínanie pre zobrazenie údajov jednotlivých parkovacích miest bude možné pomocou tlačidiel. Celý systém bude možne resetovať jedným tlačidlom a tým sa spustí cyklus odznovu.
<br><br>
<i>... vložiť schému návrhu Top Level</i>
</p>

<h2>Popis softvérového riešenia</h2>
<p>
Funkciu merania a vyhodnotenia vysvetlíme na jednom senzore: Spustením štartovacieho pulzu sa spustí jednorázový impulz, ktorý spustí vyslanie ultrazvukovej vlny a zároveň počítadlo. Počítadlo počíta hodinové cykly. Keď po určitom počte hodinových cykloch dosiahne hodnotu odpovedajúcu približne jednému centimetru, pripočíta sa jeden centimeter do výsledku a počítadlo sa vynuluje a počíta znovu. Keď dorazí odrazená vlna, zastaví sa počítanie, výsledná vzdialenosť sa nasmeruje na spracovanie a následné zobrazenie na dispej. Vyvolaním resetu sa všetky počítadlá vynulujú.
</p>

<h3>Použité komponenty a simulácie</h3>
<ul>
  <li>clock_enable.vhd - generátor periodických "štartovacích" pulzov</li>
  <li>trig_pulse.vhd - generátor jednorázových pulzov pre ultrazvukový senzor</li>
  <li>echo_detector.vhd - počítadlo a vyhodnotenie vzdialenosti v cm v binárom čísle</li>
  <li>bin2bcd9.vhd - prevodník binárneho čísla na kód "Binary to Decimal" pre zobrazenie čísel v desiatkovej sústave na sedem segmentových displejoch</li>
  <li>bin2seg.vhd - prevodník binárneho čísla na zobrazenie na sedem segmentovom displeji</li>
  
</ul>
<i>... a ďalšie budú pridané postupne</i>

<h2>Návod na používanie</h2>
<p><i>Stručné vysvetlenie finálneho produktu, fotografie a video.</i></p>

<h2>Použité zdroje a nástroje</h2>
<ol>
  <li>Modul s ultrazvukovými senzormi typ HC-SR04</li>
  <li>Doska s FPGA typ Nexys A7-50T, <a href="https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual">referenčný manuál</a></li>
  <li>Komponenty <i>clock_enable.vhd</i> a <i>bin2seg.vhd</i> vytvorené počas počítačových cvičení predmetu</li>
  <li><i>... odkazy s nápadmi, kde sme sa inšpirovali, manuály a pod.</i></li>
  
</ol>
