# Mapiranje projekta na strukturu završnog rada

> Radna bilješka za pisanje završnog rada. Tema: **"Razvoj 2D akcijske video igre koristeći Godot Game Engine"**.
> Temeljeno na dokumentu "Načelna struktura završnog rada" i stvarnom stanju projekta `zr` (Godot 4.6, GDScript).

## Pravila kojih se treba pridržavati (iz predloška)

- Poglavlja **1 (Uvod)** i **2 (Terminološki sustav)** zajedno smiju imati najviše ~10 stranica.
- Ukupan rad mora imati **minimalno 30 stranica** (numeracija kreće od Uvoda), a Zaključak mora početi na stranici 30 ili kasnije — znači cijela "meso" rada (poglavlja 3–6) mora biti dovoljno opsežna (realno ~20-ak stranica).
- Nikakav copy-paste — sve parafrazirati.
- Svako poglavlje i potpoglavlje mora **početi i završiti tekstom** (ne smije početi/završiti slikom, tablicom ili kodom). Ispred i iza svake slike/tablice/koda mora postojati tekst koji ga uvodi i komentira.
- Minimalno **10 izvora literature**, i to samo onih na koje se stvarno referencira u tekstu.

Ono što slijedi je prijedlog kako svako poglavlje popuniti sadržajem iz tvog projekta.

---

## 1. Uvod (~2-3 stranice)

Kontekst, motivacija, ciljevi, struktura rada. Bez slika/koda — čisti tekst.

**Sadržaj koji predlažem:**
- **Kontekst i svrha**: 2D akcijska arkadna igra tipa *top-down shooter* (pogled odozgo, igrač se kreće i puca u svim smjerovima). Svrha je demonstrirati razvoj kompletne igre u Godot Game Engineu — od arhitekture aktera, preko sustava oružja i neprijateljske inteligencije, do korisničkog sučelja i trajnog spremanja podataka.
- **Korisnici**: igrač koji igra arkadnu igru s ciljem ostvarivanja što većeg rezultata (survival/score-attack format — igra traje dok igrač ne izgubi sav život).
- **Motivacija**: zašto Godot (besplatan, otvorenog koda, dovoljno moćan za 2D, dobra zajednica), zašto GDScript, osobni interes za razvoj igara / arhitekturu softvera za igre.
- **Ciljevi rada** (mapiraj direktno na `tema.txt` opis, parafraziraj):
  1. Upoznati se s Godotovim Node/Scene sustavom i usporediti ga s klasičnim objektno-orijentiranim pristupom.
  2. Implementirati jednostavnu umjetnu inteligenciju protivnika.
  3. Izraditi sustav stanja (FSM) za upravljanje igračem i neprijateljima.
  4. Implementirati trajno spremanje podataka (postavke, rezultati).
  5. Izraditi korisničko sučelje za prikaz bodova i statusa igrača tijekom igre.
- **Struktura rada**: kratko po poglavljima (1 rečenica po poglavlju 2–8).

---

## 2. Terminološki sustav (~5-7 stranica)

Ovo je pregled *teorije/pojmova*, ne opis tvog projekta — ali svaki pojam biraš tako da ga poslije koristiš u analizi/oblikovanju/implementaciji. Mora referencirati literaturu.

**Pojmovi koje bi trebao obraditi (svaki 1 kratki odlomak s referencom):**

