import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../values/k_colors.dart';
import '../../values/k_values.dart';
import '../enums/page_names.dart';
import '../ui/popups/hello_popup.dart';
import '../ui/popups/information_alert_popup.dart';
import '../ui/screens/home_page.dart';
import '../utils/page_args.dart';

class PageManager {
  static final PageManager _instance = PageManager._constructor();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  PageNames? currentPage;

  factory PageManager() {
    return _instance;
  }

  PageNames? getPageNameEnum(String? pageName) {
    try {
      return PageNames.values.where((x) => x.toString() == pageName).single;
    } catch (e) {}

    return null;
  }

  PageManager._constructor();

  MaterialPageRoute? getRoute(RouteSettings settings) {
    PageArgs? arguments;

    if (settings.arguments != null) {
      arguments = settings.arguments as PageArgs;
    }

    PageNames? page = getPageNameEnum(settings.name);

    currentPage = page;
    switch (page) {
      case PageNames.home:
        return MaterialPageRoute(builder: (context) => HomePage(arguments));
      default:
        return MaterialPageRoute(builder: (context) => HomePage(arguments));
    }
  }

  _goPage(String pageName,
      {PageArgs? args,
      Function(PageArgs args)? actionBack,
      bool makeRootPage = false}) {
    if (!makeRootPage) {
      return navigatorKey.currentState
          ?.pushNamed(pageName, arguments: args)
          .then((value) {
        if (actionBack != null) actionBack(value as PageArgs);
      });
    } else {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
          pageName, (route) => false,
          arguments: args);
    }
  }

  goBack({PageArgs? args, PageNames? specificPage}) {
    if (specificPage != null) {
      navigatorKey.currentState!
          .popAndPushNamed(specificPage.toString(), arguments: args);
    } else {
      //Navigator.pop(navigatorKey.currentContext, args);
      Navigator.pop(navigatorKey.currentState!.overlay!.context, args);
    }
  }

  doLogout() {
    // _goPage(PageNames.login.toString(),
    //     args: null, actionBack: null, makeRootPage: true);
    // DataManager().cleanData();
    // AppProvider().cleanData();
    // AppProvider().setToken();
  }

  goHomePage({PageArgs? args, Function(PageArgs args)? actionBack}) {
    _goPage(PageNames.home.toString(),
        args: args, actionBack: actionBack, makeRootPage: true);
  }

  goMaintenancePage({PageArgs? args, Function(PageArgs args)? actionBack}) {
    // _goPage(PageNames.maintenance.toString(),
    //     args: args, actionBack: actionBack, makeRootPage: true);
  }

  goClose() {
    SystemNavigator.pop();
  }

  //PopUp

  openHelloPopup() {
    BuildContext context = PageManager().navigatorKey.currentContext!;
    return HelloPopup(context: context, name: "Hello popup").show();
  }

  openDefaultErrorAlert(String detail, {Function? onRetry}) {
    return InformationAlertPopup(
      context: PageManager().navigatorKey.currentContext!,
      backgroundOpacity: 0.8,
      image: Image.asset(
        'images/icon_alert.png',
        color: KPrimary,
        height: 100,
        width: 100,
      ),
      title: 'Error',
      titleStyle: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w800,
        fontSize: KFontSizeLarge40,
      ),
      subtitle1: detail,
      subtitle1Style:
          const TextStyle(color: Colors.grey, fontSize: KFontSizeMedium35),
      labelButtonAccept: onRetry == null ? 'Aceptar' : 'Reintentar',
      labelButtonCancel: onRetry != null ? 'Cancelar' : null,
      onAccept: onRetry,
      onCancel: () {},
      isCancellable: true,
    ).show();
  }
}
