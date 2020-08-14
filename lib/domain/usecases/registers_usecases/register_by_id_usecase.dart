import 'package:flutter/foundation.dart';

import '../../../repository/abstract/register_repository_abstract.dart';
import '../../entities/registers.dart';

class RegisterByIdUsecase {
  RegisterRepositoryAbstract repository;
  String id;

  RegisterByIdUsecase({
    @required this.repository,
    @required this.id,
  });

  Future<Register> call() async {
    return await repository.getRegisterById(id);
  }
}
