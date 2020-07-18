import 'dart:async';
import 'package:apiconsqlite/models/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:apiconsqlite/models/profile.dart';

abstract class DB {

    static Database _db;

    static int get _version => 1;

    static Future<void> init() async {
        if (_db != null) { return; }

        try {
            String _path = await getDatabasesPath() + 'example';
            _db = await openDatabase(_path, version: _version, onCreate: onCreate);
        }
        catch(ex) { 
            print(ex);
        }
    }

    static void onCreate(Database db, int version) async =>
        await db.execute('CREATE TABLE materias_db (id INTEGER PRIMARY KEY NOT NULL, nombre STRING,profesor STRING, cuatrimestre STRING, horario STRING, complete BOOLEAN)');

    static Future<List<Map<String, dynamic>>> query(String table) async => _db.query(table);

    static Future<int> insert(String table, Model model) async =>
        await _db.insert(table, model.toMap());
    
    static Future<int> update(String table, Model model) async =>
        await _db.update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  //  static Future<int> delete(String table, Model model) async =>
  //      await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);

    static Future<int> delete(String table, Model model) async{
        final response= await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);
        
        return response;
        // if(response == 1){
        //   return 1;
        // }
        // else{
        //   return 0;
        // }
    }

    static Future<List<Materias>> getMaterias() async{
       List<Materias> _tasks = [];

        List<Map<String, dynamic>> _results = await DB.query(Materias.table);
        _tasks = _results.map((item) => Materias.fromMap(item)).toList();
       return _tasks;
    
  }
}