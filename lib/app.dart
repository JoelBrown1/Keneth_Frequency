import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'application/session/session_notifier.dart';
import 'application/session/session_state.dart';
import 'ui/screens/calibration_screen.dart';
import 'ui/screens/compare_screen.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/dcr_entry_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/measurement_screen.dart';
import 'ui/screens/reference_screen.dart';
import 'ui/screens/results_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/screens/setup_screen.dart';

// ── Router ────────────────────────────────────────────────────────────────────

/// GoRouter instance; held at module level so [_NavigationBridge] can call
/// `router.go()` from outside the widget tree.
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, routerState) => const HomeScreen(),
    ),
    GoRoute(
      path: '/session/setup',
      builder: (context, routerState) => const SetupScreen(),
      onExit: (context, routerState) async {
        final notifier = routerState.extra as SessionNotifier?;
        await notifier?.cancelSession();
        return true;
      },
    ),
    GoRoute(
      path: '/session/dcr',
      builder: (context, routerState) => const DcrEntryScreen(),
      onExit: (context, routerState) async {
        final notifier = routerState.extra as SessionNotifier?;
        await notifier?.cancelSession();
        return true;
      },
    ),
    GoRoute(
      path: '/session/calibrate',
      builder: (context, routerState) => const CalibrationScreen(),
      onExit: (context, routerState) async {
        final notifier = routerState.extra as SessionNotifier?;
        await notifier?.cancelSession();
        return true;
      },
    ),
    GoRoute(
      path: '/session/measure',
      builder: (context, routerState) => const MeasurementScreen(),
      onExit: (context, routerState) async {
        final notifier = routerState.extra as SessionNotifier?;
        await notifier?.cancelSession();
        return true;
      },
    ),
    GoRoute(
      path: '/session/results',
      builder: (context, routerState) => const ResultsScreen(),
    ),
    GoRoute(
      path: '/results/:id',
      builder: (context, routerState) =>
          ResultsScreen(measurementId: routerState.pathParameters['id']),
    ),
    GoRoute(
      path: '/compare/:id1/:id2',
      builder: (context, routerState) => CompareScreen(
        id1: routerState.pathParameters['id1']!,
        id2: routerState.pathParameters['id2']!,
      ),
    ),
    GoRoute(
      path: '/reference',
      builder: (context, routerState) => const ReferenceScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, routerState) => const SettingsScreen(),
    ),
  ],
);

// ── App root ──────────────────────────────────────────────────────────────────

class KenethFrequencyApp extends ConsumerWidget {
  const KenethFrequencyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Keneth Frequency',
      theme: AppTheme.dark,
      routerConfig: _router,
      builder: (context, child) =>
          _NavigationBridge(router: _router, child: child ?? const SizedBox()),
    );
  }
}

// ── Navigation bridge ─────────────────────────────────────────────────────────

/// Listens to [sessionNotifierProvider] and calls `router.go()` on each
/// state transition, keeping the route in sync with the FSM (H-03 fix).
class _NavigationBridge extends ConsumerWidget {
  const _NavigationBridge({required this.router, required this.child});

  final GoRouter router;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SessionState>(sessionNotifierProvider, (_, next) {
      switch (next) {
        case PickupSetupState():
          router.go('/session/setup');
        case DcrEntryState():
          router.go('/session/dcr');
        case CalibratingState():
          router.go('/session/calibrate');
        case MeasuringState():
          router.go('/session/measure');
        case ResultsState():
          router.go('/session/results');
        case IdleState():
          router.go('/');
        case ProcessingState():
          break; // brief transient state; no navigation needed
      }
    });
    return child;
  }
}
