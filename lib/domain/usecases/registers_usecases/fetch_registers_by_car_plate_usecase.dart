import 'package:barreira_sanitaria/domain/dtos/clean_register_dto.dart';
import 'package:barreira_sanitaria/repository/abstract/register_repository_abstract.dart';
import 'package:flutter/foundation.dart';

class FetchRegistersByCarPlateUsecase {
  final RegisterRepositoryAbstract repository;
  final String plate;

  FetchRegistersByCarPlateUsecase({
    @required this.repository,
    @required this.plate,
  });

  Future<List<CleanRegisterDto>> call() async {
    return await repository.fetchCleanRegisterByCarPlate(plate);
  }
}
