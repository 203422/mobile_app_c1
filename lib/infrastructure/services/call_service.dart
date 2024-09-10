import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class CallService {
  static void callNumber(String number) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    print('Llamando: $res');
  }
}
