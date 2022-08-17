
import 'package:f_stripe_card_pay/src/bloc/pagar/pagar_bloc.dart'; 
import 'package:f_stripe_card_pay/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

class TarjetaPage extends StatelessWidget { 
 
  const TarjetaPage({
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

  // final TarjetaCredito tarjeta = BlocProvider.of<PagarBloc>(context).state.tarjeta;

    // final tarjeta = TarjetaCredito(
    //   cardNumberHidden: '4242',
    //   cardNumber: '4242424242424242',
    //   brand: 'visa',
    //   cvv: '213',
    //   expiracyDate: '01/25',
    //   cardHolderName: 'Jeancarls Carvajal'
    // );

    final tarjeta = BlocProvider.of<PagarBloc>(context).state.tarjeta;

    print('jean tarjeta page ${tarjeta.cardHolderName}');

    return Scaffold(
      appBar: AppBar( 
        centerTitle: true,
        title: const Text( 'Pagar' ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: (){
            // descativar tarjeta
            final pagarBloc = BlocProvider.of<PagarBloc>(context);
            pagarBloc.add(OnDeactivateTarjeta());
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [

          Container(), 

          Hero(
            tag: tarjeta.cardNumber,
            child: CreditCardWidget(
              cardNumber: tarjeta.cardNumber,
              expiryDate: tarjeta.expiracyDate,
              cardHolderName: tarjeta.cardHolderName,
              isHolderNameVisible: true,
              cvvCode: tarjeta.cvv,
              showBackView: false, 
              onCreditCardWidgetChange: (_) {},
            ),
          ),

          const Positioned(
            bottom: 0,
            child: TotalPayButton()
          ),

        ]
      ),
    );
  }
}