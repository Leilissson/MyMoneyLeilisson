import 'package:flutter/material.dart';

class FancyButton extends StatelessWidget {

  final GestureTapCallback onPressed;
  final IconData icone;
  final String texto;
  FancyButton({@required this.onPressed ,this.icone,this.texto});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        onPressed: onPressed,

        fillColor: Colors.grey[800],
        splashColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(icone,color: Colors.yellowAccent,),
              ),
              Text(texto, style: TextStyle(color: Colors.white),),
            ],
          ),
        ),
        shape: const StadiumBorder() ,

    );
  }
}
