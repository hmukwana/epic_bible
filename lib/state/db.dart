import 'dart:io';

import 'package:epic_bible/models/book.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/chapter.dart';
import '../models/verse.dart';

final dbState = ChangeNotifierProvider((ref) => DBState());

class DBState extends ChangeNotifier {
  DBState() {
    _openDB();
  }

  Database? _database;
  Chapter? _lastChapter;

  Future<Database> get database async {
    return _database ?? await _openDB();
  }

  Chapter? get lastChapter => _lastChapter;

  set lastChapter(Chapter? chapter) {
    _lastChapter = chapter;
    notifyListeners();
  }

  bool get hasNextChapter {
    return _lastChapter?.nextReferenceOsis.isNotEmpty ?? false;
  }

  bool get hasPrevChapter {
    return _lastChapter?.previousReferenceOsis.isNotEmpty ?? false;
  }

  // Open DB
  Future _openDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, 'copied_database.sqlite3"');

    // Check if db exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you lauch your application
      if (kDebugMode) {
        print('Creating new copey from asset');
      }

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {
        if (kDebugMode) {
          print(_);
        }
      }

      // Copy from asset
      ByteData data = await rootBundle.load("assets/db/kjv.sqlite3");
      List<int> bytes =
          data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      if (kDebugMode) {
        print("Opening existing database");
      }
    }

    // open the database
    _database = await openDatabase(path, readOnly: true);
    return _database;
  }

  Future<List<Book>> loadBooks({String? searchText}) async {
    var db = await database;
    var data = await db
        .query('books', where: "human LIKE ?", whereArgs: ['%$searchText%']);

    List<Book> books = data.map((e) => Book.fromMap(e)).toList();

    return books;
  }

  Future<Chapter> loadChapter(
      {required Book book, required int chapterNo}) async {
    var db = await database;
    var data = await db.query('chapters',
        where: "reference_osis = ?", whereArgs: ["${book.osis}.$chapterNo"]);

    lastChapter = Chapter.fromMap(data.first);

    return _lastChapter!;
  }

  Future<List<Verse>> loadVerses(
      {required Book book, required int chapter}) async {
    var db = await database;
    var data = await db.query('verses',
        where: "book = ? AND verse >= ? AND verse < ?",
        whereArgs: [book.osis, chapter, chapter]);

    List<Verse> verses = data.map((e) => Verse.fromMap(e)).toList();

    return verses;
  }
}
