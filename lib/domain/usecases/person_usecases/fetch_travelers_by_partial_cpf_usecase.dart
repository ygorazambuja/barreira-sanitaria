import '../../../repository/abstract/person_repository_abstract.dart';

import '../../entities/person.dart';

class FetchTravelersByPartialCpfUsecase {
  final PersonRepositoryAbstract repository;
  final String cpf;

  FetchTravelersByPartialCpfUsecase({this.cpf, this.repository});

  Future<List<Person>> call() async {
    return await repository.findTravelerByPartialCpf(cpf);
  }
}
