import 'package:flutter/material.dart';

class ListTileDrawerItem extends StatelessWidget {
  final Icon icon;
  final String text;
  final Function function;
  ListTileDrawerItem({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(text),
      onTap: function,
    );
  }
}
