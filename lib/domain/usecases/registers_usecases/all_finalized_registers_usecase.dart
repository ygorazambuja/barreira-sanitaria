import 'package:flutter/foundation.dart';

import '../../../repository/abstract/register_repository_abstract.dart';

import '../../dtos/clean_register_dto.dart';

class AllFinalizedRegisterUsecase {
  final RegisterRepositoryAbstract repository;
  AllFinalizedRegisterUsecase({
    @required this.repository,
  });

  Future<List<CleanRegisterDto>> call() async {
    return await repository.fetchFinalizedCleanRegistersDto();
  }
}
