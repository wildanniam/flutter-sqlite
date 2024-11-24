import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> db() async {
    return openDatabase(
      'users.db',
      version: 1,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> createTables(Database database) async {
    await database.execute("""
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_user TEXT NOT NULL
      )
    """);
  }

  // Insert user
  static Future<int> addUser(String namaUser) async {
    final db = await DatabaseHelper.db();
    final data = {'nama_user': namaUser};
    return await db.insert('user', data);
  }

  // Get all users
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await DatabaseHelper.db();
    return db.query('user', orderBy: 'id');
  }
}
