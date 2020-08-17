import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../domain/dtos/clean_register_dto.dart';
import 'register_card.dart';

class RegisterCardListBuilder extends StatelessWidget {
  const RegisterCardListBuilder({
    Key key,
    @required this.usecase,
  }) : super(key: key);

  final Future<List<CleanRegisterDto>> usecase;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CleanRegisterDto>>(
      future: usecase,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final register = snapshot.data[index];
                final occurrenceDate = register.occurrenceDate;
                final exitForecast = register.exitForecast;
                initializeDateFormatting('pt_BR', null);
                return RegisterCard(
                    register: register,
                    occurrenceDate: occurrenceDate,
                    exitForecast: exitForecast);
              },
            );
          } else {
            return Center(
              child: Text('Não tem registros sem baixa'),
            );
          }
        } else if (snapshot.hasError) {
          return Text('Houve Algum Erro');
        } else {
          return Text('Erro Inesperado');
        }
      },
    );
  }
}
