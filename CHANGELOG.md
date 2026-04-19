# Changelog

All notable changes to Keneth Frequency are documented here.

---

## v1.0.0 — 2026-04-18

### Sprint 11 — Verification & Release

- **Audio orchestration:** `SessionNotifier.runCalibration()` and `runMeasurement()` now execute the full audio + DSP pipeline end-to-end. Pressing "Start Calibration" opens the Scarlett audio session, generates a log-chirp sweep, records with the 1 MΩ reference load, runs the FFT in a background isolate, and saves `CalibrationData` to the database. Pressing "Start Sweep" does the same for the pickup under test, applies calibration subtraction, builds the full `PickupMeasurement`, and transitions to the Results screen.
- **UX-04:** SetupScreen now restores the accumulated pickup type and name when the user backs out of DCR Entry and returns.
- **UX-05:** Resonant frequency hero on the Results screen displays in kHz for values ≥ 1000 Hz (e.g. "4.78 kHz" instead of "4,780.0 Hz").
- **UX-07:** Settings sliders now show min/max bound labels ("10 s / 30 s", "−18 dBFS / −6 dBFS") so range bounds are clearly distinguished from the current value.
- **UX-08:** All icon buttons (including AppBar back buttons) have a minimum 44×44 px hit target via `iconButtonTheme`.
- **UX-09:** Results screen shows a "Pinch to zoom · scroll to pan" affordance hint below the frequency response chart.
- **UX-10:** Compare screen suppresses the secondary resonant frequency marker on the chart when the two peaks are within 200 Hz of each other to prevent annotation overlap.
- **Tests:** 256 tests passing. `screens_sprint11_test.dart` added (10 tests) covering orchestration wiring, UX-04/05/07/09 fixes.

---

### Sprint 10 — Testing & CI Completion

- `synthetic_sh4_pipeline_test.dart`: 10 tests; SH-4 peak at 4783 Hz ±50 Hz (definition of done), no dylib required — runs in CI.
- `export_round_trip_test.dart`: 14 tests; save → export CSV/JSON schema round trip verified.
- `screens_sprint10_test.dart`: 22 widget tests covering all session-flow screens.
- `dsp_pipeline_integration_test.dart`: dylib-gated groups changed from `fail` to group-level `skip`.
- CI workflow updated: `build_runner` step added to both `test` and `build` jobs.
- `TEST_RESULTS.md` written with all test counts, S10-05 DoD result, and S10-08 hardware loopback procedure (pending physical hardware).

---

### Sprint 9 — Export, Error Handling & UX Review

- `ExportService.toCsv(PickupMeasurement)` and `toJson(PickupMeasurement)` — §22 JSON schema, single measurement format.
- `ResultsScreen`: export button with format picker → `share_plus`; SNR/clip/uncalibrated/no-peak banners; no-peak empty state with troubleshooting list.
- `CalibrationScreen`: stale/missing calibration banner (via `calibrationStatusProvider`); device-not-found banner (via `audioDevicesProvider`).
- `DeviceNotFoundScreen` at `/error/device-not-found`.
- `DcrInputForm` (UX-01): corrected DCR row hidden until DCR field has content.
- `UX_REVIEW.md`: 3 P1 issues resolved; P2/P3 deferred to Sprint 11.

---

### Sprint 8 — Supporting Screens

- `ReferenceScreen` with all 10 pickup type profiles and typical frequency ranges.
- `CompareScreen` with dual-line `FrequencyResponseChart` overlay and Δf callout.
- `SettingsScreen` with all persistent settings (sweep duration, output level, smoothing, calibration threshold, temperature unit, default pickup type, export format).
- Right-click context menu on measurement tiles via `GestureDetector.onSecondaryTapUp`.

---

### Sprint 7 — Chart & Frequency Display

- `FrequencyResponseChart` with logarithmic X-axis (`fl_chart`), resonant peak annotation, −3 dB bandwidth shading.
- `formatHzLabel()` utility for log-scale axis tick labels.
- `ComparisonPanel` data table for side-by-side derived values.

---

### Sprint 6 — Core UI

