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

    // Barres horizontales (avant / arrière) — tronquées pour éviter l'overlap
    translate([t + le, t, z_bas])
        cube([LARGEUR - 2*t - 2*le, le, lh]);
    translate([t + le, PROFONDEUR - t - le, z_bas])
        cube([LARGEUR - 2*t - 2*le, le, lh]);
    // Barres verticales (gauche / droite)
    translate([t, t, z_bas])
        cube([le, PROFONDEUR - 2*t, lh]);
    translate([LARGEUR - t - le, t, z_bas])
        cube([le, PROFONDEUR - 2*t, lh]);
}

// -----------------------------------------------------------------------------
// Nervures de rigidification
// -----------------------------------------------------------------------------
module bac_nervures() {
    // Dimensions intérieures (entre les parois)
    il = LARGEUR - 2*t;
    ip = PROFONDEUR - 2*t;
    longueur = sqrt(il^2 + ip^2);
    angle = atan2(ip, il);
    m = BOSS_MARGE_BORD;

    difference() {
        union() {
            // Nervure 1 : avant-gauche → arrière-droit
            translate([t, t, EPAISSEUR_BASE])
                rotate([0, 0, angle])
                    translate([0, -NERVURE_LARGEUR/2, 0])
                        cube([longueur, NERVURE_LARGEUR, NERVURE_HAUTEUR]);

            // Nervure 2 : avant-droit → arrière-gauche
            translate([LARGEUR - t, t, EPAISSEUR_BASE])
                rotate([0, 0, -angle])
                    translate([-longueur, -NERVURE_LARGEUR/2, 0])
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