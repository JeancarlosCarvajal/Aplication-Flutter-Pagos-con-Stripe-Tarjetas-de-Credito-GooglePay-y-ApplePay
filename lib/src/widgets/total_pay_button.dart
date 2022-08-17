import 'package:f_stripe_card_pay/src/bloc/pagar/pagar_bloc.dart';
import 'package:f_stripe_card_pay/src/helpers/helpers.dart';
import 'package:f_stripe_card_pay/src/services/stripe_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_payment/stripe_payment.dart';


class TotalPayButton extends StatelessWidget {
   
  const TotalPayButton({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pagarBloc = BlocProvider.of<PagarBloc>(context);
    final dataPay = pagarBloc.state;
    return Container(
      width: size.width,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), 
          topRight: Radius.circular(30)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text( 'Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold) ),
              Text(  '${dataPay.montoPagar} ${dataPay.moneda.toUpperCase()}', style: const TextStyle(fontSize: 20) )
            ],
          ),
          
          _BtnPay(pagarState: pagarBloc.state),
 
        ],
      ),
    );
  }
}

class _BtnPay extends StatelessWidget {
  final PagarState pagarState; 
  const _BtnPay({ 
    required this.pagarState
  });

  @override
  Widget build(BuildContext context) { 
    // print('jean Avtica: ${pagarBloc.state.tarjetaActiva}');
    return pagarState.tarjetaActiva
      ? buildBotonTarjeta(context)
      : buildAppleAndGooglePay(context);
  }
  
  Widget buildBotonTarjeta(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 170,
      shape: const StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      child: Row(
        children: const [
          Icon( FontAwesomeIcons.solidCreditCard, color: Colors.white ),
          Text( '   Pagar', style: TextStyle(color: Colors.white, fontSize: 22, fontStyle: FontStyle.italic) ),
        ],
      ),
      onPressed: () async {
        // mostrar el cargando
        mostrarLoading(context);
        final stripeService = new StripeService();
        final tarjeta = pagarState.tarjeta;
        final mesAnio = tarjeta.expiracyDate.split('/');
        // print('jean boton pagar: ${tarjeta.cardHolderName}');

        final response = await stripeService.pagarConTarjetaExistente(
          amount: pagarState.montoPagarString, 
          currency: pagarState.moneda, 
          card: CreditCard(
            number: tarjeta.cardNumber,
            expMonth: int.parse(mesAnio[0]),
            expYear: int.parse(mesAnio[1])
          )
        );

        // cancelar el cargando
        Navigator.pop(context); // es lo mismo que Navigator.of(context).pop() 

        if( response.ok ) {
          mostrarAlerta(context, 'Pago exitoso', 'Estimad@ ${pagarState.tarjeta.cardHolderName} su pago ha sido procesado con exito');
        }else{
          mostrarAlerta(context, 'Algo salio mal', '${response.msg}');
        }

      }
    );
  }

  Widget buildAppleAndGooglePay(BuildContext context) { 

    return MaterialButton(
      height: 45,
      minWidth: 150,
      shape: const StadiumBorder(),
      elevation: 0,
      color: Colors.black,
      child: Row(
        children: [
          Icon( 
            Platform.isIOS 
              ? FontAwesomeIcons.applePay 
              : FontAwesomeIcons.googlePay, 
            size: 50, 
            color: Colors.white 
          ),
          // Text( 'Pay', style: TextStyle(color: Colors.white, fontSize: 22, fontStyle: FontStyle.italic) ),
        ],
      ),
      onPressed: () async {

        // mostrar el cargando
        mostrarLoading(context);

        final stripeService = new StripeService();
        final tarjeta = pagarState.tarjeta;
        final mesAnio = tarjeta.expiracyDate.split('/');

        final response = await stripeService.pagarConApplePayGooglePay(
          amount: pagarState.montoPagarString, 
          currency: pagarState.moneda, 
        );

        // cancelar el cargando
        Navigator.pop(context); // es lo mismo que Navigator.of(context).pop()  
        if( response.ok ) {
          mostrarAlerta(context, 'Pago exitoso', 'Estimad@ ${pagarState.tarjeta.cardHolderName} su pago ha sido procesado con exito');
        }else{
          mostrarAlerta(context, 'Algo salio mal', '${response.msg}');
        }

      });

  }
}