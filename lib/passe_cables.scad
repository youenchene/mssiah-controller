// =============================================================================
// passe_cables.scad — Module d'arche de passe-câbles
// =============================================================================
// Petite arche imprimée en relief sur la face intérieure du couvercle,
// sous laquelle passent les câbles pour les guider.

include <dimensions.scad>

// -----------------------------------------------------------------------------
// Arche de passe-câbles (à ajouter sur la face intérieure)
// Orientation : l'arche est alignée selon l'axe Y (le long de la pente)
// -----------------------------------------------------------------------------
module passe_cable() {
    // Corps de l'arche : un pont avec deux pieds
    difference() {
        // Bloc extérieur
        translate([-PASSE_CABLE_LARGEUR/2, -PASSE_CABLE_LARGEUR/2, 0])
            cube([PASSE_CABLE_LARGEUR, PASSE_CABLE_LARGEUR, PASSE_CABLE_HAUTEUR]);

        // Vide sous l'arche (tunnel)
        translate([-PASSE_CABLE_LARGEUR/2 + PASSE_CABLE_EPAISSEUR,
                   -PASSE_CABLE_LARGEUR/2 - 0.1,
                   -0.1])
            cube([PASSE_CABLE_LARGEUR - 2*PASSE_CABLE_EPAISSEUR,
                  PASSE_CABLE_LARGEUR + 0.2,
                  PASSE_CABLE_HAUTEUR - PASSE_CABLE_EPAISSEUR + 0.1]);
    }
}

// -----------------------------------------------------------------------------
// Tous les passes-câbles (sur la face intérieure du couvercle)
// Positionnés le long de l'axe Y, centrés en X
// -----------------------------------------------------------------------------
module passe_cables_tous() {
    for (y = PASSE_CABLE_POSITIONS_Y) {
        translate([LARGEUR/2, y, 0])
            passe_cable();
    }
}