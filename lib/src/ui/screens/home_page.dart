import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../values/k_colors.dart';
import '../../../values/k_values.dart';
import '../../utils/page_args.dart';
import '../components/button_component.dart';
import '../components/common_component/common_component.dart';
import '../components/item_data_form_component.dart';
import '../components/radio_button_component.dart';
import '../screen_controllers/home_page_controller.dart';

class HomePage extends StatefulWidget {
  final PageArgs? args;
  const HomePage(this.args, {super.key});

  @override
  _HomePagePageState createState() => _HomePagePageState(args);
}

class _HomePagePageState extends StateMVC<HomePage> {
  late HomePageController _con;
  PageArgs? args;

  _HomePagePageState(PageArgs? _args) : super(HomePageController(_args)) {
    _con = HomePageController.con;
    args = _args;
  }

  @override
  void initState() {
    _con.initPage(arguments: args);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: KGrey,
          body: Container(
            padding: const EdgeInsets.all(25),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Adios!",
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 20),
                ButtonComponent(
                  text: "Hello Popup",
                  width: double.infinity,
                  onPressed: () {
                    _con.onPopupButtonTap();
                  },
                ),
                const SizedBox(height: 20),
                ButtonComponent(
                  backgroundColor: KBlue,
                  borderColor: KBlue,
                  text: "Do nothing",
                  width: double.infinity,
                  onPressed: () {},
                ),
                const SizedBox(height: 20),
                ItemDataFormComponent.text(
                  controller: _con.textInputController,
                  placeHolder: "Test ...",
                ),
                const SizedBox(height: 20),
                closableContainer(
                  height: 100,
                  child: Column(
                    children: [
                      RadioButtonComponent(
                        label: Row(children: [
                          const Text("Acepto los ",
                              style: TextStyle(
                                color: KLightblue,
                                fontSize: KFontSizeMedium35,
                              )),
                          GestureDetector(
                            onTap: () {
                              log("On Terms and conditions tap");
                            },
                            child: const Text(
                              "términos y condiciones",
                              style: TextStyle(
                                  color: KPrimary,
                                  fontSize: KFontSizeMedium35,
                                  fontStyle: FontStyle.italic),
                            ),
                          )
                        ]),
                        onTap: (bool isCheck) {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
