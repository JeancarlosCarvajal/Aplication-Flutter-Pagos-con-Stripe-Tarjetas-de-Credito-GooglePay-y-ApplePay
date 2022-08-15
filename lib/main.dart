import 'package:f_stripe_card_pay/src/pages/pages.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StripeApp',
      routes: {
        'home':(context) => HomePage(),
        'pago_completo':(context) => PagoCompletoPage()
      },
      
    );
  }
}