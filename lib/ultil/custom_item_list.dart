import 'package:flutter/material.dart';

class CustomItemList extends StatelessWidget {
  final int color;
  final String posicao;
  final String titulo;
  final String subtitulo;
  String subsubtitulo;
  final String extras;
  final GestureTapCallback onPressedEdit;
  final GestureTapCallback onPressedRemove;
  final String pagamento;

  String formatarNoSQL(String data){

    String formatdata;
    List <String > format = data.split("-");

    formatdata = '${format[2]}/${format[1]}/${format[0]}';

    return formatdata;
  }





  @override
  Widget build(BuildContext context) {



    return Container(
        child: Stack(
      children: <Widget>[
        ExpansionTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Text(titulo),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  'Valor: R\$ $subtitulo',
                  style: TextStyle(fontSize: 14.5),
                ),
              ),
              Text(
                'Data: ${formatarNoSQL(subsubtitulo)}',
                style: TextStyle(fontSize: 14.5),
              )
            ],
          ),
          leading: CircleAvatar(
            child: Text(
              posicao,
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(color),
            radius: 15.0,
          ),
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 73.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: pagamento.isNotEmpty
                            ? Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Text("Forma de Pagamento: $pagamento",
                                  style: TextStyle(
                                      fontSize: 13.5, )),
                            )
                            : Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                  'Forma de Pagamento Não Especificada',
                                  style: TextStyle(
                                      fontSize: 13.5, ),
                                ),
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 73.0, top: 5.0, bottom: 8.0, ),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: extras.isNotEmpty
                            ? Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                  "$extras",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 13.5,
                                      color: Colors.grey[600]),
                                  textAlign: TextAlign.justify,
                                ),
                            )
                            : Text(''),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 9.0, 4.5, 8.0),
                child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onPressedEdit,
                  color: Colors.yellow[700],
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 9.0, 4.5, 8.0),
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onPressedRemove,


                  color: Colors.red[600],
                )),
          ],
        ),
      ],
    ));
  }

  CustomItemList(
      {this.color,
      this.posicao,
      this.titulo,
      this.subtitulo,
      @required this.onPressedEdit,
      @required this.onPressedRemove,
      this.extras,
      this.subsubtitulo,
      this.pagamento});
}
