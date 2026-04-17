# Sprint 0 Spike Results

Documents outcomes for the four Sprint 0 spikes (S0-11 through S0-15).
These decisions feed directly into Sprint 1+ architecture.

---

## Spike 1 — pocketfft Compilation (S0-14)

**Status: CONFIRMED**

**Approach:** pocketfft is a C++ header-only library (`pocketfft.h`). A thin C-linkage
wrapper (`pocketfft_wrapper.cpp`) exposes two functions:

- `pocketfft_real_magnitudes_db(samples, n, magnitudes)` — real-to-complex FFT,
  returns magnitude spectrum in dB FS
- `pocketfft_output_size(n)` — returns output buffer size for a given input length

**Compilation:** `clang++ -dynamiclib -std=c++17 -arch arm64 -O2 pocketfft_wrapper.cpp -o libpocketfft.dylib`

Compiles without errors on Apple Silicon (arm64) with no additional dependencies.

**FFI test result:** `test/infrastructure/pocketfft_spike_test.dart` passes.
A 1 kHz sine wave at 48 kHz sample rate produces a peak within ±1 bin of 1000 Hz.

**Decision for Sprint 2:**
- Use `DynamicLibrary.open('libpocketfft.dylib')` in `FftProcessor`
- All FFI pointer allocations (`calloc`) must be freed within the same call — no
  `Pointer<T>` escapes the function (enforces C-03 Isolate boundary safety)
- For production builds, the `.dylib` is compiled by a Run Script build phase in Xcode
  (to be added in Sprint 2 — see `macos/Runner/pocketfft_wrapper.cpp`)
- Build command for arm64 (Apple Silicon):
  `clang++ -dynamiclib -std=c++17 -arch arm64 -O2 pocketfft_wrapper.cpp -o libpocketfft.dylib`

**Issue C-01:** Resolved — pocketfft cannot be used header-only from Dart;
a compiled `.dylib` via a C wrapper is the correct approach. Confirmed working.

---

## Spike 2 — fl_chart Log Axis (S0-15)

**Status: CONFIRMED — fl_chart approach works**

**Approach:** fl_chart does not natively support a logarithmic X axis. The solution
is to log10-transform frequency values before passing them as X coordinates, then
use a custom `getTitlesWidget` callback to render human-readable tick labels at the
pre-defined frequencies (20, 50, 100, 200, 500, 1k, 2k, 5k, 10k, 20k Hz).

```dart
double logX(double hz) => math.log(hz) / math.ln10;
// minX = logX(20) ≈ 1.301,  maxX = logX(20000) ≈ 4.301
```

Tick labels are matched by testing proximity to expected log-transformed values
(`(value - expected).abs() < 0.01`).

**Spike screen:** `lib/ui/screens/log_axis_spike_screen.dart`
Renders a synthetic resonance peak at 4780 Hz with correct log-scale labels.

**Decision for Sprint 7:** Use fl_chart with log10-transformed X coordinates.
No need to switch to syncfusion. `LogAxisSpikeScreen` can be used as a visual
reference during Sprint 7 implementation.

**Issue M-07:** Confirmed — fl_chart log axis is feasible with coordinate
transform + custom tick labels. No external chart library change needed.

---

## Spike 3 — USB PID Verification (S0-11)

**Status: PENDING — requires hardware**

Connect the Scarlett 2i2 4th Gen via USB and run:
```
system_profiler SPUSBDataType | grep -A 10 "Scarlett"
```

Record the actual Vendor ID and Product ID here, and update the constants in
`macos/Runner/CoreAudioSession.swift`:
```swift
private let kFocusriteVendorID: Int = 0x1235   // verify
private let kScarlett2i2PID: Int = 0x8215       // verify — update if different
```

**Expected (from arch doc §16):** VID `0x1235`, PID `0x8215`

| Field | Expected | Actual |
|-------|----------|--------|
| Vendor ID | 0x1235 | _TBD_ |
| Product ID | 0x8215 | _TBD_ |

Update §16 of `keneth_frequency_arch.md` once confirmed.

---

## Spike 4 — AVAudioEngine Channel Routing (S0-12 / S0-13)

**Status: PENDING — requires hardware**

**Objective:** Confirm that AVAudioEngine can route audio exclusively to Output 1
(left channel) of the Scarlett 2i2 and simultaneously record from Input 1 (Hi-Z).

**Day 1–3 (S0-12):** Write a minimal Swift standalone proof-of-concept
(does not need to be inside the Flutter project) that:
1. Opens an AVAudioEngine session on the Scarlett 2i2
2. Generates a 1 kHz sine tone
3. Plays it exclusively to Output bus 0 (Output 1)

**Day 3–5 (S0-13):** Extend to simultaneously:
1. Install a tap on the input node (Input bus 0)
2. Record for 3 seconds
3. Confirm captured samples are non-silence

**Channel mapping to verify:**
- Output: AVAudioEngine output node, bus 0 → Scarlett Output 1 (left)
- Input: AVAudioEngine input node, bus 0 → Scarlett Input 1 (Hi-Z)

**Result:** _TBD — update with confirmed mapping or fallback decision_

If AVAudioEngine channel routing fails, the fallback is PortAudio via FFI.
Document which path was confirmed and update `CoreAudioSession.swift` accordingly.
