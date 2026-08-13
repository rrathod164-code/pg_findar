import 'package:flutter/material.dart';
import 'intro.dart';

void main() {
  runApp(const PGFinderApp());
}

class PGFinderApp extends StatelessWidget {
  const PGFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'PG Finder',

      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),

      home: const Introduction(),
    );
  }
}
