import 'package:barreira_sanitaria/domain/entities/car_with_registers.dart';
import 'package:barreira_sanitaria/repository/abstract/car_repository_abstract.dart';

class FetchCarWithRegistersUsecases {
  final CarRepositoryAbstract repository;
  final String plate;

  FetchCarWithRegistersUsecases({this.plate, this.repository});

  Future<CarWithRegisters> call() async {
    return await repository.fetchByPlate(plate);
  }
}
