import 'package:hasura_connect/hasura_connect.dart';
import '../../../domain/entities/person.dart';
import '../../../domain/mappers/person_json_mapper.dart';
import '../../../repository/abstract/person_repository_abstract.dart';
import '../../constants/constants.dart';

class PersonRepositoryImplementation implements PersonRepositoryAbstract {
  final HasuraConnect hasuraConnect = HasuraConnect(HASURA_URL,
      localStorageDelegate: () => LocalStorageSharedPreferences());
  @override
  Future<List<Person>> fetchOutsiders() {
    // TODO: implement fetchOutsiders
    throw UnimplementedError();
  }

  @override
  Future<List<Person>> fetchResidents() {
    // TODO: implement fetchResidents
    throw UnimplementedError();
  }

  @override
  Future<Person> getPersonByCpf(String cpf) async {
    final query = """
    query getPersonByCpf(\$cpf: String) {
      persons(where: {cpf: {_eq: \$cpf}}) {
        traveler
        phone
        fullName
        cpf
      }
    }
    """;

    final response = await hasuraConnect.query(query, variables: {'cpf': cpf});
    print(response);
    return PersonJsonMapper.fromMap(response['data']['persons'][0]);
  }

  @override
  Future<List<Person>> findPersonByPartialCpf(String cpf) async {
    final query = """
      query findPersonByPartialCpf (\$cpf: String){
        persons(where: {cpf: {_similar: "%$cpf%"}}) {
          phone
          fullName
          cpf
          traveler
          }
        }
    """;
    final response = await hasuraConnect.query(query, variables: {'cpf': cpf});
    final persons = <Person>[];

    for (var person in response['data']['persons']) {
      persons.add(PersonJsonMapper.fromMap(person));
    }
    return persons;
  }
}
