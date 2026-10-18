class AppConstants {
  static const String appName = 'Student Management System';
  static const String appVersion = '1.0.0';

  // SQLite Config
  static const String dbName = 'student_management.db';
  static const int dbVersion = 2;

  // Table Names
  static const String tableUsers = 'users';
  static const String tableStudents = 'students';

  // SharedPreferences Keys
  static const String prefIsDarkMode = 'is_dark_mode';
  static const String prefLoggedInUserId = 'logged_in_user_id';
  static const String prefLastBackupDate = 'last_backup_date';

  // Department Options
  static const List<String> departments = [
    'Computer Science',
    'Software Engineering',
    'Information Technology',
    'Electrical Engineering',
    'Civil Engineering',
    'Mechanical Engineering',
    'Business Administration',
    'Economics',
    'Mathematics',
  ];

  // Semester Options
  static const List<String> semesters = [
    '1st Semester',
    '2nd Semester',
    '3rd Semester',
    '4th Semester',
    '5th Semester',
    '6th Semester',
    '7th Semester',
    '8th Semester',
  ];

  // Section Options
  static const List<String> sections = [
    'Section A',
    'Section B',
    'Section C',
    'Section D',
  ];

  // Gender Options
  static const List<String> genders = [
    'Male',
    'Female',
    'Other',
  ];
}
