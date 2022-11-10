import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../values/k_colors.dart';
import '../../../values/k_values.dart';
import '../../utils/extensions.dart';
import '../../utils/formatters/date_formatter.dart';
import '../../utils/formatters/date_formatters_MMYYYY.dart';
import '../../utils/formatters/time_formatter.dart';

enum ItemDataFormType {
  text,
  number,
  areaCode,
  date,
  dropDown,
  images,
  signature,
  checkBoxLabel,
  time,
  dynamic
}

class ItemDataFormComponent extends StatefulWidget {
  //COMMONS
  String errorPlaceholder;
  bool showErrorPlaceholder;
  late ItemDataFormType type;
  bool isValid;
  String label;
  Color backgroundColor;
  bool hasDividerLine;
  String placeHolder;
  late TextInputType inputType;
  int maxLength = -1;
  bool readOnly = false;
  List<BoxShadow>? boxShadow = const [BoxShadow(color: Colors.transparent)];
  EdgeInsets innerPadding = const EdgeInsets.symmetric(horizontal: 20);
  bool isEnabled = true;
  EdgeInsets contentPadding = EdgeInsets.zero;
  double inputTextSize = KFontSizeLarge40;

  //TEXT
  TextEditingController? controller;
  bool hasPassword = false;
  bool isPasswordEnabled = true;
  int? maxLines;
  int? minLines;
  double borderRadius = 5;
  double height = 10;
  double fontSize = KFontSizeMedium35;
  double hintTextSize = KFontSizeLarge40;
  TextInputType textInputType = TextInputType.datetime;
  FocusNode? focusNode = FocusNode();
  Function? onSubmitted;
  Color hintTextColor = KLightblue;

  //NUMBERS

  //DATE
  // DateTime selectedDate;
  // Function(DateTime selectedDate) onSelectedDate;

  //TIME
  late bool hasExpirationMask;
  // List<CustomSelectionOptionModel> listTime;
  // CustomSelectionOptionModel selectedTime;
  // Function(CustomSelectionOptionModel selectedDate) onSelectedTime;

  //DROPDOWN
  late List<dynamic> items;
  late dynamic selectedItem;
  late Function onChange;
  late EdgeInsets itemsPadding;
  late Color textColor;
  late FontWeight fontWeight;
  late List<List<dynamic>> tooltipMessages;

  //Dynamic
  List<TextInputFormatter> inputFormatters = [];

  //IMAGEID
  // String labelImage1;
  // String labelImage2;

  //CHECKBOX
  // bool autoCheckOnClick;
  // String checkBoxLabel;
  // Widget checkBoxWidget;
  // CheckBoxLabelType checkBoxType;
  // bool isSelected;
  // String iconLeftPath;
  // Function(bool isCheck) onTap;

  //SIGNATURE
  // Color colorSignature;

  ItemDataFormComponent.text({
    super.key,
    this.isValid = true,
    this.borderRadius = 0,
    this.height = 33,
    this.fontSize = KFontSizeXXLarge55,
    this.hintTextSize = KFontSizeXXLarge55,
    this.label = '',
    this.textInputType = TextInputType.text,
    this.hasPassword = false,
    required this.controller,
    this.placeHolder = '',
    this.errorPlaceholder = '',
    this.showErrorPlaceholder = true,
    this.backgroundColor = Colors.transparent,
    this.hasDividerLine = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.boxShadow = const [BoxShadow(color: Colors.transparent)],
    this.readOnly = false,
    this.maxLength = -1,
    this.innerPadding = const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
    this.isEnabled = true,
    this.inputTextSize = KFontSizeXXLarge55,
    this.contentPadding = EdgeInsets.zero,
    this.onSubmitted,
    this.inputFormatters = const [],
    this.hintTextColor = KLightblue,
    this.textColor = KLightblue,
  }) {
    type = ItemDataFormType.text;
  }

