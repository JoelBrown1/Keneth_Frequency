# Keneth Frequency — Sprint Development Plan
**Version 0.2** — Updated to address all issues in §24 Development Issues Assessment

---

## Overview

This plan organises the Keneth Frequency Flutter application into 13 two-week sprints. Each sprint has a focused goal, a set of deliverables, and a clear definition of done. Sprints build sequentially — each depends on the previous sprint's deliverables being complete and passing tests.

**Total estimated duration:** 26 weeks (~6.5 months)
**Team assumption:** 1–2 developers
**Arch reference:** `keneth_frequency_arch.md`
**Spec reference:** `keneth_frequency_specs.md`

### Changes from v0.1

| Change | Issue Resolved | Sprint Affected |
|---|---|---|
| Sprint 0: added audio spike, CI setup, USB PID verification, fl_chart log axis prototype, pocketfft compilation proof | H-06, H-05, H-04, M-07, C-01 | Sprint 0 |
| Sprint 1: `PeakDetector` lower bound made configurable via `PickupType` | M-03 | Sprint 1 |
| Sprint 2: pocketfft compiled library approach; FFI/Isolate boundary enforced; SNR check added | C-01, C-03, M-04 | Sprint 2 |
| Sprint 3 split into 3a (device + session) and 3b (sweep/record + channels) | M-08 | Sprint 3a, 3b |
| Sprint 3a/3b: BinaryCodec replaces Base64; channel mapping verified; sample rate negotiation added; Focusrite Control note added | C-02, H-01, M-01, M-05 | Sprint 3a, 3b |
| Sprint 4: `FrequencyResponse` storage fixed — smoothed points only, not raw FFT | H-02 | Sprint 4 |
| Sprint 5: `cancelSession()` + GoRouter `onExit` hooks added to FSM | H-03 | Sprint 5 |
| Sprint 6: temperature-corrected DCR computed and displayed | M-02 | Sprint 6 |
| Sprint 7: fl_chart log axis approach confirmed in Sprint 0 spike; fallback path defined | M-07 | Sprint 7 |
| Sprint 8: comparison selection changed from long-press to right-click ContextMenu | M-06 | Sprint 8 |
| Sprint 9: UX iteration days added | L-02 | Sprint 9 |
| Sprint 10: CI was already configured in Sprint 0; loopback hardware test added | H-05, L-03 | Sprint 10 |
| Sprint 11: references updated to §25 (revision history renumbered in arch doc) | — | Sprint 11 |
| File to be renamed `keneth_frequency_sprint_plan.md` at v1.0 | L-01 | Sprint 11 |

---

## Sprint Summary

| Sprint | Name | Duration | Issues Addressed | Status |
|---|---|---|---|---|
| 0 | Foundation + Spikes | 2 weeks | H-04, H-05, H-06, C-01 (partial), M-07 | ✅ DONE |
| 1 | Domain Layer | 2 weeks | M-03 | ✅ DONE |
| 2 | DSP Pipeline | 2 weeks | C-01 (complete), C-03, M-04 | ✅ DONE |
| 3a | Swift Audio — Device & Session | 2 weeks | C-02 (partial), H-01, H-04, M-01, M-05 | ✅ DONE |
| 3b | Swift Audio — Sweep & Record | 2 weeks | C-02 (complete), M-08 | ✅ DONE |
| 4 | Storage & Calibration | 2 weeks | H-02 | ✅ DONE |
| 5 | Application State | 2 weeks | H-03 | — |
| 6 | Core UI Screens | 2 weeks | M-02 | — |
| 7 | Frequency Response Chart | 2 weeks | M-07 (confirmed) | — |
| 8 | Supporting Screens | 2 weeks | M-06 | — |
| 9 | Export, Error Handling & UX Review | 2 weeks | M-04, L-02 | — |
| 10 | Testing & CI Completion | 2 weeks | L-03 | — |
| 11 | Verification & Release | 2 weeks | L-01 | — |

---

## Sprint 0 — Foundation + Spikes ✅ COMPLETE

**Goal:** Establish a working, runnable Flutter macOS project with all dependencies installed and directory structure in place. Critically, run three technical spikes before any feature work begins: audio channel routing, pocketfft compilation, and fl_chart log axis feasibility. Configure CI from day one.

**Duration:** 2 weeks
**Arch sections:** §2 · §5 · §6 · §14 · §23
**Issues addressed:** H-04 (USB PID), H-05 (CI from day one), H-06 (audio spike), C-01 partial (pocketfft compilation), M-07 (fl_chart log axis spike)

### Deliverables

- Flutter macOS project running (`flutter run -d macos` shows blank app)
- All `pubspec.yaml` dependencies resolved with no version conflicts
- Directory structure matches §6 skeleton
- macOS audio entitlements configured
- `build_runner` code generation working (Riverpod + Drift)
- GitHub Actions CI pipeline configured and green from day one
- Git repository initialised with `main` and `develop` branches
- **Spike result documented:** AVAudioEngine channel routing — confirmed or fallback decided
- **Spike result documented:** pocketfft compilation approach confirmed on Apple Silicon
- **Spike result documented:** fl_chart log axis feasibility confirmed or syncfusion selected
- **USB PID verified** via `system_profiler SPUSBDataType` and recorded

### Tasks

