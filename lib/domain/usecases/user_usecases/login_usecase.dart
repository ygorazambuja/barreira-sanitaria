import '../../../repository/abstract/user_repository_abstract.dart';
import '../../entities/user.dart';

class LoginUsecase {
  final User user;
  final UserRepositoryAbstract repositoryAbstract;

  LoginUsecase({
    this.user,
    this.repositoryAbstract,
  });

  void call() {
    repositoryAbstract.doLogin();
  }
}
