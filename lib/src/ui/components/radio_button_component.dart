import 'package:flutter/material.dart';

import '../../../values/k_colors.dart';
import '../../../values/k_values.dart';

// ignore: must_be_immutable
class RadioButtonComponent extends StatefulWidget {
  final Widget label;

  final Function(bool isCheck)? onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final Color dotColor;
  final Color borderColor;
  final Color selectedBorderColor;

  bool isSelected;
  final bool isLabelOnTheLeft;
  final double spacing;
  final double height;
  final double width;
  final double fontSize;
  final Color fontColor;
  final bool isEnabled;
  final bool autoCheckOnClick;
  final MainAxisAlignment mainAxisAlignment;

  RadioButtonComponent(
      {super.key,
      required this.label,
      required this.onTap,
      this.selectedColor = KGreyT1,
      this.unselectedColor = KGreyT1,
      this.borderColor = Colors.transparent,
      this.selectedBorderColor = Colors.transparent,
      this.dotColor = KPrimary,
      this.isSelected = false,
      this.isLabelOnTheLeft = false,
      this.spacing = 10,
      this.height = 22,
      this.width = 22,
      this.isEnabled = true,
      this.fontSize = KFontSizeMedium35,
      this.fontColor = KLightblue,
      this.autoCheckOnClick = true,
      this.mainAxisAlignment = MainAxisAlignment.start});

  @override
  _RadioButtonComponentState createState() => _RadioButtonComponentState();
}

class _RadioButtonComponentState extends State<RadioButtonComponent> {
  _RadioButtonComponentState();

  final colorLabel = const Color(0xFF666666);
  final Color shadowColor = const Color(0x1A666666);
  final Color colorDisabled = Colors.grey.shade400;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(),
        child: _content());
  }

  _onTap() {
    if (widget.isEnabled) {
      setState(() {
        if (widget.autoCheckOnClick) {
          widget.isSelected = !widget.isSelected;
        }
      });
      if (widget.onTap != null) {
        widget.onTap!(widget.isSelected);
      }
    }
  }

  _content() {
    List<Widget> children = _getChildren();
    return Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children);
  }

  _getChildren() {
    List<Widget> children = [];
    if (widget.isLabelOnTheLeft) {
      children.addAll([widget.label, const SizedBox(width: 10)]);
      children.add(_checkBox());
    } else {
      children.add(_checkBox());
      children.addAll([
        const SizedBox(width: 10),
        widget.label,
      ]);
    }
    return children;
  }

  _checkBox() {
    return Container(
      margin: const EdgeInsets.only(top: 3, bottom: 3),
      padding: const EdgeInsets.all(1),
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color:
            widget.isSelected ? widget.selectedColor : widget.unselectedColor,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
            width: 1.5,
            color: widget.isEnabled
                ? widget.isSelected
                    ? widget.selectedBorderColor
                    : widget.borderColor
                : colorDisabled),
      ),
      child: Visibility(
        visible: widget.isSelected,
        child: Container(
            color: widget.isSelected
                ? widget.selectedColor
                : widget.unselectedColor,
            height: 5,
            child: Icon(
              Icons.circle,
              size: 17,
              color: widget.isEnabled ? widget.dotColor : colorDisabled,
            )),
      ),
    );
  }
}
