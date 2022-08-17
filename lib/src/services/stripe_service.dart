 

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

  Future pagarConTarjetaExistente({
    required String amount, 
    required String currency,
    required CreditCard card
  }) async {

    try { 
      // propio del paquete
      final paymentMetrod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card)
      );

      // realizamos el pago. aqui esta el Payment Intent, confirmar el cobro
      final resp = await _realizarPago(
        amount: amount, 
        currency: currency, 
        paymentMethod: paymentMetrod
      );
 
      return resp;
      
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }

  }

  Future<StripeCustomResponse> pagarConNuevaTarjeta({
    required String amount,
    required String currency,
  }) async {
    try { 
      // propio del paquete
      final paymentMetrod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest()
      );

      // realizamos el pago. aqui esta el Payment Intent, confirmar el cobro
      final resp = await _realizarPago(
        amount: amount, 
        currency: currency, 
        paymentMethod: paymentMetrod
      );
 
      return resp;
      
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
  }  

  Future pagarConApplePayGooglePay({
    required String amount,
    required String currency,
  }) async{
    
  }

  Future<PaymentIntentResponse> _crearPaymentIntent({
    required String amount,
    required String currency, 
  }) async {
    try {

      final dio = new Dio();
      final data = {
        'amount': amount,
        'currency': currency,
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
        return PaymentIntentResponse.fromMap(resp.data);
      }else{
        return PaymentIntentResponse(status: '400'); 
      }
    } catch (e) {
      print('jean: Error Intento ${e.toString()}');
      return PaymentIntentResponse(status: '400');
    }
  }

  Future<StripeCustomResponse> _realizarPago({
    required String amount,
    required String currency,
    required PaymentMethod paymentMethod, // esto ta informacion viene del Paquete de Stripe OJOJOJOJJ
  }) async {
    
    try {
      //  crear Payment intent.. 1 conecta API
      final paymentIntent = await _crearPaymentIntent(amount: amount, currency: currency);

      // confirmar el pago.. 2 conecta API
      final paymentResult = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent.clientSecret, // esta informacion viene de respuesta del Payment Intent
          paymentMethodId: paymentMethod.id
        )
      );

      return paymentResult.status == 'succeeded'
        ? StripeCustomResponse(ok: true)
        : StripeCustomResponse(ok: false, msg: 'Fallo: ${paymentResult.status}');
 
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: e.toString());
    }
 
  }


}