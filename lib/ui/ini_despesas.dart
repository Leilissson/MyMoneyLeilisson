import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymoneyleilisson/Modelos/despesas.dart';
import 'package:mymoneyleilisson/ui/cadastra_despesa.dart';
import 'package:mymoneyleilisson/ui/filtro.dart';
import 'package:mymoneyleilisson/ultil/banco_dados.dart';
import 'package:mymoneyleilisson/ultil/FancyButton.dart';
import 'package:mymoneyleilisson/ultil/custom_item_list.dart';

class IniDespesas extends StatefulWidget {
  @override
  _IniDespesasState createState() => _IniDespesasState();
}

class _IniDespesasState extends State<IniDespesas> {
  DatabaseHelper db = new DatabaseHelper();
  List<Despesas> items = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _atualizaLista();
  }

  void _atualizaLista() {
    db.pegarDespesas().then((despesas) {
      if (this.mounted) {
        setState(() {
          despesas.forEach((despesa) {
            items.add(Despesas.map(despesa));
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 5.0, 16.0, 0.0),
                    child: FloatingActionButton(
                      onPressed: () => _buscarDespesasFiltradas(context),
                      child: Icon(
                        Icons.filter_list,
                        color: Colors.yellowAccent,
                      ),
                      backgroundColor: Colors.grey[800],
                      mini: true,
                      elevation: 1.0,
                      tooltip: "Filtrar",
                    )),
              ],
            ),
            Expanded(
              child: items.length != 0
                  ? ListView.builder(
                      itemCount: items.length,
                      padding: const EdgeInsets.all(3.0),
                      itemBuilder: (context, position) {
                        return Column(
                          children: <Widget>[
                            CustomItemList(
                              onPressedRemove: () => _deleteDespesa(
                                  context, items[position], position),
                              onPressedEdit: () =>
                                  _atualizarDespesas(context, items[position]),
                              color: 0xFFF44336,
                              posicao: "${position + 1}",
                              titulo: "${items[position].origem}",
                              subtitulo: "${items[position].valor}",
                              subsubtitulo: "${items[position].date}",
                              extras: "${items[position].comentario}",
                              pagamento: "${items[position].pagamento}",
                            )
                          ],
                        );
                      })
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Nenhum Registro Encontrado",
                          style: TextStyle(
                              fontSize: 18.0, fontStyle: FontStyle.normal),
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FancyButton(
        onPressed: () => _criarNovaDespesa(context),
        icone: Icons.add,
        texto: "ADICIONAR",
      ),
    );
  }

  void _deleteDespesa(
      BuildContext context, Despesas despesa, int position) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Remover Item'),
            content: new Text('Deseja mesmo remover este item? '),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    db.deleteDespesa(despesa.id).then((despesas) {
                      setState(() {
                        items.removeAt(position);
                      });
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Sim')),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Não'))
            ],
          );
        });
  }

  void _atualizarDespesas(BuildContext context, Despesas despesa) async {
    String result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CDespesas(despesa)));

    if (result == 'update') {
      db.pegarDespesas().then((despesas) {
        setState(() {
          items.clear();
          despesas.forEach((despesa) {
            items.add(Despesas.fromMap(despesa));
          });
        });
      });
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(
          "Item Atualizado!",
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  void _criarNovaDespesa(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CDespesas(Despesas('', '', '', '', ''))),
    );

    if (result == 'save') {
      db.pegarDespesas().then((despesas) {
        setState(() {
          items.clear();
          despesas.forEach((despesa) {
            items.add(Despesas.fromMap(despesa));
          });
        });
      });
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(
          "Item Salvo!",
          textAlign: TextAlign.center,
        ),
      ));
    }
  }

  String formatarSQL(String data) {
    String formatdata;
    try {
      List<String> format = data.split("/");

      formatdata = '${format[2]}-${format[1]}-${format[0]}';
    } catch (e) {
      formatdata = '';
    }

    return formatdata;
  }

  void _buscarDespesasFiltradas(BuildContext context) async {
    Filtro filter = new Filtro('Despesas');

    String result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => filter));

    /*if (formatarSQL(filter.inicio) == '' || formatarSQL(filter.fim)== '') {
      filter.inicio = '01/01/1900';
      filter.fim = '31/12/2050';
    }*/

    if (result == 'buscarData') {
      db
          .pegarDespesasFiltrada(
              formatarSQL(filter.inicio), formatarSQL(filter.fim))
          .then((despesas) {
        setState(() {
          items.clear();
          despesas.forEach((despesa) {
            items.add(Despesas.fromMap(despesa));
          });
        });
      });
    } else if (result == 'buscarOrigem') {
      db.pegarDespesasFiltradaOrigem(filter.origem).then((despesas) {
        setState(() {
          items.clear();
          despesas.forEach((despesa) {
            items.add(Despesas.fromMap(despesa));
          });
        });
      });
    } else {
      db
          .pegarDespesasFiltradaOrigemData(filter.origem,
              formatarSQL(filter.inicio), formatarSQL(filter.fim))
          .then((despesas) {
        setState(() {
          items.clear();
          despesas.forEach((despesa) {
            items.add(Despesas.fromMap(despesa));
          });
        });
      });
    }
  }
}
