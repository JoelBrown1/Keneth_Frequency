import 'package:flutter/material.dart';

class KenethFrequencyApp extends StatelessWidget {
  const KenethFrequencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keneth Frequency',
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: Center(child: Text('Keneth Frequency')),
      ),
    );
  }
}
