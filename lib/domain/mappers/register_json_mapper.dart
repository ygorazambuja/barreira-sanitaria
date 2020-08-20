import 'dart:convert';

import '../entities/car.dart';
import '../entities/person.dart';
import '../entities/registers.dart';
import 'car_json_mapper.dart';
import 'person_json_mapper.dart';

class RegisterJsonMapper extends Register {
  @override
  String id;
  @override
  Car car;
  @override
  DateTime exitForecast;
  @override
  DateTime occurrenceDate;
  @override
  bool isFinalized;
  @override
  List<Person> persons;
  @override
  String reason;

  RegisterJsonMapper(
      {this.id,
      this.car,
      this.exitForecast,
      this.occurrenceDate,
      this.persons,
      this.reason,
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
      'registers_persons': personsToMap.map((e) => {
            'person': {'data': e}
          }),
      'isFinalized': isFinalized
    };
  }

  factory RegisterJsonMapper.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return RegisterJsonMapper(
      id: map['id'],
      isFinalized: map['isFinalized'],
      reason: map['reason'],
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
