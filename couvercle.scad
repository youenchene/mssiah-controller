// =============================================================================
// couvercle.scad — Moitié du haut (coin trapézoïdal avec face inclinée)
// =============================================================================
// FIX :
// 1. Bosses reliées au plan incliné par renforts verticaux
// 2. Plan incliné coupé droit à l'avant (y=0)
// 3. Mur latéral : point intérieur corrigé (h_ar au lieu de h_ar - t)

include <lib/dimensions.scad>
use <lib/composants.scad>

t = EPAISSEUR_PAROI;
h_av = COUVERCLE_H_AVANT;   // 3 mm
h_ar = COUVERCLE_H_ARRIERE; // ~61 mm

// Hauteur du plan incliné à une position Y donnée (world frame)
function z_incline(y) = h_av + y * tan(ANGLE_PENTE);

// -----------------------------------------------------------------------------
// Face inclinée PLATE (dans le plan XY, avant rotation)
// z = 0 → face intérieure, z = t → face extérieure
// -----------------------------------------------------------------------------
module face_inclinee_plate() {
    difference() {
        union() {
            cube([LARGEUR, LONGUEUR_PENTE, t]);

            // Renfort joystick (côté intérieur)
            translate([JOY_POSITION[0], JOY_POSITION[1], -(JOY_RENFORT_EPAISSEUR - t)])
                translate([-JOY_RENFORT_TAILLE/2, -JOY_RENFORT_TAILLE/2, 0])
                    cube([JOY_RENFORT_TAILLE, JOY_RENFORT_TAILLE,
                          JOY_RENFORT_EPAISSEUR - t]);
        }

        // Pots — trous traversants (face plate)
        for (pos = POT_POSITIONS) {
            translate([pos[0], pos[1], -10])
                cylinder(d = POT_TROU_DIAMETRE, h = 100);
        }

        // Joystick — trou traversant
        translate([JOY_POSITION[0], JOY_POSITION[1], -10])
            cylinder(d = JOY_TROU_DIAMETRE, h = 100);
        // 4 trous d'insert M2.5 (côté intérieur)
        for (dx = [-JOY_PCB_ENTRAXE/2, JOY_PCB_ENTRAXE/2],
             dy = [-JOY_PCB_ENTRAXE/2, JOY_PCB_ENTRAXE/2]) {
            translate([JOY_POSITION[0] + dx, JOY_POSITION[1] + dy,
                       -(JOY_RENFORT_EPAISSEUR - t) - 0.1])
                cylinder(d = insert_dims(INSERT_JOYSTICK_M)[2],
                         h = insert_dims(INSERT_JOYSTICK_M)[3] + 0.1);
        }

        // Bouton arcade — trou traversant
        translate([BTN_POSITION[0], BTN_POSITION[1], -10])
            cylinder(d = BTN_TROU_DIAMETRE, h = 100);
    }
}

// -----------------------------------------------------------------------------
// FIX 2 : Plan incliné positionné + coupé à y=0 (avant)
// -----------------------------------------------------------------------------
module couvercle_face_inclinee() {
    intersection() {
        // Plan incliné roté
        translate([0, 0, h_av])
            rotate([ANGLE_PENTE, 0, 0])
                face_inclinee_plate();
        // Clip à y >= 0 (coupe le dépassement avant)
        translate([-10, 0, -10])
            cube([LARGEUR + 20, PROFONDEUR + 20, h_ar + 20]);
    }
}

// -----------------------------------------------------------------------------
// Passe-câbles (côté intérieur)
// -----------------------------------------------------------------------------
module passe_cable_plate() {
    difference() {
        translate([-PASSE_CABLE_LARGEUR/2, -PASSE_CABLE_LARGEUR/2,
                   -PASSE_CABLE_HAUTEUR])
            cube([PASSE_CABLE_LARGEUR, PASSE_CABLE_LARGEUR,
                  PASSE_CABLE_HAUTEUR]);
        translate([-PASSE_CABLE_LARGEUR/2 + PASSE_CABLE_EPAISSEUR,
                   -PASSE_CABLE_LARGEUR/2 - 0.1,
                   -PASSE_CABLE_HAUTEUR])
            cube([PASSE_CABLE_LARGEUR - 2*PASSE_CABLE_EPAISSEUR,
                  PASSE_CABLE_LARGEUR + 0.2,
                  PASSE_CABLE_HAUTEUR - PASSE_CABLE_EPAISSEUR]);
    }
}

