# Keneth Frequency

**Keneth Frequency** is a macOS app that figures out the resonant frequency of a guitar pickup — automatically. Instead of spending an hour setting up REW, running sweeps by hand, and squinting at graphs, you plug in your pickup, press a button, and the app gives you a number.

---

## What is a resonant frequency, and why does it matter?

Every guitar pickup has a resonant frequency — a specific pitch where the pickup's electrical circuit naturally resonates (kind of like how a wine glass rings at a specific note when you tap it). This frequency lives in the audio range, usually somewhere between 2,000 Hz and 12,000 Hz depending on the pickup type.

The resonant frequency is the single biggest factor in how a pickup sounds:

- **High resonant frequency (8–12 kHz):** bright, clear tone — typical of single-coil pickups like a Stratocaster bridge pickup
- **Mid resonant frequency (4–6 kHz):** warm but present — typical of humbuckers like a Seymour Duncan JB SH-4
- **Low resonant frequency (2–4 kHz):** thick, dark tone — typical of bass pickups

Keneth Frequency measures this number so you can compare pickups, verify a rewound pickup sounds right, or just satisfy your curiosity about what's inside your guitar.

---

## What you need before you start

### Hardware

| Item | Why you need it |
|---|---|
| **Focusrite Scarlett 2i2 (4th Generation)** | This is the audio interface the app is designed for. It captures the pickup's signal and plays back the test tone. |
| **Exciter coil** | A small coil of wire that plays a test sweep tone near the pickup to excite it. See below for how to make one. |
| **220Ω resistor** | Limits the current going to the exciter coil so you don't damage the interface output. |
| **Short cable (under 30 cm / 12 inches)** | Connects the pickup to the Scarlett's Hi-Z input. Shorter is better — a long cable changes the measurement. |
| **Digital multimeter** | For measuring the pickup's DC resistance (DCR) before the sweep. |
| **1 MΩ resistor** | Used during calibration in place of the pickup. |
| **Non-magnetic fixture** | Plastic or wood clamp to hold the exciter coil in place. Nothing metal. |

> **Note:** This app does **not** work with active pickups (EMG, Fishman Fluence, etc.). Active pickups have a built-in preamp that hides the resonant behaviour.

### Making the exciter coil

You need a small coil of 42 AWG wire wound around a non-magnetic former (plastic, wood, or cardboard tube). Wind about **200 turns**. This is a one-time build — once you have it, you can use it for every pickup you ever measure.

---

## Getting started

### Step 1 — Install the app

1. Download the latest release from the Releases page on GitHub.
2. Open the `.dmg` file and drag `Keneth Frequency.app` into your Applications folder.
3. The first time you open it, macOS will ask for permission to use your audio input and output. Click **Allow** — the app needs this to record the pickup signal and play the test tone.

### Step 2 — Connect the hardware

Wire everything up like this:

```
Scarlett Output 1 (TRS)  →  220Ω resistor  →  Exciter Coil  →  Ground

Pickup (hot + ground leads)  →  short cable  →  Scarlett Input 1 (Hi-Z)
```

**Important:** Use the **Hi-Z input** on the Scarlett (the one labeled with the guitar symbol), not the line input. The line input has too low an impedance and will mess up the measurement.

Set the Scarlett's gain knob so the signal is visible but not clipping (the ring around the gain knob should be green, not red).

### Step 3 — Position the exciter coil

- Hold the exciter coil face-to-face with the pickup, centered over the pole pieces.
- Start with a **10 mm gap** between the coil and the pickup surface.
- Make sure the coil's axis is parallel to the pickup's coil axis.
- Clear all metal objects at least **30 cm away** from the test area. Metal nearby will interfere with the magnetic field and skew the result.
- Clamp the coil so it can't move during the sweep.

---

## Step-by-step measurement guide

### Step 1 — Measure DCR with your multimeter (before connecting the pickup)

DCR stands for **DC Resistance** — it's the basic electrical resistance of the pickup coil's wire.

1. Keep the pickup **disconnected** from everything (no cables, no pots, no interface).
2. Set your multimeter to the **20 kΩ range** (this covers the 5,000–16,000 Ω range typical of most pickups).
3. Touch the multimeter probes to the pickup's two output leads — **hot (tip) and ground (sleeve)**.
4. Wait 2–3 seconds for the reading to stabilise, then write down the number.
5. Note the room temperature too — resistance changes slightly with temperature, and the app uses this to give you a more accurate result.

> For a Seymour Duncan JB SH-4, expect around **16,400–16,600 Ω**. If you see something wildly different, double-check your probe placement.

### Step 2 — Open Keneth Frequency and choose your pickup

1. Open the app. You'll see the **Home** screen with a list of your past measurements (empty if this is your first time).
2. Tap **New Measurement**.
3. On the **Setup** screen, choose your pickup type from the list — Strat single-coil, Telecaster bridge, P-90, humbucker, bass pickup, etc. Choosing the right type helps the app know which frequency range to look in.
4. Type a name for the pickup (e.g. "SH-4 Bridge" or "PAF Neck Rewound").
5. Tap **Enter DCR**.

### Step 3 — Enter DCR and temperature

1. Type in the DCR reading you measured in Step 1 (in ohms).
2. Enter the room temperature in Celsius.
3. Tap **Calibrate**. The button will stay greyed out until you've entered a DCR value — that's normal.

