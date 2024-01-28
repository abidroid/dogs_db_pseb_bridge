import 'dart:io';

import 'package:dogs_db_pseb_bridge/models/dog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // database
  DatabaseHelper._privateConstructor(); // Name constructor to create instance of database
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // getter for database

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS
    // to store database

    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/dogs.db';

    // open/ create database at a given path
    var studentsDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );

    return studentsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''Create TABLE tbl_dog (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  name TEXT,
                  age INTEGER )
    
    ''');
  }

  // insert
  Future<int> insertDog(Dog dog) async {
    // add dog to table

    Database db = await instance.database;
    int result = await db.insert('tbl_dog', dog.toMap());
    return result;
  }

  // read operation
  Future<List<Dog>> getAllDogs() async {
    List<Dog> dogs = [];

    Database db = await instance.database;

    // read data from table
    List<Map<String, dynamic>> listMap = await db.query('tbl_dog');

    for (var dogMap in listMap) {
      Dog dog = Dog.fromMap(dogMap);
      dogs.add(dog);
    }

    return dogs;
  }

  // delete
  Future<int> deleteDog(int id) async {
    Database db = await instance.database;
    int result = await db.delete('tbl_dog', where: 'id=?', whereArgs: [id]);
    return result;
  }

  // update
  Future<int> updateDog(Dog dog) async {
    Database db = await instance.database;
    int result = await db.update('tbl_dog', dog.toMap(), where: 'id=?', whereArgs: [dog.id]);
    return result;
  }

  // read operation
  Future<List<Dog>> searchDog({required String name}) async {
    List<Dog> dogs = [];

    Database db = await instance.database;

    // read data from table
    List<Map<String, dynamic>> listMap = await db.query('tbl_dog', where: 'name like ?', whereArgs: ['%$name%']);

    for (var dogMap in listMap) {
      Dog dog = Dog.fromMap(dogMap);
      dogs.add(dog);
    }

    return dogs;
  }
}
