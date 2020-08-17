import '../../domain/entities/person.dart';

abstract class PersonRepositoryAbstract {
  Future<List<Person>> fetchOutsiders();
  Future<List<Person>> fetchResidents();

  Future<Person> getPersonByCpf(String cpf);
  Future<List<Person>> findPersonByPartialCpf(String cpf);
}
