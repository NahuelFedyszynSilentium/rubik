import 'package:flutter/material.dart';

import '../../../enums/navigation_bar_action_enum.dart';
import 'navigation_bar_component.dart';

simpleNavigationBar(
    {String title = "",
    NavigationBarAction navigationBarAction = NavigationBarAction.none,
    hasTitleIcon = false,
    Widget? titleContent,
    VoidCallback? onMenu,
    VoidCallback? onBack,
    VoidCallback? onCancel}) {
  return NavigationBarComponent(
    title: title,
    hasBack: onBack != null && onMenu == null,
    titleContent: titleContent,
    navigationBarAction: navigationBarAction,
    onMenuClick: onMenu,
    onBackClick: onBack,
    onCancelClick: onCancel,
  );
}

dynamicSimpleNavigationBar({
  String title = "",
  NavigationBarAction navigationBarAction = NavigationBarAction.none,
  bool hasBack = false,
  VoidCallback? onMenu,
  VoidCallback? onBack,
  VoidCallback? onCancel,
  Function? onAcceptPopUpButton,
}) {
  return NavigationBarComponent(
    title: title,
    hasBack: hasBack,
    navigationBarAction: navigationBarAction,
    onMenuClick: hasBack ? null : onMenu,
    onBackClick: onBack,
    onCancelClick: onCancel,
    onAcceptPopUpButton: onAcceptPopUpButton,
  );
}

loginNavigationBar({required Function onBack, Color iconColor = Colors.white}) {
  return Container(
    height: 55,
    decoration: const BoxDecoration(
      color: Colors.transparent,
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: IconButton(
          icon: const Icon(Icons.close),
          // icon: Image.asset(
          //   'images/button_back.png',
          //   alignment: Alignment.centerLeft,
          //   height: 20,
          //   width: 20,
          //   color: iconColor,
          // ),
          onPressed: () {
            onBack();
          }),
    ),
  );
}
