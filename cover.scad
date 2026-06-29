// =============================================================================
// cover.scad — Main body with sloped face and full-height walls
// =============================================================================
// FIX:
// 1. Bosses connected to the sloped plane via vertical reinforcements
// 2. Sloped plane cut straight at the front (y=0)
// 3. Side wall: inner point corrected (h_back instead of h_back - t)

include <lib/dimensions.scad>
use <lib/components.scad>

t = WALL_THICKNESS;
h_front = COVER_HEIGHT_FRONT;   // 3 mm
h_back  = COVER_HEIGHT_BACK;    // ≈ 61 mm

// Height of the sloped plane at a given Y position (world frame)
function z_slope(y) = h_front + y * tan(SLOPE_ANGLE);

// -----------------------------------------------------------------------------
// Flat sloped face (in XY plane, before rotation)
// z = 0 → inner face, z = t → outer face
// -----------------------------------------------------------------------------
module sloped_face_flat() {
    difference() {
        union() {
            cube([WIDTH, SLOPE_LENGTH, t]);

            // Joystick reinforcement (inner side)
            translate([JOY_POSITION[0], JOY_POSITION[1], -(JOY_REINFORCE_THICKNESS - t)])
                translate([-JOY_REINFORCE_SIZE/2, -JOY_REINFORCE_SIZE/2, 0])
                    cube([JOY_REINFORCE_SIZE, JOY_REINFORCE_SIZE,
                          JOY_REINFORCE_THICKNESS - t]);
        }

        // Pots — through-holes (flat face)
        for (pos = POT_POSITIONS) {
            translate([pos[0], pos[1], -10])
                cylinder(d = POT_HOLE_DIAMETER, h = 100);
        }

        // Anti-rotation tab slots — 2 per pot (left/right)
        sw  = POT_TAB_WIDTH  + POT_TAB_CLEARANCE;   // 1.2 mm
        sl  = POT_TAB_LENGTH + POT_TAB_CLEARANCE;   // 3.1 mm
        sd  = min(POT_TAB_DEPTH + POT_TAB_CLEARANCE,
                  WALL_THICKNESS - POT_TAB_SLOT_FLOOR);  // capped at 1.5 mm
        hs  = POT_TAB_SPAN  / 2;                    // 12.4 mm
        for (pos = POT_POSITIONS) {
            translate([pos[0], pos[1], 0]) {
                // Left tab
                translate([-hs - sw/2, -sl/2, -0.1])
                    cube([sw, sl, sd + 0.1]);
                // Right tab
                translate([+hs - sw/2, -sl/2, -0.1])
                    cube([sw, sl, sd + 0.1]);
            }
        }

        // Joystick — through-hole
        translate([JOY_POSITION[0], JOY_POSITION[1], -10])
            cylinder(d = JOY_HOLE_DIAMETER, h = 100);
        // 4 M2.5 insert holes (inner side)
        for (dx = [-JOY_PCB_SPACING/2, JOY_PCB_SPACING/2],
             dy = [-JOY_PCB_SPACING/2, JOY_PCB_SPACING/2]) {
            translate([JOY_POSITION[0] + dx, JOY_POSITION[1] + dy,
                       -(JOY_REINFORCE_THICKNESS - t) - 0.1])
                cylinder(d = insert_dims(INSERT_JOYSTICK_M)[2],
                         h = insert_dims(INSERT_JOYSTICK_M)[3] + 0.1);
        }

        // Arcade button — through-hole
        translate([BTN_POSITION[0], BTN_POSITION[1], -10])
            cylinder(d = BTN_HOLE_DIAMETER, h = 100);
    }
}

// -----------------------------------------------------------------------------
// FIX 2: Sloped plane positioned + clipped at y=0 (front)
// -----------------------------------------------------------------------------
module cover_sloped_face() {
    intersection() {
        // Rotated sloped plane
        translate([0, 0, h_front])
            rotate([SLOPE_ANGLE, 0, 0])
                sloped_face_flat();
        // Clip at y >= 0 (cuts front overhang)
        translate([-10, 0, -10])
            cube([WIDTH + 20, DEPTH + 20, h_back + 20]);
    }
}

