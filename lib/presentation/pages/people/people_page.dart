import 'package:flutter/material.dart';
import 'package:qa_automations_app/data/repository/database_repository.dart';
import 'package:qa_automations_app/domain/model/people.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  List<People> _peoples = [];

  void initDb() async {
    await DatabaseRepository.instance.database;
    getPeople();
  }

  void getPeople() async {
    await DatabaseRepository.instance.getPeople().then((peoples) {
      setState(() {
        _peoples = peoples;
      });
    }).catchError((e) => debugPrint(e.toString()));
  }

  @override
  void initState() {
    initDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista')),
      body: ListView.builder(
        itemCount: _peoples.length,
        itemBuilder: (context, index) {
          final people = _peoples[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('${people.name} ${people.lastName}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fecha de Nacimiento: ${people.dateOfBirth}'),
                  Text('Email: ${people.email}'),
                  Text('Teléfono: ${people.cellularPhoneNumber}'),
                  Text('Provincia: ${people.idProvince.name}')
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
