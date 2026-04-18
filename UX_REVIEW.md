# UX Review — Sprint 9

**Date:** 2026-04-18  
**Reviewer:** Joel Brown  
**Pickup used:** Seymour Duncan JB SH-4 (bridge humbucker)  
**Hardware:** Focusrite Scarlett 2i2 (4th Gen), exciter coil prototype  

---

## Flow Tested

End-to-end measurement session:  
**Home → Setup → DCR Entry → Calibration → Measurement → Results → Export**

---

## Findings

### P1 — Critical (must fix before Sprint closes)

| ID | Screen | Finding | Proposed Fix |
|----|--------|---------|--------------|
| UX-01 | DCR Entry | "Corrected DCR @ 20 °C" label appears before the user has entered any values — shows a stale `0 Ω` value that looks like an error. | Only show the corrected row once both DCR and temperature fields are non-empty. |
| UX-02 | Calibration | "Start Calibration" button active even when no device is found. Tapping it shows a generic exception, not the device-not-found screen. | Disable the button and show the stale-calibration banner if `audioDevicesProvider` returns an empty list; offer a "Retry" action. |
| UX-03 | Results | The export format dialog defaults to CSV regardless of the user's setting. | Read `settingsNotifierProvider.exportFormat` to pre-select the correct radio option. *(Fixed in S9-03 — confirmed working after fix.)* |

### P2 — Notable friction (defer to Sprint 11)

| ID | Screen | Finding | Proposed Fix |
|----|--------|---------|--------------|
| UX-04 | Setup | Pickup-type dropdown resets to "Unknown" when the user backs out of DCR Entry and returns to Setup. It should remember the selection. | Preserve `accumulatedType` in `PickupSetupState`. |
| UX-05 | Results | The resonant frequency hero display shows "4,780.0 Hz" — looks noisy at 4 significant figures. Consider showing "4.78 kHz" at this scale. | Apply `formatHzLabel()` to the hero display. |
| UX-06 | Home | History list shows raw UTC timestamps; users expect local time. | Already using `measurement.timestamp.toLocal()` in the date formatter — verify locale. |
| UX-07 | Settings | Sweep duration slider labels (10 s / 30 s) are small; not immediately obvious they are range bounds, not the current value. | Add a centred value label below the slider that updates live. |

### P3 — Polish (Sprint 11)

| ID | Screen | Finding |
|----|--------|---------|
| UX-08 | All | AppBar back button is hard to target — 24 px hit area. Consider 44 px minimum. |
| UX-09 | Results | Chart pan/zoom has no visual affordance. Consider a brief "pinch to zoom" tooltip on first view. |
| UX-10 | Compare | Delta callout obscures the chart peak marker when peaks are close together. |

---

## P1 Resolutions (S9-16)

### UX-01 — DCR corrected label hides when fields empty

Resolved in `lib/ui/widgets/dcr_input_form.dart`: corrected-DCR row is now conditionally visible only when both `_dcrController.text.isNotEmpty` and `_tempController.text.isNotEmpty`.

### UX-02 — Calibration button disabled when no device

Resolved in `lib/ui/screens/calibration_screen.dart`: button is disabled and device-not-found banner shown when `audioDevicesProvider` returns no Scarlett device.

### UX-03 — Export dialog pre-selects user setting

Confirmed working as of S9-03 implementation. `_ExportButton` reads `settingsNotifierProvider` before opening the dialog.

---

## Summary

Overall the flow is smooth for a known-hardware scenario. The three P1 issues were addressed before sprint close. Twelve friction points remain for Sprint 11 polish; none block the Sprint 10 testing gate.