1. **Videoigra i žanr "top-down shooter"** — definicija žanra, kratka povijest (npr. *Asteroids* 1979, *Robotron: 2084*, noviji primjeri *Geometry Wars*, *Nuclear Throne*, *Enter the Gungeon*), karakteristike (pogled odozgo, kretanje u svim smjerovima, obično arkadni format s bodovanjem).
2. **Game engine (razvojni pogon igre)** — definicija, svrha (renderiranje, fizika, ulaz, zvuk, scene graph...), pregled poznatih pogona (Unity, Unreal Engine, GameMaker, Godot) — koji su komercijalni/besplatni, licence.
3. **Godot Engine konkretno** — autor (Juan Linietsky, Ariel Manzur), godina nastanka (2014. javno objavljen, razvijan od 2007.), licenca (MIT, potpuno besplatan i open-source), gdje se preuzima (godotengine.org / GitHub), verzija korištena u radu (4.6), podržane platforme za izvoz (Windows, Linux, macOS, web, mobitel).
4. **Node i Scene sustav** — Godotov temeljni koncept: scena kao stablo čvorova (`Node`), nasljeđivanje ponašanja kroz ugrađene tipove čvorova (`CharacterBody2D`, `RigidBody2D`, `Area2D`, `StaticBody2D`), kompozicija scena umjesto klasičnog nasljeđivanja klasa — ovo je super mjesto za **usporedbu s "klasičnim" OOP pristupom** koju tema traži (kompozicija/scene vs. klasična hijerarhija nasljeđivanja).
5. **GDScript** — skriptni jezik Godota, sintaksa slična Pythonu, statičko/dinamičko tipiziranje (`@export`, tipizirane varijable — tvoj kod dosljedno koristi tipizaciju).
6. **Resource sustav** — Godotov koncept podataka kao objekata koji se mogu spremati kao `.tres` datoteke (koristiš ga za `WeaponData`) — objasni čemu služi (data-driven dizajn, odvajanje podataka od logike).
7. **Autoload / Singleton uzorak** — objasni obrazac dizajna *Singleton* općenito i kako ga Godot implementira kroz Autoload (globalno dostupni čvorovi kao `GlobalRef`, `Settings`, `Notifications`).
8. **Strojevi stanja (Finite State Machine, FSM)** — definicija, primjena u igrama za upravljanje ponašanjem entiteta (stanja poput mirovanja, kretanja, napada), prednosti (čitljivost, proširivost) u odnosu na grananje s puno `if/else`.
9. **Umjetna inteligencija u videoigrama (osnovno)** — kratak pregled pristupa (reaktivna AI temeljena na pravilima/tajmerima nasuprot složenijim pristupima poput *behavior tree*-ova ili *utility AI*-a), s naglaskom da je u ovom radu korišten jednostavan, tajmerski/pravilima vođen pristup.
10. **Trajno spremanje podataka (persistence)** — `ConfigFile` u Godotu, `user://` direktorij, zašto se koristi za postavke i rezultate.
11. **Sustav sudara (collision layers/masks) i fizika u 2D-u** — kratko objasni koncept slojeva i maski sudara koje Godot koristi za filtriranje interakcija (koristit ćeš ga u Oblikovanju).

Svaki pojam treba imati barem jednu rečenicu reference na literaturu (npr. službena Godot dokumentacija za pojmove 3–11, opći izvori/članci za 1, 2, 8, 9).

---

## 3. Analiza sustava (mogućnosti sustava, specifikacija zahtjeva)

Ovdje opisuješ **što** igra treba raditi — funkcionalni i nefunkcionalni zahtjevi, formalizirano (UML use-case dijagram, korisničke priče, ili tablica zahtjeva).

**Akteri (actors):** Igrač (Player), Sustav (spawn/AI/persistencija).

**Funkcionalni zahtjevi — predložena tablica/use-case popis, izveden iz stvarnih mehanika:**