// -----------------------------------------------------------------------------
// Cable guides — 3 arches on the sloped face (offset toward joystick side)
// -----------------------------------------------------------------------------
module cable_guide_flat() {
    difference() {
        translate([-CABLE_GUIDE_WIDTH/2, -CABLE_GUIDE_WIDTH/2, -CABLE_GUIDE_HEIGHT])
            cube([CABLE_GUIDE_WIDTH, CABLE_GUIDE_WIDTH, CABLE_GUIDE_HEIGHT]);
        translate([-CABLE_GUIDE_WIDTH/2 + CABLE_GUIDE_THICKNESS,
                   -CABLE_GUIDE_WIDTH/2 - 0.1, -CABLE_GUIDE_HEIGHT])
            cube([CABLE_GUIDE_WIDTH - 2*CABLE_GUIDE_THICKNESS,
                  CABLE_GUIDE_WIDTH + 0.2,
                  CABLE_GUIDE_HEIGHT - CABLE_GUIDE_THICKNESS]);
    }
}

module cover_face_cable_guides() {
    // Only the 2 guides closest to the top
    for (y = [CABLE_GUIDE_POSITIONS_Y[0], CABLE_GUIDE_POSITIONS_Y[1]]) {
        translate([0, 0, h_front])
            rotate([SLOPE_ANGLE, 0, 0])
                translate([WIDTH/2, y, 0])
                    cable_guide_flat();
    }
}

// -----------------------------------------------------------------------------
// Cable guides — 2 arches oriented forward on each side of a DB9
// cx, cz : position on the back face
// -----------------------------------------------------------------------------
module cover_db9_cable_guides(cx, cz) {
    y_wall = DEPTH;  // outer face

    offsets = [30, -30];

    for (dx = offsets) {
        translate([cx + dx, y_wall, cz])
            rotate([-90, 0, 0])
                cable_guide_flat();
    }
}

// -----------------------------------------------------------------------------
// Bosses with enlarged reinforcement cones trimmed flush to the sloped face
// -----------------------------------------------------------------------------
module cover_bosses() {
    m = BOSS_EDGE_MARGIN;
    boss_height = BASE_HEIGHT - BASE_THICKNESS;  // 22.5 mm
    insert_d = insert_dims(INSERT_ASSEMBLY_M)[2];
    insert_h = insert_dims(INSERT_ASSEMBLY_M)[3];
    cone_top_d = BOSS_DIAMETER + 16;  // 26 mm, enlarged for structural connection

    positions = [
        [m, m], [WIDTH - m, m],
        [m, DEPTH - m], [WIDTH - m, DEPTH - m],
    ];

