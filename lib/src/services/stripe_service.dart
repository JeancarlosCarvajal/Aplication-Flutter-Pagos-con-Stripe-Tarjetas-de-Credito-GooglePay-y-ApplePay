 

import 'package:dio/dio.dart';
import 'package:f_stripe_card_pay/src/models/payment_intent_response.dart';
import 'package:f_stripe_card_pay/src/models/stripe_custom_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {

  // singleton permite crear una sola instancia
  StripeService._privateContructor();
  static final StripeService _instance = StripeService._privateContructor();
  factory StripeService() => _instance; 

  final String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  // clave secreta
  // coloque estatico para poder usarlo en los header del options
  static final _secretKey = dotenv.env['STRIPE_SECRET_KEY'];
  final _apiKey = dotenv.env['STRIPE_PUBLIC_KEY']; 
  // header options
  final headerOptions = Options(
    contentType: Headers.formUrlEncodedContentType,
    headers: {
      'Authorization': 'Bearer ${ StripeService._secretKey }'
    }
  );

  void init() {

    // propio del paquete
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: this._apiKey,
        androidPayMode: 'test',
        merchantId: "Test", // lo vamos a tener cuando se tiene el panel configurado de la cuenta de verdad
      )
    );
  }

  // Future<StripeCustomResponse> pagarConTarjetaExistente({
  //   required String amount, 
  //   required String currency,
  //   required CreditCard card
  // }) async {

  //   try { 
  //     // propio del paquete
  //     final paymentMetrod = await StripePayment.paymentRequestWithCardForm(
  //       CardFormPaymentRequest()
  //     );
 


  //     return StripeCustomResponse(ok: true); 
  //   } catch (e) {
  //     return StripeCustomResponse(ok: false, msg: e.toString());
  //   }

  // }

  Future<StripeCustomResponse> pagarConNuevaTarjeta({
    required String amount,
    required String currency,
  }) async {
    try { 
      // propio del paquete
      final paymentMetrod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest()
      );

      //  crear el intent
      final resp = await _crearPaymentIntent(amount: amount, currency: currency);

      return StripeCustomResponse(ok: true);
      
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }  

  Future pagarConApplePayGooglePay({
    required String amount,
    required String currency,
  }) async{
    
  }

  Future _crearPaymentIntent({
    required String amount,
    required String currency,
  }) async {
    try {

      final dio = new Dio();
      final data = {
        'amount': amount,
        'currency': currency
      };

      final resp = await dio.post(
        _paymentApiUrl,
        data: data,
        options: headerOptions
      );

      // en DIO cualquier estatus diferente al 200 y pico no va pasar y entra en el catch
      // este metodo lo creamos en quicktipe io PaymentIntentResponse
      // return PaymentIntentResponse.fromJson(resp.data);
      if(resp.statusCode == 200){
        print('jean: 200'); 
        final data = PaymentIntentResponse.fromMap(resp.data); 
        return data;
      }else{
        return false; 
      }
    } catch (e) {
      print('jean: Error Intento ${e.toString()}');
      return false;
    }
  }

  Future _realizarPago({
    required String amount,
    required String currency,
    required PaymentMethod paymentMethod,
  }) async {
    
  }


}