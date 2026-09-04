import 'package:firebase_database/firebase_database.dart';
import 'package:salespro_saas_admin/model/general_setting_model.dart';

class GeneralSettingRepo {
  Future<GeneralSettingModel> getGeneralSetting() async {
    DatabaseReference generalSettingRef = FirebaseDatabase.instance.ref('Admin Panel/General Setting');
    final generalSettingData = await generalSettingRef.get();

    if (generalSettingData.value == null) {
      return GeneralSettingModel(
        title: '',
        companyName: '',
        mainLogo: '',
        commonHeaderLogo: '',
        sidebarLogo: '',
      );
    }

    if (generalSettingData.value is Map) {
      final data = Map<String, dynamic>.from(generalSettingData.value as Map);
      if (data.containsKey('title')) {
        return GeneralSettingModel.fromJson(data);
      } else {
        final firstKey = data.keys.first;
        return GeneralSettingModel.fromJson(Map<String, dynamic>.from(data[firstKey]));
      }
    }

    return GeneralSettingModel(
      title: '',
      companyName: '',
      mainLogo: '',
      commonHeaderLogo: '',
      sidebarLogo: '',
    );
  }
}

// class GeneralSettingRepo {
//   Future<GeneralSettingModel> getGeneralSetting() async {
//     DatabaseReference generalSettngRef = FirebaseDatabase.instance.ref('Admin Panel/General Setting');
//     final generalSettingData = await generalSettngRef.get();
//     GeneralSettingModel generalSettingModel = GeneralSettingModel.fromJson(jsonDecode(jsonEncode(generalSettingData.value)));
//     return generalSettingModel;
//   }
// }
