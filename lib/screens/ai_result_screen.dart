import 'package:flutter/material.dart';
import '../models/scanned_product.dart';
import '../services/scanner_service.dart';

class AIResultScreen extends StatelessWidget {
  final ScannedProduct product;

  const AIResultScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Determine the color based on the nutrition score
    final Color scoreColor = product.nutritionScore > 70 
        ? Colors.green 
        : (product.nutritionScore > 40 ? Colors.orange : Colors.red);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // 1. DYNAMIC RECALL BANNER
            _buildRecallCard(context),

            const SizedBox(height: 20),

            // 2. PRODUCT IDENTITY & SCORE
            _buildHeader(context, scoreColor),

            const SizedBox(height: 30),

            // 3. NUTRITION FACTS CARD
            _buildNutritionCard(context),

            const SizedBox(height: 40),

            // 4. ACTION BUTTONS
            _buildActionButtons(context),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

Widget _buildRecallCard(BuildContext context) {
  // Check if we have information to show
  bool isRecalled = product.recalled;
  String reason = product.recallReason ?? "No safety issues found.";

  return Card(
    elevation: 0,
    // Switch color based on status: Red for danger, Green for safe
    color: isRecalled ? Colors.red[50] : Colors.green[50],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: isRecalled ? Colors.red : Colors.green, 
        width: 1.5
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isRecalled ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                color: isRecalled ? Colors.red : Colors.green[700],
              ),
              const SizedBox(width: 10),
              Text(
                isRecalled ? "RECALL ALERT" : "SAFETY STATUS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isRecalled ? Colors.red : Colors.green[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isRecalled ? reason : "This product is currently safe to consume.",
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildHeader(BuildContext context, Color scoreColor) {
    return Column(
      children: [
        Text(product.name, 
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        
        // Circular Score Indicator (Material 3 style)
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 140,
              width: 140,
              child: CircularProgressIndicator(
                value: product.nutritionScore / 100,
                strokeWidth: 12,
                backgroundColor: scoreColor.withOpacity(0.1),
                color: scoreColor,
                strokeCap: StrokeCap.round, // 2026 M3 feature
              ),
            ),
            Column(
              children: [
                Text('${product.nutritionScore.toInt()}', 
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: scoreColor)),
                const Text('HEALTH SCORE', style: TextStyle(fontSize: 12, letterSpacing: 1.2)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNutritionCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.restaurant_menu, size: 20),
                SizedBox(width: 10),
                Text('Nutrition Facts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const Divider(height: 30),
            _nutritionRow('Calories', '${product.nutrition.calories} kcal'),
            _nutritionRow('Protein', product.nutrition.protein),
            _nutritionRow('Fat', product.nutrition.fat),
            _nutritionRow('Carbohydrates', product.nutrition.carbs),
          ],
        ),
      ),
    );
  }

  Widget _nutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Discard'),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: FilledButton(
            onPressed: () async {
              await ScannerService().saveScan(product);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved to your history!'), behavior: SnackBarBehavior.floating),
                );
                Navigator.pop(context);
              }
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save Result'),
          ),
        ),
      ],
    );
  }
}