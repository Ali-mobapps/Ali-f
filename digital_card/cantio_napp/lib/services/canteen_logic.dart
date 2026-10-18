import 'dart:math';

// Required Function 1: Calculate Total
double calculateTotal(List<String> orderItems, Map<String, double> menuPrices) {
  double subtotal = 0.0;
  for (var item in orderItems) {
    if (menuPrices.containsKey(item)) {
      subtotal += menuPrices[item]!;
    }
  }
  return subtotal;
}

// Required Function 2: Apply Discount
double applyDiscount(double subtotal, bool isHostelite, int loyaltyPoints) {
  double discountAmount = 0.0;

  // LLO-2: Control Flow with logical operators
  if (isHostelite && subtotal > 500) {
    discountAmount = subtotal * 0.15; // 15% discount
  } else if (!isHostelite && subtotal > 700) {
    discountAmount = subtotal * 0.10; // 10% discount
  }

  // Additional loyalty reduction
  if (loyaltyPoints > 100) {
    discountAmount += 50.0;
  }

  return discountAmount;
}

// Required Arrow Function: Log Transaction
void logTransaction(String id, double amount) =>
    print("CONFIRMATION: Transaction $id for Rs. ${amount.toStringAsFixed(2)} processed at ${DateTime.now()}");

// Helper to generate a unique transaction ID
String generateTransactionId() {
  var random = Random();
  return "TXN${random.nextInt(1000000).toString().padLeft(6, '0')}";
}
