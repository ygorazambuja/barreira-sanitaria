import 'package:barreira_sanitaria/domain/entities/car_with_registers.dart';
import 'package:barreira_sanitaria/domain/mappers/car_with_registers_hasura_mapper.dart';

import '../../../domain/entities/car.dart';
import '../../../domain/mappers/car_json_mapper.dart';
import '../../../repository/abstract/car_repository_abstract.dart';
import '../../hasura_singleton_connect.dart';

class CarRepositoryImplementation extends CarRepositoryAbstract {
  final hasuraConnect = HasuraSingletonConnect.getConnection;

  @override
  Future<Car> addNewCar(Car car) async {
    final existentCar = await getCarByPlate(car.plate);

    if (existentCar == null) {
      final query = '''
      mutation AddNewCar(\$plate: String = "", \$model: String = "") {
        insert_cars(objects: {model: \$model, plate: \$plate}) {
          returning {
            plate
            model
          }
        }
      }
        ''';
      final response = await hasuraConnect.mutation(
        query,
        variables: {
          'plate': car.plate,
          'model': car.model,
        },
      );
      var carJson = CarJsonMapper.fromMap(
          response['data']['insert_cars']['returning'][0]);
      return carJson;
    } else {
      return existentCar;
    }
  }

  @override
  Future<Car> getCarByPlate(String plate) async {
    final query = '''
    query GetCarByPlate(\$_eq: String = "") {
      cars(where: {plate: {_eq: \$_eq}}) {
        plate
        model
      }
    }
    ''';

    final response =
        await hasuraConnect.query(query, variables: {'_eq': plate});

    var cars = response['data']['cars'] as List;
    if (cars.isEmpty) {
      return null;
    } else {
      return CarJsonMapper(
        model: response['data']['cars'][0]['model'],
        plate: response['data']['cars'][0]['plate'],
      );
    }
  }

  @override
  Future<CarWithRegisters> fetchByPlate(String plate) async {
    final query = '''
    query FetchByPlate(\$_eq: String = "") {
      cars(where: {plate: {_eq: \$_eq}}) {
        registers {
          id
          exitForecast
          carPlate
          reason
          occurrenceDate
          isFinalized
        }
        model
        plate
      }
    }
    ''';

    final response =
        await hasuraConnect.query(query, variables: {'_eq': plate});

    return CarWithRegistersHasuraMapper.fromMap(response['data']);
  }
}
