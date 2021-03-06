import 'package:barreira_sanitaria/domain/usecases/car_usecases/fetch_car_by_plate_usecase.dart';
import 'package:barreira_sanitaria/infra/repositories/implementation/car_repository_implementation.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/car.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/registers.dart';
import '../../domain/usecases/registers_usecases/new_register_usecase.dart';
import '../../infra/repositories/implementation/register_repository_implementation.dart';
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
  final _modelController = TextEditingController();
  final _reasonController = TextEditingController();
  DateTime _exitForecast;
  final MaskTextInputFormatter cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {'#': RegExp(r'[0-9]')});
  final MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
      mask: '(##)-#####-####', filter: {'#': RegExp(r'[0-9]')});

  final MaskTextInputFormatter plateFormatter = MaskTextInputFormatter(
      mask: '###-####', filter: {'#': RegExp(r'([aA-Z]{0,3})([0-9]{0,})')});

  bool _saveButtonActivate = true;
  bool _isViajante = false;

  List<Person> passengers = <Person>[];

  void onDismissDelete(int index) {
    setState(() {
      passengers.removeAt(index);
    });
  }

  void onSaveClick() async {
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final car = Car(
      model: _modelController.text,
      plate: _placaController.text,
    );
    final register = Register(
      car: car,
      exitForecast: _exitForecast,
      reason: _reasonController.text,
      occurrenceDate: DateTime.now(),
      persons: passengers,
      isFinalized: !_isViajante,
      id: Uuid().v4(),
    );

    register.enterLocation = '${position.latitude},${position.longitude}';

    final insertedRegister = await NewRegisterUseCase(
      register: register,
      repository: RegisterRepositoryImplementation(),
    )();

    BotToast.showNotification(
        title: (cancelFunc) => Text('Registro Inserido com Sucesso'),
        subtitle: (cancelFunc) => Text(insertedRegister),
        contentPadding: const EdgeInsets.all(8));

    Navigator.pop(context);
  }

  void updatePassengerList(int index, Person person) {
    setState(() {
      passengers[index] = person;
    });
  }

  final _scaffoldState = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

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
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                                onChanged: (value) async {
                                  if (value.length == 8) {
                                    final car = await FetchCarByPlateUsecase(
                                        plate: value,
                                        repository:
                                            CarRepositoryImplementation())();
                                    if (car != null) {
                                      setState(() {
                                        _modelController.text = car.model;
                                      });
                                      BotToast.showNotification(
                                        title: (cancelFunc) => Text(
                                            'Modelo Preenchido automaticamente'),
                                      );
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Placa do Carro: ',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        gapPadding: 2)),
                                controller: _placaController,
                                maxLength: 8,
                                textCapitalization:
                                    TextCapitalization.characters,
                                inputFormatters: [
                                  UpperCaseTextFormatter(),
                                  plateFormatter
                                ],
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Campo não pode ser vazio';
                                  }
                                  if (value.length != 8) {
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
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white30),
                                      borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text('Estipular Horario para Saida'),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: DateTimePicker(
                                          type: DateTimePickerType
                                              .dateTimeSeparate,
                                          initialValue: '',
                                          dateMask: 'dd/MM/yyyy',
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2021),
                                          dateLabelText: 'Data',
                                          timeLabelText: 'Horário',
                                          onChanged: (value) => setState(() {
                                            _exitForecast =
                                                DateTime.parse(value);
                                          }),
                                          use24HourFormat: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                  controller: _reasonController,
                                  decoration: InputDecoration(
                                      labelText: 'Motivos da Visita',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gapPadding: 2)),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Campo não pode ser vazio';
                            }
                            return null;
                          },
                          controller: _modelController,
                          decoration: InputDecoration(
                              labelText: 'Modelo do carro',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  gapPadding: 2))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
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
                          label: Text('Adicionar Pessoa')),
                    ),
                    passengers.isNotEmpty
                        ? PassengerListRender(
                            onDismissDelete: onDismissDelete,
                            passengers: passengers,
                            onUpdate: updatePassengerList)
                        : Container()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 10,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            if (passengers.isNotEmpty) {
              setState(() {
                _saveButtonActivate = false;
              });
              onSaveClick();
            } else {
              BotToast.showNotification(
                leading: (cancel) => Icon(
                  Icons.warning,
                  color: Colors.redAccent,
                ),
                title: (cancelFunc) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('Não é possivel adicionar um registro sem pessoas'),
                ),
              );
            }
          }
        },
        label: Text('Salvar'),
        icon: Icon(Icons.save),
        shape: BeveledRectangleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class PassengerListRender extends StatelessWidget {
  final Function onUpdate;

  PassengerListRender({
    Key key,
    this.passengers,
    this.onDismissDelete,
    this.onUpdate,
  }) : super(key: key);

  final List<Person> passengers;
  final Function(int) onDismissDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: passengers.length,
      itemBuilder: (context, index) {
        var passenger = passengers[index];
        return Dismissible(
          onDismissed: (direction) {
            onDismissDelete(index);
          },
          background: Container(
            decoration: BoxDecoration(color: Colors.redAccent),
          ),
          key: UniqueKey(),
          child: ListTile(
            onTap: () async {
              var person = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewPassengerScreen.editar(
                      person: passenger,
                    ),
                  ));
              if (person != null) {
                onUpdate(index, person);
              }
            },
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
