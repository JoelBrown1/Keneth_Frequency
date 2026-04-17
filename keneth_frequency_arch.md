# Keneth Frequency — Flutter Application Architecture
## Architectural Design Document

---

## 1. Project Summary

Keneth Frequency is a **Flutter desktop application** (macOS primary target) that automates the measurement of guitar pickup resonant frequency using an exciter coil and a Focusrite Scarlett 2i2 (4th Generation) audio interface.

The application replaces the manual REW + multimeter workflow described in `keneth_frequency_specs.md` with a guided, integrated tool that handles:

- Log sweep signal generation → Scarlett 2i2 Output 1 → exciter coil
- Simultaneous recording → Scarlett 2i2 Input 1 (Hi-Z) → pickup under test
- Calibration reference subtraction
- FFT-based frequency response computation
- Automatic resonant peak detection
- Q factor, inductance, and capacitance derivation
- DCR entry and session logging
- Pickup result storage and comparison

---

## 2. Platform Target

| Platform | Status | Rationale |
|---|---|---|
| macOS (desktop) | **Primary** | CoreAudio HAL gives direct access to Scarlett 2i2 multi-channel I/O; required for Output 1 → exciter, Input 1 Hi-Z → pickup routing |
| Windows (desktop) | Secondary | WASAPI/ASIO support via same FFI audio layer; straightforward port |
| iOS / Android | Out of scope | USB audio class-compliant routing to specific channels is unreliable on mobile; no Hi-Z input equivalent |

**Flutter channel:** `stable`
**Minimum macOS:** 12.0 (Monterey) — required for Swift concurrency used in the CoreAudio platform channel

---

## 3. Architecture Overview

The application follows **Clean Architecture** with four layers. Dependency direction is strictly inward: Infrastructure → Application → Domain. The UI layer depends only on Application (via providers).

```
┌─────────────────────────────────────────────────────────┐
│                      UI Layer                           │
│         Screens · Widgets · Charts · Navigation         │
└────────────────────────┬────────────────────────────────┘
                         │ watches / reads
┌────────────────────────▼────────────────────────────────┐
│                  Application Layer                      │
│        Riverpod Providers · State Notifiers             │
│        Session State · Measurement Flow                 │
└──────────┬──────────────────────────┬───────────────────┘
           │ calls                    │ calls
┌──────────▼──────────┐  ┌────────────▼──────────────────┐
│    Domain Layer     │  │      Infrastructure Layer     │
│  Business Logic     │  │  Audio I/O · DSP · Storage    │
│  LC Formulas        │  │  Platform Channels · SQLite   │
│  Peak Detection     │  │  CoreAudio (macOS native)     │
│  Pickup Models      │  │                               │
└─────────────────────┘  └───────────────────────────────┘
```

---

## 4. Layer Definitions

### 4.1 Domain Layer

Pure Dart. No Flutter imports. No platform dependencies. Fully unit-testable.

#### Entities

```
lib/domain/entities/
├── pickup_measurement.dart      # Full session result
├── frequency_response.dart      # List of (Hz, dB) points
├── pickup_profile.dart          # User-defined pickup metadata
└── calibration_data.dart        # Reference sweep result
```

**`PickupMeasurement`**
```dart
class PickupMeasurement {
  final String id;
  final DateTime timestamp;
  final PickupType type;
  final String pickupName;          // user label
  final double dcr;                 // ohms — entered manually
  final double ambientTempC;        // celsius — entered manually
  final double resonantFrequency;   // Hz — computed
  final double qFactor;             // dimensionless — computed
  final double peakAmplitudeDb;     // dB above baseline — computed
  final double? inductance;         // Henries — derived from f_res + C
  final double? capacitance;        // Farads — derived from f_res + L
  final FrequencyResponse response; // full curve
  final bool calibrationApplied;
}
```

**`PickupType` enum**
```dart
enum PickupType {
  singleCoilStrat,
  singleCoilTeleBridge,
  singleCoilTeleNeck,
  p90,
  humbuckerLowOutput,
  humbuckerMediumOutput,   // e.g. SH-4 JB
  humbuckerHighOutput,
  bassSingleCoil,
  bassSplitHumbucker,
  unknown,
}
```

#### Domain Services

```
lib/domain/services/
├── lc_calculator.dart          # f = 1/(2π√LC), solve for L, solve for C
├── peak_detector.dart          # locate resonant peak, -3dB bandwidth, Q
├── sweep_generator.dart        # generate log chirp PCM buffer
└── pickup_reference_data.dart  # static reference table (all pickup types)
```

**`LcCalculator`** — implements all formulas from specs:
- `resonantFrequency(double L, double C) → double`
- `solveInductance(double f, double C) → double`
- `solveCapacitance(double f, double L) → double`
- `loadedFrequency(double L, double cPickup, double cCable, double cLoad) → double`

**`PeakDetector`** — operates on `FrequencyResponse`:
- `findResonantPeak(FrequencyResponse) → PeakResult`
  - Locates maximum above 500 Hz
  - Returns `{frequency, amplitudeDb, qFactor, bandwidthHz}`
- `computeQFactor(FrequencyResponse, double peakFreq) → double`
  - Walks -3 dB points on both sides of peak

**`SweepGenerator`** — produces the log chirp buffer:
- `generateLogChirp({double f1, double f2, double durationSec, int sampleRate}) → Float32List`
- Default: 20 Hz → 20 kHz, 20 seconds, 48000 Hz
- Output is normalised to -12 dBFS peak

**`PickupReferenceData`** — static lookup table from specs:
```dart
static const List<PickupTypeProfile> profiles = [
  PickupTypeProfile(
    type: PickupType.humbuckerMediumOutput,
    label: 'Humbucker — Medium Output (e.g. SH-4 JB)',
    dcrRangeKohm: (min: 14, max: 17),
    inductanceRangeH: (min: 7, max: 10),
    resonantFreqRangeKhz: (min: 4, max: 6),
    multimeterRangeKohm: 20,
    verificationPickup: 'Seymour Duncan JB SH-4 (~4.78 kHz unloaded)',
  ),
  // ... all types from reference table
];
```

---

### 4.2 Infrastructure Layer

Platform-specific implementations. Injected into the application layer via interfaces defined in the domain.

