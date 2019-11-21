import 'dart:async';

import 'package:mymoneyleilisson/Modelos/despesas.dart';
import 'package:mymoneyleilisson/Modelos/receitas.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tabelaReceita = 'TabelaReceita';
  final String colunaId = 'id';
  final String colunaOrigem = 'Origem';
  final String colunaValor = 'Valor';
  final String colunaData = 'Data';
  final String colunaComent = 'Comentario';
  final String colunaPag = 'Pagamento';

  final String tabelaDespesa = 'TabelaDespesa';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dados.db');

//    await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tabelaDespesa($colunaId INTEGER PRIMARY KEY, $colunaOrigem TEXT, $colunaValor DOUBLE, $colunaData TEXT, $colunaComent TEXT, $colunaPag TEXT)');

    await db.execute(
        'CREATE TABLE $tabelaReceita($colunaId INTEGER PRIMARY KEY, $colunaOrigem TEXT, $colunaValor DOUBLE, $colunaData TEXT, $colunaComent TEXT, $colunaPag TEXT)');
  }

  //RECEITAS

  Future<int> salvarReceita(Receitas receita) async {
    var dbClient = await db;
    var result = await dbClient.insert(tabelaReceita, receita.toMap());
//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tableNote ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')');

    return result;
  }

  Future<List> pegarReceitas() async {
    var dbClient = await db;
    //var result = await dbClient.query(tabelaReceita, columns: [colunaId, colunaOrigem, colunaValor, colunaData]);
    var result = await dbClient.rawQuery(
        'SELECT $colunaId,$colunaOrigem,$colunaValor,$colunaData,$colunaComent,$colunaPag FROM '
        '$tabelaReceita ORDER BY $colunaId DESC');

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tabelaReceita'));
  }

  Future<Receitas> pegarReceita(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tabelaReceita,
        columns: [
          colunaId,
          colunaOrigem,
          colunaValor,
          colunaData,
          colunaComent,
          colunaPag
        ],
        where: '$colunaId = ?',
        whereArgs: [id]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableNote WHERE $columnId = $id');

    if (result.length > 0) {
      return new Receitas.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteReceita(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tabelaReceita, where: '$colunaId = ?', whereArgs: [id]);
//    return await dbClient.rawDelete('DELETE FROM $tableNote WHERE $columnId = $id');
  }

  Future<int> updateReceita(Receitas receita) async {
    var dbClient = await db;
    return await dbClient.update(tabelaReceita, receita.toMap(),
        where: "$colunaId = ?", whereArgs: [receita.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tableNote SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
  }

  Future<List> pegarReceitasFiltrada(String dataIni, String datafim) async {
    var dbClient = await db;
    //var result = await dbClient.query(tabelaReceita, columns: [colunaId, colunaOrigem, colunaValor, colunaData]);
    var result = await dbClient.rawQuery(
        "SELECT $colunaId,$colunaOrigem,$colunaValor,$colunaData,$colunaComent,$colunaPag FROM "
        "$tabelaReceita WHERE $colunaData BETWEEN '$dataIni' AND '$datafim'");

    return result.toList();
  }

  Future<List> pegarReceitasFiltradaOrigem(String origem) async {
    var dbClient = await db;
    //var result = await dbClient.query(tabelaReceita, columns: [colunaId, colunaOrigem, colunaValor, colunaData]);
    var result = await dbClient.rawQuery(
        "SELECT $colunaId,$colunaOrigem,$colunaValor,$colunaData,$colunaComent,$colunaPag FROM "
        "$tabelaReceita WHERE $colunaOrigem = '$origem'");

    return result.toList();
  }

  Future<List> pegarReceitasFiltradaOrigemData(
      String origem, String dataIni, String dataFim) async {
    var dbClient = await db;
    //var result = await dbClient.query(tabelaReceita, columns: [colunaId, colunaOrigem, colunaValor, colunaData]);
    var result = await dbClient.rawQuery(
        "SELECT $colunaId,$colunaOrigem,$colunaValor,$colunaData,$colunaComent,$colunaPag FROM "
        "$tabelaReceita WHERE $colunaOrigem = '$origem' AND $colunaData BETWEEN '$dataIni' AND '$dataFim'");

    return result.toList();
  }

  Future<List> pegarReceitasPorTipo(
    String origemTipo, String dataINI,String dataFim
  ) async {
    var dbClient = await db;
    //var result = await dbClient.query(tabelaReceita, columns: [colunaId, colunaOrigem, colunaValor, colunaData]);

    var result = await dbClient.rawQuery("SELECT $colunaId,$colunaOrigem,$colunaValor,$colunaData,$colunaComent,$colunaPag FROM "
        "$tabelaReceita WHERE $colunaOrigem = '$origemTipo'AND $colunaData BETWEEN '$dataINI' AND '$dataFim' ");
    return result.toList();
  }

//DESPESAS
  Future<int> salvarDespesa(Despesas despesa) async {
    var dbClient = await db;
    var result = await dbClient.insert(tabelaDespesa, despesa.toMap());
//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tableNote ($columnTitle, $columnDescription) VALUES (\'${note.title}\', \'${note.description}\')');

    return result;
  }

  Future<List> pegarDespesas() async {
    var dbClient = await db;
    //var result = await dbClient.query(tabelaReceita, columns: [colunaId, colunaOrigem, colunaValor, colunaData]);
    var result = await dbClient.rawQuery(
        'SELECT $colunaId,$colunaOrigem,$colunaValor,$colunaData,$colunaComent,$colunaPag FROM '
        '$tabelaDespesa ORDER BY $colunaId DESC');

    return result.toList();
  }

  Future<Despesas> pegarDespesa(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tabelaDespesa,
        columns: [
          colunaId,
          colunaOrigem,
          colunaValor,
          colunaData,
          colunaComent,
          colunaPag
        ],
        where: '$colunaId = ?',
        whereArgs: [id]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableNote WHERE $columnId = $id');

    if (result.length > 0) {
      return new Despesas.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteDespesa(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tabelaDespesa, where: '$colunaId = ?', whereArgs: [id]);
//    return await dbClient.rawDelete('DELETE FROM $tableNote WHERE $columnId = $id');
  }

  Future<int> updateDespesa(Despesas despesa) async {
    var dbClient = await db;
    return await dbClient.update(tabelaDespesa, despesa.toMap(),
        where: "$colunaId = ?", whereArgs: [despesa.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tableNote SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
  }

  Future<List> pegarDespesasFiltrada(String dataIni, String datafim) async {
    var dbClient = await db;
    //var result = await dbClient.query(tabelaReceita, columns: [colunaId, colunaOrigem, colunaValor, colunaData]);
    var result = await dbClient.rawQuery(
        "SELECT $colunaId,$colunaOrigem,$colunaValor,$colunaData,$colunaComent,$colunaPag FROM "
        "$tabelaDespesa WHERE $colunaData BETWEEN '$dataIni' AND '$datafim'");

    return result.toList();
  }

  Future<List> pegarDespesasFiltradaOrigem(String origem) async {
    var dbClient = await db;
    //var result = await dbClient.query(tabelaReceita, columns: [colunaId, colunaOrigem, colunaValor, colunaData]);
    var result = await dbClient.rawQuery(
        "SELECT $colunaId,$colunaOrigem,$colunaValor,$colunaData,$colunaComent,$colunaPag FROM "
        "$tabelaDespesa WHERE $colunaOrigem = '$origem'");

    return result.toList();
  }

  Future<List> pegarDespesasFiltradaOrigemData(
      String origem, String dataIni, String dataFim) async {
    var dbClient = await db;
    //var result = await dbClient.query(tabelaReceita, columns: [colunaId, colunaOrigem, colunaValor, colunaData]);
    var result = await dbClient.rawQuery(
        "SELECT $colunaId,$colunaOrigem,$colunaValor,$colunaData,$colunaComent,$colunaPag FROM "
        "$tabelaDespesa WHERE $colunaOrigem = '$origem' AND $colunaData BETWEEN '$dataIni' AND '$dataFim'");

    return result.toList();
  }

  Future<List> pegarDespesasPorTipo(
      String origemTipo, String dataINI,String dataFim
      ) async {
    var dbClient = await db;
    //var result = await dbClient.query(tabelaReceita, columns: [colunaId, colunaOrigem, colunaValor, colunaData]);

    var result = await dbClient.rawQuery("SELECT $colunaId,$colunaOrigem,$colunaValor,$colunaData,$colunaComent,$colunaPag FROM "
        "$tabelaDespesa WHERE $colunaOrigem = '$origemTipo'AND $colunaData BETWEEN '$dataINI' AND '$dataFim' ");
    return result.toList();
  }


  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