  ItemDataFormComponent.number({
    super.key,
    this.isValid = true,
    this.borderRadius = 0,
    this.label = '',
    this.placeHolder = '',
    this.errorPlaceholder = '',
    this.showErrorPlaceholder = true,
    this.inputType = TextInputType.number,
    this.backgroundColor = const Color(0xFFF7F7F7),
    this.hasDividerLine = false,
    this.maxLength = -1,
    this.hasPassword = false,
    this.focusNode,
    this.controller,
    this.innerPadding = const EdgeInsets.symmetric(horizontal: 20),
    this.hintTextSize = KFontSizeMedium35,
    this.height = 33,
    this.boxShadow = const [BoxShadow(color: Colors.transparent)],
    this.textInputType = TextInputType.number,
    this.isEnabled = true,
    this.inputTextSize = KFontSizeLarge40,
    this.contentPadding = EdgeInsets.zero,
    this.maxLines = 1,
    this.minLines = 1,
  }) {
    type = ItemDataFormType.number;
  }

  ItemDataFormComponent.areaCode({
    super.key,
    this.isValid = true,
    this.borderRadius = 0,
    this.label = '',
    this.placeHolder = '',
    this.errorPlaceholder = '',
    this.showErrorPlaceholder = true,
    this.inputType = TextInputType.number,
    this.backgroundColor = const Color(0xFFF7F7F7),
    this.hasDividerLine = false,
    this.maxLength = -1,
    this.focusNode,
    this.controller,
    this.innerPadding = const EdgeInsets.symmetric(horizontal: 20),
    this.hintTextSize = KFontSizeMedium35,
    this.height = 33,
    this.boxShadow = const [BoxShadow(color: Colors.transparent)],
    this.textInputType = TextInputType.number,
    this.isEnabled = true,
    this.inputTextSize = KFontSizeLarge40,
    this.contentPadding = EdgeInsets.zero,
    this.maxLines = 1,
    this.minLines = 1,
  }) {
    type = ItemDataFormType.areaCode;
  }

  // ItemDataFormComponent.date(
  //     {this.key,
  //     this.isValid = true,
  //     this.label = '',
  //     this.backgroundColor = Colors.white,
  //     this.selectedDate,
  //     this.errorPlaceholder,
  //     this.showErrorPlaceholder = true,
  //     this.onSelectedDate,
  //     this.hasDividerLine = false})
  //     : super(key: key) {
  //   type = ItemDataFormType.date;
  // }

  // ItemDataFormComponent.time(
  //     {this.key,
  //     this.isValid = true,
  //     this.label = '',
  //     this.backgroundColor = Colors.white,
  //     this.selectedTime,
  //     this.errorPlaceholder,
  //     this.showErrorPlaceholder = true,
  //     @required this.listTime,
  //     this.onSelectedTime,
  //     this.hasDividerLine = false})
  //     : super(key: key) {
  //   type = ItemDataFormType.time;
  // }

  ItemDataFormComponent.dropDown({
    super.key,
    this.isValid = true,
    this.label = '',
    this.backgroundColor = const Color(0xFFF7F7F7),
    required this.items,
    this.selectedItem,
    this.errorPlaceholder = '',
    this.showErrorPlaceholder = true,
    required this.onChange,
    this.placeHolder = '',
    this.boxShadow = const [BoxShadow(color: Colors.transparent)],
    this.hasDividerLine = false,
    this.innerPadding = const EdgeInsets.symmetric(horizontal: 20),
    this.isEnabled = true,
    this.contentPadding = EdgeInsets.zero,
    this.itemsPadding = EdgeInsets.zero,
    this.textColor = const Color(0xFF9B9B9B),
    this.fontWeight = FontWeight.normal,
    this.fontSize = KFontSizeMedium35,
    this.tooltipMessages = const [
      ['']
    ],
  }) {
    type = ItemDataFormType.dropDown;
  }

  ItemDataFormComponent.date({
    super.key,
    this.isValid = true,
    this.borderRadius = 0,
    this.height = 33,
    this.fontSize = KFontSizeMedium35,
    this.hintTextSize = KFontSizeMedium35,
    this.label = '',
    this.textInputType = TextInputType.text,
    this.hasPassword = false,
    required this.controller,
    this.placeHolder = '',
    this.errorPlaceholder = '',
    this.showErrorPlaceholder = true,
    this.backgroundColor = const Color(0xFFF7F7F7),
    this.hasDividerLine = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.boxShadow = const [BoxShadow(color: Colors.transparent)],
    this.readOnly = false,
    this.maxLength = -1,
    this.innerPadding = const EdgeInsets.symmetric(horizontal: 20),
    this.isEnabled = true,
    this.contentPadding = EdgeInsets.zero,
    this.hasExpirationMask = false,
  }) {
    type = ItemDataFormType.date;
  }