### Step 4 — Calibrate (remove the exciter coil's own colour)

The exciter coil doesn't have a perfectly flat frequency response — it's a little louder at some frequencies than others. Calibration measures this and subtracts it from your pickup measurement so you get the pickup's true response.

1. **Replace the pickup with a 1 MΩ resistor** across the Hi-Z input. This gives the Scarlett a dummy load that doesn't have a resonant peak of its own.
2. On the **Calibration** screen, make sure the app shows your Scarlett 2i2 is connected (it appears in the device section at the top).
3. Tap **Start Calibration**.
4. The app plays a frequency sweep through the exciter coil and records the result. This takes a few seconds. A progress bar shows you how far along it is.
5. When it's done, the calibration is saved automatically.

> If you see a warning that calibration is stale or missing, you need to re-calibrate before measuring. Calibration can go stale if you change the exciter coil position, series resistor, or input gain between sessions.

### Step 5 — Connect the pickup and run the measurement

1. Remove the 1 MΩ resistor and reconnect the pickup to the Hi-Z input using your short cable.
2. Make sure the exciter coil is still in the same position as during calibration.
3. Tap **Start Sweep** on the **Measurement** screen.
4. The app plays the same frequency sweep again — this time through the pickup — and records the response. A progress bar tracks it.
5. When the sweep finishes, the app automatically analyses the signal, finds the resonant peak, and takes you to the **Results** screen.

### Step 6 — Read your results

The Results screen shows:

- **Resonant frequency** — the peak frequency in Hz. This is the main number you came for.
- **Q factor** — how sharp or broad the peak is. A higher Q means a narrower, more focused peak; a lower Q means a broader, smoother sound.
- **Inductance (L)** and **Capacitance (C)** — the electrical values that produce this resonant frequency, calculated from your DCR and the measured peak.
- **Frequency response chart** — a graph showing the pickup's full frequency response from 20 Hz to 20,000 Hz on a log scale, with the resonant peak visible as a bump.

#### Warning banners (if they appear)

| Banner | What it means | What to do |
|---|---|---|
| **Low SNR** | The signal was weak relative to background noise | Reduce the exciter gap, check gain settings, move away from noisy electronics |
| **Clipping** | The signal was too loud and distorted | Lower the Scarlett's input gain and re-run the sweep |
| **No peak found** | The app couldn't identify a clear resonant peak | Check the exciter coil position, cable connections, and pickup type selection |
| **Uncalibrated** | No calibration was applied to this measurement | Run a calibration sweep first (Step 4) |

### Step 7 — Export your results

Tap the **Export** button in the top-right corner of the Results screen. You can save as:

- **CSV** — a plain spreadsheet format you can open in Excel or Google Sheets
- **JSON** — a structured data format useful for comparing pickups in code or other tools

The export file includes the resonant frequency, Q factor, DCR, pickup name, timestamp, and the full frequency response data.

---

## Comparing two pickups

From the Home screen, tap and hold (or right-click) on any measurement tile to open a context menu. Choose **Compare** and select a second measurement to see both frequency responses overlaid on the same chart. This is useful for comparing a before/after rewound pickup, or choosing between two pickups for the same guitar position.

---

## Reference data

Tap the **book icon** in the top-right of the Home screen to open the Reference screen. It lists typical resonant frequency ranges for every pickup type the app supports, so you can check whether your measurement falls within the expected window.

| Pickup type | Typical resonant frequency |
|---|---|
| Single coil — Strat | 7–12 kHz |
| Single coil — Tele bridge | 8–11 kHz |
| Single coil — Tele neck | 7–10 kHz |
| P-90 | 5–8 kHz |
| Humbucker — medium output | 4–6 kHz |
| Bass — single coil (J-style) | 4–8 kHz |
| Bass — split humbucker (P-style) | 2–5 kHz |

---

## Troubleshooting

**The app doesn't detect my Scarlett 2i2**
- Make sure the Scarlett is plugged in via USB before opening the app.
- On the Calibration or Setup screen, check that the device name appears. If it says "No compatible device found", unplug and re-plug the USB cable, then wait a moment.

**The resonant peak is too low**
- You're probably using the line input instead of Hi-Z. Switch to Input 1 with the instrument/Hi-Z switch engaged.
- A long cable between pickup and interface loads the circuit and pulls the resonant frequency down. Use the shortest cable you can.

**No peak is visible on the chart**
- Reduce the gap between the exciter coil and the pickup (try 5 mm).
- Make sure the coil axis is parallel to the pickup coil axis.
- Check that all metal objects are well clear of the test area.

**The reading is different every time I run it**
- The exciter coil is moving between runs. Clamp it more firmly.
- You have metal nearby. Clear the area.
- If the room has a lot of 50/60 Hz electrical hum (from monitors, power supplies), try moving your setup away from them.

---

## For developers

```bash
# Install dependencies
flutter pub get

# Generate Riverpod + Drift code
dart run build_runner build --delete-conflicting-outputs

# Run on macOS
flutter run -d macos

# Run all tests
flutter test

# Production build
flutter build macos --release
```

The project follows Clean Architecture with four layers: Domain → Infrastructure → Application → UI. See `CLAUDE.md` for architecture details and `keneth_frequency_arch.md` for the full technical reference.

---

## Requirements

- macOS 12 Monterey or later
- Focusrite Scarlett 2i2 (4th Generation)
- Flutter stable channel (for building from source)
