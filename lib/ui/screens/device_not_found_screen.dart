import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Blocking error screen shown when no Focusrite Scarlett 2i2 is detected.
///
/// The user must resolve the hardware issue before the session can proceed.
/// Navigate here from [SetupScreen] or [CalibrationScreen] when
/// [audioDevicesProvider] returns an empty device list.
class DeviceNotFoundScreen extends StatelessWidget {
  const DeviceNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Not Found')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.usb_off, size: 64, color: AppTheme.error),
                const SizedBox(height: 24),
                Text(
                  'Scarlett 2i2 Not Detected',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: AppTheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No Focusrite Scarlett 2i2 was found.\n'
                  'Check the following before retrying:',
                  style: TextStyle(color: AppTheme.onSurfaceDim, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const _TroubleshootingItem(
                  icon: Icons.cable,
                  text: 'USB cable is connected securely at both ends.',
                ),
                const _TroubleshootingItem(
                  icon: Icons.power,
                  text: 'Scarlett 2i2 is powered on (status ring is lit).',
                ),
                const _TroubleshootingItem(
                  icon: Icons.settings_input_composite,
                  text:
                      'Focusrite USB driver is installed for macOS (download from focusrite.com).',
                ),
                const _TroubleshootingItem(
                  icon: Icons.privacy_tip,
                  text:
                      'macOS has granted this app audio input permission in System Settings → Privacy.',
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  key: const Key('device_not_found_back'),
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TroubleshootingItem extends StatelessWidget {
  const _TroubleshootingItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: AppTheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
