import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/person.dart';
import '../../shared/custom_bottom_app_bar.dart';
import '../../shared/shared_main_drawer.dart';
import '../../utils/upper_case_text_formatter.dart';
import '../components/title_top.dart';
import 'new_passenger_screen.dart';

class NewRegisterScreen extends StatefulWidget {
  @override
  _NewRegisterScreenState createState() => _NewRegisterScreenState();
}

class _NewRegisterScreenState extends State<NewRegisterScreen> {
  final _placaController = TextEditingController();
  final _dateTimeController = TextEditingController();

  bool _isViajante = false;

  List<Person> passengers = <Person>[];

  void onDismissDelete(int index) {
    setState(() {
      passengers.removeAt(index);
    });
  }

  final _scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      drawer: SharedMainDrawer(),
      bottomNavigationBar: CustomBottomAppBar(scaffoldState: _scaffoldState),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              TitleTop(
                title: 'Novo Registro',
              ),
              Column(
                children: [
                  Center(
                    child: Text(
                        DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY, 'pt_BR')
                            .format(DateTime.now())),
                  ),
                  Center(
                    child: Text(DateFormat(DateFormat.HOUR24_MINUTE, 'pt_BR')
                        .format(DateTime.now())),
                  )
                ],
              ),
              Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Placa do Carro: ',
                                    border: OutlineInputBorder()),
                                controller: _placaController,
                                maxLength: 7,
                                textCapitalization:
                                    TextCapitalization.characters,
                                inputFormatters: [UpperCaseTextFormatter()],
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Campo não pode ser vazio";
                                  }
                                  if (value.length != 7) {
                                    return 'Placa precisa ter 7 Caracteres';
                                  }
                                  return null;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              children: [
                                Text('É viajante ?'),
                                Switch(
                                  activeColor: Colors.red,
                                  value: _isViajante,
                                  onChanged: (value) {
                                    setState(() {
                                      _isViajante = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    _isViajante
                        ? Column(
                            children: [
                              Text('Estipular Horario para Saida'),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DateTimePicker(
                                  controller: _dateTimeController,
                                  type: DateTimePickerType.dateTimeSeparate,
                                  dateMask: 'd MMM yyyy',
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2021),
                                  dateLabelText: 'Data',
                                  timeLabelText: 'Horário',
                                  onChanged: (value) => print,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          decoration:
                              InputDecoration(labelText: "Modelo do carro")),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          decoration:
                              InputDecoration(labelText: "Nome Completo")),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Cpf do Motorista")),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Telefone"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton.icon(
                          onPressed: () async {
                            var person = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewPassengerScreen(),
                                ));
                            if (person?.cpf != null && person is Person) {
                              setState(() {
                                passengers.add(person);
                              });
                            }
                          },
                          icon: Icon(Icons.add),
                          label: Text('Adicionar Passageiro')),
                    ),
                    passengers.isNotEmpty
                        ? PassengerListRender(
                            onDismissDelete: onDismissDelete,
                            passengers: passengers,
                          )
                        : Container()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Salvar'),
        icon: Icon(Icons.save),
        shape: BeveledRectangleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class PassengerListRender extends StatelessWidget {
  PassengerListRender({
    Key key,
    this.passengers,
    this.onDismissDelete,
  }) : super(key: key);

  final List<Person> passengers;
  final Function(int) onDismissDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: passengers.length,
      itemBuilder: (context, index) {
        final passenger = passengers[index];
        return Dismissible(
          onDismissed: (direction) {
            onDismissDelete(index);
          },
          background: Container(
            decoration: BoxDecoration(color: Colors.redAccent),
          ),
          key: UniqueKey(),
          child: ListTile(
            title: Text('Nome: ${passenger.fullName}'),
            subtitle: Text('CPF: ${passenger.cpf}\n'
                'Telefone: ${passenger.phone}'),
            isThreeLine: true,
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        height: 2,
      ),
    );
  }
}
