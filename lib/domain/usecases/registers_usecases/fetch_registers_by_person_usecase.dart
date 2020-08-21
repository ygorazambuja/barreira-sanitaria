import 'package:barreira_sanitaria/domain/dtos/clean_register_dto.dart';
import 'package:barreira_sanitaria/domain/entities/person.dart';
import 'package:barreira_sanitaria/repository/abstract/register_repository_abstract.dart';
import 'package:flutter/foundation.dart';

class FetchRegistersByPersonUsecase {
  final Person person;
  final RegisterRepositoryAbstract repository;

  FetchRegistersByPersonUsecase(
      {@required this.person, @required this.repository});

  Future<List<CleanRegisterDto>> call() async {
    return await repository.fetchRegistersByPerson(person.cpf);
  }
}
