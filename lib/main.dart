import 'package:flutter/material.dart';

import 'presenters/screens/home_screen.dart';

void main() => runApp(MaterialApp(
      home: StartUp(),
      // themeMode: ThemeMode.dark,
      theme:
          ThemeData(brightness: Brightness.light, primaryColor: Colors.purple),
      darkTheme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
    ));

class StartUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
