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
  String reason;
  String exitLocation;
  String enterLocation;

  Register(
      {@required this.id,
      @required this.car,
      @required this.exitForecast,
      @required this.occurrenceDate,
      @required this.isFinalized,
      this.exitLocation,
      this.enterLocation,
      this.reason,
      this.persons});

  @override
  String toString() {
    return 'Id: $id'
        '\nexitForecast: $exitForecast,'
        '\noccurrenceDate: $occurrenceDate'
        '\nCar: ${car.plate} ${car.model}'
        '\nisFinalized: $isFinalized'
        '\nReasons: $reason'
        '\nPersons: $persons'
        '\nEnter Location: $enterLocation'
        '\nExit Location: $exitLocation';
  }
}
