// =============================================================================
// cable_guides.scad — Cable guide arch module
// =============================================================================
// Small arch printed in relief on the inner face of the cover,
// under which cables pass to be guided.

include <dimensions.scad>

// -----------------------------------------------------------------------------
// Cable guide arch (to add on the inner face)
// Orientation: the arch is aligned along the Y axis (along the slope)
// -----------------------------------------------------------------------------
module cable_guide() {
    // Arch body: a bridge with two legs
    difference() {
        // Outer block
        translate([-CABLE_GUIDE_WIDTH/2, -CABLE_GUIDE_WIDTH/2, 0])
            cube([CABLE_GUIDE_WIDTH, CABLE_GUIDE_WIDTH, CABLE_GUIDE_HEIGHT]);

        // Void under the arch (tunnel)
        translate([-CABLE_GUIDE_WIDTH/2 + CABLE_GUIDE_THICKNESS,
                   -CABLE_GUIDE_WIDTH/2 - 0.1,
                   -0.1])
            cube([CABLE_GUIDE_WIDTH - 2*CABLE_GUIDE_THICKNESS,
                  CABLE_GUIDE_WIDTH + 0.2,
                  CABLE_GUIDE_HEIGHT - CABLE_GUIDE_THICKNESS + 0.1]);
    }
}

// -----------------------------------------------------------------------------
// All cable guides (on the inner face of the cover)
// Positioned along the Y axis, centered in X
// -----------------------------------------------------------------------------
module cable_guides_all() {
    for (y = CABLE_GUIDE_POSITIONS_Y) {
        translate([WIDTH/2, y, 0])
            cable_guide();
    }
}
