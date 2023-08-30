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
