// =============================================================================
// dimensions.scad — Toutes les variables dimensionnelles du boîtier MSSIAH
// =============================================================================
// Origine du repère de la face inclinée : coin bas-gauche (avant-gauche).
// X = largeur (gauche → droite), Y = longueur le long de la pente (avant → arrière).

// -----------------------------------------------------------------------------
// Boîtier — dimensions globales
// -----------------------------------------------------------------------------
LARGEUR          = 120;    // largeur (gauche → droite)
PROFONDEUR       = 160;    // profondeur (avant → arrière, projetée au sol)
HAUTEUR_BAC      = 25;     // hauteur du bac (rectangle droit, ouvert en haut)
ANGLE_PENTE      = 20;     // angle d'inclinaison de la face (degrés)
EPAISSEUR_PAROI  = 2.5;    // épaisseur des parois
EPAISSEUR_BASE   = 2.5;    // épaisseur de la base du bac

// Couvercle : rebord vertical minimal pour la rainure
COUVERCLE_REBORD = 3;      // hauteur du rebord vertical avant (pour la rainure)

// Hauteur du couvercle (face inclinée au-dessus du bac)
COUVERCLE_H_AVANT = COUVERCLE_REBORD;                          // 3 mm
COUVERCLE_H_ARRIERE = COUVERCLE_REBORD + PROFONDEUR * tan(ANGLE_PENTE); // ≈ 61 mm

// Hauteur arrière totale du boîtier (bac + couvercle)
HAUTEUR_ARRIERE_TOTALE = HAUTEUR_BAC + COUVERCLE_H_ARRIERE;   // ≈ 86 mm

// Longueur de la face inclinée (le long de la pente)
LONGUEUR_PENTE   = PROFONDEUR / cos(ANGLE_PENTE);  // ≈ 170 mm

// -----------------------------------------------------------------------------
// Jonction bac / couvercle (lèvre mâle + rainure)
// -----------------------------------------------------------------------------
LEVRE_EPAISSEUR  = 2.0;   // épaisseur de la lèvre mâle (sur le bac)
LEVRE_HAUTEUR    = 3.0;   // hauteur de la lèvre mâle
RAINURE_LARGEUR  = 2.2;   // largeur de la rainure (dans le couvercle) — jeu 0.2
RAINURE_PROFONDEUR = 3.2; // profondeur de la rainure — jeu 0.2
RAINURE_CHANFREIN = 0.5;  // chanfrein d'entrée de rainure (mm × 45°)

// -----------------------------------------------------------------------------
// Inserts à chaud — dimensions par taille
// -----------------------------------------------------------------------------
// Format : [diam_ext, longueur, diam_perçage, prof_perçage]
function insert_dims(m) =
    m == 2.5 ? [3.5, 4,  3.0, 5] :
    m == 3   ? [5.0, 4,  4.0, 5] :
    m == 4   ? [6.0, 4,  5.0, 5] :
    m == 5   ? [7.0, 4,  5.5, 5] :
    [0,0,0,0];  // fallback

INSERT_JOYSTICK_M   = 2.5;
INSERT_DB9_M        = 3;
INSERT_ASSEMBLAGE_M = 3;

// -----------------------------------------------------------------------------
// Boss de fixation (assemblage bac/couvercle)
// -----------------------------------------------------------------------------
BOSS_DIAMETRE    = 10;    // diamètre du pilier
BOSS_MARGE_BORD  = 10;    // distance du bord

// -----------------------------------------------------------------------------
// Patins de pied
// -----------------------------------------------------------------------------
PATIN_DIAMETRE   = 11;    // diamètre des patins adhésifs
PATIN_PROFONDEUR = 2;     // profondeur du détourage (optionnel)

// -----------------------------------------------------------------------------
// Nervures de rigidification (base du bac)
// -----------------------------------------------------------------------------
NERVURE_LARGEUR  = 2;     // largeur des nervures
NERVURE_HAUTEUR  = 3;     // hauteur des nervures

