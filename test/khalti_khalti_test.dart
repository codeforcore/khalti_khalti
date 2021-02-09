import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khalti_khalti/khalti_khalti.dart';

void main() {
  const MethodChannel channel = MethodChannel('khalti_khalti');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  // test('getPlatformVersion', () async {
  //   expect(await KhaltiKhalti.platformVersion, '42');
  // });
}
