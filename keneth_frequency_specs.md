# Guitar Pickup Resonant Frequency Measurement Specs
## Keneth Frequency Project

---

## Overview

A guitar pickup is a parallel **LC resonant circuit**. The resonant frequency is the single most important parameter defining the pickup's tonal character.

```
f_resonant = 1 / (2π × √(L × C))
```

- **L** = coil inductance (Henries)
- **C** = distributed capacitance (Farads)

> **Source:** Helmuth Lemme, *"The Secrets of Electric Guitar Pickups,"* originally published in *Electronic Musician*, December 1986. Republished at http://www.buildyourguitar.com/resources/lemme/

### Scope of Application

This measurement system is **entirely generic** and works on any passive guitar or bass pickup regardless of type, manufacturer, or output level. The **Seymour Duncan JB SH-4 is used only as a verification reference** — its DCR and resonant frequency are well-documented by third-party measurements, providing a known result to confirm the system is working correctly before testing unknown pickups.

**Active pickups (e.g. EMG, Fishman Fluence)** are the one category this system cannot characterise — the onboard preamp masks the passive LC behaviour entirely.

---

### Resonant Frequency Reference by Pickup Type (Unloaded)

| Pickup Type | Typical DCR | Typical Inductance | Typical Resonant Freq | Multimeter Range |
|---|---|---|---|---|
| Single coil — Strat | 5–7 kΩ | 2–3 H | 7–12 kHz | 20 kΩ |
| Single coil — Tele bridge | 6–8 kΩ | 2.5–3.5 H | 8–11 kHz | 20 kΩ |
| Single coil — Tele neck | 6–8 kΩ | 3–4 H | 7–10 kHz | 20 kΩ |
| P-90 | 7–10 kΩ | 4–6 H | 5–8 kHz | 20 kΩ |
| Humbucker — PAF-style (low output) | 7–9 kΩ | 4–6 H | 5–7 kHz | 20 kΩ |
| Humbucker — medium output (e.g. SH-4 JB) | 14–17 kΩ | 7–10 H | 4–6 kHz | 20 kΩ |
| Humbucker — high output | 16–20 kΩ | 10–15 H | 2–4 kHz | 20 kΩ |
| Bass — single coil (J-style) | 6–10 kΩ | 3–6 H | 4–8 kHz | 20 kΩ |
| Bass — split humbucker (P-style) | 8–12 kΩ | 6–10 H | 2–5 kHz | 20 kΩ |
| Active pickup (EMG, Fluence, etc.) | 50–200 Ω | N/A | **Not measurable** | 2 kΩ |

> **Note:** These are typical ranges compiled from community measurements. Individual pickups vary significantly within each type. Resonant frequencies listed are unloaded — connecting any cable, pot, or load will shift the peak downward.

> **Sources:** Bedlam Guitars, *"Pickup Inductance"* — https://bedlamguitars.wordpress.com/technical-info/pickup-inductance/ ; GuitarNutz 2, *"Seymour Duncan Resonant Frequency Testing,"* thread 10355 — https://guitarnuts2.proboards.com/thread/10355/seymour-duncan-resonant-frequency-testing ; Helmuth Lemme resonant frequency table — http://www.buildyourguitar.com/resources/lemme/table.htm

### Adjustments When Testing Different Pickups

| Parameter | Adjustment |
|---|---|
| Multimeter range | Match to expected DCR (see table above) |
| REW sweep range | Widen to 20 Hz – 20 kHz to cover all pickup types |
| Expected peak location | Use table above to know where to look |
| Exciter gap | May need reducing for low-output pickups to improve SNR |
| Input gain (2i2) | Increase slightly for low-output pickups if signal is weak |

---

## Exciter Coil Specifications

| Parameter | Value |
|---|---|
| Wire gauge | 42 AWG enameled magnet wire |
| Wire diameter (bare) | 0.064 mm |
| Wire resistance | ~5.4 Ω/m |
| Turn count | 150–250 turns (200 recommended) |
| Bobbin diameter | 15–20 mm |
| Bobbin material | Non-magnetic (plastic, wood, 3D-printed) |
| Core type | Air core or ferrite rod (AM radio bar antenna) |
| Target inductance | 1–10 mH |
| Estimated DCR (200 turns) | ~59 Ω |

