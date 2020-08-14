import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatefulWidget {
  const CustomBottomAppBar({
    Key key,
    @required GlobalKey<ScaffoldState> scaffoldState,
  })  : _scaffoldState = scaffoldState,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldState;

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 60,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  widget._scaffoldState.currentState.openDrawer();
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