    // Outer difference: trim everything above the sloped face inner surface
    difference() {
        // All bosses with oversized cones (extend past inner face for overlap)
        for (pos = positions) {
            z_top = z_slope(pos[1]);   // inner face height at this Y
            jy = JOY_POSITION[1] * cos(SLOPE_ANGLE);

            difference() {
                union() {
                    // Pillar extending down into the base
                    translate([pos[0], pos[1], -boss_height])
                        cylinder(d = BOSS_DIAMETER, h = boss_height + t);

                    // Enlarged reinforcement cone (except boss near joystick)
                    if (pos[0] != m || pos[1] != DEPTH - m) {
                        translate([pos[0], pos[1], 0])
                            cylinder(d1 = BOSS_DIAMETER,
                                     d2 = cone_top_d,
                                     h  = z_top + 2);
                    }
                }

                // Insert hole at the BOTTOM of the boss (base side)
                translate([pos[0], pos[1], -boss_height - 0.1])
                    cylinder(d = insert_d, h = insert_h + 0.1);

                // Clear the joystick mounting area
                if (pos[0] == m && pos[1] == DEPTH - m) {
                    translate([JOY_POSITION[0] - JOY_REINFORCE_SIZE/2 - 5,
                               jy - JOY_REINFORCE_SIZE/2 - 5,
                               -1])
                        cube([JOY_REINFORCE_SIZE + 10,
                              JOY_REINFORCE_SIZE + 10,
                              h_back + 2]);
                }
            }
        }

        // Trim 1 : cut off anything above the sloped face inner surface.
        // Inner surface is at z=0 in the flat (rotated) coordinate frame.
        translate([-1, -1, h_front])
            rotate([SLOPE_ANGLE, 0, 0])
                translate([0, 0, 0])
                    cube([WIDTH + 2, SLOPE_LENGTH + 2, 200]);

        // Trim 2 : cut off cone overhang beyond the outer face of each wall.
        // Left wall  (x < 0)
        translate([-100, -1, -boss_height - 1])
            cube([100, DEPTH + 2, h_back + boss_height + 5]);
        // Front wall (y < 0)
        translate([-1, -100, -boss_height - 1])
            cube([WIDTH + 2, 100, h_back + boss_height + 5]);
        // Right wall (x > WIDTH)
        translate([WIDTH, -1, -boss_height - 1])
            cube([100, DEPTH + 2, h_back + boss_height + 5]);
        // Back wall  (y > DEPTH)
        translate([-1, DEPTH, -boss_height - 1])
            cube([WIDTH + 2, 100, h_back + boss_height + 5]);
    }
}

// -----------------------------------------------------------------------------
// Base plate (rim) + connection pegs to bosses
// -----------------------------------------------------------------------------
module cover_rim() {
    difference() {
        cube([WIDTH, DEPTH, t]);
        translate([t, t, -0.1])
            cube([WIDTH - 2*t, DEPTH - 2*t, t + 0.2]);
    }
}

// -----------------------------------------------------------------------------
// Front wall (vertical, h_front = 3 mm)
// FIX 2: height = h_front for straight cut
// -----------------------------------------------------------------------------
module cover_front_wall() {
    cube([WIDTH, t, h_front]);
}

// -----------------------------------------------------------------------------
// Back wall (vertical, h_back)
// -----------------------------------------------------------------------------
module cover_back_wall() {
    translate([0, DEPTH - t, 0])
        cube([WIDTH, t, h_back]);
}

// -----------------------------------------------------------------------------
// FIX 3: Side walls — inner point corrected
// -----------------------------------------------------------------------------
module cover_left_wall() {
    polyhedron(
        points = [
            [0, 0, 0],             // 0 : front-bottom-ext
            [0, DEPTH, 0],          // 1 : back-bottom-ext
            [0, DEPTH, h_back],     // 2 : back-top-ext
            [0, 0, h_front],        // 3 : front-top-ext
            [t, 0, 0],              // 4 : front-bottom-int
            [t, DEPTH, 0],          // 5 : back-bottom-int
            [t, DEPTH, h_back],     // 6 : back-top-int (FIX: h_back, not h_back-t)
            [t, 0, h_front],        // 7 : front-top-int
        ],
        faces = [
            [0,1,2,3],    // exterior
            [4,7,6,5],    // interior
            [0,3,7,4],    // front
            [1,5,6,2],    // back
            [0,4,5,1],    // bottom
            [3,2,6,7],    // top (sloped)
        ]
    );
}

module cover_right_wall() {
    translate([WIDTH - t, 0, 0])
        cover_left_wall();
}

// -----------------------------------------------------------------------------
// DB9 cutout on the back face of the cover
// cx, cz : position on the back face
// -----------------------------------------------------------------------------
module cover_db9_cutout(cx, cz) {
    wall_y = DEPTH - t;