- `HomeScreen` with measurement history list (storage-resolution response), empty-state illustration, "New Measurement" button.
- `ResultsScreen` with 9-row derived values table: resonant frequency, Q factor, peak amplitude, bandwidth, inductance, capacitance, DCR, DCR @ 20 °C, ambient temp, calibration applied.
- `DcrInputForm` with live temperature-corrected DCR display.
- `SessionProgressBar` step indicator across all measurement screens.

---

### Sprint 5 — Application State

- Session FSM (`IdleState → PickupSetupState → DcrEntryState → CalibratingState → MeasuringState → ProcessingState → ResultsState`).
- `SessionNotifier` with Riverpod code-gen; `cancelSession()` closes audio and resets from any state (H-03).
- `SettingsNotifier` with `SharedPreferences` persistence for all settings.
- `_NavigationBridge` in `app.dart` listens to FSM state and drives GoRouter navigation.

---

### Sprint 4 — Storage & Calibration

- `AppDatabase` via Drift/SQLite (`path_provider` for location).
- `MeasurementRepository`: `save()`, `getAll()` (storage ~60 pts), `getById()` (display ~1000 pts), `delete()`.
- `CalibrationRepository`: `save()`, `getLatest()`, `isStale()`.
- Two-resolution storage: display response persisted separately from storage response to maintain chart fidelity.

---

### Sprint 3b — Swift Audio: Sweep & Record

- `playSweepAndRecord` MethodChannel method; PCM transferred as `FlutterStandardTypedData(float32:)` — no Base64 (C-02).
- `EventChannel` for real-time level meter (`levelStream`).

---

### Sprint 3a — Swift Audio: Device & Session

- `CoreAudioSession.swift` wrapping AVAudioEngine on macOS.
- Scarlett 2i2 detection by USB VID/PID via `ScarlettDeviceDetector.swift`.
- `getDevices()` / `openSession()` / `closeSession()` MethodChannel methods.
- `StandardMethodCodec` (not `BinaryCodec`) for MethodChannel — plain Swift Maps/primitives pass through directly.

---

### Sprint 2 — DSP Pipeline

- `FftProcessor`: pocketfft via `dart:ffi`; all native pointers allocated and freed within one call — never escape to Isolate boundary (C-03).
- `FrequencyResponseBuilder`: builds `FrequencyResponse` from FFT magnitudes, applies calibration subtraction (dB − dB), trims to 20–20 kHz.
- `SignalValidator`: clip detection, silence detection, SNR calculation.
- `Smoothing`: fractional-octave smoothing to 1000 display points; `toStorageResolution()` to ≤60 storage points.
- `DspPipeline` (`runDspPipeline`): top-level entry point for `compute()` — all inputs/outputs are plain Dart types.
- `libpocketfft.dylib` compiled from `pocketfft_wrapper.cpp` (`macos/Runner/`).

---

### Sprint 1 — Domain Layer

- `PickupMeasurement`, `FrequencyResponse`, `FrequencyPoint`, `CalibrationData` entities.
- `LcCalculator`: `resonantFrequency()`, `solveInductance()`, `solveCapacitance()`, `loadedFrequency()`, `correctDcrForTemperature()`.
- `PeakDetector`: `findResonantPeak()` with per-type search range from `PickupReferenceData`; `computeQFactor()` via −3 dB walking.
- `SweepGenerator`: log-chirp generation, normalised to −12 dBFS.
- `PickupReferenceData` covering 10 pickup types with DCR, inductance, and search-range profiles.

---

### Sprint 0 — Foundation & Spikes

- Flutter macOS project (`lib/`, `macos/`, `test/`) with Clean Architecture skeleton.
- Riverpod code-gen + Drift + GoRouter + `fl_chart` + `share_plus` + `path_provider` dependencies.
- GitHub Actions CI: `test` + `build` jobs on `macos-latest`, runs on every push.
- Spike proofs for all pre-implementation issues (C-01 dylib, C-02 BinaryCodec, C-03 Isolate FFI safety, H-04 USB PID, log-axis fl_chart).
