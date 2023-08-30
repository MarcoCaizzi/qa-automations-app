import 'province.dart';

class People {
  int? id;
  String name;
  String lastName;
  String dateOfBirth;
  String email;
  String cellularPhoneNumber;
  Province idProvince;

  People({
    this.id,
    required this.name,
    required this.lastName,
    required this.dateOfBirth,
    required this.email,
    required this.cellularPhoneNumber,
    required this.idProvince,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'cellularPhoneNumber': cellularPhoneNumber,
      'idProvince': idProvince.id,
    };
  }
}