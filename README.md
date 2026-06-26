# MSSIAH Controller

3D-printable enclosure (case) for a DIY MSSIAH controller for the Commodore 64.
Designed in OpenSCAD — two-piece snap-together case with a 20° sloped face,
parametric dimensions, and integrated heat-set insert pockets.

## What is the MSSIAH controller?

[MSSIAH](https://mssiah.com/mssiah.php) is a cartridge/software suite that turns
the Commodore 64 into a MIDI workstation and synthesizer.

This project reproduces a custom physical controller enclosure inspired by the
build documented at [c64customs](https://c64customs.blogspot.com/2021/08/custom-diy-mssiah-controller.html).
The controller connects to the C64 via the **user port (CB8)** through a DB9
connector, and provides physical knobs, a joystick, and an arcade button to
interact with the MSSIAH software.

## STL models

Pre-built STL files are in the [`stl/`](stl/) directory once exported.

To generate them yourself from the parametric source:

1. Open `main.scad`, `bac.scad`, or `couvercle.scad` in [OpenSCAD](https://openscad.org/)
2. Hit **F6** to render
3. File → Export → Export as STL

| File | Part | Description |
|------|------|-------------|
| `stl/bac.stl` | Bac (bottom) | Flat base + walls + boss pillars + alignment lip |
| `stl/couvercle.stl` | Couvercle (top) | Sloped face with all control cutouts + DB9 opening |

> The `.scad` source is parametric — adjust dimensions in
> [`lib/dimensions.scad`](lib/dimensions.scad) before exporting to adapt the
> enclosure to different components or tolerances.

## Hardware list

### Electronic components

| Qty | Component | Key specs | Source |
|-----|-----------|-----------|--------|
| 4× | **Potentiometer** B10K rotary | Shaft Ø 9.7 mm, hex nut 13.85 mm AF, decorative washer Ø 41 mm, knob Ø 26.5 mm | [AliExpress](https://fr.aliexpress.com/item/32847136499.html) |
| 1× | **Joystick** analog (PS2-style) | Cap Ø 15 mm, PCB 34×34 mm, 4 mounting holes Ø 2.5 mm at 35 mm center distance | [AliExpress](https://fr.aliexpress.com/item/1005005367139157.html) |
| 1× | **Arcade button** Sanwa OBSF-30 | Snap-in, head Ø 30 mm, collar Ø 33 mm | [Amazon](https://www.amazon.fr/dp/B01MRWL6DW) |
| 1× | **DB9 connector** female 9-pin | Chassis-mount, body ~30×13 mm, 2 mounting holes | [AliExpress](https://fr.aliexpress.com/item/1005009405056447.html) |

### Fasteners & inserts

| Usage | Insert | Screw | Qty |
|-------|--------|-------|-----|
| Joystick mounting | M2.5 (Ø 3.5 ext, length 4 mm) | M2.5 × 8 mm | 4 |
| DB9 connector | M3 (Ø 5 ext, length 4 mm) | M3 × 8 mm | 2 |
| Case assembly (bac → couvercle) | M3 (Ø 5 ext, length 4 mm) | M3 × 10 mm | 4 |
| Potentiometers | — (hex nut M6 provided) | — | 4 |
| Arcade button | — (snap-in) | — | 1 |
| Feet | — | Adhesive pads Ø 11 mm ([AliExpress](https://fr.aliexpress.com/item/1005006618909639.html)) | 4 |

**Inserts to buy**: 4× M2.5 brass heat-set inserts (Ø 3.5 ext, length 4 mm).
M3 inserts (×6 total) are assumed already in inventory.

### Tools

- Soldering iron (or dedicated insert press) for heat-set inserts
- M2.5 and M3 hex drivers
- OpenSCAD (free, [openscad.org](https://openscad.org/)) to view or modify the model

## Project structure

```
.
├── main.scad          # Full assembly (view: assembled or exploded)
├── bac.scad           # Bottom half — base, walls, bosses, alignment lip
├── couvercle.scad     # Top half — sloped face, control cutouts, DB9 opening
├── lib/
│   ├── dimensions.scad   # All dimensional variables
│   ├── inserts.scad      # Parametric heat-set insert modules
│   ├── composants.scad   # Cutout modules for each component
│   └── passe_cables.scad # Internal cable-routing arches
├── stl/               # Exported STL files
├── PLAN.md            # Full design specification (in French)
├── CONTEXT.md         # Glossary & terminology (in French)
└── LICENSE
```

## Opening in OpenSCAD

Open `main.scad` to see the full assembly. Toggle the flags at the top:

```openscad
EXPLODED = true;        // true = exploded view, false = assembled
SHOW_BAC = true;
SHOW_COUVERCLE = true;
```

Set `EXPLODED = false` for a print-ready view before exporting.

## License

[Unlicense](LICENSE) — public domain. Do whatever you want.
