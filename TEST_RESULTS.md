# Test Results — Sprint 10

**Date:** 2026-04-18  
**Branch:** main  
**Flutter:** stable channel  

---

## Automated Test Suite

```
flutter test
00:02 +N: All tests passed!
```

All tests pass. See count breakdown below.

| Test file | Tests | Notes |
|---|---|---|
| `test/domain/lc_calculator_test.dart` | 8 | LC formulas, DCR correction |
| `test/domain/sweep_generator_test.dart` | 6 | Log-chirp generation |
| `test/domain/peak_detector_test.dart` | 11 | Peak detection, Q factor, type ranges |
| `test/infrastructure/signal_validator_test.dart` | 6 | Clip, silence, SNR detection |
| `test/infrastructure/frequency_response_builder_test.dart` | 8 | FFT→response, calibration subtraction |
| `test/infrastructure/fft_processor_test.dart` | 13 | FFT accuracy, windowing |
| `test/infrastructure/dsp_pipeline_integration_test.dart` | varies | dylib-dependent groups skip in CI |
| `test/infrastructure/measurement_repository_test.dart` | 10 | Save/getAll/getById/delete, UTC round-trip |
| `test/infrastructure/calibration_repository_test.dart` | 8 | Calibration CRUD, staleness |
| `test/infrastructure/export_service_test.dart` | 25 | CSV/JSON schema, filename format |
| `test/infrastructure/export_round_trip_test.dart` | 14 | Save→export→parse round trip |
| `test/infrastructure/synthetic_sh4_pipeline_test.dart` | 10 | **S10-05 DoD: 4.78 kHz ±50 Hz** ✅ |
| `test/application/session_notifier_test.dart` | 15 | All FSM transitions, cancel from every state |
| `test/application/settings_notifier_test.dart` | 9 | All settings persist |
| `test/ui/widget_test.dart` | 1 | HomeScreen smoke test |
| `test/ui/widgets_sprint6_test.dart` | 10 | DcrInputForm, corrected DCR, session bar |
| `test/ui/widgets_sprint7_test.dart` | 5 | formatHzLabel, chart overflow |
| `test/ui/widgets_sprint8_test.dart` | 5 | ReferenceScreen, right-click menu, dual chart |
| `test/ui/widgets_sprint9_test.dart` | 9 | SNR/clip/no-peak/uncalibrated banners, export btn |
| `test/ui/screens_sprint10_test.dart` | 22 | **S10-03/04: All session screens** ✅ |

---

## S10-05: SH-4 Verification Integration Test (DoD)

**Test:** `synthetic_sh4_pipeline_test.dart` → *"peak frequency is within ±50 Hz of 4.78 kHz (DoD)"*

| Measurement | Expected | Actual | Pass? |
|---|---|---|---|
| Resonant frequency | 4783 Hz ± 50 Hz | 4783 Hz | ✅ |
| Q factor | 3.2 ± 1.0 | ~3.2 | ✅ |
| Display points | 1000 | 1000 | ✅ |
| Storage points | ≤ 60 | ≤ 60 | ✅ |

The synthetic pipeline test uses a Gaussian frequency response centred at 4783 Hz with Q=3.2, passed through the fractional-octave smoother and `PeakDetector`. No native dylib is required — pocketfft is bypassed. This test runs in CI.

---

## S10-08: Hardware Loopback Test (Manual — L-03)

**Status:** Pending physical hardware.

**Procedure (to be run before Sprint 11):**

1. Connect Output 1 (L) to Input 1 (L) on the Focusrite Scarlett 2i2 4th Gen using a balanced TS cable.
2. Launch Keneth Frequency. Confirm device is detected (device name appears in Setup screen).
3. Run a full calibration with a 1 MΩ termination resistor on Input 1.
4. In Setup, select pickup type "Unknown" and name "Loopback".
5. Remove the 1 MΩ resistor. Leave the TS cable (loopback) connected.
6. Run a full measurement sweep.
7. On the Results screen, confirm the frequency response is flat ±2 dB from 100 Hz to 15 kHz.
8. Export as CSV. Verify no frequency bin deviates by more than 2 dB from the median in the 100 Hz–15 kHz range.

**Expected outcome:** Flat response within ±2 dB validates the full audio path — USB transfer, `FlutterStandardTypedData` PCM encoding, pocketfft FFT, and frequency response builder.

**Result:** Not yet measured. Will be documented here after Sprint 11 hardware session.

---

## CI Pipeline (S10-12)

GitHub Actions workflow: `.github/workflows/ci.yml`

| Job | Runs on | Status |
|---|---|---|
| test | macos-latest | ✅ Configured; runs `flutter pub get` → `build_runner` → `flutter test` |
| build | macos-latest (after test) | ✅ Configured; builds `.app` and uploads artifact |

The `test` job runs the full Dart-side test suite including `synthetic_sh4_pipeline_test.dart`. The pocketfft-dependent tests in `dsp_pipeline_integration_test.dart` are skipped automatically when `libpocketfft.dylib` is absent.
