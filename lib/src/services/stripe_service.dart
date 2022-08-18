 

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
        : CreateCustomerResponse(id: '');  
    } catch (e) {
        return CreateCustomerResponse(id: ''); 
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
        : PaymentIntentResponse(clientSecret: ''); 
    } catch (e) { 
      print('jean: Error Intento ${e.toString()}');
      return PaymentIntentResponse(clientSecret: '');
    } 
  }

  Future<StripeCustomResponse> _createCreditCard(String customerId, String clientSecret) async { 
    try {
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
      return StripeCustomResponse(ok: true);
    } catch (e) {
      // StripeException
      return StripeCustomResponse(ok: false, msg: 'Problemas al finalizar el pago: ${e.toString()}');
    } 
  }

  Future<dynamic> _customCreditCard(String customerId, String clientSecret) async { 
    try {
      // NO hay sufuiente documentacion para este tipo de pagos en el paquete de flutter_stripe
    } catch (e) {
      return StripeCustomResponse(ok: false, msg: 'Problemas al finalizar el pago: ${e.toString()}');
    } 
    
  }

  Future<StripeCustomResponse> payment({required String amount, required String currency}) async { 
    final customer = await _createCustomer();
    if(customer.id.isEmpty) return StripeCustomResponse(ok: false, msg: 'Problemas al crear un nuevo cliente');
    final paymentIntent = await _crearPaymentIntent(amount: amount, currency: currency);
    if(paymentIntent.clientSecret.isEmpty) return StripeCustomResponse(ok: false, msg: 'Problemas al crear el Payment Intent');
    return await _createCreditCard(customer.id, paymentIntent.clientSecret);
  }



  Future pagarConTarjetaExistente({
    required String name,
    required String amount, 
    required String currency,
    required CardDetails cardDetails
  }) async {
 

  }

  Future<dynamic> pagarConNuevaTarjeta({ 
    required String amount,
    required String currency,
  }) async { 

  }  

  Future<dynamic> pagarConApplePayGooglePay({
    required String amount,
    required String currency, 
  }) async{

    
  }


}