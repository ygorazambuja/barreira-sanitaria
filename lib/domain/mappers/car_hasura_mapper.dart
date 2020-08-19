import '../entities/car.dart';

class CarHasuraMapper {
  static Map<String, dynamic> toMap(Car car) {
    return {
      'car': {
        'data': {'model': car.model, 'plate': car.plate}
      }
    };
  }
}
