import 'package:flutter_test/flutter_test.dart';
import 'package:cybershelf/domain/media/contributor.dart';

void main() {
  group('Contributor', () {
    test('can represent a person contributor', () {
      const contributor = Contributor(
        id: 1,
        personId: 10,
      );

      expect(contributor.id, 1);
      expect(contributor.personId, 10);
      expect(contributor.companyId, null);
      expect(contributor.isPerson, isTrue);
      expect(contributor.isCompany, isFalse);
    });

    test('can represent a company contributor', () {
      const contributor = Contributor(
        id: 2,
        companyId: 20,
      );

      expect(contributor.id, 2);
      expect(contributor.personId, null);
      expect(contributor.companyId, 20);
      expect(contributor.isPerson, isFalse);
      expect(contributor.isCompany, isTrue);
    });

    test('requires either a person or company', () {
      expect(
            () => Contributor(id: 1),
        throwsA(isA<AssertionError>()),
      );
    });

    test('does not allow both a person and company', () {
      expect(
            () => Contributor(
          id: 1,
          personId: 10,
          companyId: 20,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('equality - same values are equal', () {
      const contributor1 = Contributor(
        id: 1,
        personId: 10,
      );

      const contributor2 = Contributor(
        id: 1,
        personId: 10,
      );

      expect(contributor1, equals(contributor2));
      expect(contributor1.hashCode, equals(contributor2.hashCode));
    });

    test('equality - different ids are not equal', () {
      const contributor1 = Contributor(
        id: 1,
        personId: 10,
      );

      const contributor2 = Contributor(
        id: 2,
        personId: 10,
      );

      expect(contributor1, isNot(equals(contributor2)));
    });

    test('equality - different personIds are not equal', () {
      const contributor1 = Contributor(
        id: 1,
        personId: 10,
      );

      const contributor2 = Contributor(
        id: 1,
        personId: 20,
      );

      expect(contributor1, isNot(equals(contributor2)));
    });

    test('equality - person vs company are not equal', () {
      const contributor1 = Contributor(
        id: 1,
        personId: 10,
      );

      const contributor2 = Contributor(
        id: 1,
        companyId: 10,
      );

      expect(contributor1, isNot(equals(contributor2)));
    });
  });
}