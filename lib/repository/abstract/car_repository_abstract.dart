import 'package:barreira_sanitaria/domain/entities/car_with_registers.dart';

import '../../domain/entities/car.dart';

abstract class CarRepositoryAbstract {
  Future<Car> addNewCar(Car car);
  Future<Car> getCarByPlate(String plate);
  Future<CarWithRegisters> fetchByPlate(String plate);
}
