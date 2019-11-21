import 'package:flutter/material.dart';

import 'package:mymoneyleilisson/Modelos/despesas.dart';
import 'package:mymoneyleilisson/ultil/banco_dados.dart';

import 'package:intl/intl.dart';

import 'package:mymoneyleilisson/ultil/custom_form.dart';

class CDespesas extends StatefulWidget {
  final Despesas despesa;
  CDespesas(this.despesa);

  @override
  _CDespesasState createState() => _CDespesasState();
}

class _CDespesasState extends State<CDespesas> {
  DatabaseHelper db = new DatabaseHelper();

  TextEditingController _origemController;
  TextEditingController _valorController;
  TextEditingController _dataController;
  TextEditingController _comentController;
  TextEditingController _pagController;
  List<String> _l_despesas = <String>[
    '',
    'Aluguel',
    'Alimentação',
    'Vestuário',
    'Combustível',
    'Contas de Internet',
    'Água',
    'Energia Elétrica',
    'Outros'
  ];

  String formatarNoSQL(String data) {
    final f = new DateFormat('dd/MM/yyyy');
    String formatdata;
    try {


      List <String> format = data.split("-");

      formatdata = '${format[2]}/${format[1]}/${format[0]}';


    }catch(e) {
      formatdata = f.format(DateTime.now());
    }

    return formatdata;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _comentController =
        new TextEditingController(text: widget.despesa.comentario);
    _origemController = new TextEditingController(text: widget.despesa.origem);
    _valorController = new TextEditingController(text: widget.despesa.valor);
    _dataController = new TextEditingController(text: formatarNoSQL(widget.despesa.date));
    _pagController  = new TextEditingController(text: widget.despesa.pagamento);
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child: CustomForm(
        lista: _l_despesas,
        valorController: _valorController,
        dataController: _dataController,
        origemController: _origemController,
        comentController: _comentController,
        instancia: widget.despesa,
        tipo: Despesas,
        id: widget.despesa.id,
        pagController: _pagController,


      ),
    );
  }
}
