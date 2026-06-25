# Plan — Boîtier MSSIAH Controller (OpenSCAD)

## Objectif

Reproduire le boîtier du contrôleur MSSIAH (https://c64customs.blogspot.com/2021/08/custom-diy-mssiah-controller.html) pour piloter le C64 via le port CB8 (https://mssiah.com/mssiah.php). Le boîtier est imprimé en 3D, conçu en OpenSCAD, et se monte autour de l'électronique déjà assemblée.

## Décisions de conception

### Boîtier

| Paramètre | Valeur |
|---|---|
| Architecture | 2 moitiés : bac (bas) + couvercle (haut) |
| Split | Horizontal, plan de jonction au niveau du rebord |
| Dimensions extérieures | 120 × 160 mm (largeur × profondeur) |
| Hauteur avant (bas de pente) | 25 mm |
| Hauteur arrière (haut de pente) | 83 mm (25 + 160·tan 20°) |
| Angle d'inclinaison | 20°, arrière haut, avant bas |
| Épaisseur parois | 2.5 mm |
| Épaisseur base du bac | 2.5 mm |
| Aération | Aucune (électronique passive) |

### Assemblage des deux moitiés

| Paramètre | Valeur |
|---|---|
| Mécanisme | Lèvre mâle sur le bac + rainure femelle dans le couvercle |
| Lèvre mâle (bac) | 2 mm d'épaisseur, 3 mm de haut |
| Rainure (couvercle) | 2.2 mm de large, 3.2 mm de profondeur |
| Jeu radial | 0.2 mm |
| Jeu axial | 0.2 mm |
| Chanfrein d'entrée de rainure | 0.5 mm × 45° |
| Fixation | 4 inserts M3 (Ø 5 ext, long. 4 mm) dans les boss du bac |
| Vis d'assemblage | M3 × 10 mm (×4) |
| Perçage traversant dans le rebord du couvercle | Ø 3.2 mm |

### Disposition des contrôles (face inclinée)

Repère : origine au coin bas-gauche (avant-gauche vu de l'opérateur). X = largeur (0–120), Y = longueur le long de la pente (0–~170).

| Contrôle | X (mm) | Y (mm) | Rangée |
|---|---|---|---|
| Joystick | 30 | 130 | 1 (arrière) |
| Bouton arcade | 90 | 130 | 1 (arrière) |
| Potentiomètre P1 | 38.5 | 85 | 2 (médiane) |
| Potentiomètre P2 | 81.5 | 85 | 2 (médiane) |
| Potentiomètre P3 | 38.5 | 40 | 3 (avant) |
| Potentiomètre P4 | 81.5 | 40 | 3 (avant) |

```
        0     30      38.5   81.5    90      120
        │     │        │      │       │       │
  170 ──┼─────────────────────────────────────┼── arrière
        │     │        │      │       │       │
        │  [JOY]      │      │    [BTN]      │  rangée 1
        │     │        │      │       │       │
  85  ──┼─────┤       [P1]  [P2]     ├───────┼── rangée 2
        │     │        │      │       │       │
  40  ──┼─────┤       [P3]  [P4]     ├───────┼── rangée 3
        │     │        │      │       │       │
   0  ──┼─────────────────────────────────────┼── avant
```

### Montage des composants

#### Potentiomètres (×4)

| Paramètre | Valeur |
|---|---|
| Trou de passage (axe Ø 9.7) | Ø 10 mm |
| Renfort local | Ø 22 mm, épaisseur 4 mm |
| Logement hexagonal (écrou noyé) | 14 mm across-flats, profondeur 4 mm |
| Écrou | M6 fourni (13.85 mm across-flats) |
| Rondelle décorative extérieure | Ø 41 mm |
| Rondelle intérieure | Ø 10 int / 15 ext |
| Bouton (knob) | Ø 26.5 mm, à visser |
| Corps | Ø 28 mm, hauteur 12.6 mm sous la face |
| Fixation | Écrou hex noyé (anti-rotation) + rondelle + écrou extérieur |

#### Joystick (×1)

| Paramètre | Valeur |
|---|---|
| Trou de passage (cap + base) | Ø 32 mm |
| Renfort local | 45 × 45 mm, épaisseur 6 mm |
| Entraxe inserts | 35 × 35 mm |
| Inserts | M2.5, laiton, Ø 3.5 ext, long. 4 mm (à acheter) |
| Perçage plastique | Ø 3.0 mm, profondeur 5 mm |
| Vis | M2.5 × 8 mm (×4) |
| Cap | Ø 15 mm |
| PCB | 34 × 34 mm, 4 trous Ø 2.5 mm |

#### Bouton arcade Sanwa OBSF-30 (×1)

| Paramètre | Valeur |
|---|---|
| Trou de passage | Ø 30 mm |
| Épaisseur face (pas de renfort) | 2.5 mm |
| Fixation | Snap-in (sans vis, collet à ressort) |
| Collet | Ø 33 mm |
| Profondeur sous la face | ~40 mm |
| Hauteur disponible à Y=130 | ~64 mm → OK |

#### DB9 (×1)

| Paramètre | Valeur |
|---|---|
| Face | Arrière (verticale) |
| Position | X=60 mm (centré), Y=20 mm depuis le bas |
| Découpe | 32 × 15 mm (rectangle) |
| Inserts | M3, laiton, Ø 5 ext, long. 4 mm (×2) |
| Entraxe inserts | ~25 mm |
| Perçage plastique | Ø 4.0 mm, profondeur 5 mm |
| Vis | M3 × 8 mm (×2) |
| Renfort local face arrière | 45 × 20 mm, épaisseur 6 mm |

### Structure du bac (moitié du bas)

| Paramètre | Valeur |
|---|---|
| Base | 120 × 160 mm, épaisseur 2.5 mm |
| Parois | 4 parois verticales, épaisseur 2.5 mm |
| Boss de fixation | 4 piliers Ø 10 mm aux coins, inserts M3 |
| Position des boss | ~10 mm des bords |
| Patins de pied | 4 × Ø 11 mm (adhésifs, sous la base) |
| Nervures de rigidification | 2 diagonales sur la base |
| Structure interne | Vide (les composants sont portés par le couvercle) |

### Structure du couvercle (moitié du haut)

| Paramètre | Valeur |
|---|---|
| Face inclinée | Plan à 20°, 120 × ~170 mm |
| Parois | 4 parois verticales (avant 25 mm, arrière 83 mm, 2 latérales trapézoïdales) |
| Renforts locaux | Aux emplacements des composants (voir ci-dessus) |
| Passe-câbles | 3 arches imprimées sur la face intérieure |
| Rainure périphérique | 2.2 × 3.2 mm, chanfrein 0.5 × 45° |

### Passe-câbles (×3)

Positionnés sur la face intérieure du couvercle pour guider les câbles vers le DB9 (arrière) :
- Passe-câble 1 : entre rangée 1 et DB9 (guide câbles joystick + bouton)
- Passe-câble 2 : entre rangée 2 et rangée 1 (guide câbles P1/P2)
- Passe-câble 3 : entre rangée 3 et rangée 2 (guide câbles P3/P4)

Arches de ~5 mm de haut, câbles passent dessous.

## Inventaire des fixations

| Usage | Insert | Vis | Quantité |
|---|---|---|---|
| Joystick | M2.5, Ø 3.5 ext, long. 4 mm | M2.5 × 8 mm | 4 |
| DB9 | M3, Ø 5 ext, long. 4 mm | M3 × 8 mm | 2 |
| Assemblage bac/couvercle | M3, Ø 5 ext, long. 4 mm | M3 × 10 mm | 4 |
| Potentiomètres | Aucun (écrou M6 fourni) | Écrou M6 fourni | 4 |
| Bouton arcade | Aucun (snap-in) | — | — |
| Patins de pied | Aucun | Adhésif | 4 |

**Total inserts à acheter** : 4 × M2.5 (Ø 4 ext, long. 4 mm)
**Total vis** : 4 × M2.5×8, 2 × M3×8, 4 × M3×10

## Structure du projet OpenSCAD

```
mssiah-controller/
├── CONTEXT.md              # Glossaire (terminologie du projet)
├── PLAN.md                 # Ce fichier
├── main.scad               # Assemblage complet (vue 3D)
├── bac.scad                # Moitié du bas (bac)
├── couvercle.scad          # Moitié du haut (couvercle + face inclinée)
├── lib/
│   ├── dimensions.scad    # Toutes les variables dimensionnelles
│   ├── inserts.scad        # Modules d'inserts à chaud (modèles)
│   ├── composants.scad    # Modules de perçages/trous pour chaque composant
│   └── passe_cables.scad   # Modules de passes-câbles
└── stl/                    # Fichiers STL exportés (générés)
    ├── bac.stl
    └── couvercle.stl
```

## Ordre de réalisation

1. **`lib/dimensions.scad`** : Toutes les variables (dimensions, positions, angles)
2. **`lib/inserts.scad`** : Modules paramétriques d'inserts (trou de perçage + logement)
3. **`lib/composants.scad`** : Modules de découpe pour chaque composant (pot, joystick, bouton, DB9)
4. **`lib/passe_cables.scad`** : Module d'arche de passe-câbles
5. **`couvercle.scad`** : Assemblage de la face inclinée + parois + renforts + découpes + passe-câbles + rainure
6. **`bac.scad`** : Assemblage de la base + parois + boss + nervures + lèvre + patins
7. **`main.scad`** : Assemblage des deux moitiés (vue 3D exploded + fermé)
8. **Export STL** : `bac.stl` et `couvercle.stl`

## Vues de référence

### Vue de profil (depuis la droite)

```
        arrière                    avant
       83mm                       25mm

   83mm ┌─╲
        │   ╲
        │     ╲
        │       ╲
        │         ╲
        │           ╲
        │             ╲
        │               ╲
        │                 ╲
        │                   ╲
        │                     ╲
        │                       ╲
        │                         ╲
        │                           ╲
   25mm │                             └──┐
        └──────────────────────────────────┘
        ←──────────── 160 mm ──────────────→
```

### Vue du plan incliné (disposition des contrôles)

```
        ←──────── 120 mm ────────→
   ┌──────────────────────────────────┐
   │                                  │  ← arrière (haut de pente)
   │   [JOY]                  [BTN]   │   rangée 1
   │                                  │
   │          [P1]      [P2]         │   rangée 2
   │                                  │
   │          [P3]      [P4]          │   rangée 3
   │                                  │  ← avant (bas de pente)
   └──────────────────────────────────┘
   ←────────── ~170 mm ──────────────→
```

### Vue arrière (DB9)

```
        ←──────── 120 mm ────────→
   83mm ┌──────────────────────────┐
        │                          │
        │                          │
        │                          │
        │      ┌────────┐          │
   20mm │      │  DB9   │          │
        │      └────────┘          │
        │  ◯               ◯       │  ← inserts M3
        └──────────────────────────┘
```