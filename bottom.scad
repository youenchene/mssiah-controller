// =============================================================================
// bottom.scad — Flat base plate
// =============================================================================
// Plate 120×160×2.5 mm. The cover handles everything else.

include <lib/dimensions.scad>

t = WALL_THICKNESS;

// -----------------------------------------------------------------------------
// Foot pad recesses (cutout under the base)
// -----------------------------------------------------------------------------
module bottom_foot_recesses() {
    m = FOOT_EDGE_MARGIN;
    positions = [
        [m, m], [WIDTH - m, m],
        [m, DEPTH - m], [WIDTH - m, DEPTH - m],
    ];
    for (pos = positions) {
        translate([pos[0], pos[1], -0.1])
            cylinder(d = FOOT_DIAMETER, h = FOOT_RECESS_DEPTH + 0.1);
    }
}

// -----------------------------------------------------------------------------
// Through-holes + countersink for M3 assembly screws
// -----------------------------------------------------------------------------
module bottom_assembly_screw_holes() {
    m = BOSS_EDGE_MARGIN;
    positions = [
        [m, m], [WIDTH - m, m],
        [m, DEPTH - m], [WIDTH - m, DEPTH - m],
    ];
    for (pos = positions) {
        // Through-hole for M3 screw
        translate([pos[0], pos[1], -0.1])
            cylinder(d = 3.6, h = BASE_THICKNESS + 0.2);
        // Conical countersink for flat-head screw (bottom side)
        translate([pos[0], pos[1], -0.1])
            cylinder(d1 = 7, d2 = 3.6, h = 2);
    }
}

// -----------------------------------------------------------------------------
// Alignment holes for cover pins
// -----------------------------------------------------------------------------
module bottom_alignment_holes() {
    d = 3.2;  // hole diameter (0.2 mm clearance on Ø 3 pin)

    // Front (wall center)
    translate([30, t/2, -0.1])
        cylinder(d = d, h = BASE_THICKNESS + 0.2);
    // Back (wall center)
    translate([WIDTH - 30, DEPTH - t/2, -0.1])
        cylinder(d = d, h = BASE_THICKNESS + 0.2);
}

// -----------------------------------------------------------------------------
// Complete bottom (flat plate)
// -----------------------------------------------------------------------------
module bottom() {
    difference() {
        cube([WIDTH, DEPTH, BASE_THICKNESS]);
        bottom_foot_recesses();
        bottom_assembly_screw_holes();
        bottom_alignment_holes();
    }
}

bottom();
