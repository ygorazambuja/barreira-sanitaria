import 'package:hasura_connect/hasura_connect.dart';

import '../../../domain/dtos/clean_register_dto.dart';
import '../../../domain/entities/registers.dart';
import '../../../domain/mappers/car_hasura_mapper.dart';
import '../../../domain/mappers/register_hasura_mapper.dart';
import '../../../domain/mappers/register_json_mapper.dart';
import '../../../domain/mappers/registers_persons_hasura_mapper.dart';
import '../../../repository/abstract/register_repository_abstract.dart';
import '../../constants/constants.dart';
import 'person_repository_implementation.dart';

class RegisterRepositoryImplementation implements RegisterRepositoryAbstract {
  final hasuraConnect = HasuraConnect(HASURA_URL);

  @override
  Future<List<Register>> getAll() async {
    final query = """
    subscription {
  registers {
    id
    exitForecast
    occurrenceDate
    car {
      plate
      model
    }
    registers_persons {
      person {
        cpf
        fullName
        phone
        traveler
      }
    }
  }
}
    """;

    final response = await hasuraConnect.query(query);
    final registersJson = response['data']['registers'] as List;

    var registers = <Register>[];
    for (var registerJson in registersJson) {
      registers.add(RegisterJsonMapper.fromMap(registerJson));
    }
    return registers;
  }

  @override
  Future<Register> getRegisterById(String id) async {
    final _query = """
      query {
        registers(where: {id: {_eq: "$id"}}) {
        car {
          plate
          model
        }
        isFinalized
        exitForecast
        id
        occurrenceDate
        registers_persons {
          person {
          cpf
          fullName
          phone
          traveler
          }
        }
      }
    }""";

    final response = await hasuraConnect.query(_query);
    if (response == null) {
      throw HasuraError('dasdas', null);
    }
    final register = response['data']['registers'][0];
    return RegisterJsonMapper.fromMap(register);
  }

  @override
  Future<void> newRegisterAux(Register register) async {
    for (var person in register.persons) {
      PersonRepositoryImplementation().addNewPerson(person);
    }

    final registerMutation = """
      mutation MyMutation(\$model: String, \$plate:String, \$exitForecast: timestamptz, \$id: uuid, \$occurrenceDate: timestamp, \$reason:String, \$isFinalized: Boolean) {
        insert_registers(objects: {car: {data: {model: \$model, plate: \$plate}}, isFinalized: \$isFinalized, reason: \$reason, occurrenceDate: \$occurrenceDate, exitForecast: \$exitForecast, id: \$id}) {
          affected_rows
        }
      }
    """;

    final response = await hasuraConnect.mutation(
      registerMutation,
      variables: {
        'plate': register.car.plate,
        'model': register.car.model,
        'exitForecast': register.exitForecast == null
            ? null
            : register.exitForecast.toIso8601String(),
        'occurrenceDate': register.occurrenceDate.toIso8601String(),
        'id': register.id,
        'isFinalized': register.isFinalized,
        'reason': register.reason
      },
    );

    var affectedRows =
        int.parse(response['data']['insert_registers']['affected_rows']);
    if (affectedRows > 0) {}
  }

  @override
  Future<List<CleanRegisterDto>> fetchCleanRegistersDto() async {
    final query = """
    query {
      registers {
        carPlate
        exitForecast
        id
        occurrenceDate
        isFinalized
      }
    }
    """;

    final response = await hasuraConnect.query(query);
    final registersJson = response['data']['registers'] as List;

    var registers = <CleanRegisterDto>[];
    for (var registerJson in registersJson) {
      registers.add(CleanRegisterDto.fromMap(registerJson));
    }
    return registers;
  }

  @override
  Future<List<CleanRegisterDto>> fetchFinalizedCleanRegistersDto() async {
    final query = """
    query finalized {
      registers(where: {isFinalized: {_eq: true}}) {
        id
        exitForecast
        carPlate
        occurrenceDate
        isFinalized
      }
    }
""";

    final response = await hasuraConnect.query(query);
    final registersJson = response['data']['registers'] as List;

    var registers = <CleanRegisterDto>[];
    for (var registerJson in registersJson) {
      registers.add(CleanRegisterDto.fromMap(registerJson));
    }
    return registers;
  }

  @override
  Future<List<CleanRegisterDto>> fetchNonFinalizedCleanRegistersDto() async {
    final query = """
    query finalized {
      registers(where: {isFinalized: {_eq: false}}) {
        id
        exitForecast
        carPlate
        occurrenceDate
        isFinalized
      }
    }
""";

    final response = await hasuraConnect.query(query);
    final registersJson = response['data']['registers'] as List;

    var registers = <CleanRegisterDto>[];
    for (var registerJson in registersJson) {
      registers.add(CleanRegisterDto.fromMap(registerJson));
    }
    return registers;
  }

  @override
  Future<int> finalizeRegister(String _eq) async {
    final query = """
    mutation MyMutation(\$_eq: uuid) {
      update_registers(where: {id: {_eq: \$_eq}}, _set: {isFinalized: true}) {
        affected_rows
      }
    }
    """;
    final response =
        await hasuraConnect.mutation(query, variables: {'_eq': _eq});
    final int affectedRows =
        response['data']['update_registers']['affected_rows'];
    return affectedRows;
  }

  void testInsertion(Register register) async {
    final query = """
    mutation MyMutation(\$objects: [registers_insert_input!]! = {}) {
      insert_registers(objects: \$objects) {
        affected_rows
      }
    }

""";

    final response = await hasuraConnect.mutation(query, variables: {
      "objects": {
        "car": {
          "data": {"model": "86538ertyeyre5368", "plate": "rytr"}
        },
        "reason": "asuhdiasuhdasudas",
        "exitForecast": null,
        "occurrenceDate": "2020-08-18T02:41:26+00:00",
        "isFinalized": true,
        "id": "e954e761-e99a-4fce-9eaa-1efba592d056",
        "registers_persons": {
          "data": [
            {
              "person": {
                "data": {
                  "cpf": "1462684178",
                  "fullName": "Pessoa807!08",
                  "traveler": false,
                  "phone": "012673190264"
                }
              }
            },
            {
              "person": {
                "data": {
                  "cpf": "182813694612",
                  "fullName": "Pessoa 123",
                  "traveler": true,
                  "phone": "1286134895"
                }
              }
            }
          ]
        }
      }
    });
    print(response);
  }

  @override
  Future<String> newRegister(Register register) async {
    final mutation = """
        mutation MyMutation(\$objects: [registers_insert_input!]! = {}) {
          insert_registers(objects: \$objects) {
            returning {
              id
            }
          }
        }
    """;

    var objects = <String, dynamic>{};
    objects.addAll(CarHasuraMapper.toMap(register.car));
    objects
        .addAll(RegisterPersonsHasuraMapper.listPersonsToMap(register.persons));

    objects.addAll(RegisterHasuraMapper.toMap(register));

    final response =
        await hasuraConnect.mutation(mutation, variables: {"objects": objects});

    return response['data']['insert_registers']['returning'][0]['id']
        .toString();

    // var insertedRegister = await getRegisterById(
    //     response['data']['insert_registers']['returning']['id'] as String);
    // return insertedRegister;
  }
}
