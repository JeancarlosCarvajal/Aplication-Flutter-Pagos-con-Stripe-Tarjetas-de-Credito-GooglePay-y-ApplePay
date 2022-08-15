import 'package:f_stripe_card_pay/src/models/models.dart';
import 'package:f_stripe_card_pay/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

class TarjetaPage extends StatelessWidget {
   
  const TarjetaPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final tarjeta = TarjetaCredito(
      cardNumberHidden: '4242',
      cardNumber: '4242424242424242',
      brand: 'visa',
      cvv: '213',
      expiracyDate: '01/25',
      cardHolderName: 'Jeancarls Carvajal'
    );

    return Scaffold(
      appBar: AppBar( 
        centerTitle: true,
        title: const Text( 'Pagar' ),
      ),
      body: Stack(
        children: [

          Container(),

          Hero(
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

          Positioned(
            bottom: 0,
            child: TotalPayButton()
          ),

        ]
      ),
    );
  }
}