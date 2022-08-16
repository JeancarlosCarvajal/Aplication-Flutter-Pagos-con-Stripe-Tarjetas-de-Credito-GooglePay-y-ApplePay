import 'package:f_stripe_card_pay/src/bloc/pagar/pagar_bloc.dart';
import 'package:flutter/material.dart';

import 'package:f_stripe_card_pay/src/pages/pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider( create: ( _ ) => PagarBloc() ), 
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StripeApp',
        initialRoute: 'home',
        routes: {
          'home':(context) => HomePage(),
          'pago_completo':(context) => PagoCompletoPage(),
        },
        theme: ThemeData.light().copyWith(
          appBarTheme: const AppBarTheme(
            color: Color(0xff284879)
          ),
          primaryColor: const Color(0xff284879),
          scaffoldBackgroundColor: const Color(0xff21232a), 
        ),
      ),
    );
  }
}