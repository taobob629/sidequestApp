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
  final Widget? customInput;
  final Widget? customLabel;
  final bool autoHeight;
  Decoration? decoration;
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
      this.height = 40,
        this.decoration,
      this.autoHeight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          child: customLabel ??
              Text(
                label,
                style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: FONT_MEDIUM),
              ),
        ),
        Container(
          height: autoHeight ? null : height,
          margin: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: decoration??inputDecoration(),
          alignment: Alignment.center,
          child: customInput ??
              TextField(
                maxLines: 1,
                focusNode: focusNode,
                controller: controller,
                cursorColor: Colors.white70,
                textAlign: TextAlign.start,
                keyboardType: textInputType,
                inputFormatters: inputFormatters,
                maxLength: maxLength,
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
        )
      ],
    );
  }
}
