import 'package:flutter/material.dart';
import 'package:qa_automations_app/data/repository/database_repository.dart';
import 'package:qa_automations_app/domain/model/country.dart';
import 'package:qa_automations_app/domain/model/people.dart';
import 'package:qa_automations_app/domain/model/province.dart';
import 'package:qa_automations_app/presentation/pages/people/people_page.dart';

class _LoginData {
  String name = '';
  String lastName = '';
  String email = '';
  String cellularPhoneNumber = '';
  String dateOfBirth = "";

  Country? country;
  Province? province;
}

var defaultCountry = Country(id: -1, name: "Selecciona Pais");
var defaultProvince =
    Province(id: -1, name: "Selecciona Provincia", idCountry: -1);

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final dbHelper = DatabaseRepository.instance;

  final _formKey = GlobalKey<FormState>();
  final _LoginData _data = _LoginData();

  List<Country> _countries = [defaultCountry];
  List<Province> _provinces = [defaultProvince];

  @override
  void initState() {
    initDb();
    super.initState();
  }

  void saveCountry(Country country) {
    _data.country = country;
  }

  void saveProvince(Province province) {
    _data.province = province;
  }

  /// Database

  void initDb() async {
    await DatabaseRepository.instance.database;
    getCountries();
  }

  void getCountries() async {
    await DatabaseRepository.instance.getCountries().then((countries) {
      saveCountry(countries[0]);
      setState(() {
        _countries = countries;
      });
    }).catchError((e) => debugPrint(e.toString()));

    getProvinces();
  }

  void getProvinces() async {
    await DatabaseRepository.instance
        .getProvincesByCountry(_data.country!.id)
        .then((provinces) {
      setState(() {
        _provinces = provinces;
        saveProvince(provinces[0]);
      });
    }).catchError((e) => debugPrint(e.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingrese de Datos'),
        //backgroundColor: lightScheme.onPrimary,
      ),
      body: Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
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
                      onSaved: (value) => {
                        if (value != null) {_data.name = value}
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Apellido'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu apellido';
                        }
                        return null;
                      },
                      onSaved: (value) => {
                        if (value != null) {_data.lastName = value}
                      },
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
                      onSaved: (value) => {
                        if (value != null) {_data.email = value}
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Fecha de Nacimiento'),
                      onTap: () => _selectDate(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu fecha de nacimiento';
                        }
                        return null;
                      },
                      readOnly: true,
                      controller:
                          TextEditingController(text: _data.dateOfBirth),
                      // Agrega esta línea para usar un TextEditingController
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
                      onSaved: (value) => {
                        if (value != null) {_data.cellularPhoneNumber = value}
                      },
                    ),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(labelText: 'País'),
                      value: _countries[0],
                      items: _countries.map((country) {
                        return DropdownMenuItem<Country>(
                          value: country,
                          child: Text(country.name),
                        );
                      }).toList(),
                      onChanged: (Country? country) {
                        if (country != null) {
                          saveCountry(country);
                          getProvinces();
                        }
                      },
                      isDense: true,
                      isExpanded: true,
                    ),
                    DropdownButtonFormField<Province>(
                      decoration: const InputDecoration(labelText: 'Provincia'),
                      value: _provinces[0],
                      items: _provinces.map((province) {
                        return DropdownMenuItem<Province>(
                          value: province,
                          child: Text(province.name),
                        );
                      }).toList(),
                      onChanged: (Province? province) {
                        if (province != null) {
                          saveProvince(province);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _submitForm(context),
                      child: const Text('Ingresar'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PeoplePage(),
                        ));
                      },
                      child: const Text('Ver lista'),
                    )
                  ],
                ),
              ))),
    );
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _showInformationDialog();
    }
  }

  void savePeople() async {
    final people = People(
        name: _data.name,
        lastName: _data.lastName,
        dateOfBirth: _data.dateOfBirth,
        email: _data.email,
        cellularPhoneNumber: _data.cellularPhoneNumber,
        idProvince: _data.province!);

    await DatabaseRepository.instance.insertPeople(people);

    Future.microtask(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PeoplePage(),
        ),
      );
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    var initial = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != initial) {
      setState(() {
        _data.dateOfBirth = picked.toLocal().toString().split(' ')[0];
        ;
      });
    }
  }

  Future<void> _showInformationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Valida tus datos'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Nombre ${_data.name}"),
                Text("Apellidos ${_data.lastName}"),
                Text("Email ${_data.email}"),
                Text("Fecha de Nacimiento ${_data.dateOfBirth}"),
                Text("Telefono ${_data.cellularPhoneNumber}"),
                Text("Pais ${_data.country?.name}"),
                Text("Provincia ${_data.province?.name}")
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                savePeople();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