### 42 AWG Wire Specifications

- Nominal bare conductor diameter: **0.0640 mm** (range 0.0610–0.0660 mm)
- Resistance at 20°C: **~5.4 Ω/m** (varies slightly by insulation build)
- Maximum winding tension: 24 grams
- Breakdown voltage: 425–700 V depending on insulation grade

> **Sources:**
> - ELEKTRISOLA, *"Technical Data by Size"* — https://www.elektrisola.com/en-us/Products/Enamelled-Wire/Technical-Data
> - Schatten Pickups, *"42 Gauge Vintage Plain Enamel Coil Wire"* — https://schatten-pickups.myshopify.com/products/42-gauge-vintage-plain-enamel-coil-wire (lists 1,652 Ω/1,000 ft ≈ 5.42 Ω/m)
> - IEC-60317-0-1 standard via Encyclopedia Magnetica — https://e-magnetica.pl/doku.php/enamelled_wire/iec_dimensions

> **Note:** 42 AWG is described as *"the most common gauge of wire used in building and rewinding most modern electric guitar and bass pickups,"* used for Stratocaster, Telecaster bridge, and Humbucker pickups.
> — Schatten Pickups product page (above)

### DCR Calculation

```
200 turns × 0.055 m/turn (mean circumference, 17.5 mm bobbin) × 5.4 Ω/m ≈ 59 Ω
```

### Winding Notes

- Wind slowly by hand — 42 AWG is fragile; maximum winding tension is only 24 grams
- Secure lead ends with cyanoacrylate glue before and after winding
- 200 turns single-layer on 15 mm bobbin: wire diameter 0.064 mm fits in ~13 mm of bobbin length
- Multiple layers increase interwinding capacitance slightly — negligible at these inductance values

### Validated Exciter Coil Design Variants

Community testing has confirmed consistent frequency response results across significantly different coil designs:

| Design | Turns | Wire gauge | Series R | DCR | Inductance |
|---|---|---|---|---|---|
| Lemme (Pickup Analyzer) | 50 | 24 AWG (0.5 mm) | None (constant-current source) | ~5 Ω | — |
| Willmott | ~50 | 30 AWG | 100 Ω | ~5 Ω | — |
| "Axetech" (DIY audio interface) | 100–200 | 41–44 AWG | — | 118–177 Ω | 0.6–1.4 mH |
| **This project** | **200** | **42 AWG** | **220 Ω** | **~59 Ω** | **~0.9 mH** |

> **Source:** GuitarNutz 2, *"Exciter / driver coil designs for pickup frequency response,"* thread 11055 — https://guitarnuts2.proboards.com/thread/11055/exciter-driver-designs-frequency-response

---

## Equipment

| Item | Specification |
|---|---|
| Audio Interface | Focusrite Scarlett 2i2 (4th Generation) |
| Sample Rate | 48 kHz or 96 kHz |
| Bit Depth | 24-bit |
| Measurement Software | Room EQ Wizard (REW) — free |
| Verification Pickup | Seymour Duncan JB SH-4 |

### Focusrite Scarlett 2i2 4th Generation Specifications

| Parameter | Value |
|---|---|
| Hi-Z (Instrument) input impedance | 1 MΩ |
| Line input impedance | 60 kΩ |
| Maximum input level (line) | +22 dBu |
| Dynamic range (ADC) | 111 dB |
| Frequency response | 20 Hz – 20 kHz (±0.06 dB) |
| Output impedance | 240 Ω |
| Maximum output level | +14 dBu |

> **Source:** Focusrite, *Scarlett 2i2 4th Gen Specifications* — https://userguides.focusrite.com/hc/en-gb/articles/19640392541202-Scarlett-2i2-Specifications

---

## Signal Chain

```
[2i2 Output 1 (TRS)] → 220Ω series resistor → [Exciter Coil] → GND

[Pickup Under Test] → short cable (<30 cm) → [2i2 Input 1 (Hi-Z)]
```