```
lib/infrastructure/
├── audio/
│   ├── audio_service.dart              # Dart interface
│   ├── macos_audio_service.dart        # Platform channel → CoreAudio
│   └── audio_device_info.dart          # Device name, channels, sample rates
├── dsp/
│   ├── fft_processor.dart              # FFT via dart:ffi → pocketfft C lib
│   ├── frequency_response_builder.dart # Sweep / recording ratio → dB curve
│   ├── smoothing.dart                  # 1/6 octave smoothing
│   └── window_functions.dart           # Hann, Blackman-Harris
├── storage/
│   ├── measurement_repository.dart     # drift (SQLite) — persist sessions
│   ├── calibration_repository.dart     # persist/load calibration blobs
│   └── export_service.dart             # CSV / JSON export
└── platform/
    └── scarlett_device_detector.dart   # detect 2i2 4th Gen by USB VID/PID
```

#### CoreAudio Platform Channel (macOS)

Flutter communicates with CoreAudio via a `MethodChannel`:

```
channel: 'keneth_frequency/audio'
```

**Methods exposed from Swift:**

| Method | Arguments | Returns |
|---|---|---|
| `getDevices` | — | `List<Map>` device info |
| `openSession` | deviceId, sampleRate, bufferSize | bool |
| `playSweepAndRecord` | sweepPcmBase64, outputChannel, inputChannel | recordingPcmBase64 |
| `closeSession` | — | void |

The Swift native layer uses **AVAudioEngine** with **AVAudioUnit** wrapping the Scarlett's CoreAudio HAL device. This allows explicit per-channel routing: Output 1 (index 0) for the exciter drive and Input 1 (index 0) for the pickup return.

**Scarlett 2i2 4th Gen device identification:**
- USB Vendor ID: `0x1235` (Focusrite)
- USB Product ID: `0x8219` (Scarlett 2i2 4th Gen)
- `scarlett_device_detector.dart` validates the correct interface is connected before allowing a session to open

#### DSP Pipeline (`fft_processor.dart`)

Uses `dart:ffi` bindings to **pocketfft** (MIT-licensed C library, header-only, bundled in `macos/Runner/`):

```
Recording buffer (Float32)
    │
    ▼
Apply Hann window
    │
    ▼
FFT (pocketfft, size = next power of 2 ≥ buffer length)
    │
    ▼
Compute magnitude spectrum (dB)
    │
    ▼
Divide by calibration reference spectrum (subtract in dB)
    │
    ▼
1/6 octave smoothing
    │
    ▼
FrequencyResponse entity (List<FrequencyPoint>)
```

**Sample rate and resolution:**
- Sample rate: 48,000 Hz
- Sweep duration: 20 seconds → 960,000 samples
- FFT size: 1,048,576 (2²⁰) — frequency resolution: 48000 / 1048576 ≈ **0.046 Hz/bin**
- Usable range: 20 Hz – 20,000 Hz (1,048,555 bins discarded above Nyquist)

#### Storage (`drift` SQLite)

```sql
-- measurements table
CREATE TABLE measurements (
  id TEXT PRIMARY KEY,
  timestamp INTEGER,
  pickup_name TEXT,
  pickup_type TEXT,
  dcr_ohms REAL,
  ambient_temp_c REAL,
  resonant_freq_hz REAL,
  q_factor REAL,
  peak_amplitude_db REAL,
  inductance_h REAL,
  capacitance_f REAL,
  calibration_applied INTEGER,
  frequency_response_json TEXT   -- compressed JSON blob
);

-- calibration table
CREATE TABLE calibrations (
  id TEXT PRIMARY KEY,
  timestamp INTEGER,
  label TEXT,
  spectrum_json TEXT              -- reference sweep magnitude spectrum
);
```

---

### 4.3 Application Layer

Riverpod providers and state notifiers. Orchestrates domain services and infrastructure.

```
lib/application/
├── providers/
│   ├── audio_device_provider.dart        # available audio devices
│   ├── session_provider.dart             # current measurement session state
│   ├── calibration_provider.dart         # active calibration data
│   ├── measurement_results_provider.dart # computed results for current session
│   └── measurement_history_provider.dart # all saved measurements
└── state/
    ├── session_state.dart                # enum + data for session FSM
    └── measurement_session.dart          # in-progress session data class
```

#### Session State Machine

The core flow is a finite state machine managed by `SessionStateNotifier`:

```
         ┌──────────────────────────────────────────────┐
         │                                              │
  [Idle] → [PickupSetup] → [DcrEntry] → [Calibrating]  │
                                              │         │
                                              ▼         │
                                        [Measuring]     │
                                              │         │
                                              ▼         │
                                        [Processing]    │
                                              │         │
                                              ▼         │
                                        [Results] ──────┘
                                              │
                                              ▼
                                        [Saved / Reset]
```

**`SessionState` sealed class:**
```dart
sealed class SessionState {}
class IdleState extends SessionState {}
class PickupSetupState extends SessionState {}
class DcrEntryState extends SessionState {
  final PickupType type;
  final String pickupName;
}
class CalibratingState extends SessionState {
  final double progress; // 0.0–1.0
}
class MeasuringState extends SessionState {
  final double progress;
}
class ProcessingState extends SessionState {}
class ResultsState extends SessionState {
  final PickupMeasurement measurement;
}
```

---

### 4.4 UI Layer

```
lib/ui/
├── app.dart                      # MaterialApp, GoRouter setup
├── screens/
│   ├── home_screen.dart          # measurement history list
│   ├── setup_screen.dart         # pickup type + name selection
│   ├── dcr_entry_screen.dart     # manual DCR + temperature input
│   ├── calibration_screen.dart   # run calibration sweep
│   ├── measurement_screen.dart   # run pickup sweep (live level meter)
│   ├── results_screen.dart       # frequency response chart + derived values
│   └── reference_screen.dart     # pickup type reference table
├── widgets/
│   ├── frequency_response_chart.dart  # fl_chart log-scale line chart
│   ├── peak_marker.dart               # annotation overlay on chart
│   ├── level_meter.dart               # live input level bar during sweep
│   ├── session_progress_bar.dart      # step indicator across screens
│   ├── pickup_type_selector.dart      # card grid of pickup types
│   └── dcr_input_form.dart            # validated DCR + temp form fields
└── theme/
    └── app_theme.dart                 # dark theme (measurement tool aesthetic)
```

#### Screen Flow

```
HomeScreen
    │
    ├── [New Measurement] ──► SetupScreen (pickup type + name)
    │                              │
    │                              ▼
    │                         DcrEntryScreen (DCR Ω + temp °C)
    │                              │
    │                              ▼
    │                         CalibrationScreen (1MΩ reference sweep)
    │                              │
    │                              ▼
    │                         MeasurementScreen (live level + progress)
    │                              │
    │                              ▼
    │                         ResultsScreen (chart + values + save)
    │                              │
    │                              └──► HomeScreen (saved)
    │
    └── [tap saved result] ──► ResultsScreen (read-only)
```

#### `FrequencyResponseChart` Widget

Built on **fl_chart** `LineChart`:

