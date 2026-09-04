class SubscriptionModel {
  SubscriptionModel({
    required this.subscriptionName,
    required this.subscriptionDate,
    required this.saleNumber,
    required this.purchaseNumber,
    required this.partiesNumber,
    required this.dueNumber,
    required this.duration,
    required this.products,
    this.whatsappMarketingEnabled = false,
  });

  String subscriptionName, subscriptionDate;
  bool whatsappMarketingEnabled;
  int saleNumber, purchaseNumber, partiesNumber, dueNumber, duration, products;

  SubscriptionModel.fromJson(Map<dynamic, dynamic> json)
      : subscriptionName = json['subscriptionName'],
        saleNumber = json['saleNumber'],
        subscriptionDate = json['subscriptionDate'],
        purchaseNumber = json['purchaseNumber'],
        partiesNumber = json['partiesNumber'],
        dueNumber = json['dueNumber'],
        duration = json['duration'],
        whatsappMarketingEnabled = json['whatsappMarketingEnabled'] ?? false,
        products = json['products'];

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'subscriptionName': subscriptionName,
        'subscriptionDate': subscriptionDate,
        'saleNumber': saleNumber,
        'purchaseNumber': purchaseNumber,
        'partiesNumber': partiesNumber,
        'dueNumber': dueNumber,
        'duration': duration,
        'whatsappMarketingEnabled': whatsappMarketingEnabled,
        'products': products,
      };
}
