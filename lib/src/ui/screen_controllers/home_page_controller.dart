import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../interfaces/i_view_controller.dart';
import '../../managers/page_manager.dart';
import '../../utils/page_args.dart';

class HomePageController extends ControllerMVC implements IViewController {
  static late HomePageController _this;

  factory HomePageController(PageArgs? args) {
    _this = HomePageController._(args);
    return _this;
  }

  static HomePageController get con => _this;
  PageArgs? args;
  HomePageController._(this.args);

  bool isLoading = false;
  TextEditingController textInputController = TextEditingController();

  @override
  void initPage({PageArgs? arguments}) {
    textInputController = TextEditingController();
  }

  @override
  disposePage() {}

  refreshPage(value) {
    if (value != null && value) {
      setState(() {});
    }
  }

  void onPopupButtonTap() async {
    await PageManager().openHelloPopup();
  }
}
