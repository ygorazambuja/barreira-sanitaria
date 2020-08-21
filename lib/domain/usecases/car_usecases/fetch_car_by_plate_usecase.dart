import 'package:barreira_sanitaria/domain/entities/car.dart';
import 'package:barreira_sanitaria/repository/abstract/car_repository_abstract.dart';

class FetchCarByPlateUsecase {
  final String plate;
  final CarRepositoryAbstract repository;

  FetchCarByPlateUsecase({this.plate, this.repository});

  Future<Car> call() async {
    return await repository.getCarByPlate(plate);
  }
}
