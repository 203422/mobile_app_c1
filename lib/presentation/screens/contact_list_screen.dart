import 'package:flutter/material.dart';
import 'contact_detail_screen.dart';
import '../../domain/models/contact.dart';
import '../widgets/contact_avatar.dart';

class ContactListScreen extends StatelessWidget {
  final List<Contact> contacts = const [
    Contact(name: 'Fernando Pérez', phone: '9612739154', email: '213524@ids.upchiapas.edu.mx', matricula: '213524'),
    Contact(name: 'Alan Gomez', phone: '9671632128', email: '203422@ids.upchiapas.edu.mx', matricula: '203422'),
    Contact(name: 'Omar Ceja', phone: '9941064858', email: '203460@ids.upchiapas.edu.mx', matricula: '203460'),
  ];

  final List<Color> avatarColors = [
    Colors.blue, 
    Colors.green, 
    Colors.orange,
  ];

  ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrantes'),
      ),
      body: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 70.0,
          runSpacing: 70.0,
          children: contacts.asMap().entries.map((entry) {
            int index = entry.key;
            Contact contact = entry.value;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactDetailScreen(contact: contact, avatarColor: avatarColors[index]),
                  ),
                );
              },
              child: ContactAvatar(contact: contact, avatarColor: avatarColors[index]),
            );
          }).toList(),
        ),
      ),
    );
  }
}
