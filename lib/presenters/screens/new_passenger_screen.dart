import 'package:flutter/material.dart';

import '../../domain/entities/person.dart';
import '../components/title_top.dart';

class NewPassengerScreen extends StatefulWidget {
  Person person;

  NewPassengerScreen.editar({this.person});
  NewPassengerScreen() {
    person = Person();
    person.traveler = false;
  }

  @override
  _NewPassengerScreenState createState() => _NewPassengerScreenState();
}

class _NewPassengerScreenState extends State<NewPassengerScreen> {
  bool _passengerTravelerController = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context, widget.person);
        },
        label: Text("Salvar"),
        icon: Icon(Icons.save),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TitleTop(
              title: 'Novo Passageiro',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) =>
                    setState(() => widget.person.fullName = value),
                decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      gapPadding: 2,
                    ),
                    icon: Icon(Icons.account_circle)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) => setState(() {
                  widget.person.cpf = value;
                }),
                decoration: InputDecoration(
                    labelText: 'CPF',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      gapPadding: 2,
                    ),
                    icon: Icon(Icons.perm_device_information)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) =>
                    setState(() => widget.person.phone = value),
                decoration: InputDecoration(
                    labelText: 'Telefone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      gapPadding: 2,
                    ),
                    icon: Icon(Icons.phone)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Viajante?'),
                Switch(
                  value: _passengerTravelerController,
                  onChanged: (value) {
                    setState(() {
                      _passengerTravelerController = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
