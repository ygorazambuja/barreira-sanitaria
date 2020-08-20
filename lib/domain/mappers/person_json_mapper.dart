import 'dart:convert';

import '../entities/person.dart';

class PersonJsonMapper extends Person {
  @override
  String cpf;
  @override
  String phone;
  @override
  String fullName;
  @override
  bool traveler;

  PersonJsonMapper({
    this.cpf,
    this.phone,
    this.fullName,
    this.traveler,
  });

  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'phone': phone,
      'full_name': fullName,
      'traveler': traveler,
    };
  }

  factory PersonJsonMapper.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return PersonJsonMapper(
      cpf: map['cpf'],
      phone: map['phone'],
      fullName: map['fullName'],
      traveler: map['traveler'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonJsonMapper.fromJson(String source) =>
      PersonJsonMapper.fromMap(json.decode(source));
}
