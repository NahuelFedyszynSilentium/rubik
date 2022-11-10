import 'package:flutter/material.dart';

import '../../../../values/k_colors.dart';
import '../../../../values/k_values.dart';
import '../../../enums/navigation_bar_action_enum.dart';

class NavigationBarComponent extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final Widget? titleContent;
  final bool hasTitleIcon;
  bool isContentBarExtended;
  bool isFooterBarExtended;
  double contentExtendHeight;
  NavigationBarAction navigationBarAction = NavigationBarAction.cancel;
  final bool hasBack;
  final VoidCallback? onMenuClick;
  final VoidCallback? onBackClick;
  final VoidCallback? onCancelClick;
  final Function? onAcceptPopUpButton;

  NavigationBarComponent({
    super.key,
    this.title = '',
    this.hasTitleIcon = false,
    this.isContentBarExtended = false,
    this.isFooterBarExtended = false,
    //this.contentExtendContent,
    //this.footerExtendedContent,
    this.contentExtendHeight = 0,
    this.titleContent,
    this.navigationBarAction = NavigationBarAction.none,
    this.hasBack = false,
    this.onMenuClick,
    this.onBackClick,
    this.onCancelClick,
    this.onAcceptPopUpButton,
  });

  @override
  _NavigationBarComponentState createState() => _NavigationBarComponentState();
  final double barSize = 55;
  final double footerBarSize = 45;

  @override
  Size get preferredSize =>
      Size.fromHeight(((isFooterBarExtended && isContentBarExtended)
          ? barSize + footerBarSize + contentExtendHeight + 5
          : (isFooterBarExtended)
              ? barSize + footerBarSize
              : (isContentBarExtended)
                  ? barSize + contentExtendHeight
                  : barSize));
}

class _NavigationBarComponentState extends State<NavigationBarComponent> {
  @override
  Widget build(BuildContext context) {
    try {
      return SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: ((widget.isFooterBarExtended && widget.isContentBarExtended)
                  ? widget.barSize +
                      widget.footerBarSize +
                      widget.contentExtendHeight
                  : (widget.isFooterBarExtended)
                      ? widget.barSize + widget.footerBarSize
                      : (widget.isContentBarExtended)
                          ? widget.barSize + widget.contentExtendHeight
                          : widget.barSize) +
              5,
          child: Column(
            //overflow: Overflow.visible,
            children: [
              _menu(),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: widget.isFooterBarExtended ? 45 : 0,
                  child: Column(
                    children: const [
                      SizedBox(
                        height: 5,
                      ),
                      /*
                      Material(
                        elevation: 1,
                        child: Container(
                          height: 40,
                          color: Colors.white,
                          child: widget.footerExtendedContent,
                        ),
                      ),*/
                    ],
                  )),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: widget.isContentBarExtended
                      ? widget.contentExtendHeight + 5
                      : 0,
                  child: Column(
                    children: const [
                      SizedBox(
                        height: 5,
                      ),
                      //_menuButtons(),
                    ],
                  )),
            ],
          ),
        ),
      );
    } catch (ex) {
      return const SizedBox.shrink();
    }
  }

  _menu() {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey,
      child: Container(
        height: 55,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(gradient: _gradient()),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: _menuButton(),
              ),
              Expanded(
                flex: 4,
                child: (widget.titleContent != null)
                    ? widget.titleContent!
                    : Text(
                        widget.title,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: KFontSizeXLarge45),
                      ),
              ),
              Expanded(
                flex: 1,
                child: IndexedStack(
                  index: widget.navigationBarAction.index,
                  children: [
                    const SizedBox.shrink(),
                    _buttonFilter(),
                    _buttonNotification(),
                    _buttonClose()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  _menuButtons() {
    return Container(
      height: widget.contentExtendHeight,
      color: Colors.white,
      child: widget.contentExtendContent,
    );
  }*/

  _gradient() {
    return const LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: [
        0.5,
        0.9,
      ],
      colors: [
        Color(0xFFEA6144),
        Color(0xFFEF8D68),
      ],
    );
  }

  _menuButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 5), //<-- this too. 2
      child: Container(
        alignment: Alignment.centerLeft, //<-- menu position. 1
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(gradient: _gradient()),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(32.0)),
          child: Material(
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            child: IconButton(
                icon: widget.hasBack
                    ? Image.asset(
                        'images/button_back.png',
                        alignment: Alignment.centerLeft,
                        height: 20,
                        width: 20,
                      )
                    : Image.asset(
                        'images/icon_menu.png',
                        alignment: Alignment.centerLeft,
                        height: 27,
                        width: 27,
                      ),
                onPressed:
                    widget.hasBack ? widget.onBackClick : widget.onMenuClick),
          ),
        ),
      ),
    );
  }

  _buttonFilter() {
    if (widget.onAcceptPopUpButton != null) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5),
        child: GestureDetector(
          child: Material(
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            child: IconButton(
              icon: Image.asset(
                'images/icon_filter.png',
                alignment: Alignment.centerLeft,
                height: 23,
                width: 23,
              ),
              onPressed: () {
                widget.onAcceptPopUpButton!();
              },
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  _buttonNotification() {
    int quantityNotification = 5;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        child: Material(
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Image.asset(
                  'images/icon_campeign.png',
                  alignment: Alignment.centerLeft,
                  height: 23,
                  width: 23,
                ),
                onPressed: () {
                  //PageManager().goNotificationListPage();
                },
              ),
              Visibility(
                visible: quantityNotification > 0,
                child: Positioned(
                  right: -5,
                  top: 5,
                  child: Container(
                    height: 15,
                    width: 28,
                    decoration: const BoxDecoration(
                        color: Color(0xFFF46A4A),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Text(quantityNotification.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: "Arial",
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buttonClose() {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
        child: Material(
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          child: IconButton(
            icon: Image.asset(
              'images/icon_close.png',
              color: KPrimary,
              alignment: Alignment.centerLeft,
              height: 15,
              width: 15,
            ),
            onPressed: () {
              widget.onCancelClick;
            },
            // {
            //   setState(() {
            //     widget.extended = false;
            //   }
            //   );
            // },
          ),
        ),
      ),
    );
  }
}