- X axis: **logarithmic** frequency scale, 20 Hz – 20 kHz
  - Custom `getTitlesWidget` maps log values to labeled ticks: 20, 50, 100, 200, 500, 1k, 2k, 5k, 10k, 20k
- Y axis: dB magnitude, auto-scaled with ±5 dB padding around peak
- Resonant peak annotated with a vertical dashed line + callout label (`f_res = X.XX kHz`)
- -3 dB bandwidth shown as a shaded horizontal band
- If calibration reference is available, shown as a secondary grey line
- Pinch-to-zoom and pan enabled via `fl_chart` `FlTransformationConfig`

---

## 5. Package Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0

  # Navigation
  go_router: ^14.0.0

  # Charting
  fl_chart: ^0.68.0

  # Local database
  drift: ^2.18.0
  sqlite3_flutter_libs: ^0.5.0

  # FFI (DSP / pocketfft bindings)
  ffi: ^2.1.0

  # File system
  path_provider: ^2.1.0

  # Export / share
  share_plus: ^9.0.0

  # Utilities
  uuid: ^4.4.0
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  riverpod_generator: ^2.4.0
  build_runner: ^2.4.0
  drift_dev: ^2.18.0
  mockito: ^5.4.0
```

**Native dependency (bundled):**
- `pocketfft` — C header-only FFT library, placed in `macos/Runner/pocketfft.h`
- Exposed to Dart via `dart:ffi` bindings in `lib/infrastructure/dsp/fft_processor.dart`

---

## 6. Directory Structure

```
keneth_frequency/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── domain/
│   │   ├── entities/
│   │   ├── services/
│   │   └── repositories/          # abstract interfaces
│   ├── infrastructure/
│   │   ├── audio/
│   │   ├── dsp/
│   │   ├── storage/
│   │   └── platform/
│   ├── application/
│   │   ├── providers/
│   │   └── state/
│   └── ui/
│       ├── screens/
│       ├── widgets/
│       └── theme/
├── macos/
│   └── Runner/
│       ├── AppDelegate.swift
│       ├── AudioChannel.swift       # MethodChannel handler
│       ├── CoreAudioSession.swift   # AVAudioEngine setup
│       └── pocketfft.h              # bundled C DSP library
└── test/
    ├── domain/
    │   ├── lc_calculator_test.dart
    │   ├── peak_detector_test.dart
    │   └── sweep_generator_test.dart
    ├── infrastructure/
    │   ├── fft_processor_test.dart
    │   └── frequency_response_builder_test.dart
    └── application/
        └── session_notifier_test.dart
```

---

## 7. Signal Flow: End-to-End

```
SweepGenerator.generateLogChirp()
        │  Float32List (20s @ 48kHz, -12 dBFS)
        ▼
MacosAudioService.playSweepAndRecord()
        │  Output channel 0 → Scarlett 2i2 Output 1 → 220Ω → Exciter coil
        │  Input channel 0 ← Scarlett 2i2 Input 1 (Hi-Z 1MΩ) ← Pickup
        ▼
Raw recording: Float32List (960,000 samples)
        │
        ▼
FftProcessor.process(recording, windowFn: Hann)
        │  magnitude spectrum (dB vs Hz, 0–24kHz)
        ▼
FrequencyResponseBuilder.build(spectrum, calibration)
        │  subtract calibration reference spectrum (dB subtraction)
        │  apply 1/6 octave smoothing
        ▼
FrequencyResponse entity (List<FrequencyPoint> 20Hz–20kHz)
        │
        ▼
PeakDetector.findResonantPeak(response)
        │  locate max above 500Hz
        │  walk ±3dB for bandwidth
        ▼
PeakResult { frequency, amplitudeDb, qFactor, bandwidthHz }
        │
        ▼
LcCalculator (if inductance or capacitance known from DCR cross-check)
        │  derive L or C from measured f_res
        ▼
PickupMeasurement entity → persisted to SQLite → displayed on ResultsScreen
```

---

## 8. Calibration Flow

Calibration removes frequency coloration from the exciter coil's non-flat response.

```
User connects 1MΩ reference resistor in place of pickup
        │
        ▼
CalibrationScreen triggers CalibrationNotifier.runCalibration()
        │
        ▼
playSweepAndRecord() → reference recording Float32List
        │
        ▼
FftProcessor → reference magnitude spectrum
        │
        ▼
CalibrationData { id, timestamp, spectrum } → persisted to SQLite
        │
        ▼
