import 'package:barreira_sanitaria/infra/constants/constants.dart';
import 'package:hasura_connect/hasura_connect.dart';

class HasuraSingletonConnect {
  static HasuraConnect _connection;

  static HasuraConnect get getConnection {
    return _connection??= HasuraConnect(HASURA_URL);
  }

  static void dispose() {
    _connection = null;
  }
}