  ItemDataFormComponent.time({
    super.key,
    this.isValid = true,
    this.borderRadius = 0,
    this.height = 33,
    this.fontSize = KFontSizeMedium35,
    this.hintTextSize = KFontSizeMedium35,
    this.label = '',
    this.textInputType = TextInputType.text,
    this.hasPassword = false,
    required this.controller,
    this.placeHolder = '',
    this.errorPlaceholder = '',
    this.showErrorPlaceholder = true,
    this.backgroundColor = const Color(0xFFF7F7F7),
    this.hasDividerLine = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.boxShadow = const [BoxShadow(color: Colors.transparent)],
    this.readOnly = false,
    this.maxLength = -1,
    this.innerPadding = const EdgeInsets.symmetric(horizontal: 20),
    this.isEnabled = true,
    this.contentPadding = EdgeInsets.zero,
  }) {
    type = ItemDataFormType.time;
  }

  ItemDataFormComponent.dynamic({
    super.key,
    this.isValid = true,
    this.borderRadius = 0,
    this.height = 33,
    this.fontSize = KFontSizeMedium35,
    this.hintTextSize = KFontSizeMedium35,
    this.label = '',
    this.textInputType = TextInputType.text,
    this.hasPassword = false,
    required this.controller,
    this.placeHolder = '',
    this.errorPlaceholder = '',
    this.showErrorPlaceholder = true,
    this.backgroundColor = const Color(0xFFF7F7F7),
    this.hasDividerLine = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.boxShadow = const [BoxShadow(color: Colors.transparent)],
    this.readOnly = false,
    this.maxLength = -1,
    this.innerPadding = const EdgeInsets.symmetric(horizontal: 20),
    this.isEnabled = true,
    this.contentPadding = EdgeInsets.zero,
    this.inputFormatters = const [],
  }) {
    type = ItemDataFormType.dynamic;
  }

  // ItemDataFormComponent.checkBoxLabel(
  //     {this.key,
  //     this.isValid = true,
  //     this.label = '',
  //     this.autoCheckOnClick = true,
  //     required this.checkBoxType,
  //     this.checkBoxLabel = '',
  //     this.errorPlaceholder = '',
  //     this.showErrorPlaceholder = false,
  //     required this.checkBoxWidget,
  //     this.isSelected = false,
  //     this.iconLeftPath = '',
  //     required this.onTap,
  //     this.hasDividerLine = false})
  //     : super(key: key) {
  //   type = ItemDataFormType.checkBoxLabel;
  // }

  @override
  _ItemDataFormComponentState createState() => _ItemDataFormComponentState();
}

