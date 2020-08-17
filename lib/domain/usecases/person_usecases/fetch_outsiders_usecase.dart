import '../../../repository/abstract/person_repository_abstract.dart';

import '../../entities/person.dart';

class FetchOutsidersUsecase {
  PersonRepositoryAbstract repository;
  FetchOutsidersUsecase({this.repository});

  Future<List<Person>> call() async {
    return await repository.fetchOutsiders();
  }
}
