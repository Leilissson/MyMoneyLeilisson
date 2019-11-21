import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymoneyleilisson/Modelos/despesas.dart';
import 'package:mymoneyleilisson/Modelos/receitas.dart';

import 'package:mymoneyleilisson/ultil/banco_dados.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:decimal/decimal.dart';


class balanco extends StatefulWidget {
  @override
  _balancoState createState() => _balancoState();
}

class Balance {
  final String tipo;
  final double valor;
  final charts.Color color;

  Balance(this.tipo, this.valor, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class _balancoState extends State<balanco> {
  DatabaseHelper db = new DatabaseHelper();
  List<Receitas> items = new List();
  List<Receitas> itemsOtherRec = new List();
  List<Despesas> items2 = new List();
  String totalBalanco;
  Color ReCSalLegenda;
  Color RecALuLegenda;
  Color RecRendLegenda;
  Color RecMesLegenda;
  Color RecVbensLegenda;
  Color RecLegenda;
  Color RecOutLegenda;

  Color DepAgLegenda;
  Color DepAlLegenda;
  Color DepCombLegenda;
  Color DepVestLegenda;
  Color DepIntLegenda;
  Color DepElLegenda;
  Color DespLegenda;
  Color DepOutLegenda;

  String balanco = 'Total: ';
  int radioValue = 0;
  int radiov0 = 0;
  int radiov1 = 1;
  int radiov2 = 2;

  List<Balance> data;

  double totRec = 0.0;
  double totdesp = 0.0;
  double totSal = 0.0;
  double totAlu = 0.0;
  double totRend = 0.0;
  double totMes = 0.0;
  double totVbens = 0.0;
  double totOut = 0.0;

  double totAg;
  double totEl;
  double totComb;
  double totAlm;
  double totVest;
  double totInt;

  final f = new DateFormat('MM/yyyy');
  String mesAno;

  List<Widget> lw = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mesAno = f.format(DateTime.now());
    _atualizaLista();
  }


  var month = {
    1: '01',
    2: '02',
    3: '03',
    4: '04',
    5: '05',
    6: '06',
    7: '07',
    8: '08',
    9: '09',
    10: '10',
    11: '11',
    12: '12',
  };

  void _atualizaLista() {
    var MA = mesAno.split('/');
    String dataINIformatada = '${MA[1]}-${MA[0]}-01';
    String dadaFIMformatada = '${MA[1]}-${MA[0]}-31';
    db
        .pegarReceitasFiltrada(dataINIformatada, dadaFIMformatada)
        .then((receitas) {
      if (this.mounted) {
        setState(() {
          receitas.forEach((receita) {
            items.add(Receitas.map(receita));
          });
          items.forEach((r) {
            totRec = totRec + double.parse(r.valor);
          });
          if (items.length != 0)
            RecLegenda = Colors.green;
          else
            RecLegenda = null;
        });
      }
    });

    db
        .pegarDespesasFiltrada(dataINIformatada, dadaFIMformatada)
        .then((despesas) {
      if (this.mounted) {
        setState(() {
          despesas.forEach((despesa) {
            items2.add(Despesas.map(despesa));
          });
          items2.forEach((d) {
            totdesp = totdesp + double.parse(d.valor);
          });
          if (items2.length != 0)
            DespLegenda = Colors.red;
          else
            DespLegenda = null;
        });
      }
      _buildLegendList();
      totalBalanco =
          '${Decimal.parse(totRec.toString()) - Decimal.parse(totdesp.toString())}';
    });

    //  balancoTot(items, items2);
  }

  Widget _buildRadio() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        //direction: Axis.horizontal,crossAxisAlignment: WrapCrossAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
            value: radiov0,
            groupValue: radioValue,
            onChanged: _handleRadioValueChange1,
            activeColor: Colors.grey[800],
          ),
          new Text(
            'Todos',
            style: new TextStyle(fontSize: 16.0),
          ),
          new Radio(
            value: radiov1,
            groupValue: radioValue,
            onChanged: _handleRadioValueChange1,
            activeColor: Colors.green,
          ),
          new Text(
            'Receitas',
            style: new TextStyle(
              fontSize: 16.0,
            ),
          ),
          new Radio(
            value: radiov2,
            groupValue: radioValue,
            onChanged: _handleRadioValueChange1,
            activeColor: Colors.red,
          ),
          new Text(
            'Despesas',
            style: new TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  void _handleRadioValueChange1(int value) {
    var MA = mesAno.split('/');
    String dataINIformatada = '${MA[1]}-${MA[0]}-01';
    String dadaFIMformatada = '${MA[1]}-${MA[0]}-31';
    setState(() {
      radioValue = value;
      try {
        data.clear();
      } catch (e) {
        data = [new Balance('', 100.0, Colors.red)];
        data.clear();
      }
    });
    switch (radioValue) {
      case 0:
        db
            .pegarReceitasFiltrada(dataINIformatada, dadaFIMformatada)
            .then((receitas) {
          if (this.mounted) {
            setState(() {
              totRec = 0.0;
              items.clear();
              receitas.forEach((receita) {
                items.add(Receitas.map(receita));
              });
              items.forEach((r) {
                totRec = totRec + double.parse(r.valor);
              });
              if (items.length != 0)
                RecLegenda = Colors.green;
              else
                RecLegenda = null;
            });
          }
        });

        db
            .pegarDespesasFiltrada(dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              totdesp = 0.0;
              items2.clear();
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((d) {
                totdesp = totdesp + double.parse(d.valor);
              });
              if (items2.length != 0)
                DespLegenda = Colors.red;
              else
                DespLegenda = null;
            });
          }
          _buildLegendList();
          totalBalanco =
              '${Decimal.parse(totRec.toString()) - Decimal.parse(totdesp.toString())}';
          balanco = 'Total: ';
        });
        break;
      case 1:
        db
            .pegarReceitasPorTipo('Aluguel', dataINIformatada, dadaFIMformatada)
            .then((receitas) {
          if (this.mounted) {
            setState(() {
              items.clear();
              totAlu = 0.0;
              receitas.forEach((receita) {
                items.add(Receitas.map(receita));
              });
              items.forEach((r) {
                totAlu = totAlu + double.parse(r.valor);
              });
              if (items.length != 0) {
                RecALuLegenda = Colors.blue;
              } else {
                RecALuLegenda = null;
              }
              data.add(
                new Balance('Aluguel', totAlu, Colors.blue),
              );
            });
          }
        });

        db
            .pegarReceitasPorTipo('Salário', dataINIformatada, dadaFIMformatada)
            .then((receitas) {
          if (this.mounted) {
            setState(() {
              items.clear();
              totSal = 0.0;
              receitas.forEach((receita) {
                items.add(Receitas.map(receita));
              });
              items.forEach((r) {
                totSal = totSal + double.parse(r.valor);
              });
              if (items.length != 0) {
                ReCSalLegenda = Colors.green;
              } else {
                ReCSalLegenda = null;
              }
              data.add(
                new Balance('Salário', totSal, Colors.green),
              );
            });
          }
        });

        db
            .pegarReceitasPorTipo(
                'Venda de Bens', dataINIformatada, dadaFIMformatada)
            .then((receitas) {
          if (this.mounted) {
            setState(() {
              items.clear();
              totVbens = 0.0;
              receitas.forEach((receita) {
                items.add(Receitas.map(receita));
              });
              items.forEach((r) {
                totVbens = totVbens + double.parse(r.valor);
              });
              if (items.length != 0) {
                RecVbensLegenda = Colors.yellowAccent;
              } else {
                RecVbensLegenda = null;
              }
              data.add(
                new Balance('Venda de Bens', totVbens, Colors.yellowAccent),
              );
            });
          }
        });

        db
            .pegarReceitasPorTipo(
                'Rendimentos', dataINIformatada, dadaFIMformatada)
            .then((receitas) {
          if (this.mounted) {
            setState(() {
              items.clear();
              totRend = 0.0;
              receitas.forEach((receita) {
                items.add(Receitas.map(receita));
              });
              items.forEach((r) {
                totRend = totRend + double.parse(r.valor);
              });
              if (items.length != 0) {
                RecRendLegenda = Colors.deepPurple;
              } else {
                RecRendLegenda = null;
              }
              data.add(
                new Balance('Rendimentos', totRend, Colors.deepPurple),
              );
            });
          }
        });

        db
            .pegarReceitasPorTipo('Outros', dataINIformatada, dadaFIMformatada)
            .then((receitas) {
          if (this.mounted) {
            setState(() {
              items.clear();
              totOut = 0.0;
              receitas.forEach((receita) {
                items.add(Receitas.map(receita));
              });
              items.forEach((r) {
                totOut = totOut + double.parse(r.valor);
              });
              if (items.length != 0) {
                RecOutLegenda = Colors.brown;
              } else {
                RecOutLegenda = null;
              }
              data.add(
                new Balance('Outros', totOut, Colors.brown),
              );
            });
          }
        });

        db
            .pegarReceitasPorTipo('Mesada', dataINIformatada, dadaFIMformatada)
            .then((receitas) {
          if (this.mounted) {
            setState(() {
              items.clear();
              totMes = 0.0;
              receitas.forEach((receita) {
                items.add(Receitas.map(receita));
              });
              items.forEach((r) {
                totMes = totMes + double.parse(r.valor);
              });
              if (items.length != 0) {
                RecMesLegenda = Colors.lightGreen;
              } else {
                RecMesLegenda = null;
              }
              data.add(
                new Balance('Mesada', totMes, Colors.lightGreen),
              );
            });
            _buildLegendList();
            balanco = 'Total Receitas: ';
            totalBalanco =
                '${Decimal.parse(totMes.toString()) +Decimal.parse(totOut.toString()) + Decimal.parse(totSal.toString()) + Decimal.parse(totAlu.toString()) + Decimal.parse(totVbens.toString()) + Decimal.parse(totRend.toString())}';
          }
        });


        break;


      case 2:
        db
            .pegarDespesasPorTipo('Aluguel', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totAlu = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totAlu = totAlu + double.parse(r.valor);
              });
              if (items2.length != 0) {
                RecALuLegenda = Colors.blue;
              } else {
                RecALuLegenda = null;
              }
              data.add(
                new Balance('Aluguel', totAlu, Colors.blue),
              );
            });
          }
        });

        db
            .pegarDespesasPorTipo(
                'Contas de Internet', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totInt = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totInt = totInt + double.parse(r.valor);
              });
              if (items2.length != 0) {
                DepIntLegenda = Colors.green;
              } else {
                DepIntLegenda = null;
              }
              data.add(
                new Balance('Contas de Internet', totInt, Colors.green),
              );
            });
          }
        });

        db
            .pegarDespesasPorTipo(
                'Energia Elétrica', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totEl = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totEl = totEl + double.parse(r.valor);
              });
              if (items2.length != 0) {
                DepElLegenda = Colors.deepPurple;
              } else {
                DepElLegenda = null;
              }
              data.add(
                new Balance('Energia Elétrica', totEl, Colors.deepPurple),
              );
            });
          }
        });

        db
            .pegarDespesasPorTipo(
                'Alimentação', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totAlm = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totAlm = totAlm + double.parse(r.valor);
              });
              if (items2.length != 0) {
                DepAlLegenda = Colors.orange;
              } else {
                DepAlLegenda = null;
              }
              data.add(
                new Balance('Alimentação', totAlm, Colors.orange),
              );
            });
          }
        });
        db
            .pegarDespesasPorTipo(
                'Combustível', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totComb = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totComb = totComb + double.parse(r.valor);
              });
              if (items2.length != 0) {
                DepCombLegenda = Colors.deepOrange;
              } else {
                DepCombLegenda = null;
              }
              data.add(
                new Balance('Combustível', totComb, Colors.deepOrange),
              );
            });
          }
        });

        db
            .pegarDespesasPorTipo(
                'Vestuário', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totVest = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totVest = totVest + double.parse(r.valor);
              });
              if (items2.length != 0) {
                DepVestLegenda = Colors.yellowAccent;
              } else {
                DepVestLegenda = null;
              }
              data.add(
                new Balance('Vestuário', totVest, Colors.yellowAccent),
              );
            });
          }
        });

        db
            .pegarDespesasPorTipo(
            'Outros', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totOut = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totOut = totOut + double.parse(r.valor);
              });
              if (items2.length != 0) {
                DepOutLegenda = Colors.brown;
              } else {
                DepOutLegenda = null;
              }
              data.add(
                new Balance('Outros', totOut, Colors.brown),
              );
            });
          }
        });

        db
            .pegarDespesasPorTipo('Água', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totAg = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totAg = totAg + double.parse(r.valor);
              });
              if (items2.length != 0) {
                DepAgLegenda = Colors.lightGreen;
              } else {
                DepAgLegenda = null;
              }
              data.add(
                new Balance('Água', totAg, Colors.lightGreen),
              );
            });
            _buildLegendList();
            balanco = 'Total Despesas: ';
            totalBalanco =
                '${Decimal.parse(totOut.toString()) +Decimal.parse(totAg.toString()) + Decimal.parse(totVest.toString()) + Decimal.parse(totAlu.toString()) + Decimal.parse(totComb.toString()) + Decimal.parse(totInt.toString()) + Decimal.parse(totAlm.toString()) + Decimal.parse(totEl.toString())}';
          }
        });


        break;
    }
  }

  void _handle() {
    var MA = mesAno.split('/');
    String dataINIformatada = '${MA[1]}-${MA[0]}-01';
    String dadaFIMformatada = '${MA[1]}-${MA[0]}-31';
    try {
      data.clear();
    } catch (e) {
      data = [];
    }
    switch (radioValue) {
      case 0:
        db
            .pegarReceitasFiltrada(dataINIformatada, dadaFIMformatada)
            .then((receitas) {
          if (this.mounted) {
            setState(() {
              items.clear();
              totRec = 0.0;
              receitas.forEach((receita) {
                items.add(Receitas.map(receita));
              });
              items.forEach((r) {
                totRec = totRec + double.parse(r.valor);
              });
              if (items.length != 0)
                RecLegenda = Colors.green;
              else
                RecLegenda = null;
            });
          }
        });

        db
            .pegarDespesasFiltrada(dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totdesp = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((d) {
                totdesp = totdesp + double.parse(d.valor);
              });
              if (items2.length != 0)
                DespLegenda = Colors.red;
              else
                DespLegenda = null;
            });
          }
          _buildLegendList();
          totalBalanco =
              '${Decimal.parse(totRec.toString()) - Decimal.parse(totdesp.toString())}';
          balanco = 'Total: ';
        });
        break;
      case 1:
        db
            .pegarReceitasPorTipo('Aluguel', dataINIformatada, dadaFIMformatada)
            .then((receitas) {
          if (this.mounted) {
            setState(() {
              items.clear();
              totAlu = 0.0;
              receitas.forEach((receita) {
                items.add(Receitas.map(receita));
              });
              items.forEach((r) {
                totAlu = totAlu + double.parse(r.valor);
              });
              if (items.length != 0) {
                RecALuLegenda = Colors.blue;
              } else {
                RecALuLegenda = null;
              }
              data.add(
                new Balance('Aluguel', totAlu, Colors.blue),
              );
            });
          }
        });

        db
            .pegarReceitasPorTipo('Salário', dataINIformatada, dadaFIMformatada)
            .then((receitas) {
          if (this.mounted) {
            setState(() {
              items.clear();
              totSal = 0.0;
              receitas.forEach((receita) {
                items.add(Receitas.map(receita));
              });
              items.forEach((r) {
                totSal = totSal + double.parse(r.valor);
              });
              if (items.length != 0) {
                ReCSalLegenda = Colors.green;
              } else {
                ReCSalLegenda = null;
              }
              data.add(
                new Balance('Salário', totSal, Colors.green),
              );
            });
          }
        });

        db
            .pegarReceitasPorTipo(
                'Venda de Bens', dataINIformatada, dadaFIMformatada)
            .then((receitas) {
          if (this.mounted) {
            setState(() {
              items.clear();
              totVbens = 0.0;
              receitas.forEach((receita) {
                items.add(Receitas.map(receita));
              });
              items.forEach((r) {
                totVbens = totVbens + double.parse(r.valor);
              });
              if (items.length != 0) {
                RecVbensLegenda = Colors.yellowAccent;
              } else {
                RecVbensLegenda = null;
              }
              data.add(
                new Balance('Venda de Bens', totVbens, Colors.yellowAccent),
              );
            });
          }
        });

        db
            .pegarReceitasPorTipo(
                'Rendimentos', dataINIformatada, dadaFIMformatada)
            .then((receitas) {
          if (this.mounted) {
            setState(() {
              items.clear();
              totRend = 0.0;
              receitas.forEach((receita) {
                items.add(Receitas.map(receita));
              });
              items.forEach((r) {
                totRend = totRend + double.parse(r.valor);
              });
              if (items.length != 0) {
                RecRendLegenda = Colors.deepPurple;
              } else {
                RecRendLegenda = null;
              }
              data.add(
                new Balance('Rendimentos', totRend, Colors.deepPurple),
              );
            });
          }
        });

        db
            .pegarReceitasPorTipo('Outros', dataINIformatada, dadaFIMformatada)
            .then((receitas) {
          if (this.mounted) {
            setState(() {
              items.clear();
              totOut = 0.0;
              receitas.forEach((receita) {
                items.add(Receitas.map(receita));
              });
              items.forEach((r) {
                totOut = totOut + double.parse(r.valor);
              });
              if (items.length != 0) {
                RecOutLegenda = Colors.brown;
              } else {
                RecOutLegenda = null;
              }
              data.add(
                new Balance('Outros', totOut, Colors.brown),
              );
            });
          }
        });

        db
            .pegarReceitasPorTipo('Mesada', dataINIformatada, dadaFIMformatada)
            .then((receitas) {
          if (this.mounted) {
            setState(() {
              items.clear();
              totMes = 0.0;
              receitas.forEach((receita) {
                items.add(Receitas.map(receita));
              });
              items.forEach((r) {
                totMes = totMes + double.parse(r.valor);
              });
              if (items.length != 0) {
                RecMesLegenda = Colors.lightGreen;
              } else {
                RecMesLegenda = null;
              }
              data.add(
                new Balance('Mesada', totMes, Colors.lightGreen),
              );
            });
            _buildLegendList();
            totalBalanco =
                '${Decimal.parse(totMes.toString()) +Decimal.parse(totMes.toString()) + Decimal.parse(totSal.toString()) + Decimal.parse(totAlu.toString()) + Decimal.parse(totVbens.toString()) + Decimal.parse(totRend.toString())}';
          }
        });

        break;
      case 2:
        db
            .pegarDespesasPorTipo('Aluguel', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totAlu = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totAlu = totAlu + double.parse(r.valor);
              });
              if (items2.length != 0) {
                RecALuLegenda = Colors.blue;
              } else {
                RecALuLegenda = null;
              }
              data.add(
                new Balance('Aluguel', totAlu, Colors.blue),
              );
            });
          }
        });

        db
            .pegarDespesasPorTipo(
                'Contas de Internet', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totInt = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totInt = totInt + double.parse(r.valor);
              });
              if (items2.length != 0) {
                DepIntLegenda = Colors.green;
              } else {
                DepIntLegenda = null;
              }
              data.add(
                new Balance('Contas de Internet', totInt, Colors.green),
              );
            });
          }
        });

        db
            .pegarDespesasPorTipo(
                'Energia Elétrica', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totEl = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totEl = totEl + double.parse(r.valor);
              });
              if (items2.length != 0) {
                DepElLegenda = Colors.deepPurple;
              } else {
                DepElLegenda = null;
              }
              data.add(
                new Balance('Energia Elétrica', totEl, Colors.deepPurple),
              );
            });
          }
        });

        db
            .pegarDespesasPorTipo(
                'Alimentação', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totAlm = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totAlm = totAlm + double.parse(r.valor);
              });
              if (items2.length != 0) {
                DepAlLegenda = Colors.orange;
              } else {
                DepAlLegenda = null;
              }
              data.add(
                new Balance('Alimentação', totAlm, Colors.orange),
              );
            });
          }
        });
        db
            .pegarDespesasPorTipo(
                'Combustível', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totComb = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totComb = totComb + double.parse(r.valor);
              });
              if (items2.length != 0) {
                DepCombLegenda = Colors.deepOrange;
              } else {
                DepCombLegenda = null;
              }
              data.add(
                new Balance('Combustível', totComb, Colors.deepOrange),
              );
            });
          }
        });

        db
            .pegarDespesasPorTipo(
                'Vestuário', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totVest = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totVest = totVest + double.parse(r.valor);
              });
              if (items2.length != 0) {
                DepVestLegenda = Colors.yellowAccent;
              } else {
                DepVestLegenda = null;
              }
              data.add(
                new Balance('Vestuário', totVest, Colors.yellowAccent),
              );
            });
          }
        });

        db
            .pegarDespesasPorTipo(
            'Outros', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totOut = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totOut = totOut + double.parse(r.valor);
              });
              if (items2.length != 0) {
                DepOutLegenda = Colors.brown;
              } else {
                DepOutLegenda = null;
              }
              data.add(
                new Balance('Outros', totOut, Colors.brown),
              );
            });
          }
        });

        db
            .pegarDespesasPorTipo('Água', dataINIformatada, dadaFIMformatada)
            .then((despesas) {
          if (this.mounted) {
            setState(() {
              items2.clear();
              totAg = 0.0;
              despesas.forEach((despesa) {
                items2.add(Despesas.map(despesa));
              });
              items2.forEach((r) {
                totAg = totAg + double.parse(r.valor);
              });
              if (items2.length != 0) {
                DepAgLegenda = Colors.lightGreen;
              } else {
                DepAgLegenda = null;
              }
              data.add(
                new Balance('Água', totAg, Colors.lightGreen),
              );
            });
            _buildLegendList();
            balanco = 'Total Despesas: ';
            totalBalanco =
                '${Decimal.parse(totOut.toString()) +Decimal.parse(totAg.toString()) + Decimal.parse(totVest.toString()) + Decimal.parse(totAlu.toString()) + Decimal.parse(totComb.toString()) + Decimal.parse(totInt.toString()) + Decimal.parse(totAlm.toString()) + Decimal.parse(totEl.toString())}';
          }
        });

        break;
    }
  }

  void changeProxMonth() {
    String mes, ano;
    var dataAtual = mesAno;
    var listdata = dataAtual.split('/');
    if (listdata[0] == '12') {
      mes = month[1];
      ano = '${int.parse(listdata[1]) + 1}';
    } else {
      mes = month[int.parse(listdata[0]) + 1];
      ano = '${listdata[1]}';
    }
    setState(() {
      mesAno = '$mes/$ano';
    });
    _handle();
    _buildLegendList();
  }

  void changePreMonth() {
    String mes, ano;
    var dataAtual = mesAno;
    var listdata = dataAtual.split('/');
    if (listdata[0] == '01') {
      mes = '12';
      ano = '${int.parse(listdata[1]) - 1}';
    } else {
      mes = month[int.parse(listdata[0]) - 1];
      ano = '${listdata[1]}';
    }
    setState(() {
      mesAno = '$mes/$ano';
    });
    _buildLegendList();
    _handle();
  }

  Widget _buildMonthBar() {
    return Row(
      children: <Widget>[
        FloatingActionButton(
          onPressed: changePreMonth,
          heroTag: 'ant',
          mini: true,
          backgroundColor: Colors.grey[800],
          child: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.yellowAccent,
          ),
        ),
        Expanded(
            child: Center(
                child: Text(
          '${mesAno}',
          style: TextStyle(fontSize: 18.0,fontStyle: FontStyle.italic),
        ))),
        FloatingActionButton(
          onPressed: changeProxMonth,
          heroTag: 'prox',
          mini: true,
          backgroundColor: Colors.grey[800],
          child: Icon(Icons.keyboard_arrow_right, color: Colors.yellowAccent),
        )
      ],
    );

    /*MonthBar mb = MonthBar();

    _handleRadioValueChange1;*/
  }

  void _buildLegendList() {
    setState(() {
      lw.clear();

      if (radioValue == 1) {
        if (RecMesLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: RecMesLegenda,
              ),
              Flexible(
                  child: Text(
                "Mesada: R\$ $totMes",
                style: TextStyle(fontSize: 15.0),
              )),
            ],
          ));
        }

        if (RecALuLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: RecALuLegenda,
              ),
              Flexible(
                  child: Text(
                "Aluguel: R\$ $totAlu",
                style: TextStyle(fontSize: 15.0),
              )),
            ],
          ));
        }

        if (RecRendLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: RecRendLegenda,
              ),
              Flexible(
                  child: Text(
                "Rendimentos: R\$ $totRend",
                style: TextStyle(fontSize: 15.0),
              )),
            ],
          ));
        }

        if (RecVbensLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: RecVbensLegenda,
              ),
              Flexible(
                  child: Text(
                "V. de Bens: R\$ $totVbens",
                style: TextStyle(fontSize: 15.0),
              )),
            ],
          ));
        }

        if (ReCSalLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: ReCSalLegenda,
              ),
              Flexible(
                  child: Text(
                "Salário: R\$ $totSal",
                style: TextStyle(fontSize: 15.0),
              )),
            ],
          ));
        }

        if (RecOutLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: RecOutLegenda,
              ),
              Flexible(
                  child: Text(
                    "Outros: R\$ $totOut",
                    style: TextStyle(fontSize: 15.0),
                  )),
            ],
          ));
        }
        } else if (radioValue == 2) {
        if (DepElLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: DepElLegenda,
              ),
              Flexible(
                  child: Text(
                "Ener. Elérica: R\$ $totEl",
                style: TextStyle(fontSize: 15.0),
              )),
            ],
          ));
        }

        if (DepAgLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: DepAgLegenda,
              ),
              Flexible(
                  child: Text(
                "Água: R\$ $totAg",
                style: TextStyle(fontSize: 15.0),
              )),
            ],
          ));
        }

        if (DepVestLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: DepVestLegenda,
              ),
              Flexible(
                  child: Text(
                "Vestuário: R\$ $totVest",
                style: TextStyle(fontSize: 15.0),
              )),
            ],
          ));
        }

        if (DepCombLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: DepCombLegenda,
              ),
              Flexible(
                  child: Text(
                "Combustível: R\$ $totComb",
                style: TextStyle(fontSize: 15.0),
              )),
            ],
          ));
        }

        if (DepAlLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: DepAlLegenda,
              ),
              Flexible(
                  child: Text(
                "Alimentação: R\$ $totAlm",
                style: TextStyle(fontSize: 15.0),
              )),
            ],
          ));
        }

        if (DepIntLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: DepIntLegenda,
              ),
              Flexible(
                  child: Text(
                "Contas de Internet: R\$ $totInt",
                style: TextStyle(fontSize: 15.0),
              )),
            ],
          ));
        }

        if (DepOutLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: DepOutLegenda,
              ),
              Flexible(
                  child: Text(
                    "Outros: R\$ $totOut",
                    style: TextStyle(fontSize: 15.0),
                  )),
            ],
          ));
        }

        if (RecALuLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: RecALuLegenda,
              ),
              Flexible(
                  child: Text(
                "Aluguel: R\$ $totAlu",
                style: TextStyle(fontSize: 15.0),
              )),
            ],
          ));
        }
      } else {
        if (RecLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: RecLegenda,
              ),
              Flexible(
                  child: Text(
                "Receitas: R\$ $totRec",
                style: TextStyle(fontSize: 15.0),
              )),
            ],
          ));
        }
        if (DespLegenda != null) {
          lw.add(Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: DespLegenda,
              ),
              Flexible(
                  child: Text(
                "Despesas: R\$ $totdesp",
                style: TextStyle(fontSize: 15.0),
              )),
            ],
          ));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var msg, cor;
    if (radioValue == 0) {
      if (totRec == 0 && totdesp == 0) {
        msg = true;
        cor = Colors.grey;
      } else {
        data = [
          new Balance('Receitas', totRec, Colors.green),
          new Balance('Despesas', totdesp, Colors.red),
        ];
        msg = false;
        if (totRec - totdesp < 0)
          cor = Colors.red;
        else if (totRec - totdesp > 0)
          cor = Colors.green;
        else
          cor = Colors.grey;
      }
    } else if (radioValue == 1) {
      if (totalBalanco == "0") {
        msg = true;
        cor = Colors.grey;
      } else {
        msg = false;
        cor = Colors.green;
      }
    } else {
      if (totalBalanco == "0") {
        msg = true;
        cor = Colors.grey;
      } else {
        msg = false;
        cor = Colors.red;
      }
    }
    var series = [
      new charts.Series(
        domainFn: (Balance valueData, _) => valueData.tipo,
        measureFn: (Balance valueData, _) => valueData.valor,
        colorFn: (Balance valueData, _) => valueData.color,
        id: 'Valor',
        data: data,
        //labelAccessorFn: (Balance valueData, _) => valueData.tipo != '' ? 'R\$ ${valueData.valor}':'R\$ ${totRec - totdesp}'
      ),
    ];

    var chart = new charts.PieChart(
      series,
      animate: true,
    );

    return (Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildMonthBar(),
        Padding(
            padding: const EdgeInsets.only(bottom: 8.0), child: _buildRadio()),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0, top: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: msg == false
                  ? <Widget>[
                      Expanded(child: chart),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 1.0),
                            child: Column(children: lw),
                          ),
                        ],
                      ))
                    ]
                  : <Widget>[
                      Center(
                          child: Text(
                        'Nenhum Registro Encontrado',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.normal,
                        ),
                      ))
                    ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 19.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              //alignment: WrapAlignment.center,
              children: <Widget>[
                Text("$balanco",
                    style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.black87,
                        fontStyle: FontStyle.normal)),
                Text(
                  'R\$ $totalBalanco',
                  style: TextStyle(fontSize: 22.0, color: cor),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
/*
  void _buscarFiltradas(BuildContext context) async {
    FiltroBalanco filter = new FiltroBalanco();

    String result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => filter));

    */ /*if (formatarSQL(filter.inicio) == '' || formatarSQL(filter.fim)== '') {
      filter.inicio = '01/01/1900';
      filter.fim = '31/12/2050';
    }*/ /*
    if (filter.radioValue1 == 1) {
      if (result == 'buscarData') {
        db
            .pegarReceitasFiltrada(
                formatarSQL(filter.inicio), formatarSQL(filter.fim))
            .then((receitas) {
          setState(() {
            items.clear();
            totRec = 0.0;
            totdesp = 0.0;
            receitas.forEach((receita) {
              items.add(Receitas.fromMap(receita));
            });
            items.forEach((r) {
              totRec = totRec + double.parse(r.valor);
            });
            yLegenda = '';
            yCorLegenda = null;
            balanco = 'De ${filter.inicio} até ${filter.fim}';
          });
        });
      } else if (result == 'buscarOrigem') {
        db.pegarReceitasFiltradaOrigem(filter.origem).then((receitas) {
          setState(() {
            totRec = 0.0;
            items.clear();
            receitas.forEach((receita) {
              items.add(Receitas.fromMap(receita));
            });
            items.forEach((r) {
              totRec = totRec + double.parse(r.valor);
            });
            xLegenda = filter.origem;
          });
        });
        db.pegarReceitasOrigemExceto(filter.origem).then((receitas) {
          setState(() {
            totdesp = 0.0;
            itemsOtherRec.clear();
            receitas.forEach((receita) {
              itemsOtherRec.add(Receitas.fromMap(receita));
            });
            itemsOtherRec.forEach((r) {
              totdesp = totdesp + double.parse(r.valor);
            });
            yLegenda = 'Outras Receitas';
            yCorLegenda = Colors.blue[800];
            balanco = 'por ${filter.origem}';
          });
        });
      } else if (result == 'buscarOrigemData') {
        db
            .pegarReceitasFiltradaOrigemData(filter.origem,
                formatarSQL(filter.inicio), formatarSQL(filter.fim))
            .then((receitas) {
          setState(() {
            totRec = 0.0;
            totdesp = 0.0;
            items.clear();
            receitas.forEach((receita) {
              items.add(Receitas.fromMap(receita));
            });
            items.forEach((r) {
              totRec = totRec + double.parse(r.valor);
            });
            yCorLegenda = null;
            yLegenda = '';
            balanco = 'de ${filter.inicio} até ${filter.fim}';
            xLegenda = '${filter.origem}';
          });
        });
      }
    } else if (filter.radioValue1 == 2) {
      if (result == 'buscarData') {
        db
            .pegarDepesasFiltrada(
                formatarSQL(filter.inicio), formatarSQL(filter.fim))
            .then((despesas) {
          setState(() {
            totdesp = 0.0;
            totRec = 0.0;
            items2.clear();
            despesas.forEach((despesa) {
              items2.add(Despesas.fromMap(despesa));
            });
            items2.forEach((d) {
              totdesp = totdesp + double.parse(d.valor);
            });
            xLegenda = '';
            xCorLegenda = null;
            balanco = 'De ${filter.inicio} até ${filter.fim}';
          });
        });
      } else if (result == 'buscarOrigem') {
        db.pegarDespesasFiltradaOrigem(filter.origem).then((despesas) {
          setState(() {
            items2.clear();
            despesas.forEach((despesa) {
              items2.add(Despesas.fromMap(despesa));
            });
            /
          });
        });
      } else {
        db
            .pegarDespesasFiltradaOrigemData(filter.origem,
                formatarSQL(filter.inicio), formatarSQL(filter.fim))
            .then((despesas) {
          setState(() {
            items2.clear();
            despesas.forEach((despesa) {
              items2.add(Despesas.fromMap(despesa));
            });
            //TODO
          });
        });
      }
    } else {
      //TODO
    }
  }*/

  String formatarSQL(String data) {
    String formatdata;
    try {
      List<String> format = data.split("/");

      formatdata = '${format[2]}-${format[1]}-1';
    } catch (e) {
      formatdata = '';
    }

    return formatdata;
  }
}
