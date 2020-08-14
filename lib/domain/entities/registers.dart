import 'package:flutter/foundation.dart';

import 'car.dart';
import 'person.dart';

class Register {
  String id;
  Car car;
  DateTime exitForecast;
  DateTime occurrenceDate;
  List<Person> persons;
  bool isFinalized;

  Register(
      {@required this.id,
      @required this.car,
      @required this.exitForecast,
      @required this.occurrenceDate,
      @required this.isFinalized,
      this.persons});

  @override
  String toString() {
    return "Id: $id, \nexitForecast: $exitForecast,"
        "\noccurrenceDate: $occurrenceDate"
        "\nCar: ${car.plate} ${car.model}"
        "\nisFinalized: $isFinalized";
  }
}
