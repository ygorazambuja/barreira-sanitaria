import 'package:barreira_sanitaria/domain/entities/person.dart';
import 'package:barreira_sanitaria/domain/usecases/person_usecases/fetch_person_by_cpf_usecase.dart';
import 'package:barreira_sanitaria/repository/abstract/person_repository_abstract.dart';
import 'package:flutter/material.dart';

import '../../shared/custom_bottom_app_bar.dart';
import '../../shared/rectangle_floating_action_button.dart';
import '../../shared/shared_main_drawer.dart';
import '../components/title_top.dart';

class PersonDetailsScreen extends StatefulWidget {
  final String cpf;
  final PersonRepositoryAbstract repository;

  PersonDetailsScreen({this.cpf, this.repository});

  @override
  _PersonDetailsScreenState createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  final GlobalKey _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

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
        body: Container(
          child: StreamBuilder<Person>(
              stream: Stream.fromFuture(FetchPersonByCpf(
                  cpf: widget.cpf, repository: widget.repository)()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var person = snapshot.data;
                  return Column(
                    children: [
                      TitleTop(
                        title: 'Detalhes da Pessoa',
                      ),
                      Text(person.cpf)
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ));
  }
}
