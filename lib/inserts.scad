// =============================================================================
// inserts.scad — Modules paramétriques pour inserts à chaud
// =============================================================================
// Fournit des modules pour percer les trous d'insert et modéliser les inserts.

include <dimensions.scad>

// -----------------------------------------------------------------------------
// Trou de perçage pour insert à chaud (à soustraire de la pièce)
// m : taille métrique (2.5, 3, 4, 5)
// prof : profondeur du trou (défaut = prof_perçage de l'insert)
// -----------------------------------------------------------------------------
module trou_insert(m, prof = 0) {
    dims = insert_dims(m);
    diam_per = dims[2];
    p = (prof > 0) ? prof : dims[3];
    translate([0, 0, 0])
        cylinder(d = diam_per, h = p + 0.1, center = false);
}

// -----------------------------------------------------------------------------
// Trou traversant pour vis (à soustraire de la pièce)
// m : taille métrique (2.5, 3, 4, 5)
// -----------------------------------------------------------------------------
module trou_vis_traversant(m) {
    diam_vis = (m == 2.5) ? 2.7 : (m == 3) ? 3.2 : (m == 4) ? 4.2 : 5.2;
    cylinder(d = diam_vis, h = 100, center = true);
}

// -----------------------------------------------------------------------------
// Modèle 3D d'un insert à chaud (pour visualisation uniquement)
// m : taille métrique
// -----------------------------------------------------------------------------
module insert_model(m) {
    dims = insert_dims(m);
    diam_ext = dims[0];
    longueur = dims[1];
    color("gold")
        cylinder(d = diam_ext, h = longueur, center = false, $fn = 32);
}

// -----------------------------------------------------------------------------
// Boss complet avec insert (pour le bac)
// m : taille métrique de l'insert
// hauteur_boss : hauteur du pilier
// -----------------------------------------------------------------------------
module boss_insert(m, hauteur_boss) {
    dims = insert_dims(m);
    diam_per = dims[2];
    prof_per = dims[3];

    // Pilier
    difference() {
        cylinder(d = BOSS_DIAMETRE, h = hauteur_boss, center = false);
        // Trou de perçage pour l'insert (au sommet du boss)
        translate([0, 0, hauteur_boss - prof_per])
            cylinder(d = diam_per, h = prof_per + 0.1, center = false);
    }
}