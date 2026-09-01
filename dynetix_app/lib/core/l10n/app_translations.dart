class AppTranslations {
  static const Map<String, Map<String, String>> _data = {
    'en': {
      'app_title': 'Dynetix App',
      'welcome': 'Welcome Back',
      'login': 'Login',
      'signup': 'Sign Up',
      'email': 'Email Address',
      'password': 'Password',
      'services': 'Services',
      'skills': 'Skills',
      'chat': 'Chat',
      'projects': 'Projects',
      'payments': 'Payments',
      'profile': 'Profile',
      'logout': 'Logout',
      'excellence': 'EXCELLENCE IN EVERY NODE',
    },
    'ur': {
      'app_title': 'ڈائنیٹکس ایپ',
      'welcome': 'خوش آمدید',
      'login': 'لاگ ان',
      'signup': 'سائن اپ',
      'email': 'ای میل ایڈریس',
      'password': 'پاس ورڈ',
      'services': 'خدمات',
      'skills': 'مہارتیں',
      'chat': 'چیٹ',
      'projects': 'پروجیکٹس',
      'payments': 'ادائیگیاں',
      'profile': 'پروفائل',
      'logout': 'لاگ آؤٹ',
      'excellence': 'ہر کام میں مہارت',
    },
  };

  static String translate(String key, String langCode) {
    return _data[langCode]?[key] ?? key;
  }
}