calibration_provider updates → all subsequent measurements auto-subtract reference
```

Calibration persists across sessions. The UI displays the active calibration timestamp and allows re-running at any time. A stale calibration warning is shown if the last calibration is >24 hours old.

---

## 9. DCR Entry and Validation

DCR is entered manually by the user on `DcrEntryScreen` following the multimeter measurement described in the specs.

**Validation rules (from specs):**

| Pickup Type | Valid DCR Range | Warn if outside |
|---|---|---|
| Single coil (all) | 4,000 – 10,000 Ω | yes |
| P-90 | 6,000 – 12,000 Ω | yes |
| Humbucker low output | 6,000 – 10,000 Ω | yes |
| Humbucker medium output | 12,000 – 18,000 Ω | yes |
| Humbucker high output | 14,000 – 22,000 Ω | yes |
| Bass single coil | 4,000 – 12,000 Ω | yes |
| Bass humbucker | 6,000 – 14,000 Ω | yes |

If the entered DCR is outside the expected range for the selected pickup type, a non-blocking warning is shown: *"DCR of X Ω is outside the typical range for this pickup type. Check multimeter range setting."*

The SH-4 verification reference shows its expected range (16,400–16,600 Ω) inline as a hint.

**Temperature field:** optional, defaults to 20°C. Stored with the session but not used in computation (informational only for future temperature-corrected DCR normalisation).

---

## 10. Results Screen: Derived Values

After measurement and peak detection, the Results screen displays:

| Value | Source |
|---|---|
| Resonant frequency | `PeakDetector` — peak of smoothed frequency response |
| Peak amplitude | dB above 1 kHz baseline |
| Q factor | -3 dB bandwidth calculation |
| Bandwidth (-3 dB) | Hz — shown on chart |
| Inductance (est.) | `LcCalculator.solveInductance(f_res, C_typical)` using typical C for pickup type |
| Capacitance (est.) | `LcCalculator.solveCapacitance(f_res, L_typical)` using typical L for pickup type |
| DCR | User-entered value |
| Pass/Fail vs reference | For SH-4: peak within 4.5–5.1 kHz = PASS |

**Estimate caveat:** Inductance and capacitance are derived estimates using the typical capacitance/inductance for the selected pickup type. They are labelled *"estimated"* in the UI. Exact values require a separate LCR meter measurement.

---

## 11. Pickup Library Screen

A reference screen (no measurement capability) displaying the full pickup type table from the specs:

- Sortable by resonant frequency, DCR, inductance
- Each row expandable to show typical L range, C range, multimeter setting
- SH-4 row marked as *"Verification reference — expected 4.78 kHz unloaded"*
- Active pickup (EMG/Fluence) row marked with a distinct *"Not measurable — active electronics"* badge

---

## 12. Key Architectural Decisions

### ADR-001: macOS Desktop as Primary Target
**Decision:** Target macOS desktop, not mobile.
**Reason:** The Scarlett 2i2 requires USB and CoreAudio channel routing (Output 1 specifically). iOS/Android USB audio support is unreliable for multi-channel routing. Desktop is where this hardware is used.

### ADR-002: Platform Channel for Audio, Not Pure Dart
**Decision:** Use a Swift/CoreAudio platform channel rather than a pure-Dart audio package.
**Reason:** No pure-Dart package provides explicit per-channel routing to a specific USB audio interface output. `just_audio` and `audioplayers` are single-output. Controlling Output 1 of the 2i2 independently of Output 2 requires AVAudioEngine with explicit bus routing — Swift only.

### ADR-003: pocketfft via FFI for DSP
**Decision:** Bundle pocketfft C library and bind via `dart:ffi`.
**Reason:** Dart has no native FFT. `pocketfft` is MIT-licensed, header-only, battle-tested (used in NumPy), and performs a 1M-point FFT in ~200 ms on Apple Silicon — acceptable for a post-sweep computation step.

### ADR-004: Riverpod for State Management
**Decision:** Riverpod over Bloc or Provider.
**Reason:** The session FSM is well-suited to `StateNotifier`. Riverpod's compile-time safety and code generation (`riverpod_generator`) reduce boilerplate. The measurement pipeline involves async streams (live level metering) which Riverpod handles cleanly via `StreamProvider`.

### ADR-005: Manual DCR Entry, No Bluetooth Multimeter Integration
**Decision:** DCR is entered by the user, not auto-read from a multimeter.
**Reason:** Bluetooth multimeter integration would require a separate hardware dependency and introduces connectivity complexity. The measurement procedure already requires a manual multimeter step before connecting the pickup to the interface. A well-validated input form with type-specific range hints is sufficient.

### ADR-006: Logarithmic X-Axis for Frequency Chart
**Decision:** Implement a custom log-scale X axis on `fl_chart`.
**Reason:** Pickup resonant frequencies span 2–12 kHz in a 20 Hz–20 kHz range. A linear axis compresses the interesting region into the rightmost 10% of the chart. A log axis gives equal visual space per octave, matching standard audio analysis convention.

---

## 13. Testing Strategy

| Layer | Test Type | Tooling |
|---|---|---|
| Domain (LcCalculator, PeakDetector, SweepGenerator) | Unit | `flutter_test` |
| Domain (PickupReferenceData) | Unit — validate all table entries | `flutter_test` |
| Infrastructure (FftProcessor) | Unit — known input → known FFT output | `flutter_test` + `ffi` |
| Infrastructure (FrequencyResponseBuilder) | Unit — synthetic sweep + calibration | `flutter_test` |
| Application (SessionNotifier) | Unit — FSM transition coverage | `flutter_test` + `mockito` |
| UI (ResultsScreen) | Widget test — given a `PickupMeasurement`, renders correctly | `flutter_test` |
| Integration (full pipeline) | Integration — synthetic sweep file → expected peak | `flutter_test` |

**Verification baseline test:** A synthetic log chirp is processed through the full DSP pipeline with a simulated SH-4 frequency response (Gaussian peak at 4.78 kHz, Q=3). `PeakDetector` must return `4.78 kHz ± 50 Hz`. This test runs in CI on every push.

---

## 14. Build and Run

```bash
# Install dependencies
flutter pub get

# Generate Riverpod + Drift code
dart run build_runner build --delete-conflicting-outputs

# Run on macOS
flutter run -d macos

# Run tests
flutter test

# Build release
flutter build macos --release
```

**Required macOS entitlement** (`macos/Runner/DebugProfile.entitlements` and `Release.entitlements`):
```xml
<key>com.apple.security.device.audio-input</key>
<true/>
<key>com.apple.security.device.audio-output</key>
<true/>
```

---

## 15. Out of Scope (v1)

- Real-time oscilloscope view during sweep
- Automatic inductance measurement via known external capacitor method
- Bluetooth multimeter integration for automated DCR capture
- Cloud sync or remote storage
- Windows / Linux builds (architecture supports it; platform channel needs porting)
- Loaded resonant frequency simulation (voltage divider model with pot + cable capacitance)

These are natural v2 candidates once the core measurement pipeline is validated against the SH-4 reference target.

---

## 16. Swift Native Layer — Detailed Design

The CoreAudio platform channel is implemented across two Swift files in `macos/Runner/`.

### `AudioChannel.swift` — MethodChannel Handler

```swift
import FlutterMacOS
import Foundation

class AudioChannel: NSObject {
    private let channel: FlutterMethodChannel
    private let session = CoreAudioSession()

    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(
            name: "keneth_frequency/audio",
            binaryMessenger: messenger
        )
        super.init()
        channel.setMethodCallHandler(handle)
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getDevices":
            result(session.listDevices())
        case "openSession":
            guard let args = call.arguments as? [String: Any],
                  let deviceId = args["deviceId"] as? String,
                  let sampleRate = args["sampleRate"] as? Double else {
                result(FlutterError(code: "INVALID_ARGS", message: nil, details: nil))
                return
            }
            result(session.open(deviceId: deviceId, sampleRate: sampleRate))
        case "playSweepAndRecord":
            guard let args = call.arguments as? [String: Any],
                  let sweepB64 = args["sweepPcmBase64"] as? String,
                  let outCh = args["outputChannel"] as? Int,
                  let inCh = args["inputChannel"] as? Int else {
                result(FlutterError(code: "INVALID_ARGS", message: nil, details: nil))
                return
            }
            Task {
                do {
                    let recording = try await session.playSweepAndRecord(
                        sweepBase64: sweepB64,
                        outputChannel: outCh,
                        inputChannel: inCh
                    )
                    result(recording)
                } catch {
                    result(FlutterError(code: "AUDIO_ERROR",
                                        message: error.localizedDescription,
                                        details: nil))
                }
            }
        case "closeSession":
            session.close()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
```

### `CoreAudioSession.swift` — AVAudioEngine Setup

Key responsibilities:
- Enumerate CoreAudio devices and match the Scarlett 2i2 4th Gen by USB VID/PID (`0x1235` / `0x8219`)
- Set the audio device on `AVAudioEngine`'s input and output node explicitly
- Route Output bus 0 (index 0) to the Scarlett's Output 1 (left channel)
- Route Input bus 0 from the Scarlett's Input 1 (Hi-Z channel)
- Play the sweep buffer while simultaneously tap-recording the input
- Return the recorded PCM buffer as Base64 to Dart

```swift
import AVFoundation
import CoreAudio

class CoreAudioSession {
    private var engine: AVAudioEngine?
    private var outputNode: AVAudioOutputNode?
    private var inputNode: AVAudioInputNode?
    private var deviceSampleRate: Double = 48000

