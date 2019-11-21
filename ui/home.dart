import 'package:flutter/material.dart';
import 'package:mymoneyleilisson/ui/balanco.dart';
import 'package:mymoneyleilisson/ui/econ_indicators.dart';
import 'package:mymoneyleilisson/ui/ini_despesas.dart';
import 'package:mymoneyleilisson/ui/ini_receitas.dart';

class Home extends StatefulWidget {
  List<double> lista = new List();

  Home(this.lista);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.attach_money,
                  color: Colors.green,
                ),
                text: 'Receitas',
              ),
              Tab(
                icon: Icon(Icons.money_off, color: Colors.red),
                text: 'Despesas',
              ),
              Tab(
                icon: Icon(Icons.pie_chart, color: Colors.yellowAccent),
                text: 'Balanço',
              ),
              Tab(
                icon: Icon(Icons.account_balance_wallet, color: Colors.brown),
                text: 'Cotações',
              ),
            ],
          ),
          title: Text('MyMoneyLeilisson'),
        ),
        body: TabBarView(children: [
          new IniReceitas(),
          new IniDespesas(),
          new balanco(),
          new SimpleSeriesLegend(widget.lista),
        ]),
      ),
    );
  }
}
