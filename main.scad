// =============================================================================
// main.scad — Assemblage complet (vue 3D des deux moitiés)
// =============================================================================
// Affiche le bac et le couvercle assemblés ou en vue éclatée.

include <lib/dimensions.scad>
use <bac.scad>
use <couvercle.scad>

// -----------------------------------------------------------------------------
// Paramètres d'affichage
// -----------------------------------------------------------------------------
EXPLODED = true;       // true = vue éclatée, false = assemblé
SHOW_BAC = true;
SHOW_COUVERCLE = true;

// Décalage vertical pour la vue éclatée
decalage_explode = EXPLODED ? 40 : 0;

// -----------------------------------------------------------------------------
// Assemblage
// -----------------------------------------------------------------------------
module assemblage() {
    if (SHOW_BAC) {
        color("lightgray", 0.9)
            bac();
    }

    if (SHOW_COUVERCLE) {
        color("lightblue", 0.9)
            translate([0, 0, HAUTEUR_BAC + decalage_explode])
                couvercle();
    }
}

assemblage();