| # | Task | Issue | Notes |
|---|---|---|---|
| S0-01 | Create Flutter project: `flutter create --platforms=macos keneth_frequency` | — | macOS-only flag |
| S0-02 | Add all dependencies to `pubspec.yaml` per §5; pin exact versions | — | |
| S0-03 | Run `flutter pub get` and resolve any conflicts | — | |
| S0-04 | Create full directory skeleton under `lib/` per §6; add `.gitkeep` in empty dirs | — | |
| S0-05 | Configure macOS audio entitlements in `DebugProfile.entitlements` and `Release.entitlements` | — | `audio-input` + `audio-output` keys |
| S0-06 | Initialise git, add `.gitignore`, create `main` and `develop` branches | — | |
| S0-07 | **Configure GitHub Actions CI** — `ci.yml` with `test` + `build` jobs on `macos-latest`; runs on every push from day one | H-05 | Do not defer to Sprint 10 |
| S0-08 | Run `dart run build_runner build` and confirm no errors | — | Riverpod + Drift generators |
| S0-09 | Verify `flutter run -d macos` launches blank app without errors | — | |
| S0-10 | Verify `flutter test` exits 0 (zero tests, passes vacuously); CI pipeline goes green | H-05 | |
| S0-11 | **USB PID spike:** connect Scarlett 2i2 4th Gen; run `system_profiler SPUSBDataType`; record VID and PID | H-04 | Update §16 of arch doc with verified value |
| S0-12 | **Audio spike (day 1–3):** write a minimal Swift proof-of-concept using AVAudioEngine that routes a sine tone to Output channel 0 of the Scarlett 2i2 exclusively | H-06 | Does not need to be in the Flutter project |
| S0-13 | **Audio spike (day 3–5):** extend proof-of-concept to simultaneously record Input channel 0; confirm correct channel is captured | H-06, H-01 | Record result; if fails, evaluate PortAudio FFI fallback |
| S0-14 | **pocketfft compilation spike:** add `pocketfft.h` + `pocketfft_wrapper.c` to `macos/Runner/`; add Xcode build phase to compile to `.dylib`; confirm `DynamicLibrary.open()` loads it from Dart | C-01 | Must succeed before Sprint 2 begins |
| S0-15 | **fl_chart log axis spike:** implement a minimal `LineChart` with log10-transformed X axis; confirm tick labels render correctly at 20, 100, 1k, 10k, 20k Hz | M-07 | If too complex, switch to `syncfusion_flutter_charts`; document decision |
| S0-16 | Document all four spike outcomes in a `SPIKES.md` file in the project root | — | Decisions become inputs for arch doc updates |

### Definition of Done

- `flutter run -d macos` launches without error
- `flutter test` exits 0; CI pipeline is green on `main`
- USB PID verified and §16 of arch doc updated
- Audio spike: AVAudioEngine routes to Output 1 and records from Input 1 independently — confirmed or fallback selected
- pocketfft `.dylib` loads successfully from Dart `DynamicLibrary.open()`
- fl_chart log axis renders correct tick labels — confirmed or syncfusion selected
- All four spike outcomes documented in `SPIKES.md`

---

## Sprint 1 — Domain Layer ✅ COMPLETE

**Goal:** Implement the complete domain layer — all entities, enums, domain services, and reference data. No platform code. Fully unit-tested.

**Duration:** 2 weeks
**Arch sections:** §4.1
**Depends on:** Sprint 0
**Issues addressed:** M-03 (configurable PeakDetector search range)

### Deliverables

- `PickupMeasurement`, `FrequencyResponse`, `FrequencyPoint`, `CalibrationData`, `PickupProfile` entities
- `PickupType` enum with all 10 values
- `LcCalculator` — all four formula methods including temperature-corrected DCR
- `PeakDetector` — peak finding with configurable search range per pickup type
- `SweepGenerator` — log chirp buffer generation
- `PickupReferenceData` — complete static table for all pickup types including search range per type
- Unit tests for all domain services passing

### Tasks

| # | Task | Issue | Notes |
|---|---|---|---|
| S1-01 | Implement `PickupType` enum | — | 10 values including `unknown` |
| S1-02 | Implement `FrequencyPoint` value class | — | `{double frequency, double magnitude}` |
| S1-03 | Implement `FrequencyResponse` entity | — | Wraps `List<FrequencyPoint>`; helpers: `atFrequency()`, `maxMagnitude()`, `slice(f1, f2)` |
| S1-04 | Implement `CalibrationData` entity | — | `{id, timestamp, List<FrequencyPoint> spectrum}` |
| S1-05 | Implement `PickupMeasurement` entity | — | Full field set per §4.1; add `dcrCorrected` field for temperature-corrected value |
| S1-06 | Implement `PickupProfile` entity | M-03 | Add `searchRangeHz: ({double min, double max})` field to define valid peak search range per type |
| S1-07 | Implement `LcCalculator` | — | `resonantFrequency()`, `solveInductance()`, `solveCapacitance()`, `loadedFrequency()` |
| S1-08 | Implement `LcCalculator.correctDcrForTemperature(double dcr, double tempC) → double` | M-02 | Formula: `DCR_20C = DCR / (1 + 0.00393 × (T − 20))` |
| S1-09 | Implement `PeakDetector.findResonantPeak(FrequencyResponse, {PickupType? type}) → PeakResult` | M-03 | Derive search range from `PickupReferenceData` when type is provided; default lower bound 500 Hz for `unknown` |
| S1-10 | Implement `PeakDetector.computeQFactor()` with -3 dB walk | — | |
| S1-11 | Implement `SweepGenerator` | — | Log chirp formula, normalised to -12 dBFS |
| S1-12 | Implement `PickupReferenceData` | M-03 | All 10 pickup types; include `searchRangeHz` per type matching specs reference table |
| S1-13 | Write unit tests: `lc_calculator_test.dart` | — | Test all formula methods; verify SH-4: L=8.06H, C=128pF → ~4.95 kHz; verify DCR correction at 0°C and 40°C |
| S1-14 | Write unit tests: `peak_detector_test.dart` | M-03 | Test with `PickupType.humbuckerMediumOutput` → search range 4–6 kHz; synthetic peak at 4.78 kHz returns within ±50 Hz |
| S1-15 | Write unit tests: `sweep_generator_test.dart` | — | Verify output length, sample rate, frequency bounds, peak amplitude |

### Definition of Done

- All domain service unit tests pass
- `LcCalculator` with SH-4 values returns 4,951 Hz ±10 Hz
- `PeakDetector` with `humbuckerMediumOutput` type locates synthetic 4.78 kHz peak within ±50 Hz
- `PeakDetector` search range is derived from `PickupReferenceData`, not hardcoded
- No Flutter imports anywhere in `lib/domain/`
- 100% of domain service methods covered by at least one test

---

## Sprint 2 — DSP Pipeline ✅ COMPLETE

**Goal:** Implement the full post-recording DSP pipeline. The pocketfft `.dylib` compiled in Sprint 0 is wrapped in FFI bindings. The pipeline runs entirely within a single Dart Isolate — no native pointers cross Isolate boundaries. SNR validation is included.

**Duration:** 2 weeks
**Arch sections:** §4.2 (DSP) · §7 · §17
**Depends on:** Sprint 1; Sprint 0 pocketfft spike confirmed
**Issues addressed:** C-01 (complete — compiled .dylib), C-03 (Isolate boundary safety), M-04 (SNR check)

