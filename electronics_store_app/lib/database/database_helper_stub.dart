class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();
  get database async => null;
  String hashPassword(String password) => password;
}
