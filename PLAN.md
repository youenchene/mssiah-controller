# Plan — MSSIAH Controller Enclosure (OpenSCAD)

## Objective

Reproduce the MSSIAH controller enclosure (https://c64customs.blogspot.com/2021/08/custom-diy-mssiah-controller.html) to control the C64 via the CB8 port (https://mssiah.com/mssiah.php). The enclosure is 3D printed, designed in OpenSCAD, and assembled around the pre-existing electronics.

## Design Decisions

### Enclosure

| Parameter | Value |
|---|---|
| Architecture | 2 halves: bottom (lower) + cover (upper) |
| Split | Horizontal, junction plane at the rim |
| External dimensions | 120 × 160 mm (width × depth) |
| Front height (bottom of slope) | 25 mm |
| Back height (top of slope) | 83 mm (25 + 160·tan 20°) |
| Slope angle | 20°, back high, front low |
| Wall thickness | 2.5 mm |
| Bottom base thickness | 2.5 mm |
| Ventilation | None (passive electronics) |

### Assembly of the Two Halves

| Parameter | Value |
|---|---|
| Mechanism | Male lip on the bottom + female groove in the cover |
| Male lip (bottom) | 2 mm thick, 3 mm high |
| Groove (cover) | 2.2 mm wide, 3.2 mm deep |
| Radial clearance | 0.2 mm |
| Axial clearance | 0.2 mm |
| Groove entry chamfer | 0.5 mm × 45° |
| Fixation | 4 M3 inserts (Ø 5 ext, length 4 mm) in the bottom bosses |
| Assembly screws | M3 × 10 mm (×4) |
| Through-hole in cover rim | Ø 3.2 mm |

### Control Layout (sloped face)

Coordinate system: origin at bottom-left corner (front-left as seen by operator). X = width (0–120), Y = length along the slope (0–~170).

| Control | X (mm) | Y (mm) | Row |
|---|---|---|---|
| Joystick | 30 | 130 | 1 (back) |
| Arcade button | 90 | 130 | 1 (back) |
| Potentiometer P1 | 38.5 | 85 | 2 (middle) |
| Potentiometer P2 | 81.5 | 85 | 2 (middle) |
| Potentiometer P3 | 38.5 | 40 | 3 (front) |
| Potentiometer P4 | 81.5 | 40 | 3 (front) |

```
        0     30      38.5   81.5    90      120
        │     │        │      │       │       │
  170 ──┼─────────────────────────────────────┼── back
        │     │        │      │       │       │
        │  [JOY]      │      │    [BTN]      │  row 1
        │     │        │      │       │       │
   85 ──┼─────┤       [P1]  [P2]     ├───────┼── row 2
        │     │        │      │       │       │
   40 ──┼─────┤       [P3]  [P4]     ├───────┼── row 3
        │     │        │      │       │       │
    0 ──┼─────────────────────────────────────┼── front
```

### Component Mounting

#### Potentiometers (×4)

| Parameter | Value |
|---|---|
| Pass-through hole (shaft Ø 9.7) | Ø 10 mm |
| Local reinforcement | Ø 22 mm, thickness 4 mm |
| Hexagonal socket (embedded nut) | 14 mm across-flats, depth 4 mm |
| Nut | M6 supplied (13.85 mm across-flats) |
| Decorative outer washer | Ø 41 mm |
| Inner washer | Ø 10 int / 15 ext |
| Knob | Ø 26.5 mm, screw-on |
| Body | Ø 28 mm, height 12.6 mm under the face |
| Fixation | Embedded hex nut (anti-rotation) + washer + external nut |

#### Joystick (×1)

| Parameter | Value |
|---|---|
| Pass-through hole (cap + base) | Ø 32 mm |
| Local reinforcement | 45 × 45 mm, thickness 6 mm |
| Insert spacing | 35 × 35 mm |
| Inserts | M2.5, brass, Ø 3.5 ext, length 4 mm (to purchase) |
| Plastic drilling | Ø 3.0 mm, depth 5 mm |
| Screws | M2.5 × 8 mm (×4) |
| Cap | Ø 15 mm |
| PCB | 34 × 34 mm, 4 holes Ø 2.5 mm |

#### Arcade Button Sanwa OBSF-30 (×1)

| Parameter | Value |
|---|---|
| Pass-through hole | Ø 30 mm |
| Face thickness (no reinforcement) | 2.5 mm |
| Fixation | Snap-in (screwless, spring-loaded collar) |
| Collar | Ø 33 mm |
| Depth under the face | ~40 mm |
| Available height at Y=130 | ~64 mm → OK |

#### DB9 (×1)

| Parameter | Value |
|---|---|
| Face | Back (vertical) |
| Position | X=60 mm (centered), Y=20 mm from bottom |
| Cutout | 32 × 15 mm (rectangle) |
| Inserts | M3, brass, Ø 5 ext, length 4 mm (×2) |
| Insert spacing | ~25 mm |
| Plastic drilling | Ø 4.0 mm, depth 5 mm |
| Screws | M3 × 8 mm (×2) |
| Local reinforcement (back face) | 45 × 20 mm, thickness 6 mm |

### Bottom Structure (lower half)

| Parameter | Value |
|---|---|
| Base | 120 × 160 mm, thickness 2.5 mm |
| Walls | 4 vertical walls, thickness 2.5 mm |
| Fixation bosses | 4 pillars Ø 10 mm at corners, M3 inserts |
| Boss position | ~10 mm from edges |
| Foot pads | 4 × Ø 11 mm (adhesive, under the base) |
| Stiffening ribs | 2 diagonals on the base |
| Internal structure | Empty (components are carried by the cover) |

### Cover Structure (upper half)

| Parameter | Value |
|---|---|
| Sloped face | Plane at 20°, 120 × ~170 mm |
| Walls | 4 vertical walls (front 25 mm, back 83 mm, 2 trapezoidal sides) |
| Local reinforcements | At component locations (see above) |
| Cable guides | 3 arches printed on the inner face |
| Peripheral groove | 2.2 × 3.2 mm, chamfer 0.5 × 45° |

### Cable Guides (×3)

Positioned on the inner face of the cover to guide cables toward the DB9 (back):
- Cable guide 1: between row 1 and DB9 (guides joystick + button cables)
- Cable guide 2: between row 2 and row 1 (guides P1/P2 cables)
- Cable guide 3: between row 3 and row 2 (guides P3/P4 cables)

Arches ~5 mm high, cables pass underneath.

## Fasteners Inventory

| Use | Insert | Screw | Quantity |
|---|---|---|---|
| Joystick | M2.5, Ø 3.5 ext, length 4 mm | M2.5 × 8 mm | 4 |
| DB9 | M3, Ø 5 ext, length 4 mm | M3 × 8 mm | 2 |
| Bottom/cover assembly | M3, Ø 5 ext, length 4 mm | M3 × 10 mm | 4 |
| Potentiometers | None (M6 nut supplied) | M6 nut supplied | 4 |
| Arcade button | None (snap-in) | — | — |
| Foot pads | None | Adhesive | 4 |

**Total inserts to purchase**: 4 × M2.5 (Ø 4 ext, length 4 mm)
**Total screws**: 4 × M2.5×8, 2 × M3×8, 4 × M3×10

## OpenSCAD Project Structure

```
mssiah-controller/
├── CONTEXT.md              # Glossary (project terminology)
├── PLAN.md                 # This file
├── main.scad               # Full assembly (3D view)
├── bottom.scad             # Lower half (bottom)
├── cover.scad              # Upper half (cover + sloped face)
├── lib/
│   ├── dimensions.scad    # All dimensional variables
│   ├── inserts.scad        # Heat-set insert modules (models)
│   ├── components.scad    # Drill/cutout modules for each component
│   └── cable_guides.scad   # Cable guide modules
└── stl/                    # Exported STL files (generated)
    ├── bottom.stl
    └── cover.stl
```

## Build Order

1. **`lib/dimensions.scad`** : All variables (dimensions, positions, angles)
2. **`lib/inserts.scad`** : Parametric insert modules (drill hole + socket)
3. **`lib/components.scad`** : Cutout modules for each component (pot, joystick, button, DB9)
4. **`lib/cable_guides.scad`** : Cable guide arch module
5. **`cover.scad`** : Assembly of sloped face + walls + reinforcements + cutouts + cable guides + groove
6. **`bottom.scad`** : Assembly of base + walls + bosses + ribs + lip + feet
7. **`main.scad`** : Assembly of both halves (exploded + closed 3D view)
8. **STL export** : `bottom.stl` and `cover.stl`

## Reference Views

### Side Profile (from the right)

```
        back                      front
       83mm                      25mm

   83mm ┌─╲
        │   ╲
        │     ╲
        │       ╲
        │         ╲
        │           ╲
        │             ╲
        │               ╲
        │                 ╲
        │                   ╲
        │                     ╲
        │                       ╲
        │                         ╲
        │                           ╲
   25mm │                             └──┐
        └──────────────────────────────────┘
        ←──────────── 160 mm ──────────────→
```

### Sloped Plane View (control layout)

```
        ←──────── 120 mm ────────→
   ┌──────────────────────────────────┐
   │                                  │  ← back (top of slope)
   │   [JOY]                  [BTN]   │   row 1
   │                                  │
   │          [P1]      [P2]         │   row 2
   │                                  │
   │          [P3]      [P4]          │   row 3
   │                                  │  ← front (bottom of slope)
   └──────────────────────────────────┘
   ←────────── ~170 mm ──────────────→
```

### Back View (DB9)

```
        ←──────── 120 mm ────────→
   83mm ┌──────────────────────────┐
        │                          │
        │                          │
        │                          │
        │      ┌────────┐          │
   20mm │      │  DB9   │          │
        │      └────────┘          │
        │  ◯               ◯       │  ← M3 inserts
        └──────────────────────────┘
```
