class ExternalId {
  const ExternalId({
    required this.source,
    required this.value,
  });

  final String source;
  final String value;

  ExternalId copyWith({
    String? source,
    String? value,
  }) {
    return ExternalId(
      source: source ?? this.source,
      value: value ?? this.value,
    );
  }
}