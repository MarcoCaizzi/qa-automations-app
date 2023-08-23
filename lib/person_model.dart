class Person {
  int? id;
  String nombre;
  String apellido;
  String fechaNacimiento;
  String email;
  String telefono;

  Person({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.fechaNacimiento,
    required this.email,
    required this.telefono,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'fechaNacimiento': fechaNacimiento,
      'email': email,
      'telefono': telefono,
    };
  }
}