class _ItemDataFormComponentState extends State<ItemDataFormComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _content(),
        const SizedBox(
          height: 5,
        ),
        Visibility(
            visible: !widget.isValid && widget.showErrorPlaceholder,
            child: Text(
              widget.errorPlaceholder.isNullOrEmpty()
                  ? 'Este campo es requerido'
                  : widget.errorPlaceholder,
              style: const TextStyle(
                  color: Colors.red, fontSize: KFontSizeXSmall25),
            )),
      ],
    );
  }

  _content() {
    switch (widget.type) {
      case ItemDataFormType.text:
        return _text();
      case ItemDataFormType.number:
        return _number();
      // case ItemDataFormType.areaCode:
      //   return _areaCode();
      case ItemDataFormType.date:
        return _date();
      case ItemDataFormType.dropDown:
        return _dropDown();
      case ItemDataFormType.dynamic:
        return _dynamic();
      case ItemDataFormType.time:
        return _time();
      // case ItemDataFormType.checkBoxLabel:
      //   return _checkBoxLabel();
      //   break;

      //   break;
      default:
        return _text();
    }
  }

  _text() {
    return Container(
      padding: widget.contentPadding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.backgroundColor,
          boxShadow: widget.boxShadow ?? const [BoxShadow()]),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius)),
              alignment: Alignment.center,
              height: widget.height,
              child: Material(
                color: widget.backgroundColor,
                child: TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(widget.maxLength),
                    ...widget.inputFormatters
                  ],
                  enabled: widget.isEnabled,
                  readOnly: widget.readOnly,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  keyboardType: widget.textInputType,
                  controller: widget.controller,
                  cursorColor: Colors.grey,
                  obscureText: widget.isPasswordEnabled && widget.hasPassword,
                  obscuringCharacter: "*",
                  onSubmitted: (value) {
                    widget.onSubmitted != null
                        ? widget.onSubmitted!(value)
                        : () {};
                  },
                  style: TextStyle(
                      color: widget.isValid
                          ? widget.readOnly
                              ? Colors.grey.shade400
                              : widget.textColor
                          : Colors.red,
                      fontSize: widget.inputTextSize),
                  decoration: InputDecoration(
                      contentPadding: widget.innerPadding,
                      hintText: widget.placeHolder.hasValue()
                          ? widget.placeHolder
                          : '',
                      hintStyle: TextStyle(
                          color: widget.hintTextColor,
                          fontSize: widget.hintTextSize),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.5),
                      ),
                      isCollapsed: true),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.hasPassword,
            child: InkWell(
              onTap: () {
                setState(() {
                  widget.isPasswordEnabled = !widget.isPasswordEnabled;
                });
              },
              child: _getIcon(),
            ),
          )
        ],
      ),
    );
  }

  _getIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Image.asset(
        widget.isPasswordEnabled
            ? 'images/icon_eye_disabled.png'
            : 'images/icon_eye_enabled.png',
        height: 20,
        width: 20,
        fit: BoxFit.contain,
      ),
    );
  }

  _number() {
    return Container(
      padding: widget.contentPadding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.backgroundColor,
          boxShadow:
              widget.boxShadow ?? const [BoxShadow(color: Colors.transparent)]),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius)),
              alignment: Alignment.center,
              height: widget.height,
              child: Material(
                color: widget.backgroundColor,
                child: TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(widget.maxLength),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  enabled: widget.isEnabled,
                  readOnly: widget.readOnly,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  keyboardType: widget.textInputType,
                  controller: widget.controller,
                  cursorColor: Colors.grey,
                  obscureText: widget.isPasswordEnabled && widget.hasPassword,
                  obscuringCharacter: "*",
                  style: TextStyle(
                      color: widget.isValid
                          ? widget.readOnly
                              ? Colors.grey.shade400
                              : Colors.grey
                          : Colors.red,
                      fontSize: widget.inputTextSize),
                  decoration: InputDecoration(
                      contentPadding: widget.innerPadding,
                      hintText: widget.placeHolder.hasValue()
                          ? widget.placeHolder
                          : '',
                      hintStyle: TextStyle(
                          color: Colors.grey, fontSize: widget.hintTextSize),
                      border: InputBorder.none,
                      isCollapsed: true),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.hasPassword,
            child: InkWell(
              onTap: () {
                setState(() {
                  widget.isPasswordEnabled = !widget.isPasswordEnabled;
                });
              },
              child: _getIcon(),
            ),
          )
        ],
      ),
    );
  }

  // _areaCode() {
  //   double screenSize = MediaQuery.of(context).size.width;
  //   final key = GlobalKey<State<Tooltip>>();
  //   return Container(
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(widget.borderRadius),
  //         color: widget.backgroundColor,
  //         boxShadow: widget.boxShadow != null
  //             ? widget.boxShadow
  //             : [BoxShadow(color: Colors.transparent)]),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Container(
  //             decoration: BoxDecoration(
  //                 color: widget.backgroundColor,
  //                 borderRadius: BorderRadius.circular(widget.borderRadius)),
  //             alignment: Alignment.center,
  //             height: widget.height,
  //             child: Material(
  //               color: widget.backgroundColor,
  //               child: TextField(
  //                 focusNode: widget.focusNode,
  //                 inputFormatters: [
  //                   new LengthLimitingTextInputFormatter(widget.maxLength),
  //                   FilteringTextInputFormatter.digitsOnly,
  //                 ],
  //                 enabled: widget.isEnabled,
  //                 readOnly: widget.readOnly,
  //                 maxLines: widget.maxLines,
  //                 minLines: widget.minLines,
  //                 keyboardType: widget.textInputType,
  //                 controller:
  //                     widget.controller != null ? widget.controller : null,
  //                 cursorColor: Colors.grey,
  //                 obscureText: widget.isPasswordEnabled && widget.hasPassword,
  //                 obscuringCharacter: "*",
  //                 style: TextStyle(
  //                     color: widget.isValid
  //                         ? widget.readOnly
  //                             ? Colors.grey.shade400
  //                             : Colors.grey
  //                         : Colors.red,
  //                     fontSize: widget.inputTextSize),
  //                 decoration: InputDecoration(
  //                     contentPadding: widget.innerPadding,
  //                     hintText: widget.placeHolder.hasValue()
  //                         ? widget.placeHolder
  //                         : '',
  //                     hintStyle: TextStyle(
  //                         color: Colors.grey, fontSize: widget.hintTextSize),
  //                     border: InputBorder.none,
  //                     isCollapsed: true),
  //               ),
  //             ),
  //           ),
  //         ),
  //         Visibility(
  //           //visible: isValidAreaCode(widget.controller!.text),
  //           child: Tooltip(
  //             key: key,
  //             message: _getAreaCodeCityName(widget.controller!.text),
  //             verticalOffset: -48,
  //             child: GestureDetector(
  //               behavior: HitTestBehavior.opaque,
  //               onTap: () {
  //                 final dynamic tooltip = key.currentState;
  //                 tooltip?.ensureTooltipVisible();
  //                 Timer(Duration(milliseconds: 2000),
  //                     () => tooltip?..deactivate());
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.only(right: 7),
  //                 child: Image.asset(
  //                   'images/icon_successful.png',
  //                   height: screenSize < 480 ? 13 : 17,
  //                   fit: BoxFit.contain,
  //                   color: KPrimary,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // _getAreaCodeCityName(String? input) {
  //   List<Map<String, String>> areaCodes = KAreaCodes;
  //   for (var areaCode in areaCodes) {
  //     if (areaCode.containsValue(input)) {
  //       return areaCode.values.elementAt(1);
  //     }
  //   }
  //   return '';
  // }

  _dynamic() {
    return Container(
      padding: widget.contentPadding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.backgroundColor,
          boxShadow: widget.boxShadow ?? const [BoxShadow()]),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius)),
              alignment: Alignment.center,
              height: widget.height,
              child: Material(
                color: widget.backgroundColor,
                child: TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(widget.maxLength),
                    ...widget.inputFormatters,
                  ],
                  enabled: widget.isEnabled,
                  readOnly: widget.readOnly,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  keyboardType: widget.textInputType,
                  controller: widget.controller,
                  cursorColor: Colors.grey,
                  obscureText: widget.isPasswordEnabled && widget.hasPassword,
                  obscuringCharacter: "*",
                  style: TextStyle(
                      color: widget.isValid
                          ? widget.readOnly
                              ? Colors.grey.shade400
                              : Colors.grey
                          : Colors.red,
                      fontSize: KFontSizeLarge40),
                  decoration: InputDecoration(
                      contentPadding: widget.innerPadding,
                      hintText: widget.placeHolder.hasValue()
                          ? widget.placeHolder
                          : '',
                      hintStyle: TextStyle(
                          color: Colors.grey, fontSize: widget.hintTextSize),
                      border: InputBorder.none,
                      isCollapsed: true),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.hasPassword,
            child: InkWell(
              onTap: () {
                setState(() {
                  widget.isPasswordEnabled = !widget.isPasswordEnabled;
                });
              },
              child: _getIcon(),
            ),
          )
        ],
      ),
    );
  }

  // _date() {
  //   return GestureDetector(
  //     key: Key("itemFormDataDateEntry"),
  //     onTap: () => _selectDate(context),
  //     child: Material(
  //       color: widget.backgroundColor,
  //       child: Align(
  //         alignment: Alignment.centerLeft,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               widget.selectedDate != null
  //                   ? DateFormat('dd/MM/yyyy').format(widget.selectedDate)
  //                   : "Día",
  //               style: TextStyle(
  //                   color: widget.selectedDate != null ? KGray : KGray_L2),
  //             ),
  //             Image.asset(
  //               'images/icon_arrow_right.png',
  //               color: KPrimary,
  //               height: 15,
  //               width: 15,
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // _time() {
  //   return GestureDetector(
  //     key: Key("itemFormDataTimeEntry"),
  //     onTap: () => _selectTime(context),
  //     child: Material(
  //       color: widget.backgroundColor,
  //       child: Align(
  //         alignment: Alignment.centerLeft,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               widget.selectedTime != null
  //                   ? widget.selectedTime.name.toString()
  //                   : "Hora",
  //               style: TextStyle(
  //                   color:
  //                       widget.selectedTime?.name != null ? KGray : KGray_L2),
  //             ),
  //             Image.asset(
  //               'images/icon_arrow_right.png',
  //               color: KPrimary,
  //               height: 15,
  //               width: 15,
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // _selectDate(BuildContext context) async {
  //   DateTime result = await DateSelectionAlertPopup(
  //     context: context,
  //     selectedDate:
  //         widget.selectedDate != null ? widget.selectedDate : DateTime.now(),
  //     startDate: DateTime(1920),
  //   ).show();
  //   setState(() {
  //     widget.selectedDate = result;
  //     widget.onSelectedDate(result);
  //   });
  // }

  // _selectTime(BuildContext context) async {
  //   CustomSelectionOptionModel result = await CustomSelectionPopup(
  //     context: context,
  //     selectedOption: widget.selectedTime,
  //     list: widget.listTime,
  //     title: "Seleccionar hora",
  //   ).show();
  //   setState(() {
  //     widget.selectedTime = result;
  //     widget.onSelectedTime(result);
  //   });
  // }

  _dropDown() {
    return Container(
        decoration: BoxDecoration(
          boxShadow: widget.boxShadow,
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: widget.backgroundColor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: DropdownButton(
            hint: Padding(
              padding: widget.innerPadding,
              child: Text(
                widget.selectedItem != null
                    ? widget.selectedItem.toString()
                    : widget.placeHolder, //TODO i18n
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: widget.textColor,
                  fontWeight: widget.fontWeight,
                  fontSize: widget.fontSize,
                ),
              ),
            ),
            isExpanded: true,
            isDense: true,
            style: TextStyle(
              color: widget.textColor,
              fontWeight: widget.fontWeight,
              fontSize: widget.fontSize,
            ),
            underline: const SizedBox.shrink(),
            icon: const Icon(Icons.keyboard_arrow_down,
                size: 23, color: KPrimary),
            elevation: 0,
            dropdownColor: widget.backgroundColor,
            items: widget.items.map((dynamic value) {
              return DropdownMenuItem<String>(
                value: value,
                child: widget.tooltipMessages[0][0] != '' &&
                        tooltipMessage(widget.tooltipMessages, value) != ''
                    ? Tooltip(
                        message: tooltipMessage(widget.tooltipMessages, value),
                        //verticalOffset: -48,
                        child: tooltipChild(value),
                      )
                    : tooltipChild(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                widget.selectedItem = newValue;
                widget.onChange(newValue);
              });
            },
          ),
        ));
  }

  tooltipChild(dynamic value) {
    return Padding(
      padding: widget.itemsPadding,
      child: Text(
        value,
        style: TextStyle(
          color: widget.textColor,
          fontWeight: widget.fontWeight,
          fontSize: widget.fontSize,
        ),
      ),
    );
  }

  tooltipMessage(List<List<dynamic>> valueMessages, String value) {
    String message = "";
    for (var valueMessage in valueMessages) {
      if (valueMessage[1] == value) message = valueMessage[0];
    }
    return message;
  }

  _date() {
    return Container(
      padding: widget.contentPadding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.backgroundColor,
          boxShadow: widget.boxShadow ?? [const BoxShadow()]),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius)),
              alignment: Alignment.center,
              height: widget.height,
              child: Material(
                color: widget.backgroundColor,
                child: TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(widget.maxLength),
                    widget.hasExpirationMask
                        ? DateFormatterMMYY()
                        : DateFormatter(),
                  ],
                  enabled: widget.isEnabled,
                  readOnly: widget.readOnly,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  keyboardType: widget.textInputType,
                  controller: widget.controller,
                  cursorColor: Colors.grey,
                  obscureText: widget.isPasswordEnabled && widget.hasPassword,
                  obscuringCharacter: "*",
                  style: TextStyle(
                      color: widget.isValid
                          ? widget.readOnly
                              ? Colors.grey.shade400
                              : Colors.grey
                          : Colors.red,
                      fontSize: KFontSizeLarge40),
                  decoration: InputDecoration(
                      contentPadding: widget.innerPadding,
                      hintText: widget.placeHolder.hasValue()
                          ? widget.placeHolder
                          : '',
                      hintStyle: TextStyle(
                          color: Colors.grey, fontSize: widget.hintTextSize),
                      border: InputBorder.none,
                      isCollapsed: true),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.hasPassword,
            child: InkWell(
              onTap: () {
                setState(() {
                  widget.isPasswordEnabled = !widget.isPasswordEnabled;
                });
              },
              child: _getIcon(),
            ),
          )
        ],
      ),
    );
  }

  _time() {
    return Container(
      padding: widget.contentPadding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: widget.backgroundColor,
          boxShadow: widget.boxShadow ?? const [BoxShadow()]),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius)),
              alignment: Alignment.center,
              height: widget.height,
              child: Material(
                color: widget.backgroundColor,
                child: TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(5),
                    TimeFormatter(),
                  ],
                  enabled: widget.isEnabled,
                  readOnly: widget.readOnly,
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  keyboardType: widget.textInputType,
                  controller: widget.controller,
                  cursorColor: Colors.grey,
                  obscureText: widget.isPasswordEnabled && widget.hasPassword,
                  obscuringCharacter: "*",
                  style: TextStyle(
                      color: widget.isValid
                          ? widget.readOnly
                              ? Colors.grey.shade400
                              : Colors.grey
                          : Colors.red,
                      fontSize: KFontSizeLarge40),
                  decoration: InputDecoration(
                      contentPadding: widget.innerPadding,
                      hintText: widget.placeHolder.hasValue()
                          ? widget.placeHolder
                          : '',
                      hintStyle: TextStyle(
                          color: Colors.grey, fontSize: widget.hintTextSize),
                      border: InputBorder.none,
                      isCollapsed: true),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.hasPassword,
            child: InkWell(
              onTap: () {
                setState(() {
                  widget.isPasswordEnabled = !widget.isPasswordEnabled;
                });
              },
              child: _getIcon(),
            ),
          )
        ],
      ),
    );
  }

  // _checkBoxLabel() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Visibility(
  //         visible: !widget.iconLeftPath.isNullOrEmpty(),
  //         child: Container(
  //           padding: EdgeInsets.only(right: 10),
  //           height: 27,
  //           width: 27,
  //           child: Image.asset(
  //             widget.iconLeftPath,
  //             color: KGray,
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         child: CheckboxComponent(
  //           autoCheckOnClick: widget.autoCheckOnClick,
  //           isLabelOnTheLeft: widget.checkBoxType == CheckBoxLabelType.left,
  //           mainAxisAlignment: widget.checkBoxType == CheckBoxLabelType.left
  //               ? MainAxisAlignment.spaceBetween
  //               : widget.checkBoxType == CheckBoxLabelType.center
  //                   ? MainAxisAlignment.center
  //                   : MainAxisAlignment.start,
  //           icon: ImageIcon(
  //             AssetImage("images/icon_checkbox.png"),
  //             color: KPrimary,
  //           ),
  //           onTap: widget.onTap,
  //           label: Flexible(
  //             child: Material(
  //               type: MaterialType.transparency,
  //               child: !widget.checkBoxLabel.isNullOrEmpty()
  //                   ? Text(
  //                       widget.checkBoxLabel,
  //                       style: TextStyle(
  //                         color: KGray,
  //                         fontWeight: FontWeight.normal,
  //                         fontSize: KFontSizeMedium35,
  //                       ),
  //                     )
  //                   : widget.checkBoxWidget,
  //             ),
  //           ),
  //           isSelected: widget.isSelected,
  //         ),
  //       ),
  //     ],
  //   );
  // }

}

cardExpirationMask(
    {required ItemDataFormComponent entry,
    required String character,
    required int position}) {
  entry.controller!.addListener(() {
    if (entry.controller!.text.length == position) {
      String entryDate = entry.controller!.text;

      if (entry.controller!.text[position] == character) {
        entry.controller!.text =
            entry.controller!.text.substring(0, position + 1);
      } else {
        entry.controller!.text = entryDate.substring(0, position) +
            character +
            entryDate[entryDate.length - 1];
      }
    }
  });
  return entry;
}
