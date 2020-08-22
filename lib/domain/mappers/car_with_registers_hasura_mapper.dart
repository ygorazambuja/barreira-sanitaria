import 'package:barreira_sanitaria/domain/dtos/clean_register_dto.dart';
import 'package:barreira_sanitaria/domain/entities/car_with_registers.dart';

class CarWithRegistersHasuraMapper {
  static CarWithRegisters fromMap(Map<String, dynamic> json) {
    // ignore: missing_required_param
    var carWithRegisters = CarWithRegisters();
    carWithRegisters.registers = <CleanRegisterDto>[];
    carWithRegisters.model = json['cars'][0]['model'];
    carWithRegisters.plate = json['cars'][0]['plate'];

    final registers = json['cars'][0]['registers'] as List;

    for (var register in registers) {
      var cleanRegister = CleanRegisterDto.fromMap(register);
      carWithRegisters.registers.add(cleanRegister);
    }
    return carWithRegisters;
  }
}
