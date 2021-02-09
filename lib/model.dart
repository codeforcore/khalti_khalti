import 'package:flutter/foundation.dart';

/// Configuration for payment methods within khalti SDK
enum KhaltiPaymentPreference {
  /// Respected only on Android, iOS will show this option anyway
  Khalti,

  /// Respected on both Android and iOS
  Ebanking,

  /// Respected on only Android, iOS SDK doesnt support it
  MobileBanking,

  /// Respected on only Android, iOS SDK doesnt support it
  ConnectIPS,

  /// Respected on only Android, iOS SDK doesnt support it
  Sct,
}

class KhaltiProduct {
  /// Product id
  String id;

  /// Product name
  String name;

  /// Product Url
  String url;

  /// Amount in paisa
  int amount;

  /// Mobile Number (optional)
  String mobile;

  /// Paymentpreferences (optional) if not specified all available method will be shown
  List<KhaltiPaymentPreference> paymentPreferences;

  /// Custom data (notes ) for payment payment
  Map<String, String> customData;

  KhaltiProduct({
    /// Product id
    @required this.id,

    /// Product name
    @required this.name,

    /// Amount in paisa
    @required this.amount,

    /// Paymentpreferences (optional) if not specified all available method will be shown
    this.paymentPreferences,

    /// Product Url
    this.url,

    /// Mobile Number (optional)
    this.mobile,

    /// Custom data (notes ) for payment payment
    this.customData,
  });
}