| # | Zahtjev | Izvor u kodu |
|---|---|---|
| 1 | Igrač se može kretati u 8/360° smjerova (WASD) uz ubrzanje/usporavanje | `Actor2D.move()`, `player_controller.get_move_dir()` |
| 2 | Igrač cilja mišem (rotacija lika prati kursor) | `player_controller.get_look_dir()` |
| 3 | Igrač puca s dva odvojena oružja (lijevo/desno tipka miša), automatsko i "charge" oružje | `WeaponHandler`, `WeaponData` (`AutoWeapon.tres`, `ChargeWeapon.tres`) |
| 4 | Oružje se može napuniti (charge) za jači, ali sporiji hitac | `weapon-handler/states/{idle,charging,charged}.gd` |
| 5 | Igrač može izvesti trenutni "dash" u smjeru kretanja/gledanja | `actor2d/states/dash.gd`, akcija `dash` |
| 6 | Igrač može aktivirati "boost" (produljeno ubrzano kretanje uz naplatu/oporavak) | `boost_charge.gd`, `boost.gd`, `boost_recovery.gd` |
| 7 | Igrač može zaključati metu (lock-on) na najbliži validni cilj unutar dometa i vidnog polja | `LockOnController._acquire_target()` |
| 8 | Neprijatelji se pojavljuju periodički unutar zadanog područja, do maksimalnog broja živih instanci | `Spawner.gd` |
| 9 | Neprijatelji jednostavno reagiraju: okreću se prema igraču i pucaju u intervalima (`dummy_controller`), odn. biraju nasumične akcije (kretanje/gađanje/izbjegavanje) u intervalima (`ai_controller`) | `actor2d/controller/{dummy_controller,ai_controller}.gd` |
| 10 | Asteroidi i uništivi kontejneri (koji ispuštaju predmete) mogu se uništiti pucanjem i nose bodove | `entities/Asteroid.gd`, `entities/ItemContainer.gd` |
| 11 | Igrač može pokupiti "medkit" koji vraća zdravlje | `entities/medkit_pickup.gd` |
| 12 | Ubijanjem neprijatelja/asteroida/kontejnera igrač dobiva bodove koji se prikazuju uživo | `Actor2D._process()`, `GlobalRef.get_main().update_score()` |
| 13 | Nakon smrti igrača prikazuje se ekran s konačnim rezultatom, animiranim brojanjem i usporedbom s najboljim rezultatom | `ScoreDisplay.gd` |
| 14 | Najbolji rezultat i korisničke postavke trajno se spremaju na disk i učitavaju pri pokretanju | `Settings.gd` (`ConfigFile`, `user://savedata.cfg`) |
| 15 | Igra se može pauzirati preko izbornika za pauzu | `PauseMenu.gd`, akcija `pause` |
| 16 | Korisnik može mijenjati postavke: rezoluciju, fullscreen, kvalitetu pozadine/grafike, uključivanje/isključivanje efekata (post-processing) | `Settings.gd`, `scenes/settings.tscn` |
| 17 | Sustav prikazuje kratkotrajne obavijesti (notifikacije) igraču | `Notifications.gd` |
| 18 | Ulazne naredbe imaju "input buffer" (kratki prozor tolerancije) da pritisak tipke ne bude izgubljen zbog vremena obrade | `core-utils/InputBuffer.gd` |

**Nefunkcionalni zahtjevi:**
- Odziv u stvarnom vremenu (fiksni fizikalni korak, `physics_interpolation` uključen za glatkoću).
- Proširivost sustava oružja i neprijatelja bez izmjene koda (data-driven `WeaponData` resursi, zamjenjivi `ActorController`).
- Odvojenost logike igrača/AI-ja od tijela aktera (isti `Actor2D` opslužuje i igrača i neprijatelje).
- Platforma: Windows desktop (vidljivo iz `export_presets.cfg`).

**Preporučeni dijagram(i):**
- **UML use-case dijagram** s akterom "Igrač" i slučajevima korištenja iz tablice gore (grupiraj u: Kretanje/Kombat, Progresija/Bodovi, Postavke/Meta).
- Eventualno **dijagram aktivnosti** za tijek jedne "runde" igre: Start → Igra (spawn, kombat, bodovanje) → Smrt → Ekran rezultata → Povratak na naslovnicu.

---

## 4. Oblikovanje sustava

Ovdje opisuješ **kako** je sustav građen — arhitektura, formalni zapisi (UML dijagram klasa, dijagrami stanja), koji je softver korišten.

### 4.1 Alati i tehnologije
Godot 4.6 (Forward+ renderer), GDScript, Git za verzioniranje, Jolt Physics (fizikalni engine za 2D/3D naveden u `project.godot`).

