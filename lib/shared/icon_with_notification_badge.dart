import 'package:flutter/material.dart';

class IconWithNotification extends StatelessWidget {
  final Icon icon;
  final int counter;

  IconWithNotification({Key key, @required this.icon, @required this.counter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(icon: icon, onPressed: () {}),
        Positioned(
          right: 11,
          top: 11,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 10,
              minHeight: 10,
            ),
            child: Text(
              counter.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
