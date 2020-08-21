import 'package:barreira_sanitaria/domain/entities/person.dart';
import 'package:barreira_sanitaria/domain/usecases/person_usecases/fetch_person_by_cpf_usecase.dart';
import 'package:barreira_sanitaria/domain/usecases/registers_usecases/fetch_registers_by_person_usecase.dart';
import 'package:barreira_sanitaria/infra/repositories/implementation/register_repository_implementation.dart';
import 'package:barreira_sanitaria/presenters/components/register_cart_list.dart';
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
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
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            child: Card(
                                child: ListTile(
                              title: Wrap(
                                children: [
                                  Text(
                                    'Nome Completo: ',
                                  ),
                                  Text(person.fullName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Card(
                              child: ListTile(
                                title: Wrap(
                                  children: [
                                    Text('CPF: '),
                                    Text(
                                      person.cpf,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Card(
                              child: ListTile(
                                title: Wrap(
                                  children: [
                                    Text('Telefone: '),
                                    Text(
                                      person.phone,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Card(
                              child: ListTile(
                                title: Wrap(
                                  children: [
                                    Text('Viajante: '),
                                    Text(
                                      person.traveler ? 'Sim' : 'Não',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 3,
                              child: RegisterCardListBuilder(
                                usecase: FetchRegistersByPersonUsecase(
                                    person: person,
                                    repository:
                                        RegisterRepositoryImplementation())(),
                              ),
                            ),
                          )
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ),
        ));
  }
}
