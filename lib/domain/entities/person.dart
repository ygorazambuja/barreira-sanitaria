import 'package:flutter/foundation.dart';

class Person {
  String cpf;
  String phone;
  String fullName;
  bool traveler;

  Person({
    @required this.cpf,
    @required this.phone,
    @required this.fullName,
    @required this.traveler,
  });

  @override
  String toString() {
    return 'Cpf: $cpf\nTelefone: $phone'
        '\nNome: $fullName'
        '\nViajante: $traveler';
  }
}
