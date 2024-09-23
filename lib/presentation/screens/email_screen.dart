import 'package:flutter/material.dart';

class EmailChecker extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _EmailCheckerState createState() => _EmailCheckerState();
}

class _EmailCheckerState extends State<EmailChecker> {
  final TextEditingController _controller = TextEditingController();
  
  String _statusMessage = "";
  
  // Color del botón
  Color? _btnColor = Colors.grey[400];
  
  // Correo electrónico ingresado
  String _inputEmail = "";

  @override
  void initState() {
    super.initState();
    
    // Agregar un listener al controlador del campo de texto
    _controller.addListener(() {
      setState(() {
        final email = _controller.text;
        
        // Cambiar el color del botón y el mensaje basado en el contenido del campo de texto
        if (email.isEmpty) {
          _btnColor = Colors.grey[400];
        } else if (email.endsWith('@hotmail.com')) {
          _btnColor = Colors.green;
          _statusMessage = "¡Correo válido!";
        } else {
          _btnColor = Colors.red;
          _statusMessage = "Correo inválido. Debe terminar en '@hotmail.com'.";
        }
      });
    });
  }

  void _checkEmail() {
    final email = _controller.text;
    setState(() {
      if (email.endsWith('@hotmail.com')) {
        _statusMessage = "¡Correo válido!";
        _inputEmail = email; // Guardar el correo electrónico ingresado
      } else {
        _statusMessage = "Correo inválido. Debe terminar en '@hotmail.com'.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('validador de correos'),
        centerTitle: true,
       
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50), // Espacio vertical
            Text(
              'Introduce tu email:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20), // Espacio vertical
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: Icon(Icons.email),
                filled: true,
              ),
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20), // Espacio vertical
            ElevatedButton(
              // Cambiar la acción del botón basado en el color
              onPressed: _btnColor == Colors.grey[400]
                  ? null
                  : _checkEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: _btnColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: _btnColor != Colors.grey[400] ? 8 : 0,
                shadowColor: Colors.black54,
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text('Verificar Email'),
            ),
            SizedBox(height: 20), // Espacio vertical
            // Mostrar el correo electrónico ingresado
            Text(
              'Email ingresado es: $_inputEmail',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20), // Espacio vertical
            // Mostrar el mensaje de validación
            Text(
              _statusMessage,
              style: TextStyle(
                fontSize: 18,
                color: _statusMessage.startsWith('¡') ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black45,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