module couvercle_passe_cables() {
    for (y = PASSE_CABLE_POSITIONS_Y) {
        translate([0, 0, h_av])
            rotate([ANGLE_PENTE, 0, 0])
                translate([LARGEUR/2, y, 0])
                    passe_cable_plate();
    }
}

// -----------------------------------------------------------------------------
// FIX 1 : Boss avec renfort vertical jusqu'au plan incliné
// -----------------------------------------------------------------------------
module couvercle_boss() {
    m = BOSS_MARGE_BORD;
    hauteur_boss = HAUTEUR_BAC - EPAISSEUR_BASE;  // 22.5 mm
    insert_d = insert_dims(INSERT_ASSEMBLAGE_M)[2];
    insert_h = insert_dims(INSERT_ASSEMBLAGE_M)[3];

    positions = [
        [m, m], [LARGEUR - m, m],
        [m, PROFONDEUR - m], [LARGEUR - m, PROFONDEUR - m],
    ];

    for (pos = positions) {
        // Hauteur du plan incliné à cette position Y
        z_top = z_incline(pos[1]);

        // Position joystick en world-Y (corrigée de la rotation)
        jy = JOY_POSITION[1] * cos(ANGLE_PENTE);

        difference() {
            union() {
                // Pilier qui descend dans le bac (z=0 → z=-hauteur_boss)
                translate([pos[0], pos[1], -hauteur_boss])
                    cylinder(d = BOSS_DIAMETRE, h = hauteur_boss + t);

                // Cône de renfort (base large en haut, arrêté avant la face)
                translate([pos[0], pos[1], 0])
                    cylinder(d1 = BOSS_DIAMETRE, d2 = BOSS_DIAMETRE + 4, h = z_top - t);
            }
            // Trou d'insert au BAS du boss (côté bac)
            translate([pos[0], pos[1], -hauteur_boss - 0.1])
                cylinder(d = insert_d, h = insert_h + 0.1);
            // Dégager la zone de fixation du joystick
            translate([JOY_POSITION[0] - JOY_RENFORT_TAILLE/2 - 5,
                       jy - JOY_RENFORT_TAILLE/2 - 5,
                       -1])
                cube([JOY_RENFORT_TAILLE + 10, JOY_RENFORT_TAILLE + 10, h_ar + 2]);
        }
    }
}

// -----------------------------------------------------------------------------
// Plaque de base (rim) + plots de connexion aux boss
// -----------------------------------------------------------------------------
module couvercle_rim() {
    difference() {
        cube([LARGEUR, PROFONDEUR, t]);
        translate([t, t, -0.1])
            cube([LARGEUR - 2*t, PROFONDEUR - 2*t, t + 0.2]);
    }
}

// -----------------------------------------------------------------------------
// Paroi avant (verticale, h_av = 3 mm)
// FIX 2 : hauteur = h_av pour couper droit
// -----------------------------------------------------------------------------
module couvercle_paroi_avant() {
    cube([LARGEUR, t, h_av]);
}

// -----------------------------------------------------------------------------
// Paroi arrière (verticale, h_ar)
// -----------------------------------------------------------------------------
module couvercle_paroi_arriere() {
    translate([0, PROFONDEUR - t, 0])
        cube([LARGEUR, t, h_ar]);
}

// -----------------------------------------------------------------------------
// FIX 3 : Parois latérales — point intérieur corrigé
// -----------------------------------------------------------------------------
module couvercle_paroi_gauche() {
    polyhedron(
        points = [
            [0, 0, 0],             // 0 : avant-bas-ext
            [0, PROFONDEUR, 0],      // 1 : arrière-bas-ext
            [0, PROFONDEUR, h_ar],   // 2 : arrière-haut-ext
            [0, 0, h_av],           // 3 : avant-haut-ext
            [t, 0, 0],              // 4 : avant-bas-int
            [t, PROFONDEUR, 0],      // 5 : arrière-bas-int
            [t, PROFONDEUR, h_ar],   // 6 : arrière-haut-int (FIX : h_ar, pas h_ar-t)
            [t, 0, h_av],           // 7 : avant-haut-int
        ],
        faces = [
            [0,1,2,3],    // extérieur
            [4,7,6,5],    // intérieur
            [0,3,7,4],    // avant
            [1,5,6,2],    // arrière
            [0,4,5,1],    // bas
            [3,2,6,7],    // haut (incliné)
        ]
    );
}

