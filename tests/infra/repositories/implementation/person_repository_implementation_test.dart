import 'package:barreira_sanitaria/domain/entities/person.dart';
import 'package:barreira_sanitaria/infra/repositories/implementation/person_repository_implementation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('description', () async {
    final cpfTest = '53';
    final response =
        await PersonRepositoryImplementation().findPersonByPartialCpf(cpfTest);

    expect(response, isA<List<Person>>());
    expect(response[0], isNotNull);
  });
}
