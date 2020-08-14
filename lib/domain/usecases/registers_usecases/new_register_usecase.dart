import 'package:flutter/foundation.dart';

import '../../../repository/abstract/register_repository_abstract.dart';
import '../../entities/registers.dart';

class NewRegisterUseCase {
  Register register;

  NewRegisterUseCase({
    @required this.register,
  });

  void call(RegisterRepositoryAbstract repository) {
    repository.newRegister(register);
  }
}