    func listDevices() -> [[String: Any]] {
        // Enumerate AudioObjectIDs via AudioObjectGetPropertyData
        // Return array of {id, name, inputChannels, outputChannels, sampleRates}
    }

    func open(deviceId: String, sampleRate: Double) -> Bool {
        // Set kAudioHardwarePropertyDefaultInputDevice
        // Set kAudioHardwarePropertyDefaultOutputDevice
        // Build AVAudioEngine with explicit device routing
        // Return true on success
    }

    func playSweepAndRecord(
        sweepBase64: String,
        outputChannel: Int,
        inputChannel: Int
    ) async throws -> String {
        // 1. Decode Base64 → Float32 PCM buffer
        // 2. Install tap on inputNode to collect samples
        // 3. Schedule sweep buffer on output player node (channel outputChannel)
        // 4. engine.start()
        // 5. Await sweep duration completion (20 seconds)
        // 6. Remove tap, engine.stop()
        // 7. Return collected samples as Base64
    }

    func close() {
        engine?.stop()
        engine = nil
    }
}
```

**Buffer handling:** The input tap uses `AVAudioNode.installTap(onBus:bufferSize:format:block:)` with a buffer size of 4096 samples. Collected buffers are appended to a `[Float]` array using a serial `DispatchQueue` to avoid data races. The full recording array is Base64-encoded and returned after the sweep completes.

**Latency compensation:** AVAudioEngine introduces a small I/O latency (typically 128–512 samples at 48 kHz). Since we are measuring frequency response from a ratio of swept spectrum to reference, constant latency affects phase but not magnitude. No compensation is needed for magnitude-only peak detection.

---

## 17. Concurrency Model

The measurement pipeline involves a 20-second blocking audio operation. This must not block the Flutter UI thread.

### Strategy

| Operation | Mechanism |
|---|---|
| Sweep playback + recording (20s) | Swift `async/await` task on native side; Dart awaits `MethodChannel` call |
| FFT computation (post-sweep) | Dart `Isolate` via `compute()` — offloads to separate thread |
| 1/6 octave smoothing | Same isolate as FFT |
| Peak detection | Same isolate as FFT |
| SQLite write | `drift` handles on its own background thread automatically |
| Live level metering | `EventChannel` streaming from Swift tap callback → Dart `StreamProvider` |

### Live Level Meter Channel

A second platform channel streams real-time RMS input level during the sweep so the UI can display a live level bar:

```
channel: 'keneth_frequency/level'   (EventChannel)
```

Swift side: Inside the AVAudioNode tap block, compute RMS of each 4096-sample buffer and sink it to the `FlutterEventSink`. Dart side: `StreamProvider<double>` wraps the `EventChannel.receiveBroadcastStream()`.

### Isolate Usage for DSP

```dart
final response = await compute(
  _runDspPipeline,
  DspPipelineInput(
    recordingPcm: recordingFloat32,
    calibrationSpectrum: calibration?.spectrum,
    sampleRate: 48000,
  ),
);
```

`_runDspPipeline` is a top-level function (required by `compute`) that runs `FftProcessor` → `FrequencyResponseBuilder` → smoothing and returns a `FrequencyResponse`. This keeps the UI at 60 fps during the ~200 ms FFT computation.

---

## 18. Error Handling Strategy

### Error Categories

| Category | Example | Handling |
|---|---|---|
| Device not found | Scarlett 2i2 not connected | Blocking error screen — cannot proceed |
| Wrong device generation | 3rd Gen connected instead of 4th Gen | Warning with option to proceed anyway |
| Clipping during recording | Input overloaded (gain too high) | Post-sweep warning; measurement flagged as suspect |
| Silence during recording | No signal on input | Post-sweep error; guide user to check cable/Hi-Z |
| Calibration missing | Measurement attempted without calibration | Non-blocking warning; results labelled "uncalibrated" |
| Stale calibration | Last calibration >24 hours ago | Non-blocking banner warning |
| No resonant peak found | Flat frequency response | Results screen shows "No peak detected" with troubleshooting steps |
| DCR out of range | Entered value inconsistent with pickup type | Non-blocking inline warning on form field |
| SQLite write failure | Disk full | Toast notification; result available in-memory for manual export |

### Clip Detection

After recording, before FFT, check for clipping:

```dart
bool _isClipped(Float32List samples) {
  const clipThreshold = 0.98;
  return samples.any((s) => s.abs() >= clipThreshold);
}
```

If clipped, `ResultsState` includes a `clipWarning: true` flag. The Results screen shows a banner: *"Input clipped during recording. Reduce gain on the Scarlett 2i2 and re-measure."*

### Silence Detection

```dart
double _computeRms(Float32List samples) {
  final sumSq = samples.fold(0.0, (acc, s) => acc + s * s);
  return sqrt(sumSq / samples.length);
}
```

If RMS < -60 dBFS, surface a guided error: *"No signal detected. Check: pickup connected to Hi-Z input · exciter coil positioned correctly · gain not at minimum."*

---

## 19. GoRouter Navigation Configuration

```dart
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomeScreen(),
    ),
    GoRoute(
      path: '/session/setup',
      builder: (_, __) => const SetupScreen(),
    ),
    GoRoute(
      path: '/session/dcr',
      builder: (_, __) => const DcrEntryScreen(),
    ),
    GoRoute(
      path: '/session/calibrate',
      builder: (_, __) => const CalibrationScreen(),
    ),
    GoRoute(
      path: '/session/measure',
      builder: (_, __) => const MeasurementScreen(),
    ),
    GoRoute(
      path: '/session/results',
      builder: (_, __) => const ResultsScreen(),
    ),
    GoRoute(
      path: '/results/:id',
      builder: (context, state) => ResultsScreen(
        measurementId: state.pathParameters['id'],
      ),
    ),
    GoRoute(
      path: '/reference',
      builder: (_, __) => const ReferenceScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (_, __) => const SettingsScreen(),
    ),
  ],
);
```

Navigation is driven by `SessionStateNotifier`. A `ref.listen` in `app.dart` watches session state and calls `router.go()` on transitions:

```dart
ref.listen<SessionState>(sessionProvider, (previous, next) {
  switch (next) {
    case DcrEntryState():   router.go('/session/dcr');
    case CalibratingState(): router.go('/session/calibrate');
    case MeasuringState():  router.go('/session/measure');
    case ResultsState():    router.go('/session/results');
    case IdleState():       router.go('/');
    default: break;
  }
});
```

---

## 20. Settings Screen

A simple preferences screen (`/settings`) backed by `shared_preferences`:

| Setting | Type | Default | Description |
|---|---|---|---|
| Sweep duration | int (seconds) | 20 | 10–30 s; longer = better SNR |
| Sweep low frequency | double (Hz) | 20 | Lower bound of log chirp |
| Sweep high frequency | double (Hz) | 20000 | Upper bound of log chirp |
| Output level | double (dBFS) | -12 | Drive level for exciter; -18 to -6 |
| Smoothing resolution | enum | 1/6 octave | 1/3, 1/6, 1/12, none |
| Calibration warning threshold | int (hours) | 24 | Hours before stale calibration warning |
| Temperature unit | enum | Celsius | Celsius / Fahrenheit |
| Default pickup type | PickupType | unknown | Pre-selects type on setup screen |
| Export format | enum | CSV | CSV / JSON |

Settings are stored via `shared_preferences` and exposed through a `SettingsProvider` (`StateNotifierProvider<SettingsNotifier, AppSettings>`).

---

## 21. Comparison Feature

The Results screen supports overlaying two saved measurements on the same chart for direct comparison.

### Activation

On the HomeScreen, long-press a saved result to enter comparison selection mode. Select a second result. Tap "Compare" → navigates to `ResultsScreen` in comparison mode.

### Comparison Mode Chart

- **Primary measurement:** solid line, accent colour
- **Secondary measurement:** dashed line, muted colour
- Both resonant peak markers shown with distinct labels: `f₁ = X.XX kHz` / `f₂ = X.XX kHz`
- Difference callout: `Δf = X.XX kHz` shown between the two peak markers
- Y axis auto-scaled to fit both curves

### Comparison Data Panel

Below the chart, a two-column table:

| Parameter | Measurement A | Measurement B |
|---|---|---|
| Pickup name | — | — |
| Resonant frequency | — | — |
| Q factor | — | — |
| DCR | — | — |
| Peak amplitude | — | — |
| Date measured | — | — |

---

## 22. Export Format

Triggered from the Results screen via `share_plus`. Two formats available per Settings:

### CSV Export

```
# Keneth Frequency Export
# Generated: 2026-04-16T14:32:00
# Pickup: Seymour Duncan JB SH-4
# Type: humbuckerMediumOutput
# DCR: 16540 ohms
# Ambient temperature: 21.0 C
# Resonant frequency: 4783 Hz
# Q factor: 3.2
# Peak amplitude: 12.4 dB
# Calibration applied: true
#
frequency_hz,magnitude_db
20.0,-0.3
21.2,-0.2
...
4783.0,12.4
...
20000.0,-18.6
```

### JSON Export

```json
{
  "export_version": 1,
  "generated": "2026-04-16T14:32:00Z",
  "pickup": {
    "name": "Seymour Duncan JB SH-4",
    "type": "humbuckerMediumOutput",
    "dcr_ohms": 16540,
    "ambient_temp_c": 21.0
  },
  "result": {
    "resonant_frequency_hz": 4783,
    "q_factor": 3.2,
    "peak_amplitude_db": 12.4,
    "bandwidth_3db_hz": 1494,
    "inductance_h_estimated": 8.1,
    "capacitance_f_estimated": 1.36e-10,
    "calibration_applied": true
  },
  "frequency_response": [
    { "frequency_hz": 20.0, "magnitude_db": -0.3 },
    ...
  ]
}
```

The export file is named `keneth_[pickup_name]_[timestamp].csv` or `.json` and delivered via the system share sheet (macOS: save panel).

---

## 23. CI / Deployment

### GitHub Actions Workflow

```yaml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: flutter test
        # Includes the SH-4 verification baseline test

  build:
    runs-on: macos-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: flutter build macos --release
      - uses: actions/upload-artifact@v4
        with:
          name: KenethFrequency-macOS
          path: build/macos/Build/Products/Release/keneth_frequency.app
