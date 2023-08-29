import 'package:flutter/material.dart';
import 'model.dart';

class DataDisplayScreen extends StatelessWidget {
  final List<People> peopleList;

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
          final people = peopleList[index];
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