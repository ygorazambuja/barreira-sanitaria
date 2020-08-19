import '../entities/registers.dart';

class RegisterHasuraMapper {
  static Map<String, dynamic> toMap(Register register) {
    return {
      'reason': register.reason,
      'exitForecast': register.exitForecast == null
          ? null
          : register.exitForecast.toIso8601String(),
      'occurrenceDate': register.occurrenceDate == null
          ? null
          : register.occurrenceDate.toIso8601String(),
      'isFinalized': register.isFinalized,
      'id': register.id,
    };
  }
}
