import 'package:flutter/services.dart';
import 'package:qa_automations_app/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:io';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    // Obtener la ubicación de la base de datos en el dispositivo
    final dbPath = await getDatabasesPath();
    final dbFile = path.join(dbPath, 'people.db');

    bool dbExists = await File(dbFile).exists();

    if (!dbExists) {
      // Si la base de datos no existe, copiarla desde los assets
      final ByteData data = await rootBundle.load('assets/db/people.db');
      final List<int> bytes = data.buffer.asUint8List();
      await File(dbFile).writeAsBytes(bytes);
    }

    // Abrir la base de datos
    return await openDatabase(dbFile);
  }

  Future<int> insertPeople(People people) async {
    final db = await database;
    int insertedId = await db.insert('people', people.toMap());
    return insertedId;
  }


  Future<List<People>> getPeople() async {
    final db = await database;
    final maps = await db.query('people');
    final List<People> peopleList = [];

    for (final map in maps) {
      final idCountry = map['idCountry'] as int;
      final idProvince = map['idProvince'] as int;

      final country = await getCountry(idCountry, db);
      final province = await getProvinces(idProvince, db);

      final person = People(
        id: map['id'] as int,
        name: map['name'] as String,
        lastName: map['lastName'] as String,
        dateOfBirth: map['dateOfBirth'] as String,
        email: map['email'] as String,
        cellularPhoneNumber: map['cellularPhoneNumber'] as String,
        idCountry: country,
        idProvince: province,
      );
      peopleList.add(person);
    }
    return peopleList;
  }

  Future<Country> getCountry(int id, Database db) async {
    final map = await db.query('country', where: 'id = ?', whereArgs: [id]);
    return Country(
      id: map[0]['id'] as int,
      name: map[0]['name'] as String,
    );
  }

  Future<Province> getProvinces(int id, Database db) async {
    final map = await db.query('province', where: 'id = ?', whereArgs: [id]);
    return Province(
      id: map[0]['id'] as int,
      name: map[0]['name'] as String,
      idCountry : map[0]['idCountry'] as int
    );
  }

  Future<List<Country>> getCountries() async {
    final db = await database;
    final maps = await db.query('country');
    return List.generate(maps.length, (i) {
      return Country(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
      );
    });
  }

  Future<List<Province>> getProvincesByCountry(int idCountry) async {
    final db = await database;
    final provinces = await db.query('province', where: 'idCountry = ?', whereArgs: [idCountry]);
    return List.generate(provinces.length, (i) {
      return Province(
        id: provinces[i]['id'] as int,
        name: provinces[i]['name'] as String,
        idCountry: idCountry,
      );
    });
  }

}
