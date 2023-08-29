import 'package:flutter/material.dart';
import 'package:qa_automations_app/model.dart';
import 'dataDisplayScreen.dart';
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
      appBar: AppBar(title: const Text('Ingrese de Datos')),
      body: const DataEntryForm(),
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

  String _name = '';
  String _lastName = '';
  String _dateOfBirth = '';
  String _email = '';
  String _cellularPhoneNumber = '';
  Country? _selectedCountry;
  Province? _selectedProvince;
  List<String> _provinces = [];
  List<Province> _provincesList = [];
  final dbHelper = DatabaseHelper.instance;

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
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Apellido'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu apellido';
                }
                return null;
              },
              onSaved: (value) => _lastName = value!,
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'Fecha de Nacimiento'),
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
                    _dateOfBirth =
                        selectedDate.toLocal().toString().split(' ')[0];
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
              controller: TextEditingController(text: _dateOfBirth),
              // Agrega esta línea para usar un TextEditingController
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu email';
                }
                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
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
              onSaved: (value) => _cellularPhoneNumber = value!,
            ),
            FutureBuilder<List<Country>>(
              future: dbHelper.getCountries(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No hay países disponibles');
                } else {
                  final countryList = snapshot.data!;
                  final countryItems = countryList.map((country) {
                    return DropdownMenuItem<Country>(
                      value: country,
                      child: Text(country.name),
                    );
                  }).toList();
                  return DropdownButtonFormField<Country>(
                    decoration: const InputDecoration(labelText: 'País'),
                    items: countryItems,
                    value: _selectedCountry,
                    onChanged: (Country? country) {
                      setState(() {
                        _selectedCountry = country!;
                        dbHelper.getProvincesByCountry(_selectedCountry!.id).then((provinces) {
                          setState(() {
                            _provincesList = provinces;
                            _provinces = _provincesList.map((province) => province.name).toList();
                            _selectedProvince=null;
                          });
                        });
                      });
                    },
                  );
                }
              },
            ),
            DropdownButtonFormField<Province>(
              decoration: const InputDecoration(labelText: 'Provincia'),
              value: _selectedProvince,
              items: _provincesList.map((province) {
                return DropdownMenuItem<Province>(
                  value: province,
                  child: Text(province.name),
                );
              }).toList(),
              onChanged: (Province? value) {
                setState(() {
                  _selectedProvince = value!;
                });
              },
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

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final people = People(
          name: _name,
          lastName: _lastName,
          dateOfBirth: _dateOfBirth,
          email: _email,
          cellularPhoneNumber: _cellularPhoneNumber,
          idProvince: _selectedProvince!);

      final dbHelper = DatabaseHelper.instance;
      await dbHelper.insertPeople(people);

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
}