```

### Distribution

For personal / lab use, unsigned `.app` via GitHub Actions artifact is sufficient. For wider distribution:
- Apple Developer account required for notarisation
- `flutter build macos --release` → `xcrun notarytool` → `xcrun stapler`
- Distribute as a `.dmg` via GitHub Releases

---

## 24. Development Issues Assessment

This section records all development issues identified in the meta-engineering review of this document and `keneth_frequency_specs.md`. Issues are classified by severity: **Critical** (will block build or produce incorrect results), **High** (significant risk to timeline or correctness), **Medium** (reduces quality or accuracy), and **Low** (documentation and process).

---

### Critical — Blockers

---

#### C-01: pocketfft cannot be used as a header-only library via `dart:ffi`

**Affects:** §4.2 DSP Pipeline, §5 Package Dependencies — blocks Sprint 2

`dart:ffi` requires a compiled native binary — a `.dylib` (shared library) or `.a` (static library) linked into the macOS Runner. A C header (`.h`) file alone is not callable from Dart. The architecture places `pocketfft.h` in `macos/Runner/` and describes it as "exposed to Dart via `dart:ffi` bindings" — this will not compile.

**Required fix:**
- Add `pocketfft_wrapper.c` to `macos/Runner/` that `#include`s pocketfft and exports required symbols
- Add a build phase in Xcode to compile it into a `.dylib` bundled with the app
- Update `FftProcessor` FFI bindings to load the library via `DynamicLibrary.open()`

---

#### C-02: Base64 PCM transfer over `MethodChannel` is a ~5 MB string transfer

**Affects:** §16 Swift Native Layer, §7 Signal Flow — blocks Sprint 3

`playSweepAndRecord` passes the sweep as `sweepPcmBase64` and returns the recording as `recordingPcmBase64`. A 20-second sweep at 48 kHz Float32 = 960,000 × 4 bytes = 3.84 MB raw → **~5.12 MB as Base64**. Flutter's `MethodChannel` with `StandardMessageCodec` copies this string twice on each side of the channel, causing a noticeable UI freeze and OOM risk.

**Required fix:**
- Use `MethodChannel` with `BinaryCodec` to pass raw bytes — eliminates Base64 encoding overhead entirely
- Alternative: write PCM to a temp file and pass only the file path over the channel
- Do not use Base64 string encoding for large audio buffers

