import 'package:flutter/material.dart';
import 'package:mymoneyleilisson/Modelos/receitas.dart';
import 'package:mymoneyleilisson/ui/cadastra_receita.dart';
import 'package:mymoneyleilisson/ui/filtro.dart';
import 'package:mymoneyleilisson/ultil/banco_dados.dart';
import 'package:mymoneyleilisson/ultil/FancyButton.dart';
import 'package:mymoneyleilisson/ultil/custom_item_list.dart';
import 'package:flutter/cupertino.dart';


class IniReceitas extends StatefulWidget {
  @override
  _IniReceitasState createState() => _IniReceitasState();

  final AppBar barra;

  IniReceitas({this.barra});
}

class _IniReceitasState extends State<IniReceitas> {
  DatabaseHelper db = new DatabaseHelper();
  List<Receitas> items = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _atualizaLista();
  }

  void _atualizaLista() {
    db.pegarReceitas().then((receitas) {
      setState(() {
        receitas.forEach((receita) {
          items.add(Receitas.map(receita));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0,5.0,16.0,0.0),
                    child: FloatingActionButton(
                      onPressed: () => _buscarReceitasFiltradas(context),
                      child: Icon(Icons.filter_list,color: Colors.yellowAccent,),
                      backgroundColor: Colors.grey[800],
                    mini: true,elevation: 1.0,
                    tooltip: "Filtrar",)
                  ),
                ],
              ),
            ),
            Expanded(
              child: items.length != 0
                  ? ListView.builder(
                      itemCount: items.length,
                      padding: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 3.0),
                      itemBuilder: (context, position) {
                        return Column(
                          children: <Widget>[
                            CustomItemList(
                              onPressedRemove: () => _deleteReceita(
                                  context, items[position], position),
                              onPressedEdit: () {
                                if (Scaffold.of(context).hasDrawer) {}

                                _atualizarReceitas(context, items[position]);
                              },
                              titulo: "${items[position].origem}",
                              subtitulo: "${items[position].valor}",
                              posicao: "${position + 1}",
                              color: 0xFF4CAF50,
                              extras: "${items[position].comentario}",
                              subsubtitulo: "${items[position].date}",
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
                            fontSize: 18.0,
                            fontStyle: FontStyle.normal,
                          ),
                        )
                      ],
                    ),
            )
          ])),

      floatingActionButton: FancyButton(
        onPressed: () => _criarNovaReceita(context),
        icone: Icons.add,
        texto: "ADICIONAR",
      ),
    );
  }

  void _deleteReceita(BuildContext context, Receitas receita, int position) async {

    showDialog (
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return  AlertDialog (
          title: new Text("Remover Item"),
          content: new Text("Deseja mesmo remover este item?"),

          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                child: new Text("Sim"),
                onPressed: () {
                  db.deleteReceita(receita.id).then((receitas) {
                    setState(() {
                      items.removeAt(position);
                    });
                  });
                  Navigator.of(context).pop();
                }


            ),
            new FlatButton(
              child: new Text("Não"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],

        );
      },
    );



  }

  void _atualizarReceitas(BuildContext context, Receitas receita) async {
    String result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CReceitas(receita)));

    if (result == 'update') {
      db.pegarReceitas().then((receitas) {
        setState(() {
          items.clear();
          receitas.forEach((receita) {
            items.add(Receitas.fromMap(receita));
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

  void _criarNovaReceita(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CReceitas(Receitas('', '', '', '', ''))),
    );

    if (result == 'save') {
      db.pegarReceitas().then((receitas) {
        setState(() {
          items.clear();
          receitas.forEach((receita) {
            items.add(Receitas.fromMap(receita));
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

  void _buscarReceitasFiltradas(BuildContext context) async {
    Filtro filter = new Filtro('Receitas');

    String result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => filter));

    /*if (formatarSQL(filter.inicio) == '' || formatarSQL(filter.fim)== '') {
      filter.inicio = '01/01/1900';
      filter.fim = '31/12/2050';
    }*/

    if (result == 'buscarData') {
      db
          .pegarReceitasFiltrada(
              formatarSQL(filter.inicio), formatarSQL(filter.fim))
          .then((receitas) {
        setState(() {
          items.clear();
          receitas.forEach((receita) {
            items.add(Receitas.fromMap(receita));
          });
        });
      });
    } else if (result == 'buscarOrigem') {
      db.pegarReceitasFiltradaOrigem(filter.origem).then((receitas) {
        setState(() {
          items.clear();
          receitas.forEach((receita) {
            items.add(Receitas.fromMap(receita));
          });
        });
      });
    } else if (result == 'buscaOrigemData'){
      db.pegarReceitasFiltradaOrigemData(filter.origem,
          formatarSQL(filter.inicio), formatarSQL(filter.fim)) .then((receitas) {
        setState(() {
          items.clear();
          receitas.forEach((receita) {
            items.add(Receitas.fromMap(receita));
          });
        });
      });
    }
  }
}
