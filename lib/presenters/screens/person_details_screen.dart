import 'package:flutter/material.dart';

import '../../shared/custom_bottom_app_bar.dart';
import '../../shared/rectangle_floating_action_button.dart';
import '../../shared/shared_main_drawer.dart';
import '../components/title_top.dart';

class PersonDetailsScreen extends StatefulWidget {
  @override
  _PersonDetailsScreenState createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  final GlobalKey _scaffoldState = GlobalKey<ScaffoldState>();
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
      child: Column(
        children: [
          TitleTop(
            title: "Nome da Pessoa",
          )
        ],
      ),
    );
  }
}
