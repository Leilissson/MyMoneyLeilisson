import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Bar chart with series legend example

import 'package:charts_flutter/flutter.dart' as charts;

class SimpleSeriesLegend extends StatelessWidget {
  List<double> _dados = new List();
  List<Convert> series = new List();

  SimpleSeriesLegend(this._dados);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: _dados.length == 4 ?new charts.BarChart(
        _createSampleData(),
        animate: true,
        barRendererDecorator: new charts.BarLabelDecorator<String>(),
        vertical: false,



        // Add the series legend behavior to the chart to turn on series legends.
        // By default the legend will display above the chart.
      ): Center(child: Text('Erro na rede. Tente novamente mais tarde.',style:TextStyle(fontSize: 18.0),)),
    );
  }

  /// Create series list with multiple series
  List<charts.Series<Convert, String>> _createSampleData() {
    try {
      series.add(new Convert('USD', _dados[0], Colors.blue));
      series.add(new Convert('EUR', _dados[1], Colors.amber));
      series.add(new Convert('JPY', _dados[2], Colors.green));
      series.add(new Convert('GBP', _dados[3], Colors.deepOrange));
    } catch (e) {
      return null;
    }

    return [
      new charts.Series<Convert, String>(
          id: 'reais',
          domainFn: (Convert data, _) => data.outros,
          measureFn: (Convert data, _) => data.reais,
          colorFn: (Convert data, _) => data.color,
          data: series,
          displayName:  'Cotação principais moedas',
          labelAccessorFn: (Convert data, _) => '${data.reais}'),

    ];
  }
}

/// Sample ordinal data type.
class Convert {
  final String outros;
  final double reais;
  final charts.Color color;

  Convert(this.outros, this.reais, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
