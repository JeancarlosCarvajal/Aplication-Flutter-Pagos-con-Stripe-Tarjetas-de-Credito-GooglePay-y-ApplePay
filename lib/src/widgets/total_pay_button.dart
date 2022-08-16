import 'package:f_stripe_card_pay/src/bloc/pagar/pagar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class TotalPayButton extends StatelessWidget {
   
  const TotalPayButton({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
              Text( 'Total', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold) ),
              Text( '250,55 USD', style: TextStyle(fontSize: 20) )
            ],
          ),
          
          _BtnPay(),
 
        ],
      ),
    );
  }
}

class _BtnPay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final pagarBloc = BlocProvider.of<PagarBloc>(context);
    // print('jean Avtica: ${pagarBloc.state.tarjetaActiva}');
    return pagarBloc.state.tarjetaActiva
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
        children: [
          Icon( FontAwesomeIcons.solidCreditCard, color: Colors.white ),
          Text( '   Pagar', style: TextStyle(color: Colors.white, fontSize: 22, fontStyle: FontStyle.italic) ),
        ],
      ),
      onPressed: (){});

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
            !Platform.isIOS 
              ? FontAwesomeIcons.applePay 
              : FontAwesomeIcons.googlePay, 
            size: 50, 
            color: Colors.white 
          ),
          // Text( 'Pay', style: TextStyle(color: Colors.white, fontSize: 22, fontStyle: FontStyle.italic) ),
        ],
      ),
      onPressed: (){});

  }
}