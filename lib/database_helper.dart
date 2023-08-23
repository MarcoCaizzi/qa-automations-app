import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'person_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    //if (_database != null) return _database!;

    _database = await _initDB('people.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE people(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT,
      apellido TEXT,
      fechaNacimiento TEXT,
      email TEXT,
      telefono TEXT
      )
    ''');
  }

  Future<int> insertPerson(Person person) async {
    final db = await database;
    int insertedId = await db.insert('people', person.toMap());
    await db.close();
    return insertedId;
  }


  Future<List<Person>> getPeople() async {
    final db = await database;
    final maps = await db.query('people');
    final peopleList = List.generate(maps.length, (i) {
      return Person(
        id: maps[i]['id'] as int,
        nombre: maps[i]['nombre'] as String,
        apellido: maps[i]['apellido'] as String,
        fechaNacimiento: maps[i]['fechaNacimiento'] as String,
        email: maps[i]['email'] as String,
        telefono: maps[i]['telefono'] as String,
      );
    });

    await db.close(); // Cierra la conexión después de generar la lista
    return peopleList;
  }

}
