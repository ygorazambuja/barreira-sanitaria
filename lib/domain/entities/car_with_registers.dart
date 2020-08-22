import 'package:barreira_sanitaria/domain/entities/registers.dart';
import 'package:flutter/foundation.dart';

import 'car.dart';

class CarWithRegisters extends Car {
  @override
  String plate;
  @override
  String model;

  List<Register> registers;

  CarWithRegisters({
    @required this.plate,
    @required this.model,
  });
}
