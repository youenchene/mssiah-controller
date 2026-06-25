// =============================================================================
// components.scad — Cutout modules for each component
// =============================================================================
// These modules are designed to be subtracted (difference) from the sloped face
// or the back face. They include pass-through holes, nut sockets,
// local reinforcements, and insert holes.

include <dimensions.scad>
use <inserts.scad>

// -----------------------------------------------------------------------------
// Potentiometer — complete cutout (hole + hex socket + reinforcement)
// To subtract from the local reinforcement (which is added separately).
// -----------------------------------------------------------------------------
module pot_cutout() {
    // Pass-through hole for the shaft
    cylinder(d = POT_HOLE_DIAMETER, h = 100, center = true);

    // Hexagonal socket for the nut (inner side)
    // The nut is embedded in the reinforcement, on the inner side of the face
    translate([0, 0, -POT_NUT_DEPTH - 0.1])
        cylinder(d = POT_HEX_SOCKET_AF * 2 / sqrt(3), h = POT_NUT_DEPTH + 0.1,
                 center = false, $fn = 6);
}

// -----------------------------------------------------------------------------
// Potentiometer — local reinforcement (to add on the sloped face)
// pos : position [x, y] in the sloped face coordinate system
// -----------------------------------------------------------------------------
module pot_reinforcement(pos) {
    translate(pos)
        cylinder(d = POT_REINFORCE_DIAMETER, h = POT_REINFORCE_THICKNESS - WALL_THICKNESS,
                 center = false);
}

// -----------------------------------------------------------------------------
// Joystick — complete cutout (hole + insert holes)
// To subtract from the local reinforcement.
// -----------------------------------------------------------------------------
module joy_cutout() {
    // Pass-through hole for cap + base
    cylinder(d = JOY_HOLE_DIAMETER, h = 100, center = true);

    // 4 M2.5 insert holes (35 mm spacing)
    spacing = JOY_PCB_SPACING;
    for (dx = [-spacing/2, spacing/2], dy = [-spacing/2, spacing/2]) {
        translate([dx, dy, 0])
            insert_hole(INSERT_JOYSTICK_M);
    }
}

// -----------------------------------------------------------------------------
// Joystick — local reinforcement (square, to add on the sloped face)
// pos : position [x, y] in the sloped face coordinate system
// -----------------------------------------------------------------------------
module joy_reinforcement(pos) {
    translate(pos)
        translate([-JOY_REINFORCE_SIZE/2, -JOY_REINFORCE_SIZE/2, 0])
            cube([JOY_REINFORCE_SIZE, JOY_REINFORCE_SIZE,
                  JOY_REINFORCE_THICKNESS - WALL_THICKNESS]);
}

// -----------------------------------------------------------------------------
// Arcade button — cutout (snap-in hole)
// To subtract from the sloped face (no reinforcement).
// -----------------------------------------------------------------------------
module btn_cutout() {
    cylinder(d = BTN_HOLE_DIAMETER, h = 100, center = true);
}

// -----------------------------------------------------------------------------
// DB9 — rectangular cutout + insert holes
// To subtract from the back face (with reinforcement).
// -----------------------------------------------------------------------------
module db9_cutout() {
    // Rectangular cutout for the connector
    translate([-DB9_CUTOUT_WIDTH/2, -DB9_CUTOUT_HEIGHT/2, 0])
        cube([DB9_CUTOUT_WIDTH, DB9_CUTOUT_HEIGHT, 100], center = true);

    // 2 M3 insert holes (horizontal spacing)
    for (dx = [-DB9_INSERT_SPACING/2, DB9_INSERT_SPACING/2]) {
        translate([dx, 0, 0])
            insert_hole(INSERT_DB9_M);
    }
}

// -----------------------------------------------------------------------------
// DB9 — local reinforcement (back face)
// -----------------------------------------------------------------------------
module db9_reinforcement() {
    translate([-DB9_REINFORCE_WIDTH/2, -DB9_REINFORCE_HEIGHT/2, 0])
        cube([DB9_REINFORCE_WIDTH, DB9_REINFORCE_HEIGHT,
              DB9_REINFORCE_THICKNESS - WALL_THICKNESS]);
}

// -----------------------------------------------------------------------------
// All sloped face cutouts (pots + joystick + button)
// To call inside a difference() on the sloped face.
// -----------------------------------------------------------------------------
module sloped_face_cutouts() {
    // Potentiometers
    for (pos = POT_POSITIONS) {
        translate([pos[0], pos[1], 0])
            pot_cutout();
    }

    // Joystick
    translate([JOY_POSITION[0], JOY_POSITION[1], 0])
        joy_cutout();

    // Arcade button
    translate([BTN_POSITION[0], BTN_POSITION[1], 0])
        btn_cutout();
}

// -----------------------------------------------------------------------------
// All sloped face reinforcements (to add before cutouts)
// -----------------------------------------------------------------------------
module sloped_face_reinforcements() {
    // Potentiometer reinforcements
    for (pos = POT_POSITIONS) {
        pot_reinforcement(pos);
    }

    // Joystick reinforcement
    joy_reinforcement(JOY_POSITION);
}
