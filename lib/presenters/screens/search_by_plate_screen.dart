import 'package:barreira_sanitaria/domain/dtos/clean_register_dto.dart';
import 'package:barreira_sanitaria/domain/entities/car.dart';
import 'package:barreira_sanitaria/domain/usecases/car_usecases/fetch_car_by_plate_usecase.dart';
import 'package:barreira_sanitaria/domain/usecases/registers_usecases/fetch_registers_by_car_plate_usecase.dart';
import 'package:barreira_sanitaria/infra/repositories/implementation/car_repository_implementation.dart';
import 'package:barreira_sanitaria/infra/repositories/implementation/register_repository_implementation.dart';
import 'package:barreira_sanitaria/presenters/components/title_top.dart';
import 'package:barreira_sanitaria/presenters/screens/register_details_screen.dart';
import 'package:barreira_sanitaria/shared/custom_bottom_app_bar.dart';
import 'package:barreira_sanitaria/shared/rectangle_floating_action_button.dart';
import 'package:barreira_sanitaria/shared/shared_main_drawer.dart';
import 'package:barreira_sanitaria/utils/upper_case_text_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SearchByPlateScreen extends StatefulWidget {
  @override
  _SearchByPlateScreenState createState() => _SearchByPlateScreenState();
}

class _SearchByPlateScreenState extends State<SearchByPlateScreen> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  final MaskTextInputFormatter plateFormatter = MaskTextInputFormatter(
      mask: '###-####', filter: {'#': RegExp(r'([aA-Z]{0,3})([0-9]{0,})')});

  String plate = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      floatingActionButton: RectangleFloatingActionButton(),
      drawer: SharedMainDrawer(),
      bottomNavigationBar: CustomBottomAppBar(
        scaffoldState: _scaffoldState,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              TitleTop(
                title: 'Pesquisa por Placa',
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40.0, horizontal: 15),
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Placa',
                      hintText: 'ABC-1234',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onChanged: (value) {
                    if (value.length == 8) {
                      setState(() {
                        plate = value;
                      });
                    }
                  },
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [UpperCaseTextFormatter(), plateFormatter],
                ),
              ),
              plate.isNotEmpty
                  ? FutureBuilder<Car>(
                      future: FetchCarByPlateUsecase(
                          plate: plate,
                          repository: CarRepositoryImplementation())(),
                      builder: (context, snapshot) {
                        var car = snapshot.data;
                        if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ExpansionTile(
                                title: Text('Placa: ${car.plate}'),
                                subtitle: Text('Modelo: ${car.model}'),
                                leading: Icon(Icons.directions_car),
                                trailing: Icon(Icons.arrow_forward),
                                children: [
                                  FutureBuilder<List<CleanRegisterDto>>(
                                    future: FetchRegistersByCarPlateUsecase(
                                        plate: car.plate,
                                        repository:
                                            RegisterRepositoryImplementation())(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, index) {
                                            var register = snapshot.data[index];
                                            return Wrap(
                                              children: [
                                                RegisterSimpleCard(
                                                    register: register)
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Center(
                            child: Text('Não foi encontrado'),
                          );
                        }
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterSimpleCard extends StatelessWidget {
  const RegisterSimpleCard({
    Key key,
    @required this.register,
  }) : super(key: key);

  final CleanRegisterDto register;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterDetailsScreen(
                registerId: register.id,
              ),
            )),
        child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Text('Data: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(DateFormat(DateFormat.HOUR24_MINUTE)
                    .format(register.occurrenceDate)),
                Text(' ás ' +
                    DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br')
                        .format(register.occurrenceDate))
              ],
            )),
      ),
    );
  }
}
