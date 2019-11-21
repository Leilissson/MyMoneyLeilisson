import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymoneyleilisson/ultil/FancyButton.dart';

class Filtro extends StatefulWidget {
  String inicio, fim, tipo, origem;

  Filtro(this.tipo);

  @override
  _FiltroState createState() => _FiltroState();
}

class _FiltroState extends State<Filtro> {
  TextEditingController _dataInicioController;
  TextEditingController _dataFimController;
  TextEditingController _origemController;
  bool checkBoxValue = false;
  bool checkBoxValueOrigem = false;

  List<String> _l_receitas = <String>[
    '',
    'Salário',
    'Aluguel',
    'Venda de Bens',
    'Rendimentos',
    'Mesada',
    'Outros'
  ];

  List<String> _l_despesas = <String>[
    '',
    'Aluguel',
    'Alimentação',
    'Vesturário',
    'Combustível',
    'Contas de Internet',
    'Água',
    'Energia Elétrica',
    'Outros'
  ];

  List<String> lvazia = [''];

  Future _chooseDate(BuildContext context, String initialDateString,
      TextEditingController newDate) async {
    final f = new DateFormat('dd/MM/yyyy');
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: new DateTime(2000),
      lastDate: new DateTime(2050),
    );

    if (result == null) return;

    setState(() {
      newDate.text = f.format(result);
    });
  }

  DateTime convertToDate(String input) {
    try {
      final f = new DateFormat('dd/MM/yyyy');
      var d = f.parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  void _onChange(bool check) {
    if (check) {
      setState(() {
        final f = new DateFormat('dd/MM/yyyy');
        checkBoxValue = check;
        _dataInicioController.text = f.format(DateTime.now());
        _dataFimController.text = f.format(DateTime.now());
      });
    } else {
      setState(() {
        _dataInicioController.text = '';
        _dataFimController.text = '';
        checkBoxValue = check;
      });
    }
  }

  void _onChangeOrigem(bool check) {
    if (check) {
      setState(() {
        checkBoxValueOrigem = check;
      });
    } else {
      setState(() {
        checkBoxValueOrigem = check;
        _origemController.text = '';
      });
    }
  }

  @override
  void initState() {
    final f = new DateFormat('dd/MM/yyyy');
    // TODO: implement initState
    super.initState();
    if (checkBoxValue) {
      _dataInicioController =
          new TextEditingController(text: '${f.format(DateTime.now())}');
      _dataFimController =
          new TextEditingController(text: '${f.format(DateTime.now())}');
    } else {
      _dataInicioController = new TextEditingController(text: '');
      _dataFimController = new TextEditingController(text: '');
    }

    _origemController = new TextEditingController(text: '');

    widget.inicio = _dataInicioController.text;
    widget.fim = _dataFimController.text;
  }

  Widget _buildDropDown(bool enable) {
    if (enable) {
      return new DropdownButtonHideUnderline(
        child: new DropdownButton(
          value: _origemController.text,
          isDense: true,
          items: widget.tipo == 'Receitas'
              ? (_l_receitas.map((String value) {
                  return new DropdownMenuItem(
                    child: new Text(value),
                    value: value,
                  );
                }).toList())
              : (_l_despesas.map((String value) {
                  return new DropdownMenuItem(
                    child: new Text(value),
                    value: value,
                  );
                }).toList()),
          onChanged: (String newValue) {
            if (checkBoxValueOrigem) {
              setState(() {
                _origemController.text = newValue;
                //state.didChange(newValue);
              });
            }
          },
        ),
      );
    } else
      return null;
  }

  Widget _buildRadio() {
    return new Row(
      //direction: Axis.horizontal,crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        new Radio(
          value: 0,
          groupValue: 1,
          onChanged: null, //_handleRadioValueChange1,
        ),
        new Text(
          'Todos',
          style: new TextStyle(fontSize: 16.0),
        ),
        new Radio(
          value: 1,
          groupValue: 1,
          onChanged: null, //_handleRadioValueChange1,
        ),
        new Text(
          'Receitas',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        ),
        new Radio(
          value: 2,
          groupValue: 1,
          onChanged: null, //_handleRadioValueChange1,
        ),
        new Text(
          'Despesas',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Filtrar ${widget.tipo}'),
        ),
        body: SafeArea(
            child: new Form(
                child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            //widget.tipo == 'Filtrar' ? _buildRadio() : Text(''),

            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: <Widget>[
                  Checkbox(
                      value: checkBoxValueOrigem, onChanged: _onChangeOrigem),
                  Text("Por Origem:")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 15.0),
              child: new FormField(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      icon: const Icon(
                        Icons.description,
                        color: Colors.lightBlue,
                      ),
                      labelText: "Origem",
                      hintText: "Escolha a Origem",
                      //labelStyle: TextStyle(fontSize: 22.0,color: Colors.grey),
                      //enabled: checkBoxValueOrigem == true ? true : false
                      //errorText: clickErroDropDown == true ?( (widget.origemController.text == '' ? erroDropDown = "Escolha uma origem": erroDropDown=textDropDown)):null,//state.hasError ? state.errorText : null,
                    ),
                    isEmpty: _origemController.text == '',
                    child: checkBoxValueOrigem ? _buildDropDown(true) : null,
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: checkBoxValue,
                    onChanged: _onChange,
                  ),
                  Text("Por Data:"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                      child: Stack(children: <Widget>[
                        new TextFormField(
                          //validator: (val) => validateData(val) ? null : 'Entre com uma data válida',//(val) => val.isEmpty ? 'Selecione uma Data' : null,
                          controller: _dataInicioController,
                          enabled: false,

                          decoration: new InputDecoration(
                            hintText: "dd/mm/aaaa",
                            icon: Icon(
                              Icons.date_range,
                              color: Colors.lightGreen,
                            ),
                            labelText: "Data Inicial",
                          ),
                          keyboardType: TextInputType.datetime,
                          maxLength: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0, right: 5.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                Icons.more_horiz,
                                color: Colors.grey[700],
                              )
                            ],
                          ),
                        )
                      ]),
                      onTap: () {
                        if (checkBoxValue) {
                          setState(() {
                            _chooseDate(context, _dataInicioController.text,
                                _dataInicioController);
                          });
                        }
                      }),
                  InkWell(
                      child: Stack(children: <Widget>[
                        new TextFormField(
                          //validator: (val) => validateData(val) ? null : 'Entre com uma data válida',//(val) => val.isEmpty ? 'Selecione uma Data' : null,
                          controller: _dataFimController,
                          enabled: false,

                          decoration: new InputDecoration(
                            hintText: "dd/mm/aaaa",
                            icon: Icon(
                              Icons.date_range,
                              color: Colors.lightGreen,
                            ),
                            labelText: "Data Final",
                          ),
                          keyboardType: TextInputType.datetime,
                          maxLength: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0, right: 5.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                Icons.more_horiz,
                                color: Colors.grey[700],
                              )
                            ],
                          ),
                        )
                      ]),
                      onTap: () {
                        if (checkBoxValue) {
                          setState(() {
                            _chooseDate(context, _dataFimController.text,
                                _dataFimController);
                          });
                        }
                      }),
                ],
              ),
            ),
          ],
        ))),
        floatingActionButton: Builder(builder: (BuildContext context) {
          return FancyButton(
            onPressed: () {
              widget.fim = _dataFimController.text;
              widget.inicio = _dataInicioController.text;
              if (checkBoxValueOrigem == true && _origemController.text != '') {

                widget.origem = _origemController.text;

                if (checkBoxValue == true)
                  Navigator.pop(context, 'buscarOrigemData');
                else
                  Navigator.pop(context, 'buscarOrigem');
              } else if (checkBoxValueOrigem != true && checkBoxValue == true ) {
                 Navigator.pop(context, 'buscarData');
              } else {
                Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text(
                  'Selecione um filtro válido',
                  textAlign: TextAlign.center,
                )));
              }
            },
            icone: Icons.search,
            texto: 'BUSCAR',
          );
        }),
      ),
    );
  }
}
