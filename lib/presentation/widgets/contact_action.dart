import 'package:flutter/material.dart';

class ContactAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ContactAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30, color: Colors.white),
          onPressed: onTap,
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
      ],
    );
  }
}
