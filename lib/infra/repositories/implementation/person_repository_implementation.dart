import '../../../domain/entities/person.dart';
import '../../../domain/mappers/person_json_mapper.dart';
import '../../../repository/abstract/person_repository_abstract.dart';
import '../../hasura_singleton_connect.dart';

class PersonRepositoryImplementation implements PersonRepositoryAbstract {
  final hasuraConnect = HasuraSingletonConnect.getConnection;

  @override
  Future<List<Person>> fetchOutsiders() {
    throw UnimplementedError();
  }

  @override
  Future<List<Person>> fetchResidents() {
    throw UnimplementedError();
  }

  @override
  Future<Person> getPersonByCpf(String cpf) async {
    final query = '''
    query getPersonByCpf(\$cpf: String) {
      persons(where: {cpf: {_eq: \$cpf}}) {
        traveler
        phone
        fullName
        cpf
      }
    }
    ''';

    final response = await hasuraConnect.query(query, variables: {'cpf': cpf});

    var persons = response['data']['persons'] as List;
    if (persons.isEmpty) {
      return null;
    } else {
      return PersonJsonMapper.fromMap(response['data']['persons'][0]);
    }
  }

  @override
  Future<List<Person>> findPersonByPartialCpf(String cpf) async {
    final query = '''
      query findPersonByPartialCpf (\$cpf: String){
        persons(where: {cpf: {_like: "%$cpf%"}}) {
          phone
          fullName
          cpf
          traveler
          }
        }
    ''';
    final response = await hasuraConnect.query(query);
    final persons = <Person>[];

    for (var person in response['data']['persons']) {
      persons.add(PersonJsonMapper.fromMap(person));
    }
    return persons;
  }

  @override
  Future<String> addNewPerson(Person person) async {
    var personAux = await getPersonByCpf(person.cpf);

    if (personAux == null) {
      final mutation = '''
      mutation MyMutation(\$objects: [persons_insert_input!]! = {}) {
        insert_persons(objects: \$objects) {
          returning {
            cpf
          }
        }
      }
    ''';

      var map = {
        'cpf': person.cpf,
        'fullName': person.fullName,
        'traveler': person.traveler,
        'phone': person.phone
      };

      final response = await hasuraConnect
          .mutation(mutation, variables: {'objects': map}).catchError((e) {
        throw e;
      });

      return response['data']['insert_persons']['returning'][0]['cpf'];
    } else {
      return personAux.cpf;
    }
  }

  @override
  Future<List<Person>> findResidentByPartialCpf(String cpf) {
    throw UnimplementedError();
  }

  @override
  Future<List<Person>> findTravelerByPartialCpf(String cpf) async {
    final query = '''
    query MyQuery(\$_eq: String) {
      persons(where: {traveler: {_eq: true}, cpf:{_like: "%$cpf%"}}) {
        cpf
        traveler
        fullName
        phone
      }
    }
''';

    final response = await hasuraConnect.query(query);

    final persons = <Person>[];

    for (var person in response['data']['persons']) {
      persons.add(PersonJsonMapper.fromMap(person));
    }
    return persons;
  }
}
