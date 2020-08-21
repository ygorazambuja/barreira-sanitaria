import 'package:hasura_connect/hasura_connect.dart';

import '../../../domain/dtos/clean_register_dto.dart';
import '../../../domain/entities/registers.dart';
import '../../../domain/mappers/car_hasura_mapper.dart';
import '../../../domain/mappers/register_hasura_mapper.dart';
import '../../../domain/mappers/register_json_mapper.dart';
import '../../../domain/mappers/registers_persons_hasura_mapper.dart';
import '../../../repository/abstract/register_repository_abstract.dart';
import '../../constants/constants.dart';

class RegisterRepositoryImplementation implements RegisterRepositoryAbstract {
  final hasuraConnect = HasuraConnect(HASURA_URL);

  @override
  Future<List<Register>> getAll() async {
    final query = '''
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
    ''';

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
    final _query = '''
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
        reason
        registers_persons {
          person {
          cpf
          fullName
          phone
          traveler
          }
        }
      }
    }''';

    final response = await hasuraConnect.query(_query);
    if (response == null) {
      throw HasuraError('dasdas', null);
    }
    final register = response['data']['registers'][0];
    return RegisterJsonMapper.fromMap(register);
  }

  @override
  Future<List<CleanRegisterDto>> fetchCleanRegistersDto() async {
    final query = '''
    query {
      registers {
        carPlate
        exitForecast
        id
        occurrenceDate
        isFinalized
      }
    }
    ''';

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
    final query = '''
    query finalized {
      registers(where: {isFinalized: {_eq: true}}) {
        id
        exitForecast
        carPlate
        occurrenceDate
        isFinalized
      }
    }
''';

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
    final query = '''
    query finalized {
      registers(where: {isFinalized: {_eq: false}}) {
        id
        exitForecast
        carPlate
        occurrenceDate
        isFinalized
      }
    }
''';

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
    final query = '''
    mutation MyMutation(\$_eq: uuid) {
      update_registers(where: {id: {_eq: \$_eq}}, _set: {isFinalized: true}) {
        affected_rows
      }
    }
    ''';
    final response =
        await hasuraConnect.mutation(query, variables: {'_eq': _eq});
    final int affectedRows =
        response['data']['update_registers']['affected_rows'];
    return affectedRows;
  }

  @override
  Future<String> newRegister(Register register) async {
    final mutation = '''
        mutation MyMutation(\$objects: [registers_insert_input!]! = {}) {
          insert_registers(objects: \$objects) {
            returning {
              id
            }
          }
        }
    ''';

    var objects = <String, dynamic>{};
    objects.addAll(CarHasuraMapper.toMap(register.car));
    objects
        .addAll(RegisterPersonsHasuraMapper.listPersonsToMap(register.persons));

    objects.addAll(RegisterHasuraMapper.toMap(register));

    final response =
        await hasuraConnect.mutation(mutation, variables: {'objects': objects});

    return response['data']['insert_registers']['returning'][0]['id']
        .toString();

    // var insertedRegister = await getRegisterById(
    //     response['data']['insert_registers']['returning']['id'] as String);
    // return insertedRegister;
  }

  @override
  Future<List<CleanRegisterDto>> fetchCleanRegisterByCarPlate(
      String plate) async {
    final query = '''
    query MyQuery(\$_eq: String) {
      registers(where: {carPlate: {_eq: \$_eq}}) {
        carPlate
        exitForecast
        id
        isFinalized
        occurrenceDate
      }
    }

    ''';

    final response =
        await hasuraConnect.query(query, variables: {'_eq': plate});
    final registersJson = response['data']['registers'] as List;

    var registers = <CleanRegisterDto>[];
    for (var registerJson in registersJson) {
      registers.add(CleanRegisterDto.fromMap(registerJson));
    }
    return registers;
  }

  @override
  Future<List<CleanRegisterDto>> fetchRegistersByPerson(String cpf) async {
    final query = '''
    query MyQuery(\$_eq: String) {
      persons(where: {cpf: {_eq: \$_eq}}) {
        registers_persons {
          register {
            exitForecast
            carPlate
            id
            isFinalized
            occurrenceDate
            reason
          }
        }
      }
    }
    ''';

    final response = await hasuraConnect.query(query, variables: {'_eq': cpf});
    final registersJson =
        response['data']['persons'][0]['registers_persons'] as List;

    var registers = <CleanRegisterDto>[];
    for (var register in registersJson) {
      registers.add(CleanRegisterDto.fromMap(register['register']));
    }
    return registers;
  }

  @override
  Stream<int> lengthNonFinalizedRegister() {
    final subscription = '''
    subscription MyQuery {
      registers(where: {isFinalized: {_eq: false}}) {
        id
        isFinalized
      }
    }
''';

    try {
      var snapshot = hasuraConnect.subscription(subscription);

      return snapshot.map((event) {
        var registers = event['data']['registers'] as List;
        return registers.length;
      });
      // snapshot.listen((event) {
      //   var registers = event['data']['registers'] as List;
      //   return registers.length;
      // });
    } on HasuraError catch (e) {
      print('LOGX ==:>> ERROR[getDebts]');
      print(e);
      print(e.extensions);
      print('=================');
      return null;
    }
  }
}

// TODO Inserir mesmas pessoas, com o mesmo carro, porem registros diferentes
