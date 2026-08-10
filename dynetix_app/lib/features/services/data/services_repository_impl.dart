Future<void> addService(String name, double price) async {
  // Agar aap Firestore use kar rahe hain:
  // await FirebaseFirestore.instance.collection('services').add({
  //   'name': name,
  //   'price': price,
  //   'timestamp': FieldValue.serverTimestamp(),
  // });
}
