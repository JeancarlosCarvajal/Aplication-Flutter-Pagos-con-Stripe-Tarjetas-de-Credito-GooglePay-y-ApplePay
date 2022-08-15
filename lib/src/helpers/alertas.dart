 import 'package:flutter/material.dart';
 
 
 mostrarLoading(BuildContext context) {

  showDialog(
    context: context, 
    barrierDismissible: false, // evita que se cierre si se toca afuera
    builder: (context) => const AlertDialog(
      title: Text( 'Espere...' ),
      content: LinearProgressIndicator(),
    ),
  );

 }

 mostrarAlerta(BuildContext context, String titulo, String mensaje) {
  showDialog(
    context: context, 
    barrierDismissible: false, // evita que se cierre si se toca afuera
    builder: (context) => AlertDialog(
      title: Text( titulo ),
      content: Text( mensaje ),
      actions: [
        MaterialButton(
          child: const Text( 'Ok' ),
          onPressed: () => Navigator.of(context).pop()
        )
      ],
    ) 
  );
 }