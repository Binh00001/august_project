import 'package:flutter_project_august/models/school_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabase {
  static Database? _database;

  // Singleton pattern to ensure only one instance of the database is open.
  static final LocalDatabase instance = LocalDatabase._init();

  LocalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('schools.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${SchoolFields.tableSchools}(
        ${SchoolFields.id} TEXT,
        ${SchoolFields.name} TEXT NOT NULL,
        ${SchoolFields.address} TEXT,
        ${SchoolFields.phoneNumber} TEXT
      )
    ''');
  }

  Future<int> addSchool(Map<String, dynamic> schoolData) async {
    final db = await instance.database;
    // Assuming 'name' is the unique identifier for the school
    var existingSchool = await db.query(
      'schools',
      where: 'id = ?',
      whereArgs: [schoolData['id']],
    );

    if (existingSchool.isEmpty) {
      // School does not exist, proceed with insert
      return await db.insert('schools', schoolData,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      // School already exists, handle accordingly
      return 0; // Return 0 or any other appropriate value to indicate no insertion
    }
  }

  Future<List<Map<String, dynamic>>> getAllSchools() async {
    final db = await instance.database;
    return await db.query('schools');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
