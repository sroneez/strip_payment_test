import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart';
import 'package:strip_payment_test/const.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment() async {
    try {
      final paymentIntentClientSecrete = await _paymentIntents(10, "usd");
      if (paymentIntentClientSecrete == null) return;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecrete,
          merchantDisplayName: 'Shofiqur Rahman Soyon',
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),
        ),
      );
      await _processPayment();
    } catch (e) {
      print(e);
    }
  }

  Future<String?> _paymentIntents(int amount, String currency) async {
    try {
      final url = 'https://api.stripe.com/v1/payment_intents';
      final Uri uri = Uri.parse(url);
      final Map<String, dynamic> requestBody = {
        'amount': _calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      Response response = await post(
        uri,
        body: requestBody,
        headers: {
          'Authorization': 'Bearer $stripSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        return jsonResponse['client_secret'];
      } else {
        print('Failed to create PaymentIntent: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print(e);
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