### Scarlett 2i2 4th Gen Input Impedance

| Input | Impedance |
|---|---|
| Hi-Z (Instrument) | 1 MΩ |
| Line | 60 kΩ |

> **Source:** Focusrite, *Scarlett 2i2 4th Gen Specifications* — https://userguides.focusrite.com/hc/en-gb/articles/19640392541202-Scarlett-2i2-Specifications

### Series Resistor by Turn Count

| Turns | Estimated DCR | Series Resistor | Drive Flatness (100 Hz–10 kHz) |
|---|---|---|---|
| 150 | ~44 Ω | 330 Ω | ~±1.5 dB |
| 200 | ~59 Ω | 220 Ω | ~±1.5 dB |
| 250 | ~74 Ω | 150 Ω | ~±1.5 dB |

### Current Draw Check (200 turns, 220Ω series R, -6 dBFS ≈ 1V peak)

```
I_peak = 1V / (220 + 59)Ω ≈ 3.6 mA
```

Well within 42 AWG handling limits at low signal levels.

### Input Side — Use Hi-Z Input, Not Line

The pickup's resonant impedance can reach **200+ kΩ** at the resonant peak. The measurement input must be significantly higher than this to avoid loading the circuit and shifting the peak downward.

- **Hi-Z input (1 MΩ on 4th Gen):** Near-unloaded measurement — correct ✓
- **Line input (60 kΩ):** Significantly loads the pickup, suppresses and shifts peak downward ✗

> **Source:** jensign.com, *"Measuring Electric-Guitar Pickup Impedance with Digilent Analog Discovery"* — https://www.jensign.com/Discovery/Pickup/index.html

---

## Exciter Coil Positioning

- Position face-to-face with pickup, centered over pole pieces
- Starting gap: **10 mm** — adjust for signal strength
- Coil axis must be parallel to pickup coil axis
- Clamp in non-magnetic fixture (plastic, wood)
- Keep all metal objects **30+ cm away** during measurement

> **Source:** Ken Willmott, *"Electric Guitar Pickup Measurements"* — https://kenwillmott.com/blog/archives/152

---

## Measurement Procedure

### 0. DCR Measurement (Before Frequency Sweep)

Measure DC resistance first, before connecting the pickup to the 2i2. This ensures the pickup is isolated with no parallel load paths skewing the reading.

**Equipment:** Digital multimeter set to resistance (Ω)

**Steps:**
1. Disconnect the pickup from all other circuitry (no pots, switches, cables to the interface)
2. Set multimeter to the **20 kΩ range** (SH-4 expected ~16.5 kΩ — a 200 Ω or 2 kΩ range will not reach it)
3. Place probes across the pickup output leads: **tip (hot) and sleeve (ground/cold)**
4. Allow the reading to stabilise — typically 2–3 seconds
5. Record the value in ohms

**Expected result for SH-4:** 16,400 – 16,600 Ω (~16.5 kΩ)

> **Note:** DCR is temperature-dependent — copper resistance increases ~0.4%/°C. A reading taken in a cold workshop will be slightly lower than one taken at room temperature. Record ambient temperature alongside DCR for completeness.

> **Note:** For a humbucker, this reading is both coils measured in series. Individual coil DCR (each ~8.1–8.4 kΩ for the SH-4) can be measured if the pickup has a 4-conductor harness by measuring each coil pair separately.

**After recording DCR**, reconnect the pickup to the Hi-Z input of the 2i2 and proceed with the frequency sweep.

---

### 1. REW Setup

1. Preferences → Audio System → select **Scarlett 2i2 (4th Gen)** for input and output
2. Set sample rate to 48 kHz
3. Preferences → Levels → output at -12 to -6 dBFS, input showing clean signal without clipping

REW uses a **logarithmic swept sine** method — spending equal time per octave. A log sweep achieves far higher SNR than impulse-based methods by sustaining the test signal over many seconds.

> **Source:** Room EQ Wizard documentation, *"Getting Started with REW"* — https://www.roomeqwizard.com/help/help_en-GB/html/gettingstarted.html

