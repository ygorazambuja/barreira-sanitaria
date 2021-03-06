import '../../../repository/abstract/person_repository_abstract.dart';
import '../../entities/person.dart';

class FetchPersonByPartialCpfUsecase {
  final PersonRepositoryAbstract repository;
  final String cpf;
  FetchPersonByPartialCpfUsecase({this.repository, this.cpf});

  Future<List<Person>> call() async {
    return await repository.findPersonByPartialCpf(cpf);
  }
}
