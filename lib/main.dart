import 'package:flutter/material.dart';
import 'package:qa_automations_app/person_model.dart';
import 'database_helper.dart';

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
  final List<Person> peopleList;

  const DataDisplayScreen({super.key,
    required this.peopleList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Ingresados')),
      body: ListView.builder(
        itemCount: peopleList.length,
        itemBuilder: (context, index) {
          final person = peopleList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('${person.nombre} ${person.apellido}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fecha de Nacimiento: ${person.fechaNacimiento}'),
                  Text('Email: ${person.email}'),
                  Text('Teléfono: ${person.telefono}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class DataEntryForm extends StatefulWidget {
  const DataEntryForm({super.key});

  @override
  DataEntryFormState createState() => DataEntryFormState();
}

class DataEntryFormState extends State<DataEntryForm> {
  final _formKey = GlobalKey<FormState>();

  String _nombre = '';
  String _apellido = '';
  String _fechaNacimiento = '';
  String _email = '';
  String _telefono = '';

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final person = Person(
        nombre: _nombre,
        apellido: _apellido,
        fechaNacimiento: _fechaNacimiento,
        email: _email,
        telefono: _telefono,
      );

      final dbHelper = DatabaseHelper.instance;
      await dbHelper.insertPerson(person);

      final peopleList = await dbHelper.getPeople();
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DataDisplayScreen(
              peopleList: peopleList, // Pasa la lista de personas a mostrar
            ),
          ),
        );
      });
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
                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
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
              onPressed: () => _submitForm(context),
              child: const Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}

