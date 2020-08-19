import '../entities/person.dart';

class RegisterPersonsHasuraMapper {
  static Map<String, dynamic> toMap(Person person) {
    return {
      'person': {
        'data': {
          'cpf': person.cpf,
          'fullName': person.fullName,
          'traveler': person.traveler,
          'phone': person.phone
        }
      }
    };
  }

  static Map<String, dynamic> listPersonsToMap(List<Person> persons) {
    var map = {
      'registers_persons': {'data': []},
    };
    map['registers_persons']['data'].clear();

    for (var person in persons) {
      var personMap = RegisterPersonsHasuraMapper.toMap(person);
      map['registers_persons']['data'].add(personMap);
    }
    return map;
  }
}
