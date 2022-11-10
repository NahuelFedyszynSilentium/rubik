import 'package:flutter/material.dart';

import '../managers/page_manager.dart';

class TestPopupPage extends StatefulWidget {
  const TestPopupPage({super.key});

  @override
  _TestPopupPageState createState() => _TestPopupPageState();
}

class _TestPopupPageState extends State<TestPopupPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _content(),
    ));
  }

  _content() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          _helloPopup(),
        ],
      ),
    );
  }

  _helloPopup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const Text("PopUp hello_popup"),
            ElevatedButton(
              child: const Text(
                "Presionar aqui",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              onPressed: () async => {await PageManager().openHelloPopup()},
            ),
          ],
        )
      ],
    );
  }
}
