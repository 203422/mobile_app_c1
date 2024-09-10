import 'package:direct_sms/direct_sms.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsService {
  static final DirectSms _directSms = DirectSms();

  static void showSmsDialog(BuildContext context, String phoneNumber) {
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enviar Mensaje"),
          content: TextField(
            controller: messageController,
            decoration: const InputDecoration(hintText: "Escribe tu mensaje"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Enviar"),
              onPressed: () async {
                String message = messageController.text;
                if (message.isNotEmpty) {
                  await sendSms(phoneNumber, message);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> sendSms(String number, String message) async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      await Permission.sms.request();
    }

    try {
      _directSms.sendSms(phone: number, message: message);
      print("Mensaje enviado a $number: $message");
    } catch (e) {
      print("Error al enviar mensaje: $e");
    }
  }
}