### 4.2 Arhitektura aktera — kompozicija umjesto nasljeđivanja
Ovo je najvažniji dio za temu (usporedba Node sustava s OOP-om). Objasni na primjeru `Actor2D`:
- `Actor2D` (`CharacterBody2D`) je **isti** čvor za igrača i neprijatelja — razlika je samo u tome koji su mu podčvorovi/resursi dodijeljeni (`is_player`/`is_enemy` zastavice + kompozicija).
- Umjesto klase `Player extends Enemy` ili obrnuto (klasično nasljeđivanje), ponašanje se **sastavlja** dodavanjem različitih **kontrolera** (Strategy uzorak) i **stanja** (FSM), a ne pisanjem posebne klase za svaki tip aktera.

**Kontroleri (`ActorController`, apstraktna baza) — Strategy uzorak:**

| Kontroler | Namjena |
|---|---|
| `player_controller` | Čita stvarni ulaz igrača (tipkovnica/miš, `InputBuffer`) |
| `ai_controller` | Nasumično bira akciju (gađanje/izbjegavanje) u intervalima, s podesivom vjerojatnošću izbjegavanja i brzinom gađanja |
| `dummy_controller` | Jednostavniji, "skriptirani" neprijatelj — okreće se prema igraču/meti i puca fiksnom brzinom |
| `null_controller` | "No-op" kontroler — siguran default kad akter ne treba ponašanje (npr. statični ciljevi za testiranje) |

Svi implementiraju isto sučelje (`is_shoot`, `get_move_dir`, `get_look_dir`, `is_dash`, `is_boost`, `is_lock_on`...), pa `Actor2D` i njegova stanja rade identično bez obzira upravlja li njima igrač ili AI — ovo je vrijedno objasniti kao primjer polimorfizma bez klasičnog nasljeđivanja ponašanja.

### 4.3 Sustav stanja (FSM)
Generička baza `State`/`StateMachine` (apstraktni `State` s `enter/update/physics_update/exit`, `StateMachine` koji drži `current_state` i obavlja prijelaze uz zaštitu od utrke stanja pomoću `lock` zastavice).

**Ova ista baza se ponovno koristi na dva mjesta** (dobar primjer reusabilnosti — vrijedi istaknuti):

**A) Stanja aktera** (`Actor2D`):
- `Idle` → `Dash` (na input) → natrag u `Idle` nakon isteka trajanja
- `Idle` → `BoostCharge` → `Boost` (dok se drži tipka) → `BoostRecovery` → `Idle`
- `ChargedShotRecoil` (nakon ispaljenog napunjenog hica, privremeno onemogućuje akcije)
- `Dying` (na 0 HP)

**B) Stanja oružja** (`WeaponHandler`, neovisno po instanci oružja):
- `idle` → `charging` (drži se tipka pucanja na oružju koje može "charge") → `charged` → ispaljuje se napunjeni hitac → natrag u `idle`

Predlažem **dva dijagrama stanja** (UML state diagram) — jedan za `Actor2D`, jedan za `WeaponHandler` — nacrtana ručno prema gornjem opisu i imenima direktorija `scripts/actor2d/states/` i `scripts/weapon-handler/states/`.

### 4.4 Sustav oružja i projektila (data-driven dizajn)
`WeaponData` je `Resource` (`AutoWeapon.tres`, `ChargeWeapon.tres`) koji nosi sve parametre oružja (brzina/šteta metka, brzina paljbe, je li automatsko, parametri punjenja) — dizajnersko rješenje koje omogućuje dodavanje novih oružja **bez pisanja koda**, samo kreiranjem novog `.tres` resursa. `Bullet` je jednostavno kretanje + detekcija sudara (`move_and_collide`) koje šteti bilo čemu što ima `take_damage()` (`Actor2D`, `Asteroid`, `ItemContainer`) — ovdje se može spomenuti *duck typing* pristup u GDScriptu.

### 4.5 Sustav slojeva sudara (collision layers)
Tablica iz `project.godot`:

| Sloj | Namjena |
|---|---|
| 1 World | Statična geometrija/granice |
| 2 Player | Tijelo igrača |
| 3 Ally Bullet | Igračevi projektili |
| 4 Enemy | Tijela neprijatelja |
| 5 EnemyBullet | Neprijateljski projektili |
| 6 Entity | Ostali entiteti (pickup-i i sl.) |
| 7 Destructible | Asteroidi/kontejneri |

