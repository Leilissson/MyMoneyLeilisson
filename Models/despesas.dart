

class Despesas{

  String _origem;
  String _valor;
  String _date;
  String _comentario;
  int _id;
  String _pagamento;

  Despesas(String origem,String valor,String date,String comentario,String pagamento){
    this._origem = origem;
    this._valor  = valor.replaceAll(',', '.');
    this._date = date;
    this._comentario = comentario;
    this._pagamento = pagamento;
  }

  Despesas.map(dynamic obj) {
    this._origem = obj['Origem'];
    this._valor = obj['Valor'].toString();
    this._date = obj['Data'];
    this._id = obj['id'];
    this._comentario = obj['Comentario'];
    this._pagamento = obj['Pagamento'];
  }

  Despesas.fromMap(Map<String, dynamic> mapa) {
    this._origem = mapa['Origem'];
    this._valor = mapa['Valor'].toString().replaceAll(',', '.');
    this._date = mapa['Data'];
    this._id = mapa['id'];
    this._comentario = mapa['Comentario'];
    this._pagamento = mapa['Pagamento'];
  }

  Map<String, dynamic> toMap() {
    /*
        {
           "id" : 1,
           "nome": "Joao",
           "senha: "joao12345"
         }
     */
    var mapa = new Map<String, dynamic>();
    mapa["Origem"] = _origem;
    mapa["Valor"] = _valor;
    mapa["Data"] = _date;
    mapa["Comentario"] = _comentario;
    mapa["Pagamento"] = _pagamento;

    if (_id != null) {
      mapa["id"] = _id;
    }

    return mapa;
  }


  String get pagamento => _pagamento;

  set pagamento(String value) {
    _pagamento = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get comentario => _comentario;

  set comentario(String value) {
    _comentario = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get valor => _valor;

  set valor(String value) {
    _valor = value;
  }

  String get origem => _origem;

  set origem(String value) {
    _origem = value;
  }

}
