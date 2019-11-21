import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymoneyleilisson/ui/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

List<double> lista = new List();
void main() {
  getData();
  Intl.defaultLocale = 'pt_BR';
  runApp(new MaterialApp(
    theme: ThemeData(primaryColor: Colors.grey[800]),
    home: new Home(lista),
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('en', 'US'),
      const Locale('pt', 'BR'),
    ],
  ));
}

void getData() async {
  int i;
  var _dados = await getJson();
  for (i = 0;i<4;i++){
    lista.add(_dados[i]['rates']['BRL']);
  }

}

Future<List<Map<String, dynamic>>> getJson() async {

  http.Response response = await http.get('https://api.exchangeratesapi.io/latest?base=USD');
  http.Response response1 = await http.get('https://api.exchangeratesapi.io/latest?base=EUR');
  http.Response response2 = await http.get('https://api.exchangeratesapi.io/latest?base=JPY');
  http.Response response3 = await http.get('https://api.exchangeratesapi.io/latest?base=GBP');

  //status code == 200 = OK
  if (response.statusCode == 200 && response1.statusCode == 200 &&
      response2.statusCode == 200 && response3.statusCode == 200 ) {
    //print(json.encode(response.body));
    List<Map<String,dynamic>> mapaList = new List();
    mapaList.add(json.decode(response.body));
    mapaList.add(json.decode(response1.body));
    mapaList.add(json.decode(response2.body));
    mapaList.add(json.decode(response3.body));
    return mapaList;
  } else {
    throw Exception('Falhou!');
  }
}
