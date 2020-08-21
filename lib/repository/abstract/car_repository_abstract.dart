import '../../domain/entities/car.dart';

abstract class CarRepositoryAbstract {
  Future<Car> addNewCar(Car car);
  Future<Car> getCarByPlate(String plate);
}