---

#### C-03: `dart:ffi` native pointers are not safe to pass across Isolate boundaries

**Affects:** §17 Concurrency Model — blocks Sprint 2

The architecture runs the DSP pipeline via `compute()`, which spawns a Dart Isolate. If `FftProcessor` allocates native memory via `dart:ffi` (e.g., `calloc<Float>()`) in the main isolate and any `Pointer<T>` is passed to the compute isolate, behaviour is undefined and will crash at runtime. Dart Isolates do not share heap memory.

**Required fix:**
- All FFI allocation and deallocation must occur within the same isolate
- The `compute()` function must receive and return plain Dart data (`Float32List` / `List<double>`) only
- `FftProcessor` performs its own FFI allocation internally within the isolate and frees before returning
- Never pass `Pointer<T>` objects as arguments to `compute()`

---

### High — Significant Risk

---

#### H-01: ~~AVAudioEngine input channel mapping unverified~~ — RESOLVED (2026-04-16)

**Verified via Spike 4 (S0-12/S0-13)** with Scarlett 2i2 4th Gen and pickup connected:
- `outputNode` bus 0 → Scarlett Output 1 (left) ✓
- `inputNode` bus 0 → Scarlett Input 1 (Hi-Z) ✓ — peak amplitude 0.706671 (non-silence confirmed)

No PortAudio fallback needed. Channel index 0 maps correctly to front-panel channel 1 on this device.

---

#### H-02: `FrequencyResponse` JSON storage is ~6.5 MB per measurement row

**Affects:** §4.2 Storage (SQLite schema) — Sprint 4

The FFT produces ~434,000 usable frequency points (20 Hz–20 kHz from a 2²⁰ FFT). Stored as JSON text in SQLite (~30 chars per record), this is ~13 MB per measurement row. The architecture does not define what length the `FrequencyResponse` output of the smoothing step is before storage.

**Required fix:**
- Store the **smoothed** response only (~60 log-spaced points at 1/6 octave) in the database
- Store a display-resolution version (~1000 log-spaced points) for chart rendering
- Never store the raw 434,000-point FFT output in SQLite

---

#### H-03: No session cancellation or back-navigation handling in the FSM

**Affects:** §4.3 Session State Machine, §19 GoRouter — Sprint 5

