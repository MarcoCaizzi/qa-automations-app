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


class Country {
  int id;
  String name;

  Country({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Country && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Province {
  int id;
  String name;
  int idCountry;

  Province({
    required this.id,
    required this.name,
    required this.idCountry,
  });
}
