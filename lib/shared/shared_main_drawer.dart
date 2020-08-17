import 'package:barreira_sanitaria/presenters/screens/outsiders_screen.dart';
import 'package:flutter/material.dart';

import '../presenters/screens/new_register_screen.dart';
import '../presenters/screens/registers_finalized_screen.dart';
import '../presenters/screens/registers_non_finalized_screen.dart';
import 'list_tile_drawer_item.dart';

class SharedMainDrawer extends StatelessWidget {
  const SharedMainDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 10,
        key: key,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/bandeira-pg.jpg',
                    ),
                    minRadius: 75,
                    maxRadius: 75,
                    backgroundColor: Colors.indigo,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Nome do Usuario',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Função Cargo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                ListTileDrawerItem(
                  icon: Icon(Icons.headset),
                  text: 'Novo Registro',
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewRegisterScreen(),
                        ));
                  },
                ),
                ListTileDrawerItem(
                    icon: Icon(Icons.warning),
                    text: 'Cadastros sem Baixa',
                    function: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterNonFinalizedScreen(),
                          ));
                    }),
                ListTileDrawerItem(
                    icon: Icon(Icons.access_alarms),
                    text: 'Cadastros com Baixa',
                    function: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterFinalizedScreen(),
                          ));
                    }),
                ListTileDrawerItem(
                  icon: Icon(Icons.sd_storage),
                  text: 'Histórico de Visitas',
                  function: () {},
                ),
                ListTileDrawerItem(
                  icon: Icon(Icons.dashboard),
                  text: 'Moradores',
                  function: () {},
                ),
                ListTileDrawerItem(
                  icon: Icon(Icons.vibration),
                  text: 'Visitantes',
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OutsidersScreen(),
                        ));
                  },
                )
              ],
            ),
          ),
        ));
  }
}
