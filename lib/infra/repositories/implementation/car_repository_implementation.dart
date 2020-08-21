import 'package:hasura_connect/hasura_connect.dart';

import '../../../domain/entities/car.dart';
import '../../../domain/mappers/car_json_mapper.dart';
import '../../../repository/abstract/car_repository_abstract.dart';
import '../../constants/constants.dart';

class CarRepositoryImplementation extends CarRepositoryAbstract {
  HasuraConnect hasuraConnect = HasuraConnect(HASURA_URL);

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
    query MyQuery(\$_eq: String = "") {
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
}
