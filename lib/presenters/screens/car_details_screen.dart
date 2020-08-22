import 'package:barreira_sanitaria/domain/entities/car_with_registers.dart';
import 'package:barreira_sanitaria/domain/usecases/car_usecases/fetch_car_with_registers_usecase.dart';
import 'package:barreira_sanitaria/infra/repositories/implementation/car_repository_implementation.dart';
import 'package:barreira_sanitaria/presenters/components/register_card.dart';
import 'package:barreira_sanitaria/presenters/components/title_top.dart';
import 'package:barreira_sanitaria/shared/custom_bottom_app_bar.dart';
import 'package:barreira_sanitaria/shared/rectangle_floating_action_button.dart';
import 'package:barreira_sanitaria/shared/shared_main_drawer.dart';
import 'package:flutter/material.dart';

class CarDetailsScreen extends StatefulWidget {
  final String car;

  CarDetailsScreen({@required this.car});

  @override
  _CarDetailsScreenState createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
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
      body: FutureBuilder<CarWithRegisters>(
          future: FetchCarWithRegistersUsecases(
              plate: widget.car, repository: CarRepositoryImplementation())(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var carWithRegisters = snapshot.data;
              return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    TitleTop(
                      title: 'Placa: ${carWithRegisters.plate}',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Card(
                        elevation: 10,
                        child: ListTile(
                          leading: Icon(Icons.find_in_page),
                          title: Text('Modelo: ${carWithRegisters.model}'),
                        ),
                      ),
                    ),
                    ListView.builder(
                      itemCount: carWithRegisters.registers.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return RegisterCard(
                            register: carWithRegisters.registers[index]);
                      },
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
