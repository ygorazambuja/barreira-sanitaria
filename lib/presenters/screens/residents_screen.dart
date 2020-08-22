import 'package:barreira_sanitaria/domain/entities/person.dart';
import 'package:barreira_sanitaria/domain/usecases/person_usecases/fetch_person_by_partial_cpf_usecase.dart';
import 'package:barreira_sanitaria/infra/repositories/implementation/person_repository_implementation.dart';
import 'package:barreira_sanitaria/presenters/components/title_top.dart';
import 'package:barreira_sanitaria/presenters/screens/person_details_screen.dart';
import 'package:barreira_sanitaria/shared/custom_bottom_app_bar.dart';
import 'package:barreira_sanitaria/shared/icon_with_notification_badge.dart';
import 'package:barreira_sanitaria/shared/rectangle_floating_action_button.dart';
import 'package:barreira_sanitaria/shared/shared_main_drawer.dart';
import 'package:flutter/material.dart';

class ResidentsScreen extends StatefulWidget {
  @override
  _ResidentsScreenState createState() => _ResidentsScreenState();
}

class _ResidentsScreenState extends State<ResidentsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  String cpf = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      bottomNavigationBar: CustomBottomAppBar(
        scaffoldState: _scaffoldState,
      ),
      drawer: SharedMainDrawer(),
      floatingActionButton: RectangleFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Column(
        children: [
          TitleTop(
            title: 'Moradores',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                leading: IconWithNotification(
                  icon: Icon(Icons.report),
                  counter: 2,
                ),
                title: Text('Contaminados'),
                onTap: () {},
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                leading: IconWithNotification(
                  icon: Icon(Icons.report),
                  counter: 2,
                ),
                title: Text('Suspeitos'),
                onTap: () {},
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                leading: IconWithNotification(
                  icon: Icon(Icons.report),
                  counter: 2,
                ),
                title: Text('Curados'),
                onTap: () {},
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
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
          Container(
            child: cpf.isNotEmpty
                ? Expanded(
                    child: FutureBuilder<List<Person>>(
                      future: FetchPersonByPartialCpfUsecase(
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
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
