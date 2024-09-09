import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:direct_sms/direct_sms.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContactListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ContactListScreen extends StatelessWidget {
  final List<Contact> contacts = [
    Contact(name: 'Fernando Pérez', phone: 'number phone', email: '213524@ids.upchiapas.edu.mx', matricula: '213524'),
    Contact(name: 'Alan Gomez', phone: 'number phone', email: '203422@ids.upchiapas.edu.mx', matricula: '203422'),
    Contact(name: 'Omar Ceja', phone: 'number phone', email: '203460@ids.upchiapas.edu.mx', matricula: '203460'), 
  ];

  ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Integrantes')),
      body: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 50.0, // Espacio horizontal entre las bolitas
          runSpacing: 50.0, // Espacio vertical si hubiera varias filas
          children: contacts.map((contact) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ContactDetailScreen(contact: contact)),
                );
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50, // Tamaño de las bolitas
                    child: Text(contact.name[0], style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(height: 8),
                  Text(contact.name),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ContactDetailScreen extends StatelessWidget {
  final Contact contact;
  final DirectSms directSms = DirectSms();

  ContactDetailScreen({super.key, required this.contact});

  Future<void> _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  Future<void> _sendSms(BuildContext context, String number) async {
    // Mostrar el cuadro de diálogo para ingresar el mensaje
    TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enviar Mensaje'),
          content: TextField(
            controller: messageController,
            decoration: const InputDecoration(
              labelText: 'Escribe tu mensaje',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo sin enviar
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                String message = messageController.text;
                if (message.isNotEmpty) {
                  final permission = await Permission.sms.request();
                  if (permission.isGranted) {
                    directSms.sendSms(message: message, phone: number);
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(); // Cerrar el diálogo al enviar
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(contact.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar con el nombre del contacto
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              contact.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Botones de Llamar, Mensaje de texto, y Video (similar a la imagen)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildContactAction(Icons.call, 'Llamar', () {
                  // Acción de llamada
                }),
                _buildContactAction(Icons.message, 'Mensaje de texto', () {
                  // Acción de mensaje
                }),
              ],
            ),
            const SizedBox(height: 30),

            // Información del contacto (solo muestra lo que esté disponible)
            if (contact.phone != null)
              _buildContactInfo(Icons.phone, 'Teléfono', contact.phone!),
            if (contact.email != null)
              _buildContactInfo(Icons.email, 'Email', contact.email!),
            if (contact.matricula != null)
              _buildContactInfo(Icons.badge, 'Matrícula', contact.matricula!),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar un ícono y la información
  Widget _buildContactInfo(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Text(
            '$label: $value',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Widget para los botones de acción (llamar, mensaje, video)
  Widget _buildContactAction(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30),
          onPressed: onTap,
        ),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  // Widget para mostrar apps conectadas (ejemplo con WhatsApp)
  Widget _buildConnectedAppsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Apps conectadas',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.messenger, color: Colors.green),
            const SizedBox(width: 16),
            const Text('WhatsApp', style: TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }
}
class Contact {
  final String name;
  final String phone;
  final String email;
  final String matricula;

  Contact({required this.name, required this.phone, required this.email, required this.matricula});
}