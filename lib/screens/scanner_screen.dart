import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ai_service.dart';
import 'package:bloom_trace_root/screens/ai_result_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final AIService _aiService = AIService();
  bool _isProcessing = false;

  Future<void> _scanPhoto() async {
    if (_isProcessing) return;
    _isProcessing = true;

    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.camera);

    if (photo == null) {
      _isProcessing = false;
      return;
    }

    final bytes = await photo.readAsBytes();
    try {
      final scannedProduct = await _aiService.analyzeProduct(bytes);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AIResultScreen(product: scannedProduct),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('AI error: $e')));
    } finally {
      _isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BloomTrace Scanner')),
      body: Center(
        child: ElevatedButton(
          onPressed: _scanPhoto,
          child: const Text('Scan Product with AI (Photo)'),
        ),
      ),
    );
  }
}
