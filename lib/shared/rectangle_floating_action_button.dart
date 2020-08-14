import 'package:barreira_sanitaria/presenters/screens/new_register_screen.dart';
import 'package:flutter/material.dart';

class RectangleFloatingActionButton extends StatelessWidget {
  const RectangleFloatingActionButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: BeveledRectangleBorder(),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NewRegisterScreen()));
      },
      child: Icon(Icons.add),
    );
  }
}
