import '../entities/registers.dart';

class CleanRegisterDto extends Register {
  String carPlate;
  String id;
  DateTime exitForecast;
  DateTime occurrenceDate;

  CleanRegisterDto({
    this.carPlate,
    this.id,
    this.exitForecast,
    this.occurrenceDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'carPlate': carPlate,
      'id': id,
      'exitForecast': exitForecast?.millisecondsSinceEpoch,
      'occurrenceDate': occurrenceDate?.millisecondsSinceEpoch,
    };
  }

  factory CleanRegisterDto.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CleanRegisterDto(
      carPlate: map['carPlate'],
      id: map['id'],
      exitForecast: map['exitForecast'] != null
          ? DateTime.parse(map['exitForecast'])
          : null,
      occurrenceDate: map['occurrenceDate'] != null
          ? DateTime.parse(map['occurrenceDate'])
          : null,
    );
  }
}
