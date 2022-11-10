import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_widgets/infinite_widgets.dart';
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
        body: InfiniteListView(
          itemBuilder: (p0, p1) => _element(),
          itemCount: 81,
          nextData: _nextData,
        ),
      ),
    );
  }

  Widget _buildRow() {
    return Row(
      children: [
        _element(),
        _element(),
        _element(),
      ],
    );
  }

  Widget _element() {
    Size x = MediaQuery.of(context).size;
    double height = x.height / 5;
    double width = x.width / 5;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        height: height,
        width: width,
        child: Container(color: Colors.black),
      ),
    );
  }

  _nextData() {
    return _element();
  }
}
