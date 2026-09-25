class Student {
  String studentName;
  String studentId;
  double walletBalance;
  bool isHostelite;
  int loyaltyPoints;
  bool isActive;

  Student({
    required this.studentName,
    required this.studentId,
    required this.walletBalance,
    required this.isHostelite,
    required this.loyaltyPoints,
    this.isActive = true,
  });

  // String interpolation for profile display as required
  String get profileSummary =>
      "Name: $studentName\nID: $studentId\nType: ${isHostelite ? 'Hostelite' : 'Day Scholar'}\nBalance: Rs. ${walletBalance.toStringAsFixed(2)}\nPoints: $loyaltyPoints";
}
