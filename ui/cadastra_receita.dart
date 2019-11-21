import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymoneyleilisson/Modelos/receitas.dart';
import 'package:mymoneyleilisson/ultil/custom_form.dart';



class CReceitas extends StatefulWidget {
  final Receitas receita;
  CReceitas(this.receita);
  @override
  _CReceitasState createState() => _CReceitasState();
}

class _CReceitasState extends State<CReceitas> {


  TextEditingController _origemController;
  TextEditingController _valorController;
  TextEditingController _dataController;
  TextEditingController _comentController;
  TextEditingController _pagController;

  List<String> _l_receitas = <String>['',
  'Salário',
  'Aluguel',
  'Venda de Bens',
  'Rendimentos',
  'Mesada',
  'Outros',
  ];

  String formatarNoSQL(String data) {
    final f = new DateFormat('dd/MM/yyyy');
    String formatdata;
    try {


      List <String> format = data.split("-");

      formatdata = '${format[2]}/${format[1]}/${format[0]}';


    }catch(e) {
      formatdata =  f.format(DateTime.now());
    }

    return formatdata;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _origemController  = new TextEditingController( text:  widget.receita.origem);
    _valorController = new TextEditingController(text: widget.receita.valor);
    _dataController = new TextEditingController(text: formatarNoSQL(widget.receita.date));
    _comentController = new TextEditingController(text: widget.receita.comentario);
    _pagController = new TextEditingController(text: widget.receita.pagamento);

  }


  @override
  Widget build(BuildContext context) {

    return Container(

      //appBar: (widget.receita.origem == '' && widget.receita.valor =='' && widget.receita.date=='') ?
      // AppBar(title: Text("Finanças"),actions: <Widget>[FlatButton(onPressed: () =>
      // Navigator.pop(context), child: null)],) : null,
      child: new CustomForm  (
        dataController: _dataController,
        valorController: _valorController,
        origemController: _origemController,
        lista: _l_receitas,
        comentController:_comentController ,
        id: widget.receita.id,
        tipo: Receitas ,
        instancia: widget.receita,
        pagController:_pagController ,

      ),
    );
  }
}