    // Rectangular cutout for the connector
    translate([cx - DB9_CUTOUT_WIDTH/2, wall_y - DB9_REINFORCE_THICKNESS - 0.1,
               cz - DB9_CUTOUT_HEIGHT/2])
        cube([DB9_CUTOUT_WIDTH, DB9_REINFORCE_THICKNESS + t + 0.2,
              DB9_CUTOUT_HEIGHT]);

    // 2 M3 insert holes
    for (dx = [-DB9_INSERT_SPACING/2, DB9_INSERT_SPACING/2]) {
        translate([cx + dx, wall_y + 0.1, cz])
            rotate([90, 0, 0])
                cylinder(d = insert_dims(INSERT_DB9_M)[2], h = 100, center = true);
    }
}

// -----------------------------------------------------------------------------
// DB9 reinforcement on the back face of the cover (inner side)
// cx, cz : position on the back face
// -----------------------------------------------------------------------------
module cover_db9_reinforcement(cx, cz) {
    wall_y = DEPTH - t;

    translate([cx - DB9_REINFORCE_WIDTH/2,
               wall_y - DB9_REINFORCE_THICKNESS + t,
               cz - DB9_REINFORCE_HEIGHT/2])
        cube([DB9_REINFORCE_WIDTH, DB9_REINFORCE_THICKNESS - t,
              DB9_REINFORCE_HEIGHT]);
}

// -----------------------------------------------------------------------------
// Back-left boss reinforcements → walls (near joystick)
// -----------------------------------------------------------------------------
module cover_boss_wall_reinforcements() {
    bx = BOSS_EDGE_MARGIN;                      // 10
    by = DEPTH - BOSS_EDGE_MARGIN;              // 150
    zh = z_slope(by);                           // height at boss (sloped plane)

    // Solid block filling the entire back-left corner
    translate([t, by - BOSS_DIAMETER/2, 0])
        cube([bx + BOSS_DIAMETER/2 - t, DEPTH - t - (by - BOSS_DIAMETER/2), zh]);
}

// -----------------------------------------------------------------------------
// Alignment pins (protrude below the lower walls)
// -----------------------------------------------------------------------------
module cover_alignment_pins() {
    hb = BASE_HEIGHT - t;
    d = 3;   // pin diameter
    h = 3;   // pin height

    // Front (wall center)
    translate([30, t/2, -hb - h])
        cylinder(d = d, h = h);
    // Back (wall center)
    translate([WIDTH - 30, DEPTH - t/2, -hb - h])
        cylinder(d = d, h = h);
}

// -----------------------------------------------------------------------------
// Lower walls (extension downward to the base plate)
// -----------------------------------------------------------------------------
module cover_lower_walls() {
    hb = BASE_HEIGHT - t;  // height of lower walls (replaces base walls)

    translate([0, 0, -hb]) {
        // Front
        cube([WIDTH, t, hb]);
        // Back
        translate([0, DEPTH - t, 0])
            cube([WIDTH, t, hb]);
        // Left
        cube([t, DEPTH, hb]);
        // Right
        translate([WIDTH - t, 0, 0])
            cube([t, DEPTH, hb]);
    }
}

// -----------------------------------------------------------------------------
// Complete cover
// -----------------------------------------------------------------------------
module cover() {
    difference() {
        union() {
            cover_rim();
            cover_lower_walls();
            cover_front_wall();
            cover_back_wall();
            cover_left_wall();
            cover_right_wall();
            cover_sloped_face();
            cover_face_cable_guides();
            cover_bosses();
            // DB9(s) on back wall
            for (pos = DB9_POSITIONS) {
                cover_db9_reinforcement(pos[0], pos[1]);
                cover_db9_cable_guides(pos[0], pos[1]);
            }
            cover_boss_wall_reinforcements();
            cover_alignment_pins();
        }
        // DB9 cutout(s) on back wall
        for (pos = DB9_POSITIONS) {
            cover_db9_cutout(pos[0], pos[1]);
        }
    }
}

cover();
