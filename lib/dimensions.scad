// =============================================================================
// dimensions.scad — All dimensional variables for the MSSIAH controller enclosure
// =============================================================================
// Origin of the sloped face coordinate system: bottom-left corner (front-left as seen by operator).
// X = width (left → right), Y = length along the slope (front → back).

// -----------------------------------------------------------------------------
// Enclosure — global dimensions
// -----------------------------------------------------------------------------
WIDTH            = 120;    // width (left → right)
DEPTH            = 160;    // depth (front → back, projected on ground)
BASE_HEIGHT      = 25;     // height of the bottom/base (straight rectangle, open on top)
SLOPE_ANGLE      = 20;     // slope angle of the face (degrees)
WALL_THICKNESS   = 2.5;    // wall thickness
BASE_THICKNESS   = 2.5;    // thickness of the bottom base

// Cover: minimal vertical rim for the groove
COVER_RIM_HEIGHT = 3;      // height of the front vertical rim (for the groove)

// Cover height (sloped face above the base)
COVER_HEIGHT_FRONT = COVER_RIM_HEIGHT;                              // 3 mm
COVER_HEIGHT_BACK  = COVER_RIM_HEIGHT + DEPTH * tan(SLOPE_ANGLE);   // ≈ 61 mm

// Total back height of the enclosure (base + cover)
TOTAL_BACK_HEIGHT = BASE_HEIGHT + COVER_HEIGHT_BACK;               // ≈ 86 mm

// Length of the sloped face (along the slope)
SLOPE_LENGTH     = DEPTH / cos(SLOPE_ANGLE);                       // ≈ 170 mm

// -----------------------------------------------------------------------------
// Base / cover joint (male lip + groove)
// -----------------------------------------------------------------------------
LIP_THICKNESS    = 2.0;   // thickness of the male lip (on the base)
LIP_HEIGHT       = 3.0;   // height of the male lip
GROOVE_WIDTH     = 2.2;   // groove width (in the cover) — 0.2 clearance
GROOVE_DEPTH_DIM = 3.2;   // groove depth — 0.2 clearance
GROOVE_CHAMFER   = 0.5;   // groove entry chamfer (mm × 45°)

// -----------------------------------------------------------------------------
// Heat-set inserts — dimensions by size
// -----------------------------------------------------------------------------
// Format: [ext_diameter, length, drill_diameter, drill_depth]
function insert_dims(m) =
    m == 2.5 ? [3.5, 4,  3.0, 5] :
    m == 3   ? [5.0, 4,  4.0, 5] :
    m == 4   ? [6.0, 4,  5.0, 5] :
    m == 5   ? [7.0, 4,  5.5, 5] :
    [0,0,0,0];  // fallback

INSERT_JOYSTICK_M   = 2.5;
INSERT_DB9_M        = 3;
INSERT_ASSEMBLY_M   = 3;

// -----------------------------------------------------------------------------
// Fixation bosses (base/cover assembly)
// -----------------------------------------------------------------------------
BOSS_DIAMETER    = 10;    // pillar diameter
BOSS_EDGE_MARGIN = 10;    // distance from edge

// -----------------------------------------------------------------------------
// Foot pads
// -----------------------------------------------------------------------------
FOOT_DIAMETER    = 11;    // diameter of adhesive foot pads
FOOT_RECESS_DEPTH = 0.5;  // depth of the surface recess
FOOT_EDGE_MARGIN = 25;    // distance from edge (offset from assembly screws)

// -----------------------------------------------------------------------------
// Stiffening ribs (bottom base)
// -----------------------------------------------------------------------------
RIB_WIDTH        = 2;     // rib width
RIB_HEIGHT       = 3;     // rib height

