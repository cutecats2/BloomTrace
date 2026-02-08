import 'package:flutter/material.dart';
import 'screens/scanner_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BloomTraceApp());
}

class BloomTraceApp extends StatelessWidget {
  const BloomTraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScannerScreen(),
    );
  }
}

