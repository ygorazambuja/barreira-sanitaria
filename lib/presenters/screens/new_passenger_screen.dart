import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../domain/entities/person.dart';
import '../components/title_top.dart';

class NewPassengerScreen extends StatefulWidget {
  Person person;

  NewPassengerScreen.editar({this.person});

  NewPassengerScreen() {
    person = Person(cpf: '', fullName: '', phone: '', traveler: false);
  }

  @override
  _NewPassengerScreenState createState() => _NewPassengerScreenState();
}

class _NewPassengerScreenState extends State<NewPassengerScreen> {
  bool _passengerTravelerController = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  MaskTextInputFormatter cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {'#': RegExp(r'[0-9]')});
  MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
      mask: '(##)-#####-####', filter: {'#': RegExp(r'[0-9]')});

  @override
  void initState() {
    setState(() {
      nameController.text = widget.person.fullName;
      cpfController.text = widget.person.cpf;
      phoneController.text = widget.person.phone;
      _passengerTravelerController = widget.person.traveler;
    });

    super.initState();
  }

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
              title: 'Nova Pessoa',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: nameController,
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
                controller: cpfController,
                inputFormatters: [cpfFormatter],
                keyboardType: TextInputType.number,
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
                controller: phoneController,
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    setState(() => widget.person.phone = value),
                inputFormatters: [phoneFormatter],
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
                      widget.person.traveler = value;
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