### Deliverables

- `FftProcessor` — FFT via `dart:ffi` → compiled pocketfft `.dylib`; all FFI allocation/deallocation within the same call, no `Pointer<T>` returned
- `WindowFunctions` — Hann and Blackman-Harris
- `FrequencyResponseBuilder` — calibration subtraction, trimming to 20 Hz–20 kHz
- `Smoothing` — 1/6 octave fractional octave smoothing; output is a fixed ~1000 log-spaced points for display
- `SignalValidator` — clip detection, silence detection, SNR check
- DSP pipeline runnable in a Dart `Isolate` via `compute()` using plain Dart types only
- Unit tests for all DSP components

### Tasks

| # | Task | Issue | Notes |
|---|---|---|---|
| S2-01 | Load compiled pocketfft `.dylib` via `DynamicLibrary.open()` in `FftBindings` | C-01 | Uses `.dylib` from Sprint 0 spike; not the header file |
| S2-02 | Implement `FftProcessor.process(Float32List samples, {WindowFunction}) → List<double> magnitudesDb` | C-03 | All `calloc` allocations within this method; freed before return; no `Pointer<T>` escapes |
| S2-03 | Implement `WindowFunctions.hann(int size) → Float64List` | — | Standard formula |
| S2-04 | Implement `WindowFunctions.blackmanHarris(int size) → Float64List` | — | 4-term formula |
| S2-05 | Implement `FrequencyResponseBuilder.build(List<double> magnitudesDb, CalibrationData?, int sampleRate) → FrequencyResponse` | — | Subtract calibration in dB; map bin index to Hz; trim to 20 Hz–20 kHz |
| S2-06 | Implement `Smoothing.fractionalOctave(FrequencyResponse, double fraction) → FrequencyResponse` | H-02 | Output: ~1000 log-spaced points for display resolution; 1/6 default |
| S2-07 | Implement `Smoothing.toStorageResolution(FrequencyResponse) → FrequencyResponse` | H-02 | Downsample smoothed response to ~60 log-spaced points for SQLite storage |
| S2-08 | Implement `SignalValidator.checkClip(Float32List) → bool` | — | Threshold: 0.98 |
| S2-09 | Implement `SignalValidator.checkSilence(Float32List) → bool` | — | RMS < -60 dBFS |
| S2-10 | Implement `SignalValidator.checkSnr(FrequencyResponse, PeakResult) → double` | M-04 | SNR = peak amplitude − median noise floor (dB); warn if < 10 dB |
| S2-11 | Wrap full pipeline in `_runDspPipeline(DspPipelineInput) → DspPipelineOutput` top-level function | C-03 | Input and output are plain Dart types only — `Float32List`, `List<double>`, no `Pointer<T>` |
| S2-12 | Write unit tests: `fft_processor_test.dart` | C-01 | 1 kHz sine at 48 kHz → peak within ±1 bin |
| S2-13 | Write unit tests: `signal_validator_test.dart` | M-04 | Clipped buffer → `checkClip` true; silence buffer → `checkSilence` true; low-SNR response → SNR < 10 dB |
| S2-14 | Write unit tests: `frequency_response_builder_test.dart` | — | Synthetic spectrum + calibration → verify subtraction and trimming |
| S2-15 | Write integration test: synthetic sweep PCM → full DSP pipeline → peak at known frequency | — | Use `PeakDetector` end-to-end |

### Definition of Done

- FFT of a 1 kHz sine wave at 48 kHz returns peak within ±1 bin
- Full pipeline locates synthetic 4.78 kHz peak within ±50 Hz
- Pipeline runs inside `compute()` without error; no `Pointer<T>` passed to or from isolate
- `toStorageResolution()` returns ≤60 points
- SNR check returns < 10 dB for a synthetic low-signal response
- pocketfft `.dylib` loads via `DynamicLibrary.open()`

---

## Sprint 3a — Swift Audio: Device & Session ✅ COMPLETE

**Goal:** Implement device enumeration, Scarlett 2i2 detection, and audio session open/close. The correct USB PID (verified in Sprint 0) is used. Sample rate negotiation is included. The channel mapping verified in Sprint 0 spike is applied.

**Duration:** 2 weeks
**Arch sections:** §4.2 (Audio) · §16
**Depends on:** Sprint 0 (audio spike result, USB PID)
**Issues addressed:** C-02 partial (BinaryCodec chosen), H-01 (channel mapping applied), H-04 (verified PID), M-01 (sample rate negotiation), M-05 (Focusrite Control note)

### Deliverables

- `ScarlettDeviceDetector.swift` — USB VID/PID detection using PID verified in Sprint 0
- `CoreAudioSession.listDevices()` — device metadata enumeration
- `CoreAudioSession.open()` — AVAudioEngine setup with explicit channel routing per Sprint 0 spike result; sample rate negotiation
- `CoreAudioSession.close()` — clean teardown
- `AudioChannel.swift` — `MethodChannel` with `getDevices` and `openSession` methods
- Dart `AudioServiceInterface` abstract class
- `MacosAudioService` Dart wrapper — device and session methods only
- `AudioDeviceInfo` Dart model
- `MethodChannel` configured to use **`BinaryCodec`** (no Base64 for audio buffers)

### Tasks

