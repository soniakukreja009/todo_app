import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todoapp/model/todo.dart';
import 'dart:async';


class DBHelper {
  static final DBHelper _dbHelper = new DBHelper._internal();

  String tblTodo = "todo";
  String colId = "id";
  String colTitle = "title";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";


  DBHelper._internal();

  factory DBHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async{
    if(_db == null) {
      _db = await initializeDB();
    }
    return _db;
  }

  Future<Database> initializeDB() async{
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "todos.db";
    var dbTodos = await openDatabase(path, version:1, onCreate: _createDb);
    return dbTodos;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute(
      "CREATE TABLE $tblTodo ($colId INTEGER PRIMARY KEY,"
          "$colTitle TEXT, "
          "$colDescription TEXT, "
          "$colPriority INTEGER, "
          "$colDate TEXT)"
    );
  }

  Future<int> insertTodo(Todo todo) async {
    Database db = await this.db;
    var result = await db.insert(tblTodo, todo.getMap());
    return result;
  }

  Future<List> getTodos() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblTodo order by $colPriority ASC");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("Select count(*) from $tblTodo")
    );
    return result;
  }

  Future<int> updateTodo(Todo todo) async{
    Database db = await this.db;
    var result = await db.update(tblTodo, todo.getMap(),
    where: "$colId=?" , whereArgs: [todo.id]);
    return result;
  }
  
  Future<int> deleteTodo(int id) async{
    Database db = await this.db;
    int result = await db.rawDelete("DELETE FROM $tblTodo where $colId = '$id'");
    return result;
  }
}