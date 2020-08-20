import 'package:flutter/material.dart';

import '../../domain/entities/person.dart';
import '../../domain/usecases/person_usecases/fetch_travelers_by_partial_cpf_usecase.dart';
import '../../infra/repositories/implementation/person_repository_implementation.dart';
import '../../shared/custom_bottom_app_bar.dart';
import '../../shared/rectangle_floating_action_button.dart';
import '../../shared/shared_main_drawer.dart';
import '../components/title_top.dart';
import 'person_details_screen.dart';

class OutsidersScreen extends StatefulWidget {
  @override
  _OutsidersScreenState createState() => _OutsidersScreenState();
}

class _OutsidersScreenState extends State<OutsidersScreen> {
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

class _Body extends StatefulWidget {
  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  String cpf = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          TitleTop(
            title: 'Visitantes',
          ),
          Form(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onSubmitted: (value) {
                  setState(() {
                    cpf = value;
                  });
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    labelText: 'Pesquisa por CPF',
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          Expanded(
            child: cpf.isNotEmpty
                ? FutureBuilder<List<Person>>(
                    future: FetchTravelersByPartialCpfUsecase(
                        cpf: cpf,
                        repository: PersonRepositoryImplementation())(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            final person = snapshot.data[index];
                            return ListTile(
                              trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_forward_ios),
                              ),
                              title: Text('Nome: ${person.fullName}'),
                              subtitle: Text('CPF: ${person.cpf}\n'
                                  'Telefone: ${person.phone}'),
                              isThreeLine: true,
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PersonDetailsScreen(
                                        cpf: person.cpf,
                                        repository:
                                            PersonRepositoryImplementation()),
                                  )),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}

/// cepem.pericia@gmail.com