| # | Task | Issue | Notes |
|---|---|---|---|
| S3a-01 | Implement `ScarlettDeviceDetector.swift` using verified USB PID from Sprint 0 spike | H-04 | Enumerate CoreAudio `AudioObjectID`s; match VID + PID |
| S3a-02 | Implement `CoreAudioSession.listDevices()` — name, channel count, supported sample rates | — | |
| S3a-03 | Implement `CoreAudioSession.open(deviceId, sampleRate)` — query device current sample rate; if mismatch with requested rate, return descriptive error string | M-01 | Error: "Scarlett 2i2 is set to 96 kHz. Set it to 48 kHz in Focusrite Control and retry." |
| S3a-04 | Apply channel routing from Sprint 0 spike result — route Output bus index and Input bus index per verified mapping | H-01 | Document the mapping in code comments |
| S3a-05 | Implement `CoreAudioSession.close()` — stop engine, release nodes | — | |
| S3a-06 | Implement `AudioChannel.swift` — `getDevices` and `openSession` MethodChannel methods | — | |
| S3a-07 | Configure `MethodChannel` with `BinaryCodec` for `keneth_frequency/audio` channel | C-02 | Establishes binary transfer for Sprint 3b sweep buffers |
| S3a-08 | Register `AudioChannel` in `AppDelegate.swift` | — | |
| S3a-09 | Implement Dart `AudioServiceInterface` abstract class | — | All four methods |
| S3a-10 | Implement `MacosAudioService` — `getDevices()` and `openSession()` Dart wrappers | — | |
| S3a-11 | Implement `AudioDeviceInfo` Dart model | — | |
| S3a-12 | Add setup note string to `CalibrationScreen` and `MeasurementScreen` copy: *"Close Focusrite Control before measuring"* | M-05 | Surfaced as an info banner, not a blocking error |
| S3a-13 | Manual test: `getDevices()` returns Scarlett 2i2 4th Gen by name | H-04 | |
| S3a-14 | Manual test: `openSession()` succeeds at 48 kHz; fails with correct error message at mismatched rate | M-01 | |

### Definition of Done

- `getDevices()` returns the Scarlett 2i2 4th Gen using verified USB PID
- `openSession()` succeeds at 48 kHz and returns a descriptive error for sample rate mismatch
- `MethodChannel` is using `BinaryCodec`
- Channel routing matches the Sprint 0 spike verified mapping
- `openSession()` returns `false` gracefully when no Scarlett is connected

---

## Sprint 3b — Swift Audio: Sweep & Record ✅ COMPLETE

**Goal:** Implement the synchronised sweep playback and input recording operation. PCM buffers are transferred as raw bytes via `BinaryCodec` — no Base64 encoding. The live RMS `EventChannel` is implemented.

**Duration:** 2 weeks
**Arch sections:** §16 · §17
**Depends on:** Sprint 3a
**Issues addressed:** C-02 (complete — BinaryCodec replaces Base64), M-08 (Sprint 3 split completed)

### Deliverables

- `CoreAudioSession.playSweepAndRecord()` — synchronised AVAudioEngine sweep + tap recording
- Raw bytes PCM transfer via `BinaryCodec` — sweep in as `Uint8List`, recording out as `Uint8List`
- `EventChannel` (`keneth_frequency/level`) streaming live RMS `double` during recording
- `MacosAudioService.playSweepAndRecord()` and `levelStream` Dart wrappers
- Manual integration test: sweep played and recording captured at correct sample count

### Tasks

| # | Task | Issue | Notes |
|---|---|---|---|
| S3b-01 | Implement `CoreAudioSession.playSweepAndRecord(sweepBytes, outputChannel, inputChannel)` — decode `Uint8List` → `Float32` buffer; schedule on output player node | C-02 | Input and output are raw bytes, not Base64 strings |
| S3b-02 | Implement AVAudioNode input tap — collect `Float32` samples into `[Float]` array on a serial `DispatchQueue` | — | Buffer size: 4096 samples |
| S3b-03 | On sweep completion: encode collected `[Float]` → `Uint8List`; return via `BinaryCodec` reply | C-02 | Eliminates ~5 MB Base64 string; raw bytes ~3.84 MB |
| S3b-04 | Implement `EventChannel` for live RMS — compute RMS per 4096-sample tap buffer; sink `Double` to `FlutterEventSink` | — | Channel: `keneth_frequency/level` |
| S3b-05 | Implement `MacosAudioService.playSweepAndRecord()` Dart wrapper — send `Float32List` as `Uint8List`; receive recording as `Float32List` | C-02 | Decode `Uint8List` response to `Float32List` |
| S3b-06 | Implement `MacosAudioService.levelStream → Stream<double>` — wraps `EventChannel.receiveBroadcastStream()` | — | |
| S3b-07 | Manual test: `playSweepAndRecord()` returns 960,000-sample buffer (20s × 48kHz) | — | |
| S3b-08 | Manual test: `levelStream` emits non-zero values during an active recording | — | |
| S3b-09 | Manual test with loopback cable (Output 1 → Input 1): sweep recorded on input; waveform visible in debug log | — | Confirms audio path; not yet a DSP test |

### Definition of Done

- `playSweepAndRecord()` returns a `Float32List` of exactly 960,000 samples without error
- No Base64 string is used anywhere in the audio transfer path
- `levelStream` emits `double` RMS values during recording
- Loopback manual test shows non-silence on the recorded buffer

---

## Sprint 4 — Storage & Calibration ✅ COMPLETE

**Goal:** Implement the persistence layer (Drift SQLite) and calibration flow. The `FrequencyResponse` storage format stores only the smoothed, downsampled curve — not the raw FFT output.

**Duration:** 2 weeks
**Arch sections:** §4.2 (Storage) · §8
**Depends on:** Sprint 1 (entities), Sprint 2 (DSP pipeline)
**Issues addressed:** H-02 (FrequencyResponse storage size)

### Deliverables

- Drift database schema — `measurements` and `calibrations` tables
- `MeasurementRepository` — CRUD for `PickupMeasurement`; stores display-resolution response (1000 points) and storage-resolution response (60 points) separately
- `CalibrationRepository` — save, load, list, delete calibrations; calibration stored at display resolution
- `ExportService` skeleton (formats implemented in Sprint 9)
- Calibration flow end-to-end: 1MΩ reference sweep → spectrum saved → loaded for subsequent measurements
- Unit tests for repository layer using in-memory SQLite

### Tasks

| # | Task | Issue | Notes |
|---|---|---|---|
| S4-01 | Define Drift `AppDatabase` schema | H-02 | Add two response columns: `frequency_response_display_json` (1000 pts) and `frequency_response_storage_json` (60 pts); never store raw FFT output |
| S4-02 | Implement `MeasurementRepository.save(PickupMeasurement)` | H-02 | Serialize display and storage resolution responses separately |
| S4-03 | Implement `MeasurementRepository.getAll() → List<PickupMeasurement>` | — | Load storage-resolution response by default for list views |
| S4-04 | Implement `MeasurementRepository.getById(String id) → PickupMeasurement?` | — | Load display-resolution response for chart rendering |
| S4-05 | Implement `MeasurementRepository.delete(String id)` | — | |
| S4-06 | Implement `CalibrationRepository.save(CalibrationData)` | — | Store at display resolution (~1000 points) |
| S4-07 | Implement `CalibrationRepository.getLatest() → CalibrationData?` | — | |
| S4-08 | Implement `CalibrationRepository.isStale({int thresholdHours}) → bool` | — | Default 24 hours |
| S4-09 | Implement `CalibrationRepository.list()` and `delete(String id)` | — | |
| S4-10 | Write unit tests: `MeasurementRepository` save → getById round trip | H-02 | Assert display response has ~1000 points; storage response has ≤60 points |
| S4-11 | Write unit tests: `CalibrationRepository` save → getLatest → isStale | — | |
| S4-12 | Wire calibration flow end-to-end: DSP pipeline → `CalibrationRepository.save()` | — | Requires Sprint 2 DSP + Sprint 3b Audio |

