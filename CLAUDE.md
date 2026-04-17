# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Keneth Frequency** is a Flutter desktop application (macOS) that automates guitar pickup resonant frequency measurement. It replaces a manual REW + multimeter workflow by generating log sweep signals, recording pickup response via a Focusrite Scarlett 2i2, performing FFT analysis, detecting resonant peaks, and deriving LC circuit parameters.

**Status:** Pre-implementation (Sprint 0). No source code exists yet — only architecture docs, specs, and a sprint plan.

## Commands

Once `pubspec.yaml` is created in Sprint 0:

```bash
flutter pub get                                              # Install dependencies
dart run build_runner build --delete-conflicting-outputs    # Generate Riverpod + Drift code
flutter run -d macos                                        # Run on macOS
flutter test                                                # Run all tests
flutter build macos --release                               # Production build
```

Code generation must be re-run after modifying any `@riverpod` annotated providers or Drift table definitions.

## Architecture

The project follows **Clean Architecture** with four layers (dependency direction: UI → Application → Domain ← Infrastructure):

### Domain Layer (`lib/domain/`)
Pure Dart, no Flutter dependencies. Fully unit-testable in isolation.
- **Entities:** `PickupMeasurement`, `FrequencyResponse`, `CalibrationData`
- **Services:** `LcCalculator` (resonant frequency formulas), `PeakDetector`, `SweepGenerator`
- **Reference data:** `PickupReferenceData` covering all 10 guitar pickup types

### Infrastructure Layer (`lib/infrastructure/`)
Platform-specific integrations:
- **Audio:** Swift `MethodChannel` via `CoreAudioSession` wrapping AVAudioEngine on macOS
- **DSP:** pocketfft C library accessed via `dart:ffi` — FFI pointer types must NOT cross Isolate boundaries (issue C-03)
- **Transport:** Use `BinaryCodec` for audio PCM data over the MethodChannel (5 MB+ transfers; Base64 is too slow — issue C-02)
- **Storage:** `drift` ORM over SQLite (`path_provider` for DB location)
- **Device:** Scarlett 2i2 detected by USB VID/PID — 4th Gen PID `0x8215` is unverified (issue H-04)

### Application Layer (`lib/application/`)
Riverpod state management with code generation (`riverpod_annotation`/`riverpod_generator`).
- **Session FSM:** `Idle → PickupSetup → DcrEntry → Calibrating → Measuring → Processing → Results`
- Providers expose current measurement state and history to the UI

### UI Layer (`lib/ui/`)
Flutter widgets consuming Riverpod providers:
- **Measurement flow:** `SetupScreen → DcrEntryScreen → CalibrationScreen → MeasurementScreen → ResultsScreen`
- **Other screens:** Home (history list), Reference, Settings, Comparison view
- Frequency response chart uses a logarithmic X-axis (`fl_chart`)

### macOS Native (`macos/Runner/`)
Swift platform channel registers audio `MethodChannel` in `AppDelegate.swift`. macOS entitlements must include audio input/output permissions.

## Key Architecture Decisions

- **Navigation:** `go_router` (declarative, deep-link capable)
- **State:** Riverpod code-gen providers (not `StateNotifier` directly)
- **FFT:** pocketfft as a compiled `.dylib` — it cannot be header-only (issue C-01 requires a C wrapper build step)
- **Database:** `drift` with generated query code

## Critical Pre-Implementation Issues

Before writing Sprint 1+ code, these must be resolved with spike proofs:

| ID | Issue |
|----|-------|
| C-01 | pocketfft needs a compiled `.dylib` wrapper — not header-only |
| C-02 | MethodChannel audio transfer must use `BinaryCodec`, not Base64 |
| C-03 | `dart:ffi` pointers are unsafe across Isolate boundaries |
| H-04 | Scarlett 2i2 4th Gen USB PID `0x8215` is unverified |
| H-06 | Audio spike prototype needed before Sprint 3 |

Full details are in `keneth_frequency_arch.md` (§15 Development Issues Assessment) and the sprint plan `keneth_frequency_sprint_paln.md`.

## Reference Documents

- `keneth_frequency_arch.md` — Full architecture (1400+ lines): entities, signal flow, DSP pipeline, Swift integration, ADRs, testing strategy
- `keneth_frequency_specs.md` — Technical specs: LC formulas, exciter coil design, Scarlett 2i2 interface, calibration procedure
- `keneth_frequency_sprint_paln.md` — 13-sprint plan with issue resolutions and definitions of done
