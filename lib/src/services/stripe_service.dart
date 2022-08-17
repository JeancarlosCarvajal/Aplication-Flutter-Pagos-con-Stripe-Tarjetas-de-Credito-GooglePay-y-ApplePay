 

import 'package:dio/dio.dart';
import 'package:f_stripe_card_pay/src/models/payment_intent_response.dart';
import 'package:f_stripe_card_pay/src/models/stripe_custom_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:stripe_payment/stripe_payment.dart';

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

  void init() async {

    // propio del paquete
    // Stripe.instance.setOptions(
    //   StripeOptions(
    //     publishableKey: this._apiKey,
    //     androidPayMode: 'test',
    //     merchantId: "Test", // lo vamos a tener cuando se tiene el panel configurado de la cuenta de verdad
    //   )
    // );

    // inicializando stripe paquete
    WidgetsFlutterBinding.ensureInitialized(); 
    // set the publishable key for Stripe - this is mandatory
    final apiKey = dotenv.env['STRIPE_PUBLIC_KEY'];  
    print('jean: $apiKey'); 
    Stripe.publishableKey = apiKey!; 
    // Stripe.merchantIdentifier = 'com.example.f_stripe_card_pay';
    // Stripe.urlScheme = 'flutterstripe';
    // await Stripe.instance.applySettings();
    
  }

  Future pagarConTarjetaExistente({
    required String name,
    required String amount, 
    required String currency,
    required CardDetails cardDetails
  }) async {

    // try {

    // await Stripe.instance.dangerouslyUpdateCardDetails(cardDetails);
    const billingDetails = BillingDetails(
      email: 'email@flutterstripe.com',
      phone: '+48888000888',
      address: Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texas',
          postalCode: '77063',
        )
      );

      // 1 propio del paquete
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(

          )
        )
      ); 

      // final paymentMetrod = await Stripe.instance.createPaymentMethod(
      //   const PaymentMethodParams.card(
      //     paymentMethodData: PaymentMethodData(
      //       billingDetails: billingDetails
      //     )
      //   )
      // );


      // realizamos el pago. aqui esta el Payment Intent, confirmar el cobro
      final resp = await _realizarPago(
        amount: amount, 
        currency: currency, 
        paymentMethod: paymentMethod
      );
 
      return resp;
      
    // } catch (e) {
    //   return StripeCustomResponse(ok: false, msg: e.toString());
    // }

  }

  Future<StripeCustomResponse> pagarConNuevaTarjeta({ 
    required String amount,
    required String currency,
  }) async {
    // try { 
      // propio del paquete
      // final paymentMethod = await Stripe.instance.createPaymentMethod (
      //   CardFormPaymentRequest()
      // );
      // 1 propio del paquete
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(

          )
        )
      ); 
      // realizamos el pago. aqui esta el Payment Intent, confirmar el cobro
      final resp = await _realizarPago(
        amount: amount, 
        currency: currency, 
        paymentMethod: paymentMethod
      );
 
      return resp;
      
    // } catch (e) {
    //   return StripeCustomResponse(ok: false, msg: e.toString());
    // }
  }  

  Future<dynamic> pagarConApplePayGooglePay({
    required String amount,
    required String currency, 
  }) async{

    // try {
      // concertir el formato del monto
      // final newAmount = (double.parse(amount)/100).toString(); 
      // generar el token es propio del paquete
      // final token = await Stripe.instance.paymentRequestWithNativePay(
      //   androidPayOptions: AndroidPayPaymentRequest(currencyCode: currency, totalPrice: newAmount), 
      //   applePayOptions: ApplePayPaymentOptions(
      //     countryCode: 'US', 
      //     currencyCode: currency, 
      //     items: [
      //       ApplePayItem(
      //         label: 'Super producto 1',
      //         amount: newAmount
      //       )
      //     ]
      //   )
      // ); 

      // final paymentMethod = await Stripe.instance.createPaymentMethod(
      //   PaymentMethodRequest(
      //     card: CardDetails(
      //       token: token.tokenId
      //     ) 
      //   )
      // );

      // realizamos el pago. aqui esta el Payment Intent, confirmar el cobro
      // final resp = await _realizarPago(
      //   amount: amount, 
      //   currency: currency, 
      //   paymentMethod: paymentMethod
      // );

      // cerrar lapantalla al tener la respuesta
      // await Stripe.instance.completeNativePayRequest();
 
      // return resp;
       
    // } catch (e) {
    //   print('jean: Error GooglePay o ApplePay ${e.toString()}');
    //   return StripeCustomResponse(ok: false, msg: e.toString());
    // }
    
  }

  Future<PaymentIntentResponse> _crearPaymentIntent({
    required String amount,
    required String currency, 
  }) async {

    // try {

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
    // } catch (e) {
    //   print('jean: Error Intento ${e.toString()}');
    //   return PaymentIntentResponse(status: '400');
    // }
  }

  Future<dynamic> _realizarPago({
    required String amount,
    required String currency,
    required PaymentMethod paymentMethod, // esto ta informacion viene del Paquete de Stripe OJOJOJOJJ
  }) async {
    
    // try {
      //  crear Payment intent.. 1 conecta API
      final paymentIntent = await _crearPaymentIntent(amount: amount, currency: currency);

      // confirmar el pago.. 2 conecta API
      // final paymentResult = await Stripe.instance.confirmPayment(
       
       
        // PaymentIntent(
        //   clientSecret: paymentIntent.clientSecret, // esta informacion viene de respuesta del Payment Intent
        //   paymentMethodId: paymentMethod.id
        // )
      // );

    //   return paymentResult.status == 'succeeded'
    //     ? StripeCustomResponse(ok: true)
    //     : StripeCustomResponse(ok: false, msg: 'Fallo: ${paymentResult.status}');
 
    // } catch (e) {
    //   return StripeCustomResponse(ok: false, msg: e.toString());
    // }
 
  }


}