Objasni kako `WeaponHandler._spawn_bullet()` postavlja sloj/masku ovisno o tome je li pucač igrač ili neprijatelj (metak igrača cilja World/Enemy/Destructible, metak neprijatelja cilja World/Player/Destructible) — sprječava "friendly fire".

### 4.6 Sustav ciljanja (Lock-on)
`LockOnController` — traži najbliži validan cilj unutar `Area2D` dometa; za igrača se traži najbliži cilj **u odnosu na poziciju nišana na ekranu** (a ne prostornu udaljenost), s provjerom je li cilj vidljiv na ekranu; za neprijatelje se koristi prostorna udaljenost.

### 4.7 Globalna infrastruktura (Autoload/Singleton)
Kratko po jedan odlomak za svaki autoload iz `project.godot`:
- `GlobalRef` — servisni lokator (service locator) koji drži globalne reference (igrač, glavna scena, UI...) bez potrebe za `get_node()` putanjama kroz cijelo stablo.
- `Settings` — sprema/učitava postavke i najbolji rezultat preko `ConfigFile` u `user://savedata.cfg`.
- `Notifications` — prikazuje kratkotrajne obavijesti (toast) u donjem desnom kutu.
- `HotkeysManager`, `InputBuffer` — upravljanje ulazom (uklj. sustav "buffered input" — kratki prozor tolerancije da brzi pritisak tipke ne "propadne" između fizikalnih koraka).
- `LogUtility` (preko `Syslog`) — sustav zapisivanja (logging) za razvoj/debug.

### 4.8 Korisničko sučelje
Skice/opis: HUD (prikaz bodova uživo), izbornik za pauzu, izbornik postavki, ekran rezultata na kraju igre (animirano brojanje, usporedba s rekordom), sustav obavijesti.

**Preporučeni dijagrami/skice za ovo poglavlje:**
- Dijagram klasa (pojednostavljen) za `Actor2D`–`ActorController`–`StateMachine`–`State`–`WeaponHandler`.
- 2 dijagrama stanja (Actor FSM, Weapon FSM).
- Tablica slojeva sudara (gore).
- Skica/wireframe ekrana (HUD, pauza, postavke, rezultat) — čak i grubi wireframe je dovoljan.

---

## 5. Implementacija sustava

Ovo je poglavlje sa screenshotovima i isječcima koda — **svaka slika/kod mora imati tekst prije i poslije**.

**Predložena struktura potpoglavlja + što staviti kao screenshot:**

1. **Postavljanje projekta** — struktura direktorija (`scripts/`, `scenes/`, `resources/`, `shaders/`), konfiguracija u `project.godot` (autoloadi, input mape, slojevi, fizika) — screenshot Godot editora s Project Settings / FileSystem panelom.
2. **Implementacija sustava stanja** — isječak `StateMachine.request_state_change()` uz objašnjenje `lock` zastavice (sprječava promjenu stanja usred tranzicije) i logiranja upozorenja.
3. **Implementacija kretanja i rotacije igrača** — isječak `Actor2D.move()`/`turn()`, objasni `move_toward` za akceleraciju i `Util.get_rotation_linear` za glatku rotaciju prema cilju.
4. **Implementacija sustava oružja** — isječak `WeaponHandler.shoot()`/`shoot_charged()` i `_spawn_bullet()` (postavljanje slojeva sudara) — screenshot igre s vizualnim efektom pucanja/punjenja.
5. **Implementacija AI-ja neprijatelja** — isječak `ai_controller._choose_action()` (nasumičan odabir akcije/smjera u intervalu) — objasni razliku prema `dummy_controller` (jednostavnije, deterministički okreni-i-pucaj ponašanje).
6. **Sustav pojavljivanja (spawner)** — isječak `Spawner._try_spawn()` (nasumična pozicija, ograničenje broja živih instanci, tween "rasta" pri pojavljivanju) — screenshot spawn efekta.
7. **Zaključavanje mete (lock-on)** — isječak `_acquire_target()` s objašnjenjem zašto se za igrača koristi udaljenost od nišana na ekranu, a ne svjetska udaljenost.
8. **Sustav bodovanja i trajnog spremanja** — isječci `Settings.save_settings()`/`load_data()`/`save_high_score()` (ConfigFile) i `ScoreDisplay` (animirano brojanje bodova, usporedba s rekordom) — screenshot ekrana rezultata.
9. **Korisničko sučelje** — screenshotovi HUD-a, izbornika za pauzu i postavki, prikaz obavijesti.
10. (Opcionalno) **Izvoz igre** — kratko spomenuti `export_presets.cfg` i ciljnu platformu (Windows).

