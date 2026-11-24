import 'package:flutter/foundation.dart';
import '../models/user_profile_model.dart';
import '../database/database_helper.dart';

class ProfileProvider with ChangeNotifier {
  UserProfile _profile = UserProfile(
    userId: 1,
    name: 'Zeren Customer',
    email: 'customer@zeren.com',
    phoneNumber: '+92 300 1234567',
    deliveryAddress: 'House 123, Street 4, Islamabad',
  );
  bool _isLoading = false;

  UserProfile get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _profile = await DatabaseHelper.instance.getUserProfile();
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    _isLoading = true;
    notifyListeners();

    try {
      await DatabaseHelper.instance.updateProfile(updatedProfile);
      _profile = updatedProfile;
    } catch (e) {
      debugPrint('Error updating profile: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
