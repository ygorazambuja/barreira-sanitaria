import 'package:barreira_sanitaria/domain/entities/car.dart';
import 'package:barreira_sanitaria/infra/repositories/implementation/car_repository_implementation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hasura_connect/hasura_connect.dart';

void main() {
  test('description', () async {
    var car = Car(model: 'Carro5', plate: 'OQP2791');
    final response = await CarRepositoryImplementation().addNewCar(car);
    expect(response, isA<HasuraError>());
    expect(response, isNot(isA<Car>()));
  });
}