### 2. Calibration (Remove Exciter Coloration)

1. Connect a **1 MΩ resistor** in place of the pickup
2. Run a 20 Hz → 15 kHz log sweep (15–30 seconds)
3. Save as reference measurement

### 3. Pickup Measurement

1. Connect pickup under test
2. Run the same log sweep
3. Overlay or subtract reference to divide out exciter frequency response
4. Identify resonant peak

### Alternative Software

- **Audacity** — Generate → Chirp (supports log interpolation, 1 Hz to 22 kHz); analyze via Analyze → Plot Spectrum (window size 65536)
  > Source: Audacity Manual, *"Chirp"* — https://manual.audacityteam.org/man/chirp.html
- **RMAA (Rightmark Audio Analyzer)** — used by Ken Willmott in his published pickup measurement system
  > Source: Ken Willmott, https://kenwillmott.com/blog/archives/152

---

## Formulas

### Resonant Frequency

```
f = 1 / (2π × √(L × C))
```

### Solving for Inductance (using a known added capacitor)

Add a known external capacitor C_ext in parallel with the pickup, record the new resonant frequency f_c:

```
L = 1 / [(2π × f_c)² × C_ext]
```

### Solving for Intrinsic Winding Capacitance

Remove external capacitor, record self-resonance frequency f_self:

```
C_winding = 1 / [(2π × f_self)² × L]
```

> **Source:** Ken Willmott, *"Electric Guitar Pickup Measurements"* — https://kenwillmott.com/blog/archives/152

### Effect of Cable/Load Capacitance

```
f_loaded = 1 / (2π × √(L × (C_pickup + C_cable + C_load)))
```

**Example (Lemme):** 8 H inductance, 800 pF cable + 150 pF winding = 950 pF total:
```
f = 1 / (2π × √(8 × 950×10⁻¹²)) ≈ 1,827 Hz
```
Cable loading alone drops a humbucker's resonance deep into the midrange.

> **Source:** Helmuth Lemme, *"The Secrets of Electric Guitar Pickups"* — http://www.buildyourguitar.com/resources/lemme/

### Q Factor

```
Q = f_resonant / bandwidth    (bandwidth measured at -3 dB points either side of peak)
```

---

## Seymour Duncan JB SH-4 Reference Values

> **Important note:** Seymour Duncan does not publish inductance, capacitance, or resonant frequency for the SH-4. All values below come from independent third-party measurements. Unit-to-unit variation is real — inductance ranges from ~7.7 H (vintage JBJ-era) to ~9.6 H (current production).
> — Seymour Duncan official product page (DCR and magnet only): https://www.seymourduncan.com/single-product/jb-model

### Measured Specifications

| Parameter | Vintage JBJ-Era | Current Production | Source |
|---|---|---|---|
| DC Resistance | ~16.4–16.6 kΩ | ~16.6 kΩ | Darth Phineas |
| Inductance (series) | ~7.75–7.89 H | ~9.6 H | Darth Phineas |
| Series DCR | ~16.5 kΩ | ~16.56 kΩ | GuitarNutz 2 |
| Series inductance | — | 8.059 H | GuitarNutz 2 |
| Self-capacitance (series) | — | 128 pF | GuitarNutz 2 |
| **Resonant freq (unloaded)** | — | **~4.78 kHz** | GuitarNutz 2 |
| Resonant freq (200kΩ + 470 pF load) | — | ~1.96 kHz | GuitarNutz 2 |
| Magnet | Alnico 5 | Alnico 5 | Seymour Duncan |

> **Sources:**
> - Darth Phineas, *"Seymour Duncan JB – Current Production"* — https://darthphineas.com/2016/11/seymour-duncan-jb/
> - Darth Phineas, *"Seymour Duncan JB – The JBJ Era"* — https://darthphineas.com/2016/11/seymour-duncan-jbj/
> - GuitarNutz 2, *"Seymour Duncan JB & Jazz Neck, Analysis & Review,"* thread 8032 — https://guitarnuts2.proboards.com/thread/8032/seymour-duncan-jazz-analysis-review
> - Bedlam Guitars, *"Pickup Inductance"* (lists SH-4 at 8.54 H, DCR 16.2 kΩ) — https://bedlamguitars.wordpress.com/technical-info/pickup-inductance/

