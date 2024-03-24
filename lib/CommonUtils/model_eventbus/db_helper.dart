import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../network/models/user_model.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();


  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'your_database.db');

    // Delete old database (if exists)
    await deleteDatabase(path);

    // Create new database
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE User (
        userid TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        photo TEXT,
        phone TEXT
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database? dbClient = await db;
    return await dbClient!.insert('User', user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    Database? dbClient = await db;
    return await dbClient!.query('User');
  }

  Future<User> getUserById(String userId) async {
    Database? dbClient = await db;
    List<Map<String, dynamic>> users = await dbClient!.query(
      'User',
      where: 'userid = ?',
      whereArgs: [userId],
    );
    if (users.isNotEmpty) {
      return User(
        userId: users.first['userid'],
        name: users.first['name'],
        email: users.first['email'],
        photo: users.first['photo'],
        phone: users.first['phone'],
      );
    } else {
      return User(
        userId: '00000',
        name: '',
        email: '',
        photo: '',
        phone: '',
      );
    }
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    Database? dbClient = await db;
    return await dbClient!.update(
      'User',
      user,
      where: 'userid = ?',
      whereArgs: [user['userid']],
    );
  }

  Future<int> deleteUser(String userId) async {
    Database? dbClient = await db;
    return await dbClient!.delete(
      'User',
      where: 'userid = ?',
      whereArgs: [userId],
    );
  }

  Future<void> close() async {
    Database? dbClient = await db;
    dbClient!.close();
  }
}