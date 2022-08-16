import 'package:f_stripe_card_pay/src/bloc/pagar/pagar_bloc.dart';
import 'package:f_stripe_card_pay/src/helpers/helpers.dart';
import 'package:f_stripe_card_pay/src/models/models.dart';
import 'package:f_stripe_card_pay/src/pages/pages.dart';
import 'package:f_stripe_card_pay/src/services/stripe_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

import 'package:f_stripe_card_pay/src/widgets/widgets.dart';
import 'package:f_stripe_card_pay/src/data/data.dart';

class HomePage extends StatelessWidget {

  final stripeService = new StripeService();
   
  HomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // para trbajar con el positiones debi colocar el size del positioned sino me da un error
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Center(child: Text( 'Pagar' )),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {

              // mostrar el cargando
              // mostrarLoading(context);
              // await Future.delayed(const Duration(seconds: 1));
              // cancelar el cargando
              // Navigator.pop(context); // es lo mismo que Navigator.of(context).pop() 
              // Mostrar la alerta personalizada
              // mostrarAlerta(context, 'Hola', 'Mundo');

              final pagarBloc = BlocProvider.of<PagarBloc>(context, listen: false);

              final response = await stripeService.pagarConNuevaTarjeta(
                amount: pagarBloc.state.montoPagarString, 
                currency: pagarBloc.state.moneda
              );

              if( response.ok ) {
                mostrarAlerta(context, 'Tarjeta Ok', 'Todo correcto');
              }else{
                mostrarAlerta(context, 'Algo salio mal', '${response.msg}');
              }
            },
          )
        ],
      ),
      body: Stack(
        children: [
          
          Positioned(
            width: size.width, // tuve que hacerlo para enviar error con el positioned
            height: size.width, // tuve que hacerlo para enviar error con el positioned
            top: 150,
            child: PageView.builder(
              controller: PageController(
                viewportFraction: 0.9 // esto hace que se vea se asome la otra tarjeta a la der/izq de la pantalla indicando que se le puede dar scroll horizontal
              ),
              physics: const BouncingScrollPhysics(parent: ScrollPhysics()),
              itemCount: tarjetas.length,
              itemBuilder: ( _ , int index) {

                final tarjeta = tarjetas[index];

                return GestureDetector( 
                  child: Hero(
                    tag: tarjeta.cardNumber,
                    child: CreditCardWidget(
                      cardNumber: tarjeta.cardNumberHidden,
                      expiryDate: tarjeta.expiracyDate,
                      cardHolderName: tarjeta.cardHolderName,
                      isHolderNameVisible: true,
                      cvvCode: tarjeta.cvv,
                      showBackView: false, 
                      onCreditCardWidgetChange: (_) {},
                    ),
                  ),                  
                  onTap: () {
                    // print('jean: Gestur Tarjeta de ${tarjeta.cardHolderName}');
                    // accedemos al Bloc
                    final pagarBloc = BlocProvider.of<PagarBloc>(context); 
                    // print('jean Avtica Inicial: ${ pagarBloc.state.tarjetaActiva}');

                    pagarBloc.add( OnSelectedTarjeta( tarjeta ) ); 
                    Navigator.push(context, navegarFadeIn(context, const TarjetaPage()));
 
                  },
                );
              },
            ),
          ),

          const Positioned(
            bottom: 0,
            child: TotalPayButton()
          )

        ],
      ),
    );
  }
}