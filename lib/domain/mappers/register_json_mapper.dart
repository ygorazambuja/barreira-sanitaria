import 'dart:convert';

import '../entities/car.dart';
import '../entities/person.dart';
import '../entities/registers.dart';
import 'car_json_mapper.dart';
import 'person_json_mapper.dart';

class RegisterJsonMapper extends Register {
  String id;
  Car car;
  DateTime exitForecast;
  DateTime occurrenceDate;
  bool isFinalized;
  List<Person> persons;

  RegisterJsonMapper(
      {this.id,
      this.car,
      this.exitForecast,
      this.occurrenceDate,
      this.persons,
      this.isFinalized});

  Map<String, dynamic> toMap() {
    var carToMap = CarJsonMapper(model: car.model, plate: car.plate).toMap();
    var personsToMap = persons
        .map((e) => PersonJsonMapper(
            cpf: e.cpf,
            fullName: e.fullName,
            phone: e.phone,
            traveler: e.traveler))
        .toList();
    return {
      'id': id,
      'car': carToMap,
      'exitForecast': exitForecast?.millisecondsSinceEpoch,
      'occurrenceDate': occurrenceDate?.millisecondsSinceEpoch,
      'persons': personsToMap,
      'isFinalized': isFinalized
    };
  }

  factory RegisterJsonMapper.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return RegisterJsonMapper(
      id: map['id'],
      isFinalized: map['isFinalized'],
      car: CarJsonMapper.fromMap(map['car']),
      exitForecast: map['exitForecast'] != null
          ? DateTime.parse(map['exitForecast'])
          : null,
      occurrenceDate: DateTime.parse(map['occurrenceDate']),
      persons: List<Person>.from(map['registers_persons']
          ?.map((x) => PersonJsonMapper.fromMap(x['person']))),
    );
  }

  static List<Register> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => RegisterJsonMapper.fromMap(item)).toList();
  }

  String toJson() => json.encode(toMap());
}
