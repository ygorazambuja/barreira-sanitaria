import 'package:flutter/foundation.dart';

class Car {
  String plate;
  String model;

  Car({
    @required this.plate,
    @required this.model,
  });

  @override
  String toString() {
    return "Plate: $plate, Model: $model";
  }
}
