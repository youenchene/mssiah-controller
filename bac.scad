// =============================================================================
// bac.scad — Plaque de base plate
// =============================================================================
// Plaque 120×160×2.5 mm. Le couvercle fait tout le reste.

include <lib/dimensions.scad>

t = EPAISSEUR_PAROI;

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
// Trous traversants + fraisure pour vis d'assemblage M3
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
// Trous d'alignement pour les ergots du couvercle
// -----------------------------------------------------------------------------
module bac_trous_alignement() {
    d = 3.2;  // diamètre trou (jeu 0.2 mm sur ergot Ø 3)

    // Avant (centre paroi)
    translate([30, t/2, -0.1])
        cylinder(d = d, h = EPAISSEUR_BASE + 0.2);
    // Arrière (centre paroi)
    translate([LARGEUR - 30, PROFONDEUR - t/2, -0.1])
        cylinder(d = d, h = EPAISSEUR_BASE + 0.2);
}

// -----------------------------------------------------------------------------
// Bac complet (plaque plate)
// -----------------------------------------------------------------------------
module bac() {
    difference() {
        cube([LARGEUR, PROFONDEUR, EPAISSEUR_BASE]);
        bac_empreintes_patins();
        bac_trous_vis_assemblage();
        bac_trous_alignement();
    }
}

bac();
