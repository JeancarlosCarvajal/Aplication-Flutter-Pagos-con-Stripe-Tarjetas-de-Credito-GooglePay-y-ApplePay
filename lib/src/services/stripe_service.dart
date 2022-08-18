 

import 'package:dio/dio.dart';
import 'package:f_stripe_card_pay/src/models/models.dart';
import 'package:f_stripe_card_pay/src/models/models.dart';
import 'dart:convert';

import 'package:f_stripe_card_pay/src/models/payment_intent_response.dart';
import 'package:f_stripe_card_pay/src/models/stripe_custom_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
// import 'package:stripe_payment/stripe_payment.dart';

class StripeService {

  // singleton permite crear una sola instancia
  StripeService._privateContructor();
  static final StripeService _instance = StripeService._privateContructor();
  factory StripeService() => _instance; 

  final String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  final String _customerApiUrl = 'https://api.stripe.com/v1/customers';


  final client = http.Client();

  // clave secreta
  // coloque estatico para poder usarlo en los header del options
  static final _secretKey = dotenv.env['STRIPE_SECRET_KEY'];
  final _apiKey = dotenv.env['STRIPE_PUBLIC_KEY']; 
  
  // header options
  final headers  = {
    'Authorization': 'Bearer $_secretKey',
    'Content-Type': 'application/x-www-form-urlencoded',
    // 'Content-Type': 'from-data', // para pruebas de respuesta 400 bad request
  };

  // the first.._createCustomer().. step is to create a customer, which means registering a user in stripe. 
  // The second step.._crearPaymentIntent().. is to create a payment intent, where the amount to be paid is specified. 
  // The third step is to enter the credit card information and complete the payment

  void init() async { 
    // inicializando stripe paquete
    WidgetsFlutterBinding.ensureInitialized(); 
    // set the publishable key for Stripe - this is mandatory 
    // print('jean: $_apiKey'); 
    Stripe.publishableKey = _apiKey!; 
  }

  // de aqui usare el CreateCustomerResponse.id
  Future<CreateCustomerResponse> _createCustomer() async {
    try { 
      var response = await client.post( Uri.parse(_customerApiUrl),
        headers: headers,
        body: {
          'description': 'new customer'
        },
      ); 
      return response.statusCode == 200
        ? CreateCustomerResponse.fromJson(response.body)
        : CreateCustomerResponse(id: 'false');  
    } catch (e) {
        return CreateCustomerResponse(id: 'false'); 
    }
  }

  // de aqui usare el PaymentIntentResponse.clientSecret
  Future<PaymentIntentResponse> _crearPaymentIntent({
    required String amount,
    required String currency, 
  }) async {
    try { 
      var response = await client.post( Uri.parse(_paymentApiUrl),
        headers: headers,
        body: {
          'amount': amount,
          'currency': currency,
        },
      ); 
      return response.statusCode == 200
        ? PaymentIntentResponse.fromJson(response.body)
        : PaymentIntentResponse(status: '400'); 
    } catch (e) { 
      print('jean: Error Intento ${e.toString()}');
      return PaymentIntentResponse(status: '400');
    } 
  }

  Future<void> _createCreditCard(String customerId, String clientSecret) async { 
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // applePay: const PaymentSheetApplePay(merchantCountryCode: 'us'),
        // googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'us'),
        style: ThemeMode.dark,
        // testEnv: true,
        // merchantCountryCode: 'JP',
        merchantDisplayName: 'Flutter Stripe Store Demo',
        customerId: customerId,
        paymentIntentClientSecret: clientSecret,
      )
    );
    await Stripe.instance.presentPaymentSheet();
    print('jean: test');
    
  }

  Future<void> payment({required String amount, required String currency}) async { 
    final customer = await _createCustomer();
    final paymentIntent = await _crearPaymentIntent(amount: amount, currency: currency);
    await _createCreditCard(customer.id, paymentIntent.clientSecret);
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
 
 
      // final paymentMetrod = await Stripe.instance.createPaymentMethod(
      //   const PaymentMethodParams.card(
      //     paymentMethodData: PaymentMethodData(
      //       billingDetails: billingDetails
      //     )
      //   )
      // );
 
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
          paymentMethodData: PaymentMethodData( )
        ),  
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