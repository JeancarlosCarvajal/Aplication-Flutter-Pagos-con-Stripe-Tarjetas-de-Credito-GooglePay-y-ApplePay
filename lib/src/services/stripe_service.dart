 

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {

  // singleton permite crear una sola instancia
  StripeService._privateContructor();
  static final StripeService _instance = StripeService._privateContructor();
  factory StripeService() => _instance; 

  final String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  // clave secreta
  final _secretKey = dotenv.env['STRIPE_TOKEN'];

  void init() {

  }

  Future pagarConTarjetaExistente({
    required String amount, 
    required String currency,
    required CreditCard card
  }) async {

  }

  Future pagarConNuevaTarjeta({
    required String amount,
    required String currency,
  }) async {
    
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
    
  }

  Future _realizarPago({
    required String amount,
    required String currency,
    required PaymentMethod paymentMethod,
  }) async {
    
  }


}