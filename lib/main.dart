import 'package:flutter/material.dart';

import 'package:f_stripe_card_pay/src/pages/pages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StripeApp',
      initialRoute: 'home',
      routes: {
        'home':(context) => HomePage(),
        'pago_completo':(context) => PagoCompletoPage(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          color: Color(0xff284879)
        ),
        primaryColor: Color(0xff284879),
        scaffoldBackgroundColor: Color(0xff21232a), 
      ),
    );
  }
}