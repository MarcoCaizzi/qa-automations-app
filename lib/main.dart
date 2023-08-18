import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DataEntryScreen(),
    );
  }
}

class DataEntryScreen extends StatelessWidget {
  const DataEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingreso de Datos')),
      body: const DataEntryForm(),
    );
  }
}

class DataDisplayScreen extends StatelessWidget {
  final String nombre;
  final String apellido;
  final String fechaNacimiento;
  final String email;
  final String telefono;

  DataDisplayScreen({super.key,
    required this.nombre,
    required this.apellido,
    required this.fechaNacimiento,
    required this.email,
    required this.telefono,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Ingresados')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: $nombre $apellido'),
            Text('Fecha de Nacimiento: $fechaNacimiento'),
            Text('Email: $email'),
            Text('Teléfono: $telefono'),
          ],
        ),
      ),
    );
  }
}

class DataEntryForm extends StatefulWidget {
  const DataEntryForm({super.key});

  @override
  _DataEntryFormState createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {
  final _formKey = GlobalKey<FormState>();

  String _nombre = '';
  String _apellido = '';
  String _fechaNacimiento = '';
  String _email = '';
  String _telefono = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DataDisplayScreen(
            nombre: _nombre,
            apellido: _apellido,
            fechaNacimiento: _fechaNacimiento,
            email: _email,
            telefono: _telefono,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu nombre';
                }
                return null;
              },
              onSaved: (value) => _nombre = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Apellido'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu apellido';
                }
                return null;
              },
              onSaved: (value) => _apellido = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Fecha de Nacimiento'),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  setState(() {
                    _fechaNacimiento = selectedDate.toLocal().toString().split(' ')[0];
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu fecha de nacimiento';
                }
                return null;
              },
              readOnly: true,
              controller: TextEditingController(text: _fechaNacimiento),
              // Agrega esta línea para usar un TextEditingController
            ),

            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Por favor ingresa un email válido';
                }
                return null;
              },
              onSaved: (value) => _email = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu número de teléfono';
                }
                if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                  return 'Por favor ingresa un número de teléfono válido';
                }
                return null;
              },
              onSaved: (value) => _telefono = value!,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}

