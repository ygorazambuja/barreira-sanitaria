import 'package:flutter/foundation.dart';

class Person {
  String cpf;
  String phone;
  String fullName;
  bool traveler;

  Person({
    @required cpf,
    @required phone,
    @required fullName,
    @required traveler,
  });

  @override
  String toString() {
    return "Cpf: $cpf\nTelefone: $phone, \nNome: $fullName, \nViajante: $traveler";
  }
}
