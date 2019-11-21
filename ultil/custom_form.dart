import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mymoneyleilisson/Modelos/despesas.dart';
import 'package:mymoneyleilisson/Modelos/receitas.dart';
import 'package:mymoneyleilisson/ultil/banco_dados.dart';
import 'package:mymoneyleilisson/ultil/FancyButton.dart';



class CustomForm extends StatefulWidget {
  TextEditingController origemController;
  List<String> lista;
  TextEditingController valorController, dataController, comentController,pagController;
  int id;
  var tipo;
  var instancia;

  CustomForm(
      {this.origemController,
      this.lista,
      this.valorController,
      this.dataController,
      this.comentController,
      this.id,
      this.tipo,
      this.instancia,this.pagController});

  @override
  _CustomFormState createState() =>
      _CustomFormState(/*valorController,dataController,opatual*/);
}

class _CustomFormState extends State<CustomForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DatabaseHelper db = new DatabaseHelper();



  List<String> listaPagamento = <String>['',
  "Cartão de Crédito",
  "Transf. Bancária",
  "Boleto",
  "Dinheiro"];


  //_CustomFormState(this.vCont, this.dCont, this.origem);

  Future _chooseDate(BuildContext context, String initialDateString) async {
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
      widget.dataController.text = f.format(result);
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

  bool validateValue(String value) {
    String p = r'^\s*(?:[1-9]\d{0,2}(?:\d{3})*|0)(?:.\d{1,2})?$';

    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(value);
  }
  bool _validateInputs() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      return false;
    } else
      return true;
  }


  String formatarSQL(String data){

    String formatdata;
    List <String > format = data.split("/");

    formatdata = '${format[2]}-${format[1]}-${format[0]}';

    return formatdata;
  }


  var erroDropDown = null;

  var clickErroDropDown = false;

  String textDropDown = "Escolha uma origem";

  @override
  Widget build(BuildContext context) {
    var titulo;
    if (widget.tipo == Receitas) {
      widget.instancia.origem == '' &&
              widget.instancia.valor == '' &&
              widget.instancia.comentario == ''&&
              widget.instancia.pagamento == ''
          ? titulo = Text("Cadastrar Receita")
          : titulo = Text("Atualizar Receita");
    } else
      widget.instancia.origem == '' &&
              widget.instancia.valor == '' &&
              widget.instancia.comentario == '' &&
              widget.instancia.pagamento == ''
          ? titulo = Text("Cadastrar Despesa")
          : titulo = Text("Atualizar Despesa");

    return Scaffold(
      appBar: AppBar(title: titulo,),
      body: SafeArea(
        bottom: false,
        top: false,
        child: new Form(
          key: _formKey,
          child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                new FormField(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.description,
                          color: Colors.lightBlue,
                        ),
                        labelText: "Origem",
                        hintText: "Escolha a Origem",
                        errorText: clickErroDropDown == true ?( (widget.origemController.text == '' ? erroDropDown = "Escolha uma origem": erroDropDown=textDropDown)):null,//state.hasError ? state.errorText : null,
                      ),
                      isEmpty: widget.origemController.text == '',
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton(
                          value: widget.origemController.text,
                          isDense: true,
                          items: widget.lista.map((String value) {
                            return new DropdownMenuItem(
                              child: new Text(value),
                              value: value,
                            );
                          }).toList(),
                          onChanged: (String newValue) {
                            setState(() {

                              widget.origemController.text = newValue;
                              //state.didChange(newValue);
                            });
                          },
                        ),
                      ),
                    );
                  },

                ),
                new TextFormField(
                  validator: (val) => validateValue(val) ? null : 'Entre com um valor válido',
                  controller: widget.valorController,
                  decoration: new InputDecoration(
                    hintText: "Entre com o Valor",
                    icon: Icon(
                      Icons.monetization_on,
                      color: Colors.yellow,
                    ),
                    labelText: "Valor",
                    prefixText: "R\$ "
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                InkWell(
                    child: Stack(children: <Widget>[
                      new TextFormField(
                        //validator: (val) => validateData(val) ? null : 'Entre com uma data válida',//(val) => val.isEmpty ? 'Selecione uma Data' : null,
                        controller: widget.dataController,
                        enabled: false,

                        decoration: new InputDecoration(
                            hintText: "dd/mm/aaaa",
                            icon: Icon(
                              Icons.date_range,
                              color: Colors.lightGreen,

                            ),
                            labelText: "Data",


                            ),
                        keyboardType: TextInputType.datetime,
                        maxLength: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0, right: 5.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[Icon(Icons.more_horiz,color: Colors.grey[700],)],
                        ),
                      )
                    ]),
                    onTap: () {
                      setState(() {
                        _chooseDate(context, widget.dataController.text);
                      });
                    }),

                new FormField(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          icon: const Icon(
                            Icons.credit_card,
                            color: Colors.deepOrange,
                          ),
                          labelText: "Forma de Pagamento (opicional)",
                          hintText: "Escolha a Forma de Pagamento",
                          labelStyle: TextStyle(fontSize: 15.0)
                        //errorText: clickErroDropDown == true ?( (widget.origemController.text == '' ? erroDropDown = "Escolha uma origem": erroDropDown=textDropDown)):null,//state.hasError ? state.errorText : null,
                      ),
                      isEmpty: widget.pagController.text =='',
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton(
                          value: widget.pagController.text,
                          isDense: true,
                          items: listaPagamento.map((String value) {
                            return new DropdownMenuItem(
                              child: new Text(value),
                              value: value,
                            );
                          }).toList(),
                          onChanged: (String newValue) {
                            setState(() {

                              widget.pagController.text = newValue;
                              //state.didChange(newValue);
                            });
                          },
                        ),
                      ),
                    );
                  },

                ),

                new TextFormField(
                  //validator: validateComent,
                  controller: widget.comentController,
                  decoration: InputDecoration(
                    hintText: "Escreva um Comentário",
                    labelText: "Comentário (opcional)",
                    icon: Icon(
                      Icons.comment,
                      color: Colors.deepPurple,
                    ),
                    labelStyle: TextStyle(fontSize: 15.0)
                  ),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                  maxLength: 100,
                ),

              ]),
        ),
      ),
      floatingActionButton: FancyButton(
        onPressed: () {


          setState(() {
            clickErroDropDown = true;
          });

          if (widget.origemController.text != '')
            textDropDown = null;


          if (_validateInputs() == true && widget.origemController.text != '' ) {

            if (widget.tipo == Receitas) {
              if (widget.id != null) {
                db
                    .updateReceita(Receitas.fromMap({
                  'id': widget.id,
                  'Origem': widget.origemController.text,
                  'Valor': widget.valorController.text.replaceAll('R\$', ''),
                  'Data': formatarSQL(widget.dataController.text),
                  'Comentario': widget.comentController.text,
                  'Pagamento': widget.pagController.text,
                }))
                    .then((_) {
                  Navigator.pop(context, 'update');
                });
              } else {
                db
                    .salvarReceita(Receitas(
                        widget.origemController.text,
                        widget.valorController.text.replaceAll('R\$', ''),
                        formatarSQL(widget.dataController.text),
                        widget.comentController.text,
                        widget.pagController.text  ))
                    .then((_) {
                  Navigator.pop(context, 'save');
                });
              }
            } else {
              if (widget.id != null) {
                db
                    .updateDespesa(Despesas.fromMap({
                  'id': widget.id,
                  'Origem': widget.origemController.text,
                  'Valor': widget.valorController.text.replaceAll('R\$', ''),
                  'Data': formatarSQL(widget.dataController.text),
                  'Comentario': widget.comentController.text,
                  'Pagamento': widget.pagController.text,
                }))
                    .then((_) {
                  Navigator.pop(context, 'update');
                });
              } else {
                db
                    .salvarDespesa(Despesas(
                        widget.origemController.text,
                        widget.valorController.text.replaceAll('R\$', ''),
                        formatarSQL(widget.dataController.text),
                        widget.comentController.text,
                        widget.pagController.text,))
                    .then((_) {
                  Navigator.pop(context, 'save');
                });
              }
            }
          } else
           // clickErroDropDown = false;
            null;
        },
        texto: "SALVAR",
        icone: Icons.save,
      ),
    );
  }
}