Napomena: budući da nije web/desktop aplikacija s "instalacijom", "koraci postavljanja" ovdje realno znače *koraci pokretanja/konfiguracije projekta u Godot editoru i izvoz gotove igre*, a ne instalacija na poslužitelju.

---

## 6. Primjena izabranog sustava

Opiši 2-3 konkretna scenarija korištenja igre "iz perspektive igrača", kao pripovijedanje kroz stvarnu igru:

1. **Scenarij: standardna borba** — igrač pokreće igru, kreće se WASD-om, mišem nišani i puca automatskim oružjem prema neprijatelju koji se stvorio putem spawnera; neprijatelj (dummy/AI kontroler) se okreće prema igraču i uzvraća paljbu; igrač uništava neprijatelja i dobiva 1000 bodova prikazanih uživo na HUD-u.
2. **Scenarij: napredna borba uz lock-on, punjenje i evaziju** — igrač zaključa metu (lock-on), koristi "charge" oružje za jači hitac po otpornijem neprijatelju/asteroidu, te koristi dash/boost da izbjegne dolazeću paljbu; usput pokupi medkit da nadoknadi zdravlje.
3. **Scenarij: kraj runde i postavke** — igrač gubi sav život, prelazi se na ekran rezultata s animiranim brojanjem bodova i usporedbom s dosadašnjim rekordom (uz spremanje ako je ostvaren novi rekord); prije/poslije igranja igrač otvara izbornik postavki i mijenja rezoluciju/fullscreen/kvalitetu grafike, što se sprema i primjenjuje odmah.

Za svaki scenarij: 1–2 screenshota "iz igre" + tekst koji opisuje što se događa i koji dijelovi sustava (iz poglavlja 4/5) sudjeluju.

---

## 7. Zaključak (mora početi na str. 30 ili kasnije)

- **Vremenska analiza po fazama** — predlažem podjelu (prilagodi stvarnom trajanju): (1) upoznavanje s Godotom i postavljanje projekta, (2) implementacija osnovnog kretanja i FSM-a za igrača, (3) implementacija sustava oružja i projektila, (4) implementacija AI-ja neprijatelja i spawnera, (5) UI, bodovanje i trajno spremanje, (6) vizualni efekti i poliranje.
- **Problemi i rješenja** — konkretni primjeri koje već imaš u projektu:
  - Sprječavanje "utrke stanja" (race condition) kod izmjene stanja usred tranzicije → riješeno `lock` zastavicom u `StateMachine`.
  - Potreba da isto ponašanje (kretanje, pucanje, FSM) radi identično za igrača i neprijatelja → riješeno odvajanjem inputa u zamjenjive `ActorController` implementacije (Strategy uzorak) umjesto duplicirane logike/nasljeđivanja.
  - Gubitak brzih pritisaka tipki zbog obrade po fizikalnom koraku → riješeno uvođenjem `InputBuffer` sustava.
  - Refleksija o opsegu projekta: tijekom razvoja je nastala i dodatna infrastruktura (npr. opsežniji debug/log sustav) veća nego što je za sam opseg igre bilo potrebno — vrijedno je kritički prokomentirati tu lekciju o upravljanju opsegom (scope) kod solo projekta.
