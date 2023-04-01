import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/res/index.dart';

class InputView extends StatelessWidget {
  final String label;
  final String tips;
  final TextInputType textInputType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  double height;
  bool readOnly;
  final Widget? customInput;
  final Widget? customLabel;
  final Widget? rightActionWidget;
  final Widget? inputLable;
  EdgeInsets padding;
  EdgeInsets? margin;
  final bool autoHeight;
  Decoration? decoration;
  bool showRightIcon;

  InputView(
      {required this.label,
      required this.tips,
      this.textInputType = TextInputType.text,
      this.controller,
      this.focusNode,
      this.inputFormatters,
      this.maxLength,
      this.customInput,
      this.customLabel,
      this.inputLable,
      this.height = 40,
      this.decoration,
      this.showRightIcon = false,
      this.rightActionWidget,
      this.readOnly = false,
      this.padding = const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      this.margin = const EdgeInsets.only(left: 15, right: 15),
      this.autoHeight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding,
          child: customLabel ??
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: FONT_MEDIUM),
                  ),
                  rightActionWidget ?? Container()
                ],
              ),
        ),
        5.verticalSpace,
        Row(
          children: [
            if (inputLable != null) inputLable!,
            Expanded(
              child: Container(
                height: autoHeight ? null : height,
                margin: margin ??
                    EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: decoration ?? inputDecoration(),
                alignment: Alignment.center,
                child: customInput ??
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: 1,
                            focusNode: focusNode,
                            controller: controller,
                            cursorColor: Colors.white70,
                            textAlign: TextAlign.start,
                            keyboardType: textInputType,
                            inputFormatters: inputFormatters,
                            maxLength: maxLength,
                            readOnly: readOnly,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            onSubmitted: (text) => {},
                            decoration: InputDecoration(
                              hintText: tips,
                              counterText: '',
                              hintStyle: inputHint(),
                              border: InputBorder.none,
                              //  contentPadding: EdgeInsets.only(bottom: 8)
                            ),
                          ),
                        ),
                        if (showRightIcon)
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                      ],
                    ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
