import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salespro_saas_admin/Repo/general_setting_repo.dart';
import 'package:salespro_saas_admin/model/general_setting_model.dart';

GeneralSettingRepo generalSettingRepo = GeneralSettingRepo();
final generalSettingProvider = FutureProvider<GeneralSettingModel>((ref) => generalSettingRepo.getGeneralSetting());