// -----------------------------------------------------------------------------
// Potentiometers (×4)
// -----------------------------------------------------------------------------
POT_SHAFT_DIAMETER        = 9.7;   // threaded shaft diameter
POT_HOLE_DIAMETER         = 10;    // pass-through hole in the face
POT_NUT_AF                = 13.85; // hex nut across-flats
POT_NUT_DEPTH             = 4;     // depth of the hexagonal socket
POT_HEX_SOCKET_AF         = 14;    // hex socket (with clearance)
POT_WASHER_DECO_DIAM      = 41;    // decorative outer washer
POT_WASHER_INNER_DIAM     = 15;    // inner washer
POT_KNOB_DIAMETER         = 26.5;  // knob
POT_BODY_DIAMETER         = 28;    // potentiometer body diameter
POT_BODY_HEIGHT           = 12.6;  // body height under the face
POT_REINFORCE_DIAMETER    = 22;    // local reinforcement diameter
POT_REINFORCE_THICKNESS   = 4;     // local reinforcement thickness
POT_TAB_SPAN              = 24.8;  // inter-ergot distance (center to center)
POT_TAB_WIDTH             = 0.8;   // tab width (X, circumferential)
POT_TAB_LENGTH            = 2.7;   // tab length (Y, radial)
POT_TAB_DEPTH             = 4.8;   // tab protrusion from pot body (Z, into face)
POT_TAB_CLEARANCE         = 0.4;   // 3D-print tolerance
POT_TAB_SLOT_FLOOR        = 1.0;   // minimum material remaining under slot (non-traversant)

// Potentiometer positions (sloped face coordinate system)
POT_POSITIONS = [
    [38.5, 65],   // P1 — middle row, left
    [81.5, 65],   // P2 — middle row, right
    [38.5, 21.5],   // P3 — front row, left
    [81.5, 21.5],   // P4 — front row, right
];

// -----------------------------------------------------------------------------
// Joystick (×1)
// -----------------------------------------------------------------------------
JOY_HOLE_DIAMETER      = 32;     // pass-through hole (cap + base + clearance)
JOY_CAP_DIAMETER       = 15;     // cap diameter
JOY_PCB_SIZE           = 34;     // PCB size (square)
JOY_PCB_SPACING        = 35;     // mounting hole spacing (center-to-center)
JOY_PCB_HOLE_DIAMETER  = 2.5;    // hole diameter on the PCB
JOY_REINFORCE_SIZE     = 45;     // local reinforcement size (square)
JOY_REINFORCE_THICKNESS = 6;     // local reinforcement thickness
JOY_POSITION           = [30, 110]; // joystick position (sloped face coordinates)

// -----------------------------------------------------------------------------
// Arcade button Sanwa OBSF-30 (×1)
// -----------------------------------------------------------------------------
BTN_HOLE_DIAMETER      = 30;     // pass-through hole (snap-in)
BTN_COLLAR_DIAMETER    = 33;     // collar diameter
BTN_DEPTH              = 40;     // depth under the face
BTN_POSITION           = [90, 110]; // position (sloped face coordinates)

// -----------------------------------------------------------------------------
// DB9 (×N — position array, see DB9_POSITIONS)
// -----------------------------------------------------------------------------
DB9_CUTOUT_WIDTH       = 19.20;  // rectangular cutout (width, X)
DB9_CUTOUT_HEIGHT      = 12;     // rectangular cutout (height, Z)
DB9_INSERT_SPACING     = 24.5;   // M3 insert spacing (in X, outside cutout)
DB9_POSITIONS = [
    [60, -8],  // DB9 #1 : bottom row, center
    [35, 17],  // DB9 #2 : top row, left
    [85, 17],  // DB9 #3 : top row, right
];
DB9_REINFORCE_WIDTH    = 45;     // local reinforcement width
DB9_REINFORCE_HEIGHT   = 25;     // local reinforcement height
DB9_REINFORCE_THICKNESS = 6;     // local reinforcement thickness

// -----------------------------------------------------------------------------
// Cable guides (×3)
// -----------------------------------------------------------------------------
CABLE_GUIDE_HEIGHT     = 5;      // arch height
CABLE_GUIDE_WIDTH      = 8;      // arch width
CABLE_GUIDE_THICKNESS   = 1.5;   // arch wall thickness

// Cable guide positions (Y along the slope)
CABLE_GUIDE_POSITIONS_Y = [110, 65, 20]; // between rows, toward the back

// -----------------------------------------------------------------------------
// Print resolution
// -----------------------------------------------------------------------------
$fn = 64;  // cylinder resolution