The `SessionState` FSM has no `cancel` transition. On macOS, pressing Cmd+[ or a back button at any point pops the GoRouter route but leaves `SessionStateNotifier` in `CalibratingState` or `MeasuringState` with the audio session still open. The next session start will find an inconsistent FSM state.

**Required fix:**
- Add `cancelSession()` to `SessionStateNotifier` — calls `MacosAudioService.closeSession()` and resets FSM to `IdleState`
- Hook into GoRouter's `onExit` callback on all session screens to trigger `cancelSession()`

---

#### H-04: ~~Scarlett USB Product ID unverified~~ — RESOLVED (2026-04-16)

**Verified via `ioreg -p IOUSB`** with Scarlett 2i2 4th Gen connected:
- VID: `0x1235` (Focusrite) ✓
- PID: `0x8219` ✓ (original arch doc had `0x8215` — incorrect)

All references in §16 and `CoreAudioSession.swift` updated to `0x8219`.

---

#### H-05: CI pipeline is deferred to Sprint 10

**Affects:** §23 CI/Deployment — quality risk across all sprints

9 sprints of code is written and merged before any CI pipeline runs. The SH-4 verification baseline integration test — the project's key correctness gate — does not run in CI until Sprint 10.

**Required fix:** Configure the GitHub Actions `test` job in Sprint 0 alongside project setup. Add the SH-4 baseline integration test to CI as soon as it is written in Sprint 2, not Sprint 10.

---

#### H-06: No audio spike before Sprint 3

**Affects:** Sprint plan — timeline risk

Sprint 3 is scheduled after 4 weeks of Dart-only work with no prior prototype of the native audio layer. If `AVAudioEngine` channel routing fails mid-Sprint 3, the entire timeline collapses. The risk register acknowledges this risk but provides no mitigation gate.

**Required fix:** Add a 2–3 day audio spike to Sprint 0:
- Prove `AVAudioEngine` can route a specific channel of the Scarlett 2i2 to output
- Prove simultaneous play + record works without timing issues
- If this fails, the PortAudio via FFI fallback is identified before other work begins

---

### Medium — Quality and Correctness

---

#### M-01: No sample rate negotiation between app and Scarlett 2i2

**Affects:** §16 Swift Native Layer — Sprint 3

The Scarlett 2i2 4th Gen supports 44.1 kHz, 48 kHz, 88.2 kHz, and 96 kHz. The selected rate is set on the hardware or via Focusrite Control. If the device is set to 96 kHz and the app opens a session at 48 kHz, `AVAudioEngine` will fail with an opaque CoreAudio error.

**Required fix:** In `CoreAudioSession.open()`, query the device's current sample rate and either adopt it or present a clear error: *"Scarlett 2i2 is set to 96 kHz. Set it to 48 kHz in Focusrite Control and retry."*

---

#### M-02: Temperature correction of DCR is stored but never computed

**Affects:** §9 DCR Entry — Sprint 6

DCR varies ~0.4%/°C (copper). The architecture stores ambient temperature but marks it "informational only." Comparing pickups measured at different temperatures introduces a systematic error. The correction formula is straightforward:

```
DCR_20C = DCR_measured / (1 + 0.00393 × (T_ambient − 20))
```

**Required fix:** Compute and display temperature-corrected DCR alongside the raw value. Use the corrected value as the stored and exported measurement.

---

#### M-03: `PeakDetector` lower frequency bound hardcoded at 500 Hz

**Affects:** §4.1 Domain Services — Sprint 1

The peak detector searches above 500 Hz. This is appropriate for all current pickup types but is a fragile hardcoded value. It should be derived from the selected `PickupType`'s known resonant frequency minimum from `PickupReferenceData`.

**Required fix:** Pass `PickupType` or an explicit `searchRangeHz` parameter to `PeakDetector.findResonantPeak()`. Use the type's documented minimum from the reference table as the lower bound.

---

#### M-04: Silence detection threshold is insufficient — no SNR check defined

**Affects:** §18 Error Handling — Sprint 9

The silence detection threshold is -60 dBFS RMS. A pickup signal at -45 dBFS with a -42 dBFS noise floor passes the silence check but produces an unreliable frequency response. No minimum signal-to-noise ratio is defined.

**Required fix:** After FFT, compute SNR as peak amplitude minus median noise floor (dB). If SNR < 10 dB, warn: *"Signal-to-noise ratio is low. Reduce exciter gap or increase output level in Settings."*

---

#### M-05: Focusrite Control app conflict not addressed

**Affects:** §16 Swift Native Layer — Sprint 3

If Focusrite Control is running simultaneously, its mixer routing (gain staging, air mode) may interfere with measurement results. No guidance is given to the user.

**Required fix:** Add a setup note to `CalibrationScreen` and `MeasurementScreen`: *"Close Focusrite Control before measuring to ensure consistent gain staging."*

---

#### M-06: Long-press comparison selection is wrong UX for macOS desktop

**Affects:** §21 Comparison Feature — Sprint 8

Long-press is a touch/mobile interaction pattern. macOS desktop users expect right-click context menus for secondary actions.

**Required fix:** Replace long-press with a right-click `ContextMenu` on each measurement row in `HomeScreen`: *"Compare with..."* → opens a picker for the second measurement.

---

#### M-07: `fl_chart` logarithmic X axis is significantly understated in scope

**Affects:** §4.4 `FrequencyResponseChart` widget — Sprint 7

`fl_chart` uses linear data coordinates. Implementing a log-scale X axis requires transforming every data point to `log10(f)` before plotting and implementing a full custom `getTitlesWidget` with inverse transforms for labels. The architecture describes this as a routine widget task; it requires careful prototyping.

**Required fix:** Prototype the log-axis implementation in Sprint 0 alongside the audio spike. If complexity is high, evaluate `syncfusion_flutter_charts` as a fallback (native log axis support, free for community use).

---

#### M-08: Sprint time estimates are optimistic for a 1-developer team

**Affects:** Sprint plan — planning

Sprint 3 (Swift Audio Layer, 13 tasks) and Sprint 6 (Core UI Screens, 13 tasks across 7 screens) are each underestimated by at least 50% at a 1-developer pace. Tasks S3-03 and S3-04 (CoreAudio channel routing, synchronised sweep and record) are individually 3–5 day tasks.

**Required fix:** Split Sprint 3 into Sprint 3a (device detection + `openSession`) and Sprint 3b (sweep/record + EventChannel). Extend Sprint 6 to 3 weeks or scope-reduce to 5 screens with 2 deferred to Sprint 8.

---

### Low — Documentation and Process

---

#### L-01: Sprint plan filename contains a typo

**Affects:** Project documentation

The file is named `keneth_frequency_sprint_paln.md` — "paln" instead of "plan."

**Required fix:** Rename to `keneth_frequency_sprint_plan.md`.

---

#### L-02: No UX iteration sprint

**Affects:** Sprint plan

After Sprint 7 (chart), the plan proceeds directly to supporting screens, then testing. No sprint is budgeted for end-to-end UX review with a real pickup before Sprint 11 physical validation.

**Required fix:** Reserve the final 3–4 days of Sprint 9 or Sprint 10 for an end-to-end walkthrough of the complete measurement flow treating it as a UX review cycle.

---

#### L-03: No loopback hardware test path defined

**Affects:** §13 Testing Strategy — Sprint 10

All integration tests use synthetic PCM. A loopback cable (Output 1 → Input 1 on the Scarlett) gives real hardware validation of the audio path. The sweep signal recorded via loopback should produce a flat response, confirming drive flatness compensation is working.

**Required fix:** Add a loopback integration test to Sprint 10: output sweep → Input 1 → expect flat ±2 dB response 100 Hz–15 kHz.

---

### Issue Summary

| ID | Severity | Issue | Sprint Impact |
|---|---|---|---|
| C-01 | Critical | pocketfft header-only — not callable from dart:ffi | Blocks Sprint 2 |
| C-02 | Critical | 5 MB Base64 PCM over MethodChannel | Blocks Sprint 3 |
| C-03 | Critical | dart:ffi pointers unsafe across Isolate boundaries | Blocks Sprint 2 |
| H-01 | ~~High~~ | ~~AVAudioEngine channel mapping unverified~~ — **RESOLVED**: bus 0 = channel 1 confirmed | ✓ Done |
| H-02 | High | FrequencyResponse JSON storage ~6.5 MB per row | Sprint 4 |
| H-03 | High | No FSM cancel / back-navigation handling | Sprint 5 |
| H-04 | ~~High~~ | ~~USB PID unverified~~ — **RESOLVED**: PID = 0x8219 | ✓ Done |
| H-05 | High | CI not set up until Sprint 10 | All sprints |
| H-06 | High | No audio spike before Sprint 3 | Timeline |
| M-01 | Medium | No sample rate negotiation with Scarlett | Sprint 3 |
| M-02 | Medium | Temperature correction stored but not applied | Sprint 6 |
| M-03 | Medium | Peak detector lower bound hardcoded at 500 Hz | Sprint 1 |
| M-04 | Medium | Silence detection insufficient — no SNR check | Sprint 9 |
| M-05 | Medium | Focusrite Control app conflict not addressed | Sprint 3 |
| M-06 | Medium | Long-press comparison UX wrong for macOS desktop | Sprint 8 |
| M-07 | Medium | fl_chart log axis scope significantly understated | Sprint 7 |
| M-08 | Medium | Sprint time estimates optimistic for 1 developer | Planning |
| L-01 | Low | Sprint plan filename typo ("paln") | Documentation |
| L-02 | Low | No UX iteration sprint budgeted | Planning |
| L-03 | Low | No loopback hardware test path | Sprint 10 |

---

### Recommended Actions Before Development Begins

1. **Resolve C-01** — define `pocketfft_wrapper.c` and Xcode build phase; update §4.2 and §5
2. **Resolve C-02** — replace Base64 PCM with `BinaryCodec` or temp-file path; update §16
3. **Resolve C-03** — enforce plain-Dart-only `compute()` boundary; update §17
4. **Run Sprint 0 audio spike** — prove AVAudioEngine channel routing before committing; update §16 with findings
5. **Verify USB PID** — run `system_profiler SPUSBDataType` with device connected; update §16
6. **Define FrequencyResponse storage size** — specify exact point count for stored vs. display curves; update §4.2
7. **Configure CI in Sprint 0** — do not defer to Sprint 10; update §23
8. **Rename sprint plan file** — `sprint_paln.md` → `sprint_plan.md`

---

## 25. Revision History

| Version | Date | Changes |
|---|---|---|
| 0.1 | 2026-04-16 | Initial architecture document — sections 1–15 |
| 0.2 | 2026-04-16 | Added sections 16–24: Swift native layer, concurrency, error handling, routing, settings, comparison, export, CI/deployment |
| 0.3 | 2026-04-16 | Added section 24: Development Issues Assessment — 20 issues across Critical/High/Medium/Low; renumbered Revision History to §25 |