// -----------------------------------------------------------------------------
// Potentiomètres (×4)
// -----------------------------------------------------------------------------
POT_AXE_DIAMETRE       = 9.7;   // diamètre de l'axe fileté
POT_TROU_DIAMETRE      = 10;     // trou de passage dans la face
POT_ECROU_AF           = 13.85;  // écrou hex across-flats
POT_ECROU_PROFONDEUR   = 4;      // profondeur du logement hexagonal
POT_LOGEMENT_HEX_AF    = 14;     // logement hex (jeu inclus)
POT_RONDELLE_DECO_DIAM = 41;     // rondelle décorative extérieure
POT_RONDELLE_INT_DIAM  = 15;     // rondelle intérieure
POT_KNOB_DIAMETRE      = 26.5;   // bouton (knob)
POT_CORPS_DIAMETRE     = 28;     // corps du potentiomètre
POT_CORPS_HAUTEUR      = 12.6;   // hauteur du corps sous la face
POT_RENFORT_DIAMETRE   = 22;     // diamètre du renfort local
POT_RENFORT_EPAISSEUR  = 4;      // épaisseur du renfort local

// Positions des potentiomètres (repère face inclinée)
POT_POSITIONS = [
    [38.5, 85],   // P1 — rangée médiane, gauche
    [81.5, 85],   // P2 — rangée médiane, droite
    [38.5, 40],   // P3 — rangée avant, gauche
    [81.5, 40],   // P4 — rangée avant, droite
];

// -----------------------------------------------------------------------------
// Joystick (×1)
// -----------------------------------------------------------------------------
JOY_TROU_DIAMETRE     = 32;     // trou de passage (cap + base + jeu)
JOY_CAP_DIAMETRE      = 15;     // diamètre du cap
JOY_PCB_TAILLE        = 34;     // taille du PCB (carré)
JOY_PCB_ENTRAXE       = 35;     // entraxe des trous de fixation
JOY_PCB_TROU_DIAMETRE = 2.5;    // diamètre des trous sur le PCB
JOY_RENFORT_TAILLE    = 45;     // taille du renfort local (carré)
JOY_RENFORT_EPAISSEUR = 6;      // épaisseur du renfort local
JOY_POSITION          = [30, 130]; // position du joystick (repère face inclinée)

// -----------------------------------------------------------------------------
// Bouton arcade Sanwa OBSF-30 (×1)
// -----------------------------------------------------------------------------
BTN_TROU_DIAMETRE     = 30;     // trou de passage (snap-in)
BTN_COLLET_DIAMETRE   = 33;     // diamètre du collet
BTN_PROFONDEUR        = 40;     // profondeur sous la face
BTN_POSITION          = [90, 130]; // position (repère face inclinée)

// -----------------------------------------------------------------------------
// DB9 (×1)
// -----------------------------------------------------------------------------
DB9_DECOUPE_LARGEUR   = 24;     // découpe rectangulaire (largeur, X)
DB9_DECOUPE_HAUTEUR   = 12;     // découpe rectangulaire (hauteur, Z)
DB9_ENTRAXE_INSERTS   = 30;     // entraxe des inserts M3 (en X, hors découpe)
DB9_POSITION_X        = 60;     // position X sur la face arrière (centré)
DB9_POSITION_Z        = 12.5;   // position Z depuis le bas du bac (centré en 25 mm) — obsolète, DB9 déplacé
DB9_POSITION_Z_COUVERCLE = 30;  // position Z depuis le bas du couvercle (centré en ~61 mm)
DB9_RENFORT_LARGEUR   = 45;     // largeur du renfort local
DB9_RENFORT_HAUTEUR   = 25;     // hauteur du renfort local
DB9_RENFORT_EPAISSEUR = 6;      // épaisseur du renfort local

// -----------------------------------------------------------------------------
// Passe-câbles (×3)
// -----------------------------------------------------------------------------
PASSE_CABLE_HAUTEUR   = 5;      // hauteur de l'arche
PASSE_CABLE_LARGEUR   = 8;      // largeur de l'arche
PASSE_CABLE_EPAISSEUR = 1.5;    // épaisseur des parois de l'arche

// Positions des passes-câbles (Y le long de la pente)
PASSE_CABLE_POSITIONS_Y = [110, 65, 20]; // entre les rangées, vers l'arrière

// -----------------------------------------------------------------------------
// Résolution d'impression
// -----------------------------------------------------------------------------
$fn = 64;  // résolution des cylindres