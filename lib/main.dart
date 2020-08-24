import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'presenters/screens/home_screen.dart';

void main() => runApp(StartUp());

class StartUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barreira Sanitaria PG',
      initialRoute: '/',
      builder: BotToastInit(),
      routes: {
        '/': (context) => HomeScreen(),
      },
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        fontFamily: GoogleFonts.openSans().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
    );
  }
}
