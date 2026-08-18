class Tag {
  const Tag({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  Tag copyWith({
    int? id,
    String? name,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}