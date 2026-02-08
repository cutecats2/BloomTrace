import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/scanned_product.dart';

class ScannerService {
   Future<void> saveScan(ScannedProduct product) async {
    await FirebaseFirestore.instance
        .collection('scanned_products')
        .add(product.toJson());
  }
}

