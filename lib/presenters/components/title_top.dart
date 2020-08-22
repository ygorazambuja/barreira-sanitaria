import 'package:flutter/material.dart';

class TitleTop extends StatelessWidget {
  final String title;
  const TitleTop({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text('$title',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300)),
        ),
      ],
    );
  }
}
