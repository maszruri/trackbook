import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sql.dart';

class SQLHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'sql.db',
      version: 1,
      onCreate: (db, version) async {
        debugPrint("creating table..");
        await db.execute("""CREATE TABLE books(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    pages INTEGER,
    lastRead INTEGER,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
      },
    );
  }

  static Future<int> createBooks(
      String title, String? description, int pages, int lastRead) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'pages': pages,
      'lastRead': lastRead
    };
    final id = await db.insert('books', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await SQLHelper.db();
    return db.query('books', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getBook(int id) async {
    final db = await SQLHelper.db();
    return db.query('books', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateBook(int id, String title, String? description,
      int pages, int lastRead) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'description': description,
      'pages': pages,
      'lastRead': lastRead,
      'createdAt': DateTime.now().toString()
    };
    final result =
        await db.update('books', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteBook(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('books', where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint(err.toString());
    }
  }
}
