import 'package:f_stripe_card_pay/src/bloc/pagar/pagar_bloc.dart';
import 'package:f_stripe_card_pay/src/services/stripe_service.dart';
import 'package:flutter/material.dart';

import 'package:f_stripe_card_pay/src/pages/pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {

  // Inicializando las Variables de Entorno
  // NOTE: fileName defaults to .env and can be omitted in this case.
  // Ensure that the filename corresponds to the path in step 1 and 2.
  await dotenv.load(fileName: ".env");

  // inicializamos el stripe service.. opcion 2
  final stripeService = StripeService();
  stripeService.init();
  
  runApp(MyApp()); 

}

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