### Definition of Done

- `MeasurementRepository` round trip preserves all fields
- Display response stored at ~1000 points; storage response at ≤60 points; no raw FFT data in SQLite
- `CalibrationRepository.isStale()` returns `true` for expired calibrations
- All repository unit tests pass against in-memory SQLite
- Calibration data persists across app restarts

---

## Sprint 5 — Application State

**Goal:** Implement the Riverpod application layer — all providers, the session FSM, and GoRouter navigation. The FSM includes a `cancelSession()` path wired to GoRouter's `onExit` on all session screens.

**Duration:** 2 weeks
**Arch sections:** §4.3 · §19
**Depends on:** Sprint 1 (domain), Sprint 4 (storage)
**Issues addressed:** H-03 (session cancellation + back-navigation)

### Deliverables

- All Riverpod providers: `audioDeviceProvider`, `sessionProvider`, `calibrationProvider`, `measurementResultsProvider`, `measurementHistoryProvider`
- `SessionStateNotifier` with full FSM including `cancelSession()` and error states
- `AppSettings` model + `SettingsNotifier` backed by `shared_preferences`
- GoRouter configuration with all routes and `onExit` hooks on session screens
- `ref.listen` navigation bridge in `app.dart`
- `SessionStateNotifier` unit tests covering all FSM transitions including cancel

### Tasks

| # | Task | Issue | Notes |
|---|---|---|---|
| S5-01 | Implement `SessionState` sealed class hierarchy | — | All 7 states from §4.3 |
| S5-02 | Implement `SessionStateNotifier` FSM — forward transitions | — | `startSession()`, `submitDcr()`, `startCalibration()`, `calibrationComplete()`, `startMeasurement()`, `measurementComplete()`, `saveResult()`, `reset()` |
| S5-03 | Implement `SessionStateNotifier.cancelSession()` | H-03 | Calls `MacosAudioService.closeSession()`; transitions FSM to `IdleState` regardless of current state |
| S5-04 | Implement GoRouter `onExit` callback on all session routes | H-03 | Calls `ref.read(sessionProvider.notifier).cancelSession()` when user navigates back mid-session |
| S5-05 | Implement `AudioDeviceProvider` — wraps `MacosAudioService.getDevices()` as `FutureProvider` | — | |
| S5-06 | Implement `CalibrationProvider` — watches `CalibrationRepository`; exposes latest calibration and `isStale` | — | |
| S5-07 | Implement `MeasurementResultsProvider` | — | Cleared on `reset()` and `cancelSession()` |
| S5-08 | Implement `MeasurementHistoryProvider` — streams `MeasurementRepository.getAll()` | — | Auto-refreshes on save |
| S5-09 | Implement `AppSettings` model and `SettingsNotifier` | — | All fields from §20 |
| S5-10 | Implement GoRouter configuration per §19 with all routes | — | |
| S5-11 | Implement `ref.listen` navigation bridge in `app.dart` | — | State changes drive `router.go()` |
| S5-12 | Write unit tests: `session_notifier_test.dart` — forward transitions | — | All 7 states |
| S5-13 | Write unit tests: `cancelSession()` from each state | H-03 | Calling `cancelSession()` from any state → `IdleState`; audio session closed |
| S5-14 | Write unit tests: `settings_notifier_test.dart` | — | Default values, persistence round trip |

### Definition of Done

- `SessionStateNotifier` transitions through all 7 states correctly
- `cancelSession()` from any state returns FSM to `IdleState`
- GoRouter `onExit` hooks call `cancelSession()` on back navigation during active session
- Navigation bridge routes to the correct screen on each state transition
- All provider unit tests pass

---

## Sprint 6 — Core UI Screens

**Goal:** Implement all screens in the primary measurement flow. The DCR Entry screen computes and displays temperature-corrected DCR alongside the raw reading.

**Duration:** 2 weeks
**Arch sections:** §4.4 · §9 · §10
**Depends on:** Sprint 5 (application state + navigation)
**Issues addressed:** M-02 (temperature-corrected DCR)

### Deliverables

- `HomeScreen` — measurement history list with New Measurement button
- `SetupScreen` — pickup type selector grid + name input
- `DcrEntryScreen` — DCR input with type-aware validation, range warning, and temperature-corrected DCR display
- `CalibrationScreen` — instruction steps + sweep progress indicator + Focusrite Control close reminder
- `MeasurementScreen` — live level meter + SNR indicator + sweep progress bar
- `ResultsScreen` — derived values table including corrected DCR + placeholder chart area + Save button
- `SessionProgressBar` widget
- `AppTheme` — dark measurement-tool aesthetic

### Tasks

| # | Task | Issue | Notes |
|---|---|---|---|
| S6-01 | Implement `AppTheme` — dark theme, colour palette, text styles | — | |
| S6-02 | Implement `SessionProgressBar` widget | — | 5-step indicator |
| S6-03 | Implement `HomeScreen` | — | History list; New Measurement button |
| S6-04 | Implement `PickupTypeSelector` widget | — | Card grid of all 10 types |
| S6-05 | Implement `SetupScreen` | — | |
| S6-06 | Implement `DcrInputForm` widget — `TextFormField` with validation, range warning per §9 | — | |
| S6-07 | Implement live temperature-corrected DCR display on `DcrEntryScreen` | M-02 | Calls `LcCalculator.correctDcrForTemperature()`; updates as user types DCR or temperature; label: "Corrected to 20°C: X,XXX Ω" |
| S6-08 | Implement `DcrEntryScreen` — hosts `DcrInputForm` + temperature field + corrected DCR display | M-02 | Stores both raw and corrected DCR values |
| S6-09 | Add Focusrite Control close reminder to `CalibrationScreen` | M-05 | Info banner: "Close Focusrite Control before measuring" |
| S6-10 | Implement `CalibrationScreen` with sweep progress and 1MΩ instructions | — | |
| S6-11 | Implement `LevelMeter` widget — dB bar; clip warning; SNR indicator when available | M-04 | Shows "Low SNR" warning if `SignalValidator.checkSnr()` < 10 dB |
| S6-12 | Implement `MeasurementScreen` | — | |
| S6-13 | Add temperature-corrected DCR row to `ResultsScreen` derived values table | M-02 | Labelled "DCR (corrected to 20°C)" |
| S6-14 | Implement `ResultsScreen` — full derived values table; placeholder chart; Save + Discard | — | |
| S6-15 | Widget test: `DcrInputForm` range warning fires for out-of-range value | — | |
| S6-16 | Widget test: corrected DCR updates live as temperature field changes | M-02 | |
| S6-17 | Widget test: `ResultsScreen` renders all 9 derived value rows (including corrected DCR) | — | |

### Definition of Done

- Full session flow navigable end-to-end
- DCR range warning fires correctly per §9 table
- Temperature-corrected DCR displayed live on DCR entry screen and on Results screen
- Focusrite Control reminder visible on CalibrationScreen
- `AppTheme` applied globally

---

## Sprint 7 — Frequency Response Chart

**Goal:** Implement the `FrequencyResponseChart` widget using the approach confirmed in the Sprint 0 log axis spike. Replace the ResultsScreen placeholder.

**Duration:** 2 weeks
**Arch sections:** §4.4 (`FrequencyResponseChart` widget)
**Depends on:** Sprint 6 (ResultsScreen placeholder)
**Issues addressed:** M-07 (log axis approach confirmed from Sprint 0 spike)

### Deliverables

- `FrequencyResponseChart` widget — log-scale implementation using fl_chart (or syncfusion, per Sprint 0 spike decision)
- `PeakMarker` widget — vertical dashed line + frequency callout
- Bandwidth shading — -3 dB region as a translucent band
- Secondary calibration reference line (grey, dashed)
- Pan and zoom enabled
- Chart integrated into `ResultsScreen`

### Tasks

| # | Task | Issue | Notes |
|---|---|---|---|
| S7-01 | Confirm Sprint 0 spike log axis approach — apply `logFrequencyToX()` transform or use syncfusion native log axis | M-07 | Decision already made in Sprint 0; implement the confirmed approach |
| S7-02 | Implement custom X axis tick labels: 20, 50, 100, 200, 500, 1k, 2k, 5k, 10k, 20k Hz | — | |
| S7-03 | Implement `FrequencyResponseChart` — auto-scaled Y axis (±5 dB padding around peak) | — | |
| S7-04 | Implement `PeakMarker` — vertical dashed line with `f_res = X.XX kHz` label | — | |
| S7-05 | Implement -3 dB bandwidth shading | — | |
| S7-06 | Add secondary calibration reference series (grey dashed) | — | |
| S7-07 | Enable pan and zoom; constrain to 20 Hz–20 kHz | — | |
| S7-08 | Replace placeholder in `ResultsScreen` with `FrequencyResponseChart` | — | |
| S7-09 | Widget test: peak at 4.78 kHz → `PeakMarker` label reads "4.78 kHz" | — | |
| S7-10 | Widget test: chart renders without overflow at 1280×800 and 1440×900 | — | |

### Definition of Done

- Log-scale X axis renders with correct tick labels
- Peak annotation appears at correct frequency
- -3 dB bandwidth band is visually correct
- Pan and zoom work without escaping bounds
- No layout overflow warnings in debug mode

---

## Sprint 8 — Supporting Screens

**Goal:** Implement the Pickup Library reference screen, Settings screen, and Comparison feature. Comparison uses a right-click context menu — not long-press — consistent with macOS desktop conventions.

**Duration:** 2 weeks
**Arch sections:** §11 · §20 · §21
**Depends on:** Sprint 7 (chart widget), Sprint 5 (providers)
**Issues addressed:** M-06 (right-click ContextMenu replaces long-press)

### Deliverables

- `ReferenceScreen` — full pickup type table, sortable, expandable rows
- `SettingsScreen` — all settings per §20 backed by `SettingsNotifier`
- Comparison mode triggered by **right-click context menu** on `HomeScreen` rows
- `ResultsScreen` comparison mode — dual-line chart, Δf callout, two-column data panel
- Navigation to Reference and Settings from `HomeScreen`

### Tasks

| # | Task | Issue | Notes |
|---|---|---|---|
| S8-01 | Implement `ReferenceScreen` — `DataTable` of all 10 pickup types | — | Sortable by resonant freq, DCR, inductance |
| S8-02 | Add expandable rows — typical L, C range and multimeter range | — | |
| S8-03 | Add "Verification reference" badge to SH-4 row | — | |
| S8-04 | Add "Not measurable — active electronics" badge to active pickup row | — | |
| S8-05 | Implement `SettingsScreen` | — | All fields from §20 |
| S8-06 | Add navigation to Reference and Settings from `HomeScreen` app bar | — | |
| S8-07 | Implement right-click `ContextMenu` on each `HomeScreen` measurement row | M-06 | Options: "View", "Compare with…", "Delete"; replaces long-press |
| S8-08 | Implement "Compare with…" picker — modal list of other saved measurements to select as comparison target | M-06 | |
| S8-09 | Add `/compare/:id1/:id2` route to GoRouter | — | |
| S8-10 | Extend `ResultsScreen` to accept optional `secondaryMeasurement` — renders dual-line chart | — | |
| S8-11 | Implement Δf callout between two peak markers | — | |
| S8-12 | Implement two-column comparison data panel below chart | — | |
| S8-13 | Widget test: `ReferenceScreen` renders all 10 pickup type rows | — | |
| S8-14 | Widget test: right-click on a `HomeScreen` row shows ContextMenu with "Compare with…" option | M-06 | |
| S8-15 | Widget test: comparison `ResultsScreen` renders two peak markers with correct frequency labels | — | |

### Definition of Done

- Reference screen shows all 10 pickup types with correct data
- Settings changes persist across app restarts
- Right-click context menu appears on `HomeScreen` rows with Compare option
- Comparison mode renders dual-line chart with Δf callout

---

## Sprint 9 — Export, Error Handling & UX Review

**Goal:** Implement the full export service and all error handling paths. The final 3 days of the sprint are reserved for a UX review — an end-to-end walkthrough of the complete measurement flow with a real pickup before Sprint 10 testing begins.

**Duration:** 2 weeks
**Arch sections:** §18 · §22
**Depends on:** Sprint 6 (screens), Sprint 4 (storage)
**Issues addressed:** M-04 (SNR warning surface in UI), L-02 (UX review sprint)

### Deliverables

- `ExportService.toCsv()` and `toJson()` per §22 schemas
- Share/save via `share_plus` from `ResultsScreen`
- All error states from §18 table implemented in UI
- SNR warning banner surfaced on `ResultsScreen` when SNR < 10 dB
- UX review session completed; findings logged in `UX_REVIEW.md`

### Tasks

| # | Task | Issue | Notes |
|---|---|---|---|
| S9-01 | Implement `ExportService.toCsv()` — header block + frequency/magnitude rows per §22 | — | |
| S9-02 | Implement `ExportService.toJson()` — full JSON schema per §22 | — | |
| S9-03 | Add Export button to `ResultsScreen` — format picker → `share_plus` | — | |
| S9-04 | Surface SNR warning banner on `ResultsScreen` when `SignalValidator.checkSnr()` < 10 dB | M-04 | Text: "Low signal-to-noise ratio. Reduce exciter gap or increase output level." |
| S9-05 | Implement device-not-found blocking error screen | — | Troubleshooting steps: check USB, check Focusrite driver |
| S9-06 | Implement wrong-generation warning (non-blocking) | — | |
| S9-07 | Implement stale calibration banner | — | |
| S9-08 | Implement calibration-missing warning — results labelled "uncalibrated" | — | |
| S9-09 | Implement no-peak-detected state on `ResultsScreen` | — | Troubleshooting steps from specs §Common Pitfalls |
| S9-10 | Implement SQLite write failure handling — toast; in-memory result available for export | — | |
| S9-11 | Unit test: `ExportService.toCsv()` correct header and row count | — | |
| S9-12 | Unit test: `ExportService.toJson()` valid JSON with correct field names | — | |
| S9-13 | Widget test: SNR warning banner appears when `snrDb < 10` | M-04 | |
| S9-14 | Widget test: clip warning banner appears when `clipWarning` is true | — | |
| S9-15 | **UX review (days 8–10):** run the complete measurement flow end-to-end with a real pickup; log friction points, unclear copy, and any missing states in `UX_REVIEW.md` | L-02 | Use any pickup available; SH-4 not required |
| S9-16 | Address critical UX findings from review before sprint closes | L-02 | P1 issues only; defer P2/P3 to Sprint 11 polish |

### Definition of Done

- CSV and JSON exports match §22 schemas exactly
- Every error category in §18 table has a visible UI response
- SNR warning surfaces correctly in UI
- Export file named `keneth_[pickup_name]_[timestamp].[ext]`
- `UX_REVIEW.md` written with findings and P1 issues resolved

---

## Sprint 10 — Testing & CI Completion

**Goal:** Achieve full test coverage across all layers. CI was configured in Sprint 0 — this sprint expands it to the complete test suite and adds the hardware loopback validation test.

**Duration:** 2 weeks
**Arch sections:** §13 · §23
**Depends on:** All previous sprints
**Issues addressed:** L-03 (loopback hardware test)

### Deliverables

- All unit tests from §13 complete and passing
- SH-4 verification integration test passing in CI
- Widget tests for all screens
- Loopback hardware integration test added (Output 1 → Input 1, flat response expected)
- Full coverage report reviewed; critical path gaps closed
- CI artifact consistently uploaded on every green build

### Tasks

| # | Task | Issue | Notes |
|---|---|---|---|
| S10-01 | Audit all prior sprint tests — confirm none skipped or incomplete | — | |
| S10-02 | Write `session_notifier_test.dart` — all FSM transitions including cancel | H-03 | Confirm `cancelSession()` from every state |
| S10-03 | Write widget tests: `HomeScreen`, `SetupScreen`, `DcrEntryScreen` | — | |
| S10-04 | Write widget tests: `CalibrationScreen`, `MeasurementScreen` | — | |
| S10-05 | Write integration test: `synthetic_sh4_pipeline_test.dart` | — | Full DSP pipeline; SH-4 synthetic response; peak must be 4.78 kHz ±50 Hz |
| S10-06 | Confirm `synthetic_sh4_pipeline_test.dart` runs green in CI | H-05 | CI was set up in Sprint 0; confirm test is in the CI run |
| S10-07 | Write integration test: export round trip — save → export CSV → parse → verify fields | — | |
| S10-08 | **Hardware loopback test:** connect Output 1 → Input 1 on Scarlett 2i2 with a TS cable; run a sweep; confirm recorded frequency response is flat ±2 dB from 100 Hz–15 kHz | L-03 | Validates audio path, BinaryCodec transfer, and DSP pipeline end-to-end |
| S10-09 | Document loopback test result in `TEST_RESULTS.md` | L-03 | |
| S10-10 | Run `flutter test --coverage`; review report | — | |
| S10-11 | Close coverage gaps in DSP pipeline, session FSM, and DCR validation | — | |
| S10-12 | Confirm CI pipeline green on `main` with full test suite | — | |

### Definition of Done

- `flutter test` exits 0 with all tests passing
- SH-4 verification integration test passes in CI: peak within 4.78 kHz ±50 Hz
- GitHub Actions `test` + `build` jobs green on `main`
- Loopback hardware test confirms flat ±2 dB response; result documented
- `.app` artifact uploads successfully on every green build

---

## Sprint 11 — Verification & Release

**Goal:** Validate the complete system against the physical Seymour Duncan JB SH-4. Address remaining UX review findings. Polish, write release notes, rename the sprint plan file, and tag v1.0.

**Duration:** 2 weeks
**Arch sections:** §15 · §25
**Depends on:** All previous sprints
**Issues addressed:** L-01 (sprint plan file renamed)

### Deliverables

- Physical SH-4 hardware validation documented
- Remaining UX review P2/P3 findings addressed
- `keneth_frequency_specs.md` updated with actual measured SH-4 result
- `keneth_frequency_arch.md` §25 Revision History updated with v1.0 entry
- `CHANGELOG.md` written
- Sprint plan file renamed from `keneth_frequency_sprint_paln.md` to `keneth_frequency_sprint_plan.md`
- `v1.0` git tag created
- Release `.app` built and notarised (if Apple Developer account available)

### Tasks

| # | Task | Issue | Notes |
|---|---|---|---|
| S11-01 | Physical validation: connect Scarlett 2i2 4th Gen, exciter coil, SH-4; run full measurement | — | Record: resonant frequency, Q, peak amplitude, DCR, corrected DCR |
| S11-02 | Compare measured result against sourced reference (4.78 kHz ±200 Hz acceptable) | — | If outside range, diagnose using specs §Common Pitfalls |
| S11-03 | Document measured result in `keneth_frequency_specs.md` — add "App Measured Result" row to SH-4 table | — | |
| S11-04 | Address UX review P2/P3 findings from `UX_REVIEW.md` | L-02 | Polish pass |
| S11-05 | Run full regression pass — all screens, all error paths, export, comparison, cancel | — | |
| S11-06 | Fix all P1/P2 regressions found | — | |
| S11-07 | Rename sprint plan file: `sprint_paln.md` → `sprint_plan.md` | L-01 | Update any references in arch doc |
| S11-08 | Update `keneth_frequency_arch.md` §25 Revision History — add v1.0 entry | — | |
| S11-09 | Write `CHANGELOG.md` — all features delivered across sprints 0–11 | — | |
| S11-10 | Create `v1.0` git tag on `main` | — | |
| S11-11 | Build release `.app`: `flutter build macos --release` | — | |
| S11-12 | Notarise `.app` if Apple Developer account available (`xcrun notarytool`) | — | Optional for personal use |
| S11-13 | Create GitHub Release with `.app` artifact and `CHANGELOG.md` content | — | |

### Definition of Done

- Physical SH-4 measurement returns resonant peak between 4.5–5.1 kHz
- All regression tests pass
- Sprint plan file renamed to `keneth_frequency_sprint_plan.md`
- `v1.0` tag on `main` with passing CI build
- GitHub Release published with downloadable `.app`

---

## Dependency Map

```
Sprint 0 (Foundation + Spikes)
    │   Proves: USB PID · AVAudioEngine channel routing · pocketfft .dylib · fl_chart log axis
    │   Configures: CI pipeline from day one
    │
    ├──► Sprint 1 (Domain Layer)
    │         │
    │         ├──► Sprint 2 (DSP Pipeline)
    │         │         │   Compiled .dylib from Sprint 0
    │         │         │   Isolate-safe FFI · SNR check
    │         │         │
    │         │         └──► Sprint 3a (Swift Audio — Device & Session)
    │         │                    │   Verified PID from Sprint 0
    │         │                    │   BinaryCodec · sample rate negotiation
    │         │                    │
    │         │                    └──► Sprint 3b (Swift Audio — Sweep & Record)
    │         │                               │   Binary PCM transfer · EventChannel
    │         │                               │
    │         │                               └──► Sprint 4 (Storage & Calibration)
    │         │                                         │   Smoothed storage only (60 pts)
    │         │                                         │
    │         └────────────────────────────────────────► Sprint 5 (App State)
    │                                                         │   cancelSession() + onExit hooks
    │                                                         │
    │                                                    Sprint 6 (Core UI)
    │                                                         │   Temperature-corrected DCR
    │                                                         │
    │                                                    Sprint 7 (Chart)
    │                                                         │   log axis approach from Sprint 0
    │                                                         │
    │                                                    Sprint 8 (Supporting Screens)
    │                                                         │   right-click ContextMenu
    │                                                         │
    │                                                    Sprint 9 (Export, Errors & UX Review)
    │                                                         │   SNR warning · UX_REVIEW.md
    │                                                         │
    │                                                    Sprint 10 (Testing & CI Completion)
    │                                                         │   loopback hardware test
    │                                                         │
    └────────────────────────────────────────────────── Sprint 11 (Verification & Release)
                                                              File rename · v1.0 tag
```

---

## Risk Register

| Risk | Likelihood | Impact | Mitigation | Status |
|---|---|---|---|---|
| AVAudioEngine channel routing fails for Scarlett 2i2 | Medium | High | Audio spike in Sprint 0 proves approach before any feature work; fallback: PortAudio via FFI | Mitigated by Sprint 0 spike |
| pocketfft FFI bindings fail to compile on Apple Silicon | Low | High | pocketfft compilation spike in Sprint 0 day 1; exit criteria: `DynamicLibrary.open()` succeeds | Mitigated by Sprint 0 spike |
| Base64 MethodChannel causes OOM or UI freeze | — | — | Resolved: BinaryCodec adopted in Sprint 3a | **Resolved (C-02)** |
| dart:ffi pointer crossing Isolate boundary crashes at runtime | — | — | Resolved: `compute()` receives/returns plain Dart types only | **Resolved (C-03)** |
| FrequencyResponse JSON storage bloats SQLite | — | — | Resolved: storage capped at 60 smoothed points | **Resolved (H-02)** |
| USB PID mismatch causes device not found | — | — | Resolved: PID verified via `system_profiler` in Sprint 0 | **Resolved (H-04)** |
| SH-4 physical measurement falls outside expected range | Low | Medium | Diagnose using specs §Common Pitfalls; loopback test in Sprint 10 confirms audio path first | Sprint 11 |
| fl_chart log axis requires excessive custom code | Medium | Medium | Log axis spike in Sprint 0; syncfusion is the defined fallback | Mitigated by Sprint 0 spike |
| Sweep + record synchronisation latency | Low | Low | Magnitude-only measurement is phase-independent; latency does not affect peak frequency | Accepted |

---

## v2 Backlog (Post-Sprint 11)

- Real-time oscilloscope view during sweep
- Automatic inductance measurement via known external capacitor method
- Bluetooth multimeter integration for automated DCR capture
- Loaded resonant frequency simulator (pot + cable capacitance model)
- Temperature-corrected DCR normalisation applied to all historical measurements
- Windows desktop build (platform channel port to WASAPI/ASIO)
- Cloud sync / remote measurement storage
- Pickup database with community-contributed measurements
