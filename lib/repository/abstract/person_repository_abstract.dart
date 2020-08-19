import '../../domain/entities/person.dart';

abstract class PersonRepositoryAbstract {
  Future<List<Person>> fetchOutsiders();
  Future<List<Person>> fetchResidents();
  Future<Person> getPersonByCpf(String cpf);
  Future<List<Person>> findPersonByPartialCpf(String cpf);
  Future<String> addNewPerson(Person person);

  Future<List<Person>> findTravelerByPartialCpf(String cpf);
  Future<List<Person>> findResidentByPartialCpf(String cpf);
}
