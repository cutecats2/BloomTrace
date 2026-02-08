import 'package:flutter/material.dart';
import '../models/scanned_product.dart';
import '../services/scanner_service.dart'; // <- relative import

class AIResultScreen extends StatelessWidget {
  final ScannedProduct product;

  const AIResultScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Results')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product: ${product.name}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text(
              product.recalled ? '⚠️ Recalled!' : '✅ Safe',
              style: TextStyle(
                fontSize: 18,
                color: product.recalled ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Text('Nutrition Score: ${product.nutritionScore.toStringAsFixed(1)} / 100'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {

                await ScannerService().saveScan(product);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product saved to history')),
                    );
                    Navigator.pop(context);
                  }
                } catch (e) {
                  print("Error saving: $e");
                }
              },
              child: const Text('Confirm & Save'),
            )
          ],
        ),
      ),
    );
  }
}
