// =============================================================================
// bac.scad — Moitié du bas (rectangle droit, ouvert en haut)
// =============================================================================
// Bac 120×160×25 mm, ouvert sur le dessus.
// Contient : base + 4 parois + lèvre mâle + 2 nervures + patins
//           + trous traversants dans la base.
//
// FIX : les trous d'assemblage sont dans la BASE du bac (par le bas),
//       les boss sont sur le couvercle.

include <lib/dimensions.scad>

t = EPAISSEUR_PAROI;

// -----------------------------------------------------------------------------
// Volume brut (boîte ouverte en haut)
// -----------------------------------------------------------------------------
module bac_volume_brut() {
    difference() {
        cube([LARGEUR, PROFONDEUR, HAUTEUR_BAC]);
        translate([t, t, EPAISSEUR_BASE])
            cube([LARGEUR - 2*t, PROFONDEUR - 2*t, HAUTEUR_BAC]);
    }
}

// -----------------------------------------------------------------------------
// Lèvre mâle périphérique
// -----------------------------------------------------------------------------
module bac_levre_male() {
    le = LEVRE_EPAISSEUR;
    lh = LEVRE_HAUTEUR;
    z_bas = HAUTEUR_BAC - lh;

    translate([t, t, z_bas])                  cube([LARGEUR - 2*t, le, lh]);
    translate([t, PROFONDEUR - t - le, z_bas]) cube([LARGEUR - 2*t, le, lh]);
    translate([t, t, z_bas])                   cube([le, PROFONDEUR - 2*t, lh]);
    translate([LARGEUR - t - le, t, z_bas])    cube([le, PROFONDEUR - 2*t, lh]);
}

// -----------------------------------------------------------------------------
// Nervures de rigidification
// -----------------------------------------------------------------------------
module bac_nervures() {
    longueur = sqrt(LARGEUR^2 + PROFONDEUR^2);
    angle = atan2(PROFONDEUR, LARGEUR);
    m = BOSS_MARGE_BORD;

    difference() {
        union() {
            translate([0, 0, EPAISSEUR_BASE])
                rotate([0, 0, angle])
                    translate([0, -NERVURE_LARGEUR/2, 0])
                        cube([longueur, NERVURE_LARGEUR, NERVURE_HAUTEUR]);

            translate([0, PROFONDEUR, EPAISSEUR_BASE])
                rotate([0, 0, -angle])
                    translate([0, -NERVURE_LARGEUR/2, 0])
                        cube([longueur, NERVURE_LARGEUR, NERVURE_HAUTEUR]);
        }
        // Dégager les 4 coins (autour des trous de vis)
        positions = [
            [m, m], [LARGEUR - m, m],
            [m, PROFONDEUR - m], [LARGEUR - m, PROFONDEUR - m],
        ];
        for (pos = positions) {
            translate([pos[0], pos[1], EPAISSEUR_BASE - 0.1])
                cylinder(d = BOSS_DIAMETRE + 2, h = NERVURE_HAUTEUR + 0.2);
        }
    }
}

// -----------------------------------------------------------------------------
// Empreintes de patins (détourage sous la base)
// -----------------------------------------------------------------------------
module bac_empreintes_patins() {
    m = PATIN_MARGE_BORD;
    positions = [
        [m, m], [LARGEUR - m, m],
        [m, PROFONDEUR - m], [LARGEUR - m, PROFONDEUR - m],
    ];
    for (pos = positions) {
        translate([pos[0], pos[1], -0.1])
            cylinder(d = PATIN_DIAMETRE, h = PATIN_PROFONDEUR + 0.1);
    }
}

// -----------------------------------------------------------------------------
// FIX : Trous traversants dans la base (pour vis d'assemblage par le bas)
// Les vis passent par le bas, traversent la base, et vont dans les boss
// du couvercle qui descendent à l'intérieur du bac.
// -----------------------------------------------------------------------------
module bac_trous_vis_assemblage() {
    m = BOSS_MARGE_BORD;
    positions = [
        [m, m], [LARGEUR - m, m],
        [m, PROFONDEUR - m], [LARGEUR - m, PROFONDEUR - m],
    ];
    for (pos = positions) {
        // Trou traversant pour vis M3
        translate([pos[0], pos[1], -0.1])
            cylinder(d = 3.6, h = EPAISSEUR_BASE + 0.2);
        // Fraisure conique pour tête fraisée (côté bas)
        translate([pos[0], pos[1], -0.1])
            cylinder(d1 = 7, d2 = 3.6, h = 2);
    }
}

// -----------------------------------------------------------------------------
// Bac complet
// -----------------------------------------------------------------------------
module bac() {
    difference() {
        union() {
            bac_volume_brut();
            bac_levre_male();
            bac_nervures();
        }
        bac_empreintes_patins();
        bac_trous_vis_assemblage();
    }
}

bac();