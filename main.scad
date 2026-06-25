// =============================================================================
// main.scad — Full assembly (3D view of both halves)
// =============================================================================
// Shows the bottom and cover assembled or in exploded view.

include <lib/dimensions.scad>
use <bottom.scad>
use <cover.scad>

// -----------------------------------------------------------------------------
// Display parameters
// -----------------------------------------------------------------------------
EXPLODED = true;       // true = exploded view, false = assembled
SHOW_BOTTOM = true;
SHOW_COVER = true;

// Vertical offset for exploded view
explode_offset = EXPLODED ? 40 : 0;

// -----------------------------------------------------------------------------
// Assembly
// -----------------------------------------------------------------------------
module assembly() {
    if (SHOW_BOTTOM) {
        color("lightgray", 0.9)
            bottom();
    }

    if (SHOW_COVER) {
        color("lightblue", 0.9)
            translate([0, 0, BASE_THICKNESS + explode_offset])
                cover();
    }
}

assembly();
