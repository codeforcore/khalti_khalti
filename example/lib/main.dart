import 'package:flutter/material.dart';
import 'package:khalti_khalti/khalti_khalti.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  KhaltiProduct _product;

  void _makePayment() {
    Khalti _khalti = Khalti.configure(
      publicKey: 'test_public_key_11927f4ef6a649ca9e8c44d2c779dba3',
    );

    _khalti.makePayment(
        onFaliure: (Map<dynamic, dynamic> data) {
          print('Payment Failed :: $data');
        },
        onSuccess: (Map<dynamic, dynamic> data) async {
          print('Payment Sucess :: $data');
          // Onsucess complete server side verification with data
          // https://docs.khalti.com/api/verification/
          print(
              "Complete the payment with server side validation Amount :: ${data['amount']} and Token :: ${data['token']}");
          Dio dio = Dio();
          Response response = await dio.post(
              "https://khalti.com/api/v2/payment/verify/",
              data: {"token": data['token'], "amount": data['amount']},
              options: Options(headers: {
                "Authorization":
                    "key test_secret_key_3f7c120822e54f3cba91cc37660b93b5"
              }));
          print('Response code ${response.statusCode}');
          print('Response :: ${response.data}');
        },
        product: _product);
  }

  @override
  void initState() {
    _product = KhaltiProduct(
      id: '1',
      name: 'iPhone X',
      amount: 1000,
      url: 'https://codeforcore.com',
      customData: {"testdata": "test_val"},
      mobile: '9840060186',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khalti Payment API Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Khalti Payment Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              OutlineButton(
                onPressed: () {
                  _product.paymentPreferences = null;
                  _product.mobile = "9851150186";
                  _makePayment();
                },
                child: Text('Pay With All Payemnt Options'),
              ),
              OutlineButton(
                onPressed: () {
                  _product.paymentPreferences = const [
                    KhaltiPaymentPreference.Khalti
                  ];
                  _makePayment();
                },
                child: Text('Pay With Khalti'),
              ),
              OutlineButton(
                onPressed: () {
                  _product.paymentPreferences = const [
                    KhaltiPaymentPreference.Ebanking
                  ];
                  _makePayment();
                },
                child: Text('Pay With E-Banking'),
              ),
              OutlineButton(
                onPressed: () {
                  _product.paymentPreferences = const [
                    KhaltiPaymentPreference.MobileBanking
                  ];
                  _makePayment();
                },
                child: Text('Pay With Mobile Banking'),
              ),
              OutlineButton(
                onPressed: () {
                  _product.paymentPreferences = const [
                    KhaltiPaymentPreference.ConnectIPS
                  ];
                  _makePayment();
                },
                child: Text('Pay With Connect IPS'),
              ),
              OutlineButton(
                onPressed: () {
                  _product.paymentPreferences = const [
                    KhaltiPaymentPreference.Sct
                  ];
                  _makePayment();
                },
                child: Text('Pay With SCT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
