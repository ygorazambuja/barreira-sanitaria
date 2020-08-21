import 'package:barreira_sanitaria/presenters/screens/new_register_screen.dart';
import 'package:barreira_sanitaria/presenters/screens/registers_non_finalized_screen.dart';
import 'package:barreira_sanitaria/presenters/screens/search_by_plate_screen.dart';
import 'package:barreira_sanitaria/shared/icon_with_notification_badge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/usecases/registers_usecases/all_registers_usecase.dart';
import '../../infra/repositories/implementation/register_repository_implementation.dart';
import '../../shared/custom_bottom_app_bar.dart';
import '../../shared/rectangle_floating_action_button.dart';
import '../../shared/shared_main_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final repository = RegisterRepositoryImplementation();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  AllRegistersUsecase allRegistersUsecase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              Text('Pedro Gomes',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  )),
              Text('Barreira Sanitaria',
                  style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 28)),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Card(
                  elevation: 10,
                  child: ListTile(
                    leading: Icon(Icons.add_circle_outline),
                    title: Text('Adicionar novo Registro'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewRegisterScreen())),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Card(
                  elevation: 10,
                  child: ListTile(
                    leading: Icon(Icons.find_in_page),
                    title: Text('Pesquisar por Placa'),
                    subtitle: Text(
                      'Util para dar baixa rapidamente',
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchByPlateScreen())),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Card(
                    elevation: 10,
                    child: ListTile(
                      leading: Icon(Icons.report_problem),
                      title: Text('Registros em Aberto'),
                      trailing: StreamBuilder(
                        stream: RegisterRepositoryImplementation()
                            .lengthNonFinalizedRegister(),
                        initialData: 0,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return IconWithNotification(
                              counter: snapshot.data,
                              icon: Icon(Icons.report),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterNonFinalizedScreen(),
                          )),
                    )),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: RectangleFloatingActionButton(),
      drawer: SharedMainDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: CustomBottomAppBar(scaffoldState: _scaffoldState),
    );
  }
}
