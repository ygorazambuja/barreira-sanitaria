import 'dart:convert';

import '../entities/car.dart';

class CarJsonMapper extends Car {
  @override
  String plate;
  @override
  String model;

  CarJsonMapper({
    this.plate,
    this.model,
  });

  Map<String, dynamic> toMap() {
    return {
      'plate': plate,
      'model': model,
    };
  }

  factory CarJsonMapper.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CarJsonMapper(
      plate: map['plate'],
      model: map['model'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CarJsonMapper.fromJson(String source) =>
      CarJsonMapper.fromMap(json.decode(source));
}
