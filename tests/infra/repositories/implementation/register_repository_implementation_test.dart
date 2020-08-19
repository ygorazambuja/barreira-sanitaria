import 'package:barreira_sanitaria/domain/entities/car.dart';
import 'package:barreira_sanitaria/domain/entities/person.dart';
import 'package:barreira_sanitaria/domain/entities/registers.dart';
import 'package:barreira_sanitaria/domain/usecases/registers_usecases/new_register_usecase.dart';
import 'package:barreira_sanitaria/infra/repositories/implementation/register_repository_implementation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('add new register', () async {
    var car = Car(model: 'dasdassad', plate: 'DASDASDAS');

    var person1 = Person(
        cpf: '12141241221',
        fullName: 'Nome Completo',
        phone: '14124121241',
        traveler: false);

    var person2 = Person(
        cpf: '12146641221',
        fullName: 'Nome Completo 2',
        phone: '6878487676',
        traveler: true);

    var register = Register(
      car: car,
      exitForecast: DateTime.now().add(Duration(days: 2)),
      isFinalized: false,
      id: Uuid().v4(),
      reason: 'Varias razões',
      occurrenceDate: DateTime.now(),
      persons: [person1, person2],
    );
    NewRegisterUseCase(
        register: register, repository: RegisterRepositoryImplementation())();
  });
}
