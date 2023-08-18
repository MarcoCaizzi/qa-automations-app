class Person {
  final int id;
  final String nombre;
  final String apellido;
  final String fechaNacimiento;
  final String email;
  final String telefono;

  Person({
    required this.id,
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

