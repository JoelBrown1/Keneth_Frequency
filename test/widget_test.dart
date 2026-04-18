import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/app.dart';
import 'package:keneth_frequency/application/settings/settings_notifier.dart';
import 'package:keneth_frequency/infrastructure/storage/app_database.dart';
import 'package:keneth_frequency/infrastructure/storage/app_database.dart'
    show appDatabaseProvider;
import 'package:keneth_frequency/application/providers/database_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App launches and renders HomeScreen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase.forTesting();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: const KenethFrequencyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // HomeScreen stub renders this text (Sprint 6 implements the real screen).
    expect(find.text('Home — Sprint 6: not yet implemented'), findsOneWidget);

    await db.close();
  });
}
