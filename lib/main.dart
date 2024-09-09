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
    Contact(name: 'Fernando Pérez', phone: '9612739154', email: '213524@ids.upchiapas.edu.mx', matricula: '213524'),
    Contact(name: 'Alan Gomez', phone: '9671632128', email: '203422@ids.upchiapas.edu.mx', matricula: '203422'),
    Contact(name: 'Omar Ceja', phone: '9941064858', email: '203460@ids.upchiapas.edu.mx', matricula: '203460'),
  ];

  ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 10, 10, 10),
      appBar: AppBar(
          title: const Text('Integrantes', 
          style: TextStyle(color: Colors.white)), 
          backgroundColor: const Color.fromARGB(255, 10, 10, 10)
          ),
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
                    backgroundColor: const Color.fromARGB(255, 121, 111, 129),
                    radius: 50, // Tamaño de las bolitas
                    child: 
                    Text(contact.name[0], 
                    style: const TextStyle(fontSize: 24),
                    
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(contact.name, style: const TextStyle(fontSize: 16, color: Colors.white)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 10, 10, 10),
      appBar: AppBar(
          title: Text(contact.name, 
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          backgroundColor: const Color.fromARGB(255, 10, 10, 10),
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar con el nombre del contacto
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color.fromARGB(255, 39, 126, 176),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              contact.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              

            ),
            const SizedBox(height: 20),
            
            // Botones de Llamar y Mensaje de texto
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildContactAction(Icons.call, 'Llamar', () {
                  _callNumber(contact.phone);
                }),
                _buildContactAction(Icons.message, 'Mensaje de texto', () {
                  _showSmsDialog(context, contact.phone);
                }),
              ],
            ),
            const SizedBox(height: 30),

            // Información del contacto (solo muestra lo que esté disponible)
            _buildContactInfo(Icons.phone, 'Teléfono', contact.phone),
            _buildContactInfo(Icons.email, 'Email', contact.email),
            _buildContactInfo(Icons.badge, 'Matrícula', contact.matricula),
          ],
        ),
      ),
    );
  }

  // Función para realizar una llamada
  void _callNumber(String number) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    print('Llamando: $res');
  }

  // Función para mostrar el diálogo de entrada de mensaje
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
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  // Función para enviar un SMS
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

  // Widget para mostrar un ícono y la información
  Widget _buildContactInfo(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 248, 248, 248)),
          const SizedBox(width: 16),
          Text(
            '$label: $value',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Widget para los botones de acción (llamar, mensaje)
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

class Contact {
  final String name;
  final String phone;
  final String email;
  final String matricula;

  Contact({required this.name, required this.phone, required this.email, required this.matricula});
}
