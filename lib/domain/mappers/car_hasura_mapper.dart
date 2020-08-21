import '../entities/car.dart';

class CarHasuraMapper {
  static Map<String, dynamic> toMap(Car car) {
    return {
      'car': {
        'data': {'model': car.model, 'plate': car.plate},
        'on_conflict': {'constraint': 'cars_pkey', 'update_columns': 'model'}
      }
    };
  }
}
