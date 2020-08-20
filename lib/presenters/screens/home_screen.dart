import 'package:flutter/material.dart';

import '../../domain/usecases/registers_usecases/all_clean_registers_dto.dart';
import '../../domain/usecases/registers_usecases/all_registers_usecase.dart';
import '../../infra/repositories/implementation/register_repository_implementation.dart';
import '../../shared/custom_bottom_app_bar.dart';
import '../../shared/rectangle_floating_action_button.dart';
import '../../shared/shared_main_drawer.dart';
import '../components/register_cart_list.dart';

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
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text('Registrados',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w300)),
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
