import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/usecases/registers_usecases/all_clean_registers_dto.dart';
import '../../domain/usecases/registers_usecases/all_registers_usecase.dart';
import '../../infra/repositories/implementation/register_repository_implementation.dart';
import '../../shared/custom_bottom_app_bar.dart';
import '../../shared/rectangle_floating_action_button.dart';
import '../../shared/shared_main_drawer.dart';
import '../components/register_cart_list.dart';

class VisitHistoryScreen extends StatefulWidget {
  @override
  _VisitHistoryScreen createState() => _VisitHistoryScreen();
}

class _VisitHistoryScreen extends State<VisitHistoryScreen> {
  final repository = RegisterRepositoryImplementation();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  AllRegistersUsecase allRegistersUsecase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text('Histórico de Registros',
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w300,
                      fontFamily: GoogleFonts.poppins().fontFamily)),
            ),
            Expanded(
              child: RegisterCardListBuilder(
                usecase: AllCleanRegistersDto(repository: repository)(),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: RectangleFloatingActionButton(),
      drawer: SharedMainDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: CustomBottomAppBar(scaffoldState: _scaffoldState),
    );
  }
}
