import 'package:flutter/material.dart';

import '../../../values/k_colors.dart';

class ButtonComponent extends StatefulWidget {
  const ButtonComponent(
      {super.key,
      this.text = "",
      this.maxLines,
      this.fontSize = 14,
      this.fontWeight = FontWeight.w700,
      this.icon,
      this.height = 50,
      this.width = 100,
      this.borderRadius = 3,
      this.backgroundColor = KPrimary,
      this.borderColor = KPrimary,
      this.textColor = const Color(0xFFFFFFFF),
      this.disableBackgroundColor = const Color(0xFFBDBDBD),
      this.disableBorderColor = const Color(0xFFBDBDBD),
      this.disableTextColor = const Color(0xFFFFFFFF),
      this.disableShadowColor = const Color(0x40666666),
      this.isEnabled = true,
      this.hasShadow = false,
      this.richText,
      required this.onPressed});

  final String text;
  final int? maxLines;
  final double fontSize;
  final FontWeight fontWeight;
  final Widget? icon;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color disableBackgroundColor;
  final Color disableBorderColor;
  final Color disableTextColor;
  final Color disableShadowColor;
  final double borderRadius;
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool hasShadow;
  final RichText? richText;

  @override
  _ButtonComponentState createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.isEnabled
          ? widget.backgroundColor
          : widget.disableBackgroundColor,
      child: InkWell(
        splashColor:
            widget.isEnabled ? Colors.grey.shade400 : Colors.transparent,
        onTap: widget.isEnabled ? widget.onPressed : () {},
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Container(
            height: widget.height,
            width: widget.width,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                  color: widget.isEnabled
                      ? widget.borderColor
                      : widget.disableBorderColor),
              boxShadow: [
                BoxShadow(
                  color: widget.hasShadow
                      ? (!widget.isEnabled
                          ? widget.disableShadowColor.withOpacity(0.1)
                          : widget.disableShadowColor)
                      : Colors.transparent,
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Center(child: _content())),
      ),
    );
  }

  _content() {
    if (widget.icon != null &&
        ((widget.text.isNotEmpty) || widget.richText != null)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(flex: 1, child: widget.icon ?? const SizedBox.shrink()),
          const SizedBox(width: 10),
          Flexible(
            flex: 3,
            child: widget.richText ??
                Text(
                  widget.text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: widget.isEnabled
                          ? widget.textColor
                          : widget.disableTextColor,
                      fontSize: widget.fontSize,
                      fontWeight: widget.fontWeight),
                ),
          )
        ],
      );
    } else if (widget.icon == null && (widget.text.isNotEmpty)) {
      return widget.richText ??
          Text(
            widget.text.isNotEmpty ? widget.text : "",
            style: TextStyle(
                color: widget.isEnabled
                    ? widget.textColor
                    : widget.disableTextColor,
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight),
            overflow: TextOverflow.ellipsis,
            maxLines: widget.maxLines,
          );
    } else if (widget.icon != null) {
      return widget.icon;
    }
    return const SizedBox.shrink();
  }
}
