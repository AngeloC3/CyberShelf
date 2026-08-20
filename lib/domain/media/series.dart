// lib/domain/media/series.dart
class Series {
  const Series({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  Series copyWith({
    int? id,
    String? name,
  }) {
    return Series(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Series &&
              other.id == id &&
              other.name == name);

  @override
  int get hashCode => Object.hash(id, name);

  @override
  String toString() => 'Series(id: $id, name: $name)';
}