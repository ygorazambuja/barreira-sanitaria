import 'package:dartz/dartz.dart';
import 'package:hasura_connect/hasura_connect.dart';

import '../../../domain/entities/car.dart';
import '../../../repository/abstract/car_repository_abstract.dart';
import '../../constants/constants.dart';

class CarRepositoryImplementation extends CarRepositoryAbstract {
  HasuraConnect hasuraConnect = HasuraConnect(HASURA_URL,
      localStorageDelegate: () => LocalStorageSharedPreferences());

  @override
  Future<Either<Exception, void>> addNewCar(Car car) {
    final query = """
      mutation AddNewCar {
        insert_registers(objects: {car: {data: {model: "${car.model}", plate: "${car.plate}"}}}) {
        affected_rows
        }
      }
""";
  }

  @override
  Future<List<Car>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Car> getCarByPlate(String plate) {
    // TODO: implement getCarByPlate
    throw UnimplementedError();
  }
}