- **Prijedlozi daljnjih poboljšanja** (izravno iz `docs/TODO.md`, parafrazirano):
  - Dodavanje stvarnog kretanja neprijatelja (trenutno se samo okreću i gađaju).
  - Generalizirani spawner za sve tipove entiteta (neprijatelji, asteroidi, ozdravljenja) umjesto zasebnih instanci.
  - Ekran usporedbe rezultata odmah nakon smrti igrača (highscore comparison).
  - Napredniji AI (lista mogućih akcija po stanju, biranih nasumično/težinski) umjesto trenutnog jednostavnog tajmerskog pristupa.
  - Zasebni "hitbox" čvorovi umjesto oslanjanja na sudar tijela za štetu.
  - Dodatna stanja (npr. "stagger"/omamljenost) i dodatni tipovi oružja/metaka.
- **Kritički osvrt**: pošto je korišten samo jedan sustav (Godot), umjesto usporedbe "uspostavljenih sustava" možeš kritički usporediti *pristup razvoju* (npr. kompozicija/Node sustav naspram klasičnog nasljeđivanja) na temelju stvarnog iskustva iz ovog projekta — to zadovoljava duh te stavke iz predloška i kad nema doslovno više instalacija istog sustava.

---

## 8. Literatura (min. 10 izvora)

Prijedlog kategorija izvora koje ćeš trebati (traži konkretne članke/dokumentaciju kad budeš pisao):

1. Službena Godot Engine dokumentacija (docs.godotengine.org) — za Node/Scene sustav, GDScript, Resource, Autoload, Area2D/CharacterBody2D/RigidBody2D, ConfigFile, collision layers.
2. Godot Engine — službena stranica/GitHub (povijest, licenca, autori).
3. Barem jedan izvor o konceptu *game engine* općenito i usporedbi popularnih pogona (Unity, Unreal, GameMaker, Godot).
4. Barem jedan izvor o žanru *top-down shooter* / arkadnim igrama (definicija, povijest, primjeri).
5. Izvor o **Finite State Machine** uzorku u razvoju igara (opći članak/knjiga o game programming patterns — npr. tematika poznata iz "Game Programming Patterns" literature).
6. Izvor o **Singleton/Service Locator** uzorku dizajna.
7. Izvor o **Strategy uzorku** dizajna (za `ActorController` hijerarhiju).
8. Izvor o pristupima umjetnoj inteligenciji u igrama (osnove: reaktivna AI, behavior trees, usporedba).
9. Godotova dokumentacija o fizici i 2D sudarima (layers/masks).
10. `godotshaders.com` — izvor za shader pozadine (`https://godotshaders.com/shader/space-background-parallax/`, već naveden u `docs/credits.md`) — obavezno citirati jer je preuzet tuđi rad.
11. (Opcionalno) izvori vezani uz bilo koje dodatne assete/fontove/zvukove koje si preuzeo, ako postoje — provjeri `assets/` mapu za licence.

> Napomena: sve izvore na koje se referenciraš u poglavlju 2 (Terminološki sustav) i 4 (Oblikovanje) moraš ovdje navesti; izvore koje ne citiraš u tekstu ne stavljaj u popis.

---

## Sažetak mapiranja (brzi pregled)

| Poglavlje rada | Ključni dijelovi projekta |
|---|---|
| 1. Uvod | `tema.txt` (cilj/opis) |
| 2. Terminološki sustav | Opći pojmovi (Godot, FSM, AI, Singleton, Resource) — teorija, ne kod |
| 3. Analiza sustava | Sve mehanike igre kao zahtjevi (tablica gore) |
| 4. Oblikovanje sustava | `Actor2D`, `ActorController` (Strategy), `StateMachine`/`State` (FSM), `WeaponHandler`/`WeaponData`, collision layers, `LockOnController`, autoloadi |
| 5. Implementacija | Isječci koda + screenshotovi po podsustavu |
| 6. Primjena | 2–3 igrana scenarija |
| 7. Zaključak | Faze rada, problemi/rješenja iz iskustva, TODO.md kao "buduća poboljšanja" |
| 8. Literatura | Godot docs, opći članci o uzorcima/AI/žanru, credits.md |