module couvercle_paroi_droite() {
    translate([LARGEUR - t, 0, 0])
        couvercle_paroi_gauche();
}

// -----------------------------------------------------------------------------
// Rainure périphérique (dans le rim)
// -----------------------------------------------------------------------------
module couvercle_rainure() {
    rl = RAINURE_LARGEUR;
    rp = RAINURE_PROFONDEUR;

    translate([t, t, 0])                       cube([LARGEUR - 2*t, rl, rp]);
    translate([t, PROFONDEUR - t - rl, 0])      cube([LARGEUR - 2*t, rl, rp]);
    translate([t, t, 0])                        cube([rl, PROFONDEUR - 2*t, rp]);
    translate([LARGEUR - t - rl, t, 0])         cube([rl, PROFONDEUR - 2*t, rp]);
}

// -----------------------------------------------------------------------------
// Découpe DB9 sur la face arrière du couvercle
// -----------------------------------------------------------------------------
module couvercle_db9_decoupe() {
    cx = DB9_POSITION_X;
    cz = DB9_POSITION_Z_COUVERCLE;
    wall_y = PROFONDEUR - t;

    // Découpe rectangulaire pour le connecteur
    translate([cx - DB9_DECOUPE_LARGEUR/2, wall_y - DB9_RENFORT_EPAISSEUR - 0.1,
               cz - DB9_DECOUPE_HAUTEUR/2])
        cube([DB9_DECOUPE_LARGEUR, DB9_RENFORT_EPAISSEUR + t + 0.2,
              DB9_DECOUPE_HAUTEUR]);

    // 2 trous d'insert M3
    for (dx = [-DB9_ENTRAXE_INSERTS/2, DB9_ENTRAXE_INSERTS/2]) {
        translate([cx + dx, wall_y + 0.1, cz])
            rotate([90, 0, 0])
                cylinder(d = insert_dims(INSERT_DB9_M)[2], h = 100, center = true);
    }
}

// -----------------------------------------------------------------------------
// Renfort DB9 sur la face arrière du couvercle (côté intérieur)
// -----------------------------------------------------------------------------
module couvercle_db9_renfort() {
    cx = DB9_POSITION_X;
    cz = DB9_POSITION_Z_COUVERCLE;
    wall_y = PROFONDEUR - t;

    translate([cx - DB9_RENFORT_LARGEUR/2,
               wall_y - DB9_RENFORT_EPAISSEUR + t,
               cz - DB9_RENFORT_HAUTEUR/2])
        cube([DB9_RENFORT_LARGEUR, DB9_RENFORT_EPAISSEUR - t,
              DB9_RENFORT_HAUTEUR]);
}

// -----------------------------------------------------------------------------
// Renforts boss arrière-gauche → parois (près du joystick)
// -----------------------------------------------------------------------------
module couvercle_renforts_boss_parois() {
    bx = BOSS_MARGE_BORD;                        // 10
    by = PROFONDEUR - BOSS_MARGE_BORD;           // 150
    zh = z_incline(PROFONDEUR - t);              // hauteur au coin arrière

    // Bloc massif remplissant tout le coin arrière-gauche
    translate([t, by - BOSS_DIAMETRE/2, 0])
        cube([bx + BOSS_DIAMETRE/2 - t, PROFONDEUR - t - (by - BOSS_DIAMETRE/2), zh]);
}

// -----------------------------------------------------------------------------
// Couvercle complet
// -----------------------------------------------------------------------------
module couvercle() {
    difference() {
        union() {
            couvercle_rim();
            couvercle_paroi_avant();
            couvercle_paroi_arriere();
            couvercle_paroi_gauche();
            couvercle_paroi_droite();
            couvercle_face_inclinee();
            couvercle_passe_cables();
            couvercle_boss();
            couvercle_db9_renfort();
            couvercle_renforts_boss_parois();
        }
        couvercle_rainure();
        couvercle_db9_decoupe();
    }
}

couvercle();