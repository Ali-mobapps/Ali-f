import 'dart:io';

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

// Required Function 2: Apply Discount (Task 2 & 4b)
double applyDiscount(double subtotal, bool isHostelite, int loyaltyPoints) {
  double discountAmount = 0.0;

  // LLO-2: Control Flow (Task 2b)
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

// Required Arrow Function: Log Transaction (Task 4c)
void logTransaction(String id, double amount) =>
    print("\n[CONFIRMATION] Transaction $id for Rs. ${amount.toStringAsFixed(2)} processed at ${DateTime.now()}");

void main() {
  print('=== CSC303: Smart Campus Canteen Engine (Console Version) ===\n');

  // Task 1: Student Profile Setup (LLO-1: Variables & Data Types)
  String studentName = "Ali Faisal";
  String studentId = "FA20-BCS-001";
  double walletBalance = 1500.0;
  bool isHostelite = true;
  int loyaltyPoints = 120;
  bool isActive = true;

  // Display Student Profile (String Interpolation)
  print('--- Student Profile ---');
  print('Name: $studentName');
  print('ID: $studentId');
  print('Status: ${isHostelite ? "Hostelite" : "Day Scholar"}');
  print('Wallet Balance: Rs. ${walletBalance.toStringAsFixed(2)}');
  print('Loyalty Points: $loyaltyPoints');
  print('Account Active: $isActive');
  print('-----------------------\n');

  // Task 3: Canteen Data Management (LLO-3: Collections)
  // a. Menu Catalog (Map)
  Map<String, double> menuPrices = {
    "Chicken Roll": 150.0,
    "Zinger Burger": 280.0,
    "Fries": 100.0,
    "Coffee": 120.0,
    "Fresh Juice": 180.0,
  };

  // b. Order Selection (List) - Simulating order selection
  List<String> orderItems = ["Zinger Burger", "Chicken Roll", "Fries", "Coffee"];

  // c. Voucher System (Set)
  Set<String> validVouchers = {'WELCOME10', 'CAMPUS50', 'EXAMBOOST'};
  String voucherInput = "CAMPUS50"; // Simulating user input

  // Start Order Processing
  print('Order Items: ${orderItems.join(", ")}');

  // Task 2a: Eligibility & Authorization
  if (!isActive) {
    print('ERROR: Student account is inactive. Order cancelled.');
    return;
  }
  if (walletBalance <= 0) {
    print('ERROR: Insufficient wallet balance (Rs. 0). Please recharge.');
    return;
  }

  // Task 4: Calculation
  double subtotal = calculateTotal(orderItems, menuPrices);
  double generalDiscount = applyDiscount(subtotal, isHostelite, loyaltyPoints);
  
  // Voucher Logic (Task 3c)
  double voucherBenefit = 0.0;
  if (validVouchers.contains(voucherInput)) {
    voucherBenefit = 50.0; // Flat discount for valid voucher
    validVouchers.remove(voucherInput); // Remove so it can't be reused
    print('Voucher "$voucherInput" applied! (Rs. 50 reduction)');
  }

  double tax = subtotal * 0.05; // Optional 5% tax
  double finalAmount = subtotal - generalDiscount - voucherBenefit + tax;

  // Task 2c & 9: Wallet Payment & Validation
  if (finalAmount > walletBalance) {
    print('\n[ALERT] INSUFFICIENT BALANCE!');
    print('Total Bill: Rs. ${finalAmount.toStringAsFixed(2)}');
    print('Current Wallet: Rs. ${walletBalance.toStringAsFixed(2)}');
    print('Shortage: Rs. ${(finalAmount - walletBalance).toStringAsFixed(2)}');
    print('Transaction Cancelled.');
  } else {
    // Payment Successful
    double balanceBefore = walletBalance;
    walletBalance -= finalAmount;
    String txnId = "TXN${DateTime.now().millisecondsSinceEpoch}";

    // Requirement 8: Billing / Itemized Receipt
    print('\n====================================');
    print('        ITEMIZED RECEIPT');
    print('====================================');
    print('Student: $studentName ($studentId)');
    print('Type: ${isHostelite ? "Hostelite" : "Day Scholar"}');
    print('Date: ${DateTime.now()}');
    print('------------------------------------');
    for (var item in orderItems) {
      print('${item.padRight(20)} Rs. ${menuPrices[item]?.toStringAsFixed(2)}');
    }
    print('------------------------------------');
    print('Subtotal:            Rs. ${subtotal.toStringAsFixed(2)}');
    if (generalDiscount > 0) print('Campus Discount:    -Rs. ${generalDiscount.toStringAsFixed(2)}');
    if (voucherBenefit > 0) print('Voucher Discount:   -Rs. ${voucherBenefit.toStringAsFixed(2)}');
    print('Tax (5% GST):        Rs. ${tax.toStringAsFixed(2)}');
    print('------------------------------------');
    print('FINAL CHARGED:       Rs. ${finalAmount.toStringAsFixed(2)}');
    print('------------------------------------');
    print('Wallet (Before):     Rs. ${balanceBefore.toStringAsFixed(2)}');
    print('Remaining Balance:   Rs. ${walletBalance.toStringAsFixed(2)}');
    print('Transaction ID:      $txnId');
    print('====================================');

    // Call Arrow Function (Task 4c)
    logTransaction(txnId, finalAmount);
  }
}
