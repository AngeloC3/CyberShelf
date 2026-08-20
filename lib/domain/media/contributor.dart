class Contributor {
  const Contributor({
    required this.id,
    this.personId,
    this.companyId,
  }) : assert(
  (personId != null) ^ (companyId != null),
  'A contributor must reference either a person or a company.',
  );

  final int id;
  final int? personId;
  final int? companyId;

  bool get isPerson => personId != null;
  bool get isCompany => companyId != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Contributor &&
              id == other.id &&
              personId == other.personId &&
              companyId == other.companyId;

  @override
  int get hashCode => Object.hash(id, personId, companyId);
}