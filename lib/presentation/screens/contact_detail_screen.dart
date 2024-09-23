import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:direct_sms/direct_sms.dart';
import 'package:http_app/domain/models/contact.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailScreen extends StatelessWidget {
  final Contact contact;
  final Color avatarColor;
  final DirectSms directSms = DirectSms();

  ContactDetailScreen(
      {super.key, required this.contact, required this.avatarColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: avatarColor,
              child: contact.name == 'Alan Gomez'
                  ? const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/pokemon.jpg'),
                    )
                  : const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              contact.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildContactAction(Icons.call, 'Llamar', () {
                  _callNumber(contact.phone);
                }),
                _buildContactAction(Icons.message, 'Mensaje de texto', () {
                  _showSmsDialog(context, contact.phone);
                }),
                _buildContactAction(Icons.file_copy, 'Repositorio', () async {
                  if (await canLaunchUrl(Uri.parse(contact.repositorio))) {
                    await launchUrl(Uri.parse(contact.repositorio));
                  } else {
                    print('No se puede abrir la URL del repositorio');
                  }
                }),
              ],
            ),
            const SizedBox(height: 30),
            _buildContactInfo(Icons.phone, 'Teléfono', contact.phone),
            _buildContactInfo(Icons.email, 'Email', contact.email),
            _buildContactInfo(Icons.badge, 'Matrícula', contact.matricula),
          ],
        ),
      ),
    );
  }

  void _callNumber(String number) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    print('Llamando: $res');
  }

  void _showSmsDialog(BuildContext context, String phoneNumber) {
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
                  _sendSms(phoneNumber, message);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _sendSms(String number, String message) async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      await Permission.sms.request();
    }

    try {
      directSms.sendSms(phone: number, message: message);
      print("Mensaje enviado a $number: $message");
    } catch (e) {
      print("Error al enviar mensaje: $e");
    }
  }

  Widget _buildContactInfo(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Text(
            '$label: $value',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildContactAction(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30),
          onPressed: onTap,
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
