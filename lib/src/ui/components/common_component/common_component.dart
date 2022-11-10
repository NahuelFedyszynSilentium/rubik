import 'package:flutter/material.dart';

import '../../../../values/k_colors.dart';

Widget closableContainer({
  Widget child = const SizedBox.shrink(),
  Function? onClose,
  double width = double.infinity,
  double height = double.minPositive,
  bool isVisible = true,
  Color backgroundColor = KGrey,
}) {
  return Visibility(
    visible: isVisible,
    child: Stack(
      children: [
        Container(
          color: backgroundColor,
          width: width,
          height: height,
          child: child,
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: () {
              onClose != null ? onClose() : () {};
            },
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                      image: AssetImage("images/button_close.png"))),
              height: 40,
              width: 40,
            ),
          ),
        ),
      ],
    ),
  );
}
