import 'package:dartz/dartz.dart';

import '../../domain/entities/car.dart';

abstract class CarRepositoryAbstract {
  Future<List<Car>> getAll();
  Future<Either<Exception, void>> addNewCar(Car car);
  Future<Car> getCarByPlate(String plate);
}
