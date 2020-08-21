import 'package:barreira_sanitaria/infra/repositories/implementation/person_repository_implementation.dart';
import 'package:barreira_sanitaria/presenters/screens/person_details_screen.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/person.dart';
import '../../domain/entities/registers.dart';
import '../../domain/usecases/registers_usecases/register_by_id_usecase.dart';
import '../../infra/repositories/implementation/register_repository_implementation.dart';
import '../../repository/abstract/register_repository_abstract.dart';
import '../../shared/custom_bottom_app_bar.dart';
import '../../shared/shared_main_drawer.dart';
import '../../utils/cpf_formatter.dart';
import '../components/title_top.dart';

class RegisterDetailsScreen extends StatelessWidget {
  final String registerId;

  RegisterDetailsScreen({this.registerId});

  final RegisterRepositoryAbstract repository =
      RegisterRepositoryImplementation();

  final _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      bottomNavigationBar: CustomBottomAppBar(
        scaffoldState: _scaffoldState,
      ),
      drawer: SharedMainDrawer(),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            TitleTop(
              title: 'Detalhes do Registro',
            ),
            _RegisterDetails(repository: repository, registerId: registerId)
          ],
        ),
      ),
    );
  }
}

class _RegisterDetails extends StatelessWidget {
  const _RegisterDetails({
    Key key,
    @required this.repository,
    @required this.registerId,
  }) : super(key: key);

  final RegisterRepositoryAbstract repository;
  final String registerId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Register>(
      future: RegisterByIdUsecase(repository: repository, id: registerId)(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final register = snapshot.data;
          return Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        trailing: Icon(Icons.arrow_forward),
                        leading: Icon(Icons.car_rental),
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container();
                              });
                        },
                        title:
                            Text('Placa do Carro: ${snapshot.data.car.plate}'),
                        subtitle: Text('Modelo: ${snapshot.data.car.model}'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      leading: Icon(Icons.schedule),
                      title: Text(
                          'Data: ${DateFormat(DateFormat.MONTH_WEEKDAY_DAY, "pt_BR").format(register.occurrenceDate)}'),
                      subtitle: Text(
                          'Horario: ${DateFormat(DateFormat.HOUR24_MINUTE).format(register.occurrenceDate)}'),
                    ),
                  ),
                ),
              ),
              register.reason != null
                  ? Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                            leading: Icon(Icons.card_travel),
                            title: Text('Motivos da Visita'),
                            subtitle: Text(register.reason)),
                      ),
                    )
                  : Container(),
              register.isFinalized ? Container() : FinalizedButtonStatus(),
              snapshot.hasData && register.persons != null
                  ? PassengerList(
                      passengers: register.persons,
                    )
                  : Container()
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class FinalizedButtonStatus extends StatelessWidget {
  final String registerId;
  const FinalizedButtonStatus({Key key, this.registerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton.icon(
        color: Colors.blueAccent,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(20),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Desejar dar baixa na placa'
                        ' e finalizar o cadastro?',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RaisedButton.icon(
                          icon: Icon(Icons.done),
                          label: Text('Sim'),
                          onPressed: () async {
                            await RegisterRepositoryImplementation()
                                .finalizeRegister(registerId);
                            BotToast.showNotification(
                              title: (cancelFunc) =>
                                  Text('Registro foi baixado com sucesso'),
                            );
                            await Navigator.pushNamed(context, '/');
                          },
                        ),
                        RaisedButton.icon(
                          icon: Icon(Icons.close),
                          label: Text('Não'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
        icon: Icon(Icons.done_outline),
        label: Text('Dar baixa'));
  }
}

class PassengerList extends StatelessWidget {
  const PassengerList({
    Key key,
    @required this.passengers,
  }) : super(key: key);

  final List<Person> passengers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(
            'Envolvidos',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                height: 10,
              );
            },
            shrinkWrap: true,
            itemCount: passengers.length,
            itemBuilder: (context, index) {
              final passenger = passengers[index];
              return PassengerCard(passenger: passenger);
            },
          ),
        ),
      ],
    );
  }
}

class PassengerCard extends StatelessWidget {
  const PassengerCard({
    Key key,
    @required this.passenger,
  }) : super(key: key);

  final Person passenger;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white10),
      alignment: Alignment.center,
      child: ListTile(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                  child: Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Detalhes da Pessoa'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PersonDetailsScreen(
                              cpf: passenger.cpf,
                              repository: PersonRepositoryImplementation(),
                            ),
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('Fazer Ligação'),
                    onTap: () {
                      launch('tel:+55${passenger.phone}');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.message),
                    title: Text('WhatsApp'),
                    onTap: () {
                      launch('whatsapp://send?phone=+55${passenger.phone}');
                    },
                  ),
                ],
              ));
            },
          );
        },
        trailing: Column(
          children: [
            Text('viajante?'),
            Expanded(
              child: Switch(
                value: passenger.traveler,
                onChanged: (data) {},
              ),
            )
          ],
        ),
        title: Text(
          'Nome: ${passenger.fullName}',
          style: TextStyle(fontSize: 20),
        ),
        subtitle: Text(
          'CPF: ${CpfFormatter(cpf: passenger.cpf)()}'
          '\nTelefone: ${passenger.phone}',
        ),
        isThreeLine: true,
      ),
    );
  }
}
