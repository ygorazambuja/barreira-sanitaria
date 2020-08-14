import 'package:hasura_connect/hasura_connect.dart';

import '../../../domain/dtos/clean_register_dto.dart';
import '../../../domain/entities/registers.dart';
import '../../../domain/mappers/register_json_mapper.dart';
import '../../../repository/abstract/register_repository_abstract.dart';
import '../../constants/constants.dart';

class RegisterRepositoryImplementation implements RegisterRepositoryAbstract {
  final hasuraConnect = HasuraConnect(HASURA_URL,
      localStorageDelegate: () => LocalStorageSharedPreferences());

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
  Future<void> newRegister(Register register) {
    final query = """
      mutation  { 
        insert_register(object: {

        })
      }

    """;
    hasuraConnect.mutation(query);
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
}
