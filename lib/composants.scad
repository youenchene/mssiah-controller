// =============================================================================
// composants.scad — Modules de découpe pour chaque composant
// =============================================================================
// Ces modules sont conçus pour être soustraits (difference) de la face inclinée
// ou de la face arrière. Ils incluent les trous de passage, logements d'écrou,
// renforts locaux et trous d'insert.

include <dimensions.scad>
use <inserts.scad>

// -----------------------------------------------------------------------------
// Potentiomètre — découpe complète (trou + logement hex + renfort)
// À soustraire du renfort local (qui est ajouté séparément).
// -----------------------------------------------------------------------------
module pot_decoupe() {
    // Trou de passage pour l'axe
    cylinder(d = POT_TROU_DIAMETRE, h = 100, center = true);

    // Logement hexagonal pour l'écrou (côté intérieur)
    // L'écrou est noyé dans le renfort, côté intérieur de la face
    translate([0, 0, -POT_ECROU_PROFONDEUR - 0.1])
        cylinder(d = POT_LOGEMENT_HEX_AF * 2 / sqrt(3), h = POT_ECROU_PROFONDEUR + 0.1,
                 center = false, $fn = 6);
}

// -----------------------------------------------------------------------------
// Potentiomètre — renfort local (à ajouter sur la face inclinée)
// pos : position [x, y] dans le repère de la face inclinée
// -----------------------------------------------------------------------------
module pot_renfort(pos) {
    translate(pos)
        cylinder(d = POT_RENFORT_DIAMETRE, h = POT_RENFORT_EPAISSEUR - EPAISSEUR_PAROI,
                 center = false);
}

// -----------------------------------------------------------------------------
// Joystick — découpe complète (trou + trous d'insert)
// À soustraire du renfort local.
// -----------------------------------------------------------------------------
module joy_decoupe() {
    // Trou de passage pour le cap + base
    cylinder(d = JOY_TROU_DIAMETRE, h = 100, center = true);

    // 4 trous d'insert M2.5 (entraxe 35 mm)
    entraxe = JOY_PCB_ENTRAXE;
    for (dx = [-entraxe/2, entraxe/2], dy = [-entraxe/2, entraxe/2]) {
        translate([dx, dy, 0])
            trou_insert(INSERT_JOYSTICK_M);
    }
}

// -----------------------------------------------------------------------------
// Joystick — renfort local (carré, à ajouter sur la face inclinée)
// pos : position [x, y] dans le repère de la face inclinée
// -----------------------------------------------------------------------------
module joy_renfort(pos) {
    translate(pos)
        translate([-JOY_RENFORT_TAILLE/2, -JOY_RENFORT_TAILLE/2, 0])
            cube([JOY_RENFORT_TAILLE, JOY_RENFORT_TAILLE,
                  JOY_RENFORT_EPAISSEUR - EPAISSEUR_PAROI]);
}

// -----------------------------------------------------------------------------
// Bouton arcade — découpe (trou snap-in)
// À soustraire de la face inclinée (pas de renfort).
// -----------------------------------------------------------------------------
module btn_decoupe() {
    cylinder(d = BTN_TROU_DIAMETRE, h = 100, center = true);
}

// -----------------------------------------------------------------------------
// DB9 — découpe rectangulaire + trous d'insert
// À soustraire de la face arrière (avec renfort).
// -----------------------------------------------------------------------------
module db9_decoupe() {
    // Découpe rectangulaire pour le connecteur
    translate([-DB9_DECOUPE_LARGEUR/2, -DB9_DECOUPE_HAUTEUR/2, 0])
        cube([DB9_DECOUPE_LARGEUR, DB9_DECOUPE_HAUTEUR, 100], center = true);

    // 2 trous d'insert M3 (entraxe horizontal)
    for (dx = [-DB9_ENTRAXE_INSERTS/2, DB9_ENTRAXE_INSERTS/2]) {
        translate([dx, 0, 0])
            trou_insert(INSERT_DB9_M);
    }
}

// -----------------------------------------------------------------------------
// DB9 — renfort local (face arrière)
// -----------------------------------------------------------------------------
module db9_renfort() {
    translate([-DB9_RENFORT_LARGEUR/2, -DB9_RENFORT_HAUTEUR/2, 0])
        cube([DB9_RENFORT_LARGEUR, DB9_RENFORT_HAUTEUR,
              DB9_RENFORT_EPAISSEUR - EPAISSEUR_PAROI]);
}

// -----------------------------------------------------------------------------
// Toutes les découpes de la face inclinée (pots + joystick + bouton)
// À appeler dans un difference() sur la face inclinée.
// -----------------------------------------------------------------------------
module face_inclinee_decoupes() {
    // Potentiomètres
    for (pos = POT_POSITIONS) {
        translate([pos[0], pos[1], 0])
            pot_decoupe();
    }

    // Joystick
    translate([JOY_POSITION[0], JOY_POSITION[1], 0])
        joy_decoupe();

    // Bouton arcade
    translate([BTN_POSITION[0], BTN_POSITION[1], 0])
        btn_decoupe();
}

// -----------------------------------------------------------------------------
// Tous les renforts de la face inclinée (à ajouter avant les découpes)
// -----------------------------------------------------------------------------
module face_inclinee_renforts() {
    // Renforts potentiomètres
    for (pos = POT_POSITIONS) {
        pot_renfort(pos);
    }

    // Renfort joystick
    joy_renfort(JOY_POSITION);
}