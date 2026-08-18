class Theme {
  const Theme({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  Theme copyWith({
    int? id,
    String? name,
  }) {
    return Theme(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}