### Correction: The "5.5 kHz" Figure

The ~5.5 kHz resonant frequency commonly cited in online references could **not be sourced to any measurement of an actual SH-4** in this research. The 5.5 kHz figure is confirmed for the **Seymour Duncan SH-1b** (a different, lower-inductance pickup: L = 4.2 H, C = 200 pF):

```
f = 1 / (2π × √(4.2 × 200×10⁻¹²)) ≈ 5,500 Hz  ← SH-1b, not SH-4
```

> **Source:** jensign.com, *"Measuring Electric-Guitar Pickup Impedance"* — https://www.jensign.com/Discovery/Pickup/index.html

**The best-sourced unloaded resonant frequency for the SH-4 JB is ~4.78 kHz** (GuitarNutz 2, measured sample). Use this as the verification target.

### Formula Verification (SH-4, current production)

Using L = 8.06 H and C = 128 pF (GuitarNutz 2 measured values):

```
f = 1 / (2π × √(8.06 × 128×10⁻¹²))
f = 1 / (2π × 3.213×10⁻⁵)
f ≈ 4,951 Hz  ✓  (consistent with measured ~4.78 kHz)
```

---

## Expected Measurement Result (SH-4, Hi-Z input)

| Parameter | Expected Value |
|---|---|
| Resonant peak frequency | **~4.78–5.0 kHz** |
| Peak amplitude above 1 kHz baseline | 8–15 dB |
| Loading effect (200 kΩ + 470 pF) | drops to ~1.96 kHz |
| Q (unloaded) | ~2.5–4 |

---

## Common Pitfalls

| Issue | Cause | Fix |
|---|---|---|
| Peak too low | Input impedance loading | Use Hi-Z input; avoid line input (60 kΩ) |
| No visible peak | Weak coupling or gain too low | Reduce exciter gap; check gain settings |
| Peak shifts between runs | Metal objects nearby or loose exciter | Remove metal; fixture coil rigidly |
| Excessive 50/60 Hz hum | High-EMI environment | Move away from monitors/PSUs; use REW averaging |
| Non-flat drive response | Series resistor too small | Increase series resistor; run calibration reference sweep |

> Loading effect demonstrated: SH-4 unloaded = 4.78 kHz; with 200 kΩ + 470 pF load = 1.96 kHz (frequency dropped by more than a factor of 2).
> — GuitarNutz 2, thread 8032

---

## Pre-Measurement Checklist

```
□ Exciter coil wound on non-magnetic former (42 AWG, 200 turns)
□ 220Ω series resistor on Output 1 line
□ Short cable (<30 cm) from pickup to interface
□ All metal objects cleared 30+ cm from test area

DCR MEASUREMENT (before connecting to 2i2):
□ Pickup disconnected from all circuitry
□ Multimeter set to 20 kΩ range
□ DCR measured across hot and ground leads
□ DCR value recorded (expected SH-4: 16,400–16,600 Ω)
□ Ambient temperature noted alongside DCR reading

FREQUENCY SWEEP:
□ Pickup reconnected to Hi-Z input on 2i2 (not line input)
□ Scarlett 2i2 4th Gen set to 48 kHz, 24-bit
□ Calibration reference sweep completed (1 MΩ load)
□ Output level -12 to -6 dBFS; input not clipping
□ Exciter coil face-to-face with pickup at ~10 mm gap
□ Looking for resonant peak at ~4.78–5.0 kHz (SH-4 verification target)
```

---

## Full Source List

