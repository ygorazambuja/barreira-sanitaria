import '../../domain/entities/car.dart';

abstract class CarRepositoryAbstract {
  Future<List<Car>> getAll();
  Future<Car> addNewCar(Car car);
  Future<Car> getCarByPlate(String plate);
}
