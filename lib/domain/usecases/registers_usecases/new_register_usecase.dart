import 'package:flutter/foundation.dart';

import '../../../infra/repositories/implementation/register_repository_implementation.dart';
import '../../entities/registers.dart';

class NewRegisterUseCase {
  final Register register;
  final RegisterRepositoryImplementation repository;

  NewRegisterUseCase({
    @required this.register,
    @required this.repository,
  });

  Future<String> call() async {
    return await repository.newRegister(register);
  }
}
