import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/app.dart';

void main() {
  testWidgets('App launches and shows title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: KenethFrequencyApp()),
    );
    expect(find.text('Keneth Frequency'), findsWidgets);
  });
}
