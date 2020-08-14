import 'package:flutter/foundation.dart';

import '../../../repository/abstract/register_repository_abstract.dart';
import '../../dtos/clean_register_dto.dart';

class AllCleanRegistersDto {
  RegisterRepositoryAbstract repository;

  AllCleanRegistersDto({
    @required this.repository,
  });

  Future<List<CleanRegisterDto>> call() {
    return repository.fetchCleanRegistersDto();
  }
}
