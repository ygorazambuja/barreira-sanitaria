import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/dtos/clean_register_dto.dart';
import '../screens/register_details_screen.dart';

class RegisterCard extends StatelessWidget {
  const RegisterCard({
    Key key,
    @required this.register,
    @required this.occurrenceDate,
    @required this.exitForecast,
  }) : super(key: key);

  final CleanRegisterDto register;
  final DateTime occurrenceDate;
  final DateTime exitForecast;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterDetailsScreen(
                registerId: register.id,
              ),
            ));
      },
      child: Card(
        color: register.isFinalized
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        elevation: 9,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Placa do carro: ${register.carPlate}"),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Data: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(DateFormat(DateFormat.HOUR24_MINUTE)
                          .format(occurrenceDate)),
                      Text(' ás ' +
                          DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br')
                              .format(occurrenceDate))
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
