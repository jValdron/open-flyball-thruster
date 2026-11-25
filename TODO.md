# TODO: hardware / design improvements

Mechanical changes from the November 2026 design review. None are modelled yet unless ticked.
Numbers marked "from the model" were measured in the SCAD files; check them against printed parts.

- [Hammer latch (touchy trigger)](#1-hammer-latch-touchy-trigger)
- [Hammer pivot: shoulder bolt](#2-hammer-pivot-shoulder-bolt)
- [Bushings: oilite instead of nylon](#3-bushings-oilite-instead-of-nylon)
- [Backstop: 10 mm thick](#4-backstop-10-mm-thick)
- [Hammer holders: stronger nut side](#5-hammer-holders-stronger-nut-side)
- [TPU bumper at the backstop](#6-tpu-bumper-at-the-backstop)
- [Pedal link: easier adjustment](#7-pedal-link-easier-adjustment)


## 1. Hammer latch (touchy trigger)

**Problem:** pedal feel is inconsistent; the hammer sometimes doesn't come up all the way, or comes up and then creeps down a bit.

**Why (from the model):** in the loaded position the shaft coupler's face pushes on the hammer head's top edge with the full main-spring force, about 15 mm above the M5 pivot and about 52 mm from it. That always tries to rotate the hammer down (towards firing). The latch is held mostly by friction at the contact, and the two balance at a friction coefficient of about 0.28, which is right where dry steel on aluminium sits. Small changes in surface condition change the pedal feel.

The pedal is *not* the cause: it already has play in the bolt and two return springs of its own.

Likely the hammer is caught part-way up: it's heavy (135 mm extrusion, pedal connector, bolt, nuts) and the 0.9 mm spring is light, so if the rod comes back before the head is fully up, the main spring pins it half-engaged.

- [ ] **Diagnose:** load slowly (hold the plunger back ~1 s, release gently).
  - Always fully up now → it's rise timing; do the spring/mass items below.
  - Still creeps down after full engagement → it's the latch geometry; more holding force (spring/leverage).
- [ ] **Diagnose:** with the thruster loaded and nothing touching the hammer, push it down and let go; check whether it snaps up crisply or drifts up.
- [ ] Stiffer hammer spring, same 8 mm OD × 10 mm: 1.0 mm wire (~1.5× stiffer) first, 1.2 mm (~3×) if needed. Adds directly to pedal force, so go one step at a time.
- [ ] Lighter hammer: shortest side extrusion the pedal linkage allows; minimal hardware on the hammer side.
- [ ] More leverage: move the spring hole from ~20 mm to ~13 mm from the front of the top extrusion (the hammer joint covers the first 8 mm). That's ~40 → ~47 mm from the pivot, about 17% more holding force. Spring holder slides forward to match; **check in the model that it clears the hammer joint through the swing.**
- [ ] Check the coupler face and the hammer head edge for a worn dent or groove. A steel collar or coupler would wear less than aluminium.
- Don't lubricate the latch faces (less friction means more likely to fire on its own).
- Rejected: bearing as the hammer head. It removes the friction that's currently holding the latch, so with this geometry it would fire on its own unless the hammer spring were much stronger.


## 2. Hammer pivot: shoulder bolt

**Problem:** the M5 screw's threads bear in a 5.5 mm hole in the top extrusion (~0.25 mm slop, which changes latch engagement), and it has to be tightened "by feel", which squeezes the PETG holders onto the hammer and drifts as PETG creeps.

- [ ] Replace with an **ISO 7379 shoulder bolt: D6 × M5 × 20 mm** (6 mm shoulder, 20 mm shoulder length, 10 mm thread, 10 × 4 mm head).
- How it clamps: the shoulder step bottoms on the nut-side holder's inner face and the nut pulls the nut pocket's 2 mm floor against it. The hammer turns on the 6 mm shoulder; the screw-side holder only needs a clearance hole and the head should *not* seat (both holders are already fixed to the extrusions with M3s).
- [ ] Model (option in `config.scad`):
  - Screw-side head counterbore **~1 mm deeper**. From the model, head seat to nut-side inner face is ~20.5 mm; 1 mm deeper (not just 0.5) guarantees the shoulder step bottoms before the head, with print tolerance. If the head lands first, the clamp squeezes the hammer again.
  - Head counterbore diameter 10 → ~10.5 mm (head is 10 mm).
  - Screw-side holder hole 5.2 → ~6.3 mm (shoulder passes through).
  - The 10 mm thread fully engages the nut and ends inside the nut pocket, so the thread length is fine.
- [ ] Nut: **M5 nyloc (DIN 985)**, 8 mm across flats × 5 mm, nylon side facing out (away from the pocket floor). It locks without bolt tension, which suits a pivot that's only snug, and it means no liquid threadlocker on the PETG (anaerobic threadlockers can stress-crack plastics). From the model, the thread passes ~3 mm past the nylon ring (needs ≥ 2 threads).
- [ ] Docs: drill the top extrusion to **6.0–6.1 mm** (was 5.5 mm). Tighten **snug**, not fully torqued: the shoulder step bears on a thin PETG ring (~7 mm²) that would crush over time. The shoulder keeps the hammer free regardless, so no more "tight but still swings". Drop the threadlocker step.


## 3. Bushings: oilite instead of nylon

**Problem:** the nylon T-washers need reaming, swell with humidity (friction and throw change day to day), and are short (~5 mm of bearing).

- [ ] Use flanged sintered-bronze (oilite) bushings **8×10×10, 15 × 1.2 mm flange**, in both the base and the backstop (with the backstop at 10 mm, see #4).
  - Check whether the listing's 10 mm length includes the flange; the numbers below assume it does (8.8 mm body).
- [ ] Config: `t_bushing_flange_od = 15`, `t_bushing_flange_thickness = 1.2`, `t_bushing_body_height = 8.8` (per the drawing), `linear_shaft_groove_depth = 1.2`.
- Base: body protrudes ~0.8 mm (up to 2 mm) into the faceplate's 2" hole. [ ] Check the plunger doesn't reach it at full load.
- The flange must stay on the inner (spring) side: it's the main spring's seat (the spring's ~9.6 mm inside diameter is smaller than the bushing's 10 mm body).
- [ ] Assembly docs: press in, **don't ream or drill** (it smears the bronze and closes the oil pores). A drop of superglue on the outside is fine. With the spring off, the rod must slide freely through both bushings; if it binds, loosen the backstop, let the rod centre it, retighten.


## 4. Backstop: 10 mm thick

So the backstop takes the same 8×10×10 bushing, ending flush with the rear face where the collar hits.

- [ ] `backstop_thickness` 8 → 10 (with `linear_shaft_groove_depth = 1.2`, the 8.8 mm body ends flush).
- [ ] Fix `thruster.scad`: it places the backstop with `plate_thickness * 2` instead of `plate_thickness + backstop_thickness` (only correct while both are 8 mm).
- [ ] Backstop screws: **M3 × 12 → M3 × 16** button head. From the model, a 10 mm backstop + 2 mm baffle leaves the M3 × 12 only ~1 mm into the extrusion ends (~3 mm today); M3 × 16 gives ~5 mm. Update the BOM, assembly docs and `thruster.scad` (it draws `l=12`).
- [ ] Check the 200 mm rod still leaves room behind the backstop for the rear collar (everything there moves back 2 mm).
- The backstop hasn't broken in a year of use, so no other strengthening needed. The collar lands on the steel baffle (keep the enlarged baffle hole under ~11 mm so it stays that way).


## 5. Hammer holders: stronger nut side

**Problem:** one nut-side holder broke above the M5 nut. Holders print lying flat, so the 2 mm of PETG over the nut pocket is a flat bridge, and the pocket is exactly 8.0 mm across the flats, so pushing the nut in spreads those walls.

- [ ] `hammer_holder_depth` 12 → 16 mm (both holders): 4 mm walls instead of 2 mm. The back face stays the same 8 mm from the backstop; it grows towards the front.
- [ ] Rotate the hex pocket so a corner points up when printed (self-supporting 60° roof, no bridge; ~3.4 mm at the thinnest point with 16 mm depth).
- [ ] Add 0.2–0.3 mm clearance to the nut pocket (config value, like `bushing_fit_clearance`).
- [ ] `m5_nut_depth` 4 → 5 for the nyloc nut (#2), so it sits fully in the pocket.
- The shoulder bolt (#2) also takes the clamp load off the nut pocket's walls, and the nyloc removes liquid threadlocker on the PETG (a possible contributor to the crack).
- Fallback if a 16 mm holder with a nyloc still cracks: M5 heat-set brass insert instead of a captive nut (no thin hex walls at all; bigger redesign).


## 6. TPU bumper at the backstop

When it fires, the rear collar hits the backstop with the full force of the rod, plunger and coupler. A thicker bumper spreads that out (lower peak force everywhere, quieter).

- [ ] New printed part: TPU bumper, 3–4 mm thick (separate STL with its own thickness setting, not the 2 mm washer), between the rear collar and the backstop.
- [ ] Make it standard in the BOM and assembly docs (the 2 mm washers are currently optional).
- [ ] Tuning docs: the plunger rest position moves by the bumper thickness; reset the rear collar.


## 7. Pedal link: easier adjustment

**Today:** pedal rod → M6 coupling barrel with a jam nut on each side → M6 bolt whose head sits loose in the pedal connector's cage. The pedal pulls the head against the cage's front wall to pull the hammer down; the cage gives free play so the hammer can rise on its own. Adjusting the link length (pedal sensitivity) means unlocking both jam nuts with two 10 mm sockets, turning the bolt, and relocking.

**Goal:** it's set once and rarely touched; when it does need a tweak (e.g. something shifted), it should be a quick single-tool (or no-tool) job instead of two wrenches and two jam nuts, and it must stay put. Not decided yet; options:

- [ ] **A. Thumbwheel in the cage (preferred so far).** Rod from the pedal goes straight into the cage, length set once at the pedal. The "head" becomes a printed knurled thumbwheel (~14 mm across, PETG at 100% infill) with a captive **M6 nyloc nut**; turn it with a finger through the cage's side window.
  - 1 mm per turn (M6 pitch), ~0.2 mm per knurl click; the nyloc holds the setting. No tools, no jam nuts.
  - The wheel also slides in the cage, so the free play works exactly as now.
  - Model: new thumbwheel part; cage redesign (larger side windows for finger access, wheel width instead of the bolt head). The cage inside is 15.2 mm wide, and the nyloc is ~11.5 mm across its corners, so the wheel's walls are thin; check this.
  - Buy: M6 nyloc nuts, M6 threaded rod (or keep the long bolt from the pedal).
- [ ] **B. Turnbuckle.** Replace the coupling barrel with one threaded left-hand at one end and right-hand at the other (plus matching rod/bolt). Turning just the barrel changes the length, twice as fast as now. Still needs jam nuts to lock, so still two wrenches. No printed changes.
- [ ] **C. Nyloc instead of jam nuts.** Use a nyloc on the adjusting end instead of the jam-nut pair. Smallest change, but adjustment is still a 10 mm hex and a wrench.
- [ ] **Optional with any of the above: M6 rod ends** (female ball joints) at one or both ends. Makes it a true "link" and stops binding when the pedal and hammer swing through different arcs. Only if the link ever feels like it catches.
