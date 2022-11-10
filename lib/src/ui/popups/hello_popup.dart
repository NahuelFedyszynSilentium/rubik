import 'package:flutter/material.dart';

class HelloPopup {
  final BuildContext context;
  final String name;

  //Function() onPressed;

  HelloPopup({
    required this.context,
    required this.name,
  });

  Future show() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return _dialog();
        });
  }

  _dialog() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              //color: Colors.transparent,
              borderRadius: BorderRadius.circular(5.0),
            ),
            //width: double.infinity,
            child: HelloDialogPopup(
              name: name,
            ),
          ),
        ),
      ],
    );
  }
}

class HelloDialogPopup extends StatefulWidget {
  String name;
  List<Widget> checkBoxList;
  HelloDialogPopup({
    super.key,
    required this.name,
    this.checkBoxList = const [],
  });

  @override
  _AboutDialogPopup createState() => _AboutDialogPopup();
}

class _AboutDialogPopup extends State<HelloDialogPopup> {
  Future show() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return build(context);
        });
  }

  @override
  build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(2.0)),
            ),
            child: _content(context),
          ),
          _buttonExit(context)
        ],
      ),
    );
  }

  _buttonExit(context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context, false);
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/button_close.png"))),
          ),
        ),
      ),
    );
  }

  _content(context) {
    return const SizedBox(
        width: double.infinity,
        child: Center(
          child: Text("Hello!"),
        ));
  }
}
