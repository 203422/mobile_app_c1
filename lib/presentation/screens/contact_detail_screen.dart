import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Para enviar mensajes
import 'package:http_app/infrastructure/services/call_service.dart'; // Para llamar
import '../../domain/models/contact.dart';

class ContactDetailScreen extends StatelessWidget {
  final Contact contact;
  final Color avatarColor;

  const ContactDetailScreen({
    super.key,
    required this.contact,
    required this.avatarColor,
  });

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
            Hero(
              tag: 'contact_${contact.matricula}', // El mismo tag único que en la lista
              child: CircleAvatar(
                radius: 50,
                backgroundColor: avatarColor,
                child: contact.name == 'Alan Gomez'
                    ? const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/pokemon.jpg'),
                      )
                    : const Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              contact.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildContactInfo(Icons.phone, 'Teléfono', contact.phone),
            _buildContactInfo(Icons.email, 'Email', contact.email),
            _buildContactInfo(Icons.badge, 'Matrícula', contact.matricula),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    CallService.callNumber(contact.phone); // Llama al número del contacto
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text('Llamar'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final Uri smsUri = Uri(
                      scheme: 'sms',
                      path: contact.phone,
                    );
                    if (await canLaunchUrl(smsUri)) {
                      await launchUrl(smsUri);
                    } else {
                      // Manejar el error si no se puede abrir la app de mensajería
                      print('No se puede abrir la app de mensajes');
                    }
                  },
                  icon: const Icon(Icons.message),
                  label: const Text('Mensaje'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
}
