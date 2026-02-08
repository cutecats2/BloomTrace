class RecallService {
  // MOCK recall database
  static const List<String> recalledUPCs = [
    '012345678905',
    '098765432109',
    '123456789012',
  ];

  static Future<bool> checkRecall(String upc) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return recalledUPCs.contains(upc);
  }

  static Future<String> recallSummary(String upc) async {
    return 'This product was recalled due to contamination risk.';
  }
}
