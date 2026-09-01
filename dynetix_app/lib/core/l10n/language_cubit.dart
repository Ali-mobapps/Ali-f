import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_translations.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en'));

  void changeLanguage(String languageCode) {
    emit(Locale(languageCode));
  }

  void toggleLanguage() {
    emit(state.languageCode == 'en' ? const Locale('ur') : const Locale('en'));
  }

  String t(String key) {
    return AppTranslations.translate(key, state.languageCode);
  }

  static LanguageCubit of(BuildContext context) => context.read<LanguageCubit>();
}
