import 'package:flutter/material.dart';
import '../presenters/screens/new_register_screen.dart';

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
