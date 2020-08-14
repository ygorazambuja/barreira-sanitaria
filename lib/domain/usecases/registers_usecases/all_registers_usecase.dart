import 'package:flutter/foundation.dart';

import '../../../repository/abstract/register_repository_abstract.dart';
import '../../entities/registers.dart';

class AllRegistersUsecase {
  List<Register> registers;

  final RegisterRepositoryAbstract repositoryAbstract;

  AllRegistersUsecase({
    @required this.repositoryAbstract,
  });

  Future<List<Register>> call() {
    return repositoryAbstract.getAll();
  }
}
