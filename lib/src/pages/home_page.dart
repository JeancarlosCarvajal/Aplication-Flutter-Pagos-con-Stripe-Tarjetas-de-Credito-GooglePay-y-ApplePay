import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

import 'package:f_stripe_card_pay/src/data/data.dart';

class HomePage extends StatelessWidget {
   
  const HomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // para trbajar con el positiones debi colocar el size del positioned sino me da un error
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text( 'Pagar' ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){

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
                return CreditCardWidget(
                  cardNumber: tarjeta.cardNumberHidden,
                  expiryDate: tarjeta.expiracyDate,
                  cardHolderName: tarjeta.cardHolderName,
                  isHolderNameVisible: true,
                  cvvCode: tarjeta.cvv,
                  showBackView: false, 
                  onCreditCardWidgetChange: (creditCardBrand) { 

                   },
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}