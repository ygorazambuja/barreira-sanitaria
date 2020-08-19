import '../../../repository/abstract/person_repository_abstract.dart';
import '../../entities/person.dart';

class FetchPersonByCpf {
  final PersonRepositoryAbstract repository;
  final String cpf;
  FetchPersonByCpf({this.repository, this.cpf});

  Future<Person> call() async {
    return await repository.getPersonByCpf(cpf);
  }
}
