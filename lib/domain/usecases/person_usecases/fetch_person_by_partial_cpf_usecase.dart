import 'package:barreira_sanitaria/domain/entities/person.dart';
import 'package:barreira_sanitaria/repository/abstract/person_repository_abstract.dart';

class FetchPersonByPartialCpfUsecase {
  final PersonRepositoryAbstract repository;
  final String cpf;
  FetchPersonByPartialCpfUsecase({this.repository, this.cpf});

  Future<List<Person>> call() async {
    return await repository.findPersonByPartialCpf(cpf);
  }
}
