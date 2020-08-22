import 'package:barreira_sanitaria/infra/constants/constants.dart';
import 'package:hasura_connect/hasura_connect.dart';

class HasuraSingletonConnect {
  static HasuraConnect _connection;

  static HasuraConnect get getConnection {
    if (_connection == null) {
      _connection = HasuraConnect(HASURA_URL);
      return _connection;
    } else {
      return _connection;
    }
  }

  static void dispose() {
    _connection = null;
  }
}
