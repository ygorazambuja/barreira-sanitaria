import 'package:flutter/material.dart';

import '../../domain/usecases/registers_usecases/all_finalized_registers_usecase.dart';
import '../../infra/repositories/implementation/register_repository_implementation.dart';
import '../../shared/custom_bottom_app_bar.dart';
import '../../shared/rectangle_floating_action_button.dart';
import '../../shared/shared_main_drawer.dart';
import '../components/register_cart_list.dart';

class RegisterFinalizedScreen extends StatefulWidget {
  @override
  _RegisterFinalizedScreenState createState() =>
      _RegisterFinalizedScreenState();
}

class _RegisterFinalizedScreenState extends State<RegisterFinalizedScreen> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      bottomNavigationBar: CustomBottomAppBar(
        scaffoldState: _scaffoldState,
      ),
      floatingActionButton: RectangleFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      drawer: SharedMainDrawer(),
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text('Registros Com Baixa',
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w300)),
          ),
          Expanded(
            child: RegisterCardListBuilder(
              usecase: AllFinalizedRegisterUsecase(
                  repository: RegisterRepositoryImplementation())(),
            ),
          )
        ],
      ),
    );
  }
}
