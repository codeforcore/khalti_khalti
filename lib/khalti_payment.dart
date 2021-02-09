import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model.dart';

class Khalti {
  static const MethodChannel _channel = const MethodChannel('khalti_khalti');

  final String publicKey;
  List<String> paymentPreferences;

  /// Building Configuration options for khalti payment
  ///
  Khalti.configure({
    @required this.publicKey,
    this.paymentPreferences = const [
      "khalti",
      "ebanking",
      "mobilebanking",
      "connectips",
      "sct"
    ],
  });

  void makePayment({
    @required KhaltiProduct product,
    @required Function(Map) onSuccess,
    @required Function(Map) onFaliure,
  }) async {
    _channel.invokeMethod("khaltiPayment", {
      "publicKey": publicKey,
      "productId": product.id,
      "productName": product.name,
      "amount": product.amount,
      "paymentPreferences": product.paymentPreferences != null
          ? getPaymentPreferences(product.paymentPreferences)
          : this.paymentPreferences,
      "customData": formatCustomData(product.customData),
      "productUrl": product.url,
      "mobile": product.mobile,
    });
    _paymentresponse(onSuccess, onFaliure);
  }

  _paymentresponse(Function onSuccess, Function onError) {
    _channel.setMethodCallHandler((call) {
      if (call.method == "khaltiSucess")
        return onSuccess(call.arguments);
      else if (call.method == "khaltiError")
        return onError(call.arguments);
      else {
        print("Unknow Error occured :: ${call.arguments}");
        return null;
      }
    });
  }

  Map<String, String> formatCustomData(Map<String, String> data) {
    return data.map((key, value) => MapEntry('merchant_' + key, value));
  }

  List<String> getPaymentPreferences(
      List<KhaltiPaymentPreference> preferences) {
    return preferences.map((e) {
      switch (e) {
        case KhaltiPaymentPreference.Khalti:
          return 'khalti';
          break;
        case KhaltiPaymentPreference.Ebanking:
          return 'ebanking';
          break;
        case KhaltiPaymentPreference.ConnectIPS:
          return 'connectips';
          break;
        case KhaltiPaymentPreference.MobileBanking:
          return 'mobilebanking';
          break;
        case KhaltiPaymentPreference.Sct:
          return 'sct';
          break;
      }
    }).toList();
  }
}
