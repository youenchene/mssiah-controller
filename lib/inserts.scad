// =============================================================================
// inserts.scad — Parametric modules for heat-set inserts
// =============================================================================
// Provides modules for drilling insert holes and modeling inserts.

include <dimensions.scad>

// -----------------------------------------------------------------------------
// Drill hole for heat-set insert (to subtract from the part)
// m : metric size (2.5, 3, 4, 5)
// depth : hole depth (default = drill_depth of the insert)
// -----------------------------------------------------------------------------
module insert_hole(m, depth = 0) {
    dims = insert_dims(m);
    diam_drill = dims[2];
    d = (depth > 0) ? depth : dims[3];
    translate([0, 0, 0])
        cylinder(d = diam_drill, h = d + 0.1, center = false);
}

// -----------------------------------------------------------------------------
// Through-hole for screw (to subtract from the part)
// m : metric size (2.5, 3, 4, 5)
// -----------------------------------------------------------------------------
module screw_through_hole(m) {
    diam_screw = (m == 2.5) ? 3.5 : (m == 3) ? 4 : (m == 4) ? 6 : 6;
    cylinder(d = diam_screw, h = 100, center = true);
}

// -----------------------------------------------------------------------------
// 3D model of a heat-set insert (visualization only)
// m : metric size
// -----------------------------------------------------------------------------
module insert_model(m) {
    dims = insert_dims(m);
    ext_diam = dims[0];
    length = dims[1];
    color("gold")
        cylinder(d = ext_diam, h = length, center = false, $fn = 32);
}

// -----------------------------------------------------------------------------
// Complete boss with insert (for the base)
// m : metric size of the insert
// boss_height : pillar height
// -----------------------------------------------------------------------------
module boss_with_insert(m, boss_height) {
    dims = insert_dims(m);
    diam_drill = dims[2];
    drill_depth = dims[3];

    // Pillar
    difference() {
        cylinder(d = BOSS_DIAMETER, h = boss_height, center = false);
        // Drill hole for the insert (at the top of the boss)
        translate([0, 0, boss_height - drill_depth])
            cylinder(d = diam_drill, h = drill_depth + 0.1, center = false);
    }
}