| Source | URL |
|---|---|
| Helmuth Lemme, *"The Secrets of Electric Guitar Pickups"* (Electronic Musician, Dec 1986) | http://www.buildyourguitar.com/resources/lemme/ |
| Lemme resonant frequency table | http://www.buildyourguitar.com/resources/lemme/table.htm |
| Lemme, *Electric Guitar: Sound Secrets and Technology* (2nd Ed., 2020) | https://www.amazon.com/dp/1907920870 |
| Ken Willmott, *"Electric Guitar Pickup Measurements"* | https://kenwillmott.com/blog/archives/152 |
| Ken Willmott, *"Guitar Pickup Measurement Revisited"* | https://kenwillmott.com/blog/archives/284 |
| guitmod.wordpress.com, *"DIY: Simple Measurement of a Pickup's Frequency Response"* | https://guitmod.wordpress.com/2016/09/26/diy-simple-measuring-of-a-pickups-frequency-response/ |
| GuitarNutz 2, *"Exciter/driver coil designs,"* thread 11055 | https://guitarnuts2.proboards.com/thread/11055/exciter-driver-designs-frequency-response |
| GuitarNutz 2, *"Seymour Duncan JB & Jazz Neck, Analysis & Review,"* thread 8032 | https://guitarnuts2.proboards.com/thread/8032/seymour-duncan-jazz-analysis-review |
| GuitarNutz 2, *"Seymour Duncan Resonant Frequency Testing,"* thread 10355 | https://guitarnuts2.proboards.com/thread/10355/seymour-duncan-resonant-frequency-testing |
| Darth Phineas, *"Seymour Duncan JB – Current Production"* | https://darthphineas.com/2016/11/seymour-duncan-jb/ |
| Darth Phineas, *"Seymour Duncan JB – The JBJ Era"* | https://darthphineas.com/2016/11/seymour-duncan-jbj/ |
| Seymour Duncan, JB Model SH-4 official product page | https://www.seymourduncan.com/single-product/jb-model |
| Bedlam Guitars, *"Pickup Inductance"* | https://bedlamguitars.wordpress.com/technical-info/pickup-inductance/ |
| jensign.com, *"Measuring Electric-Guitar Pickup Impedance"* | https://www.jensign.com/Discovery/Pickup/index.html |
| SOUNDREF, *"Scarlett 2i2 Spec Comparison – All Generations"* | https://soundref.com/focusrite-scarlett-2i2-spec-comparison-1st-2nd-3rd-4th-generations/ |
| GroupDIY Audio Forum, *"Scarlett i2 instrument input impedance"* | https://groupdiy.com/threads/scarlett-i2-instrument-input-impedance.68459/ |
| Focusrite, Scarlett 2i2 4th Gen Specifications (primary reference) | https://userguides.focusrite.com/hc/en-gb/articles/19640392541202-Scarlett-2i2-Specifications |
| ELEKTRISOLA, *"Technical Data by Size"* | https://www.elektrisola.com/en-us/Products/Enamelled-Wire/Technical-Data |
| Encyclopedia Magnetica, IEC-60317-0-1 wire dimensions | https://e-magnetica.pl/doku.php/enamelled_wire/iec_dimensions |
| Schatten Pickups, *"42 Gauge Vintage Plain Enamel Coil Wire"* | https://schatten-pickups.myshopify.com/products/42-gauge-vintage-plain-enamel-coil-wire |
| Remington Industries, *"Magnet Wire, 42 AWG Enameled Copper"* | https://www.remingtonindustries.com/magnet-wire/magnet-wire-42-awg-enameled-copper-5-spool-sizes-2-colors/ |
| Audacity Manual, *"Chirp Generator"* | https://manual.audacityteam.org/man/chirp.html |
| Room EQ Wizard, *"Getting Started"* documentation | https://www.roomeqwizard.com/help/help_en-GB/html/gettingstarted.html |
| Planet Z, *"Pickup Measuring Techniques"* (Lemme article reference) | https://www.planetz.com/pickup-measuring-techniques/ |
| Music Electronics Forum, Helmuth Lemme Pickup Analyzer thread 38937 | https://music-electronics-forum.com/forum/instrumentation/pickup-makers/tools-and-coil-winding-gear/38937-helmuth-lemme-pickup-analyzer |
| Fractal Audio Wiki, *"Input Impedance"* | https://wiki.fractalaudio.com/wiki/index.php?title=Input_impedance |
