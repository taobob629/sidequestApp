/**
    author:mac
    创建日期:2023/4/1
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/icon_font.dart';

class IconTextWidget extends StatelessWidget {
  Widget? spacing;
  String icon;
  Widget? iconWidget;
  Color? iconColor;
  Color? textColor;
  String text;
  double? size;
  MainAxisAlignment mainAxisAlignment;

  IconTextWidget(
      {this.spacing,
      this.size,
      required this.icon,
      this.iconColor,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.textColor,
      this.iconWidget,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        iconWidget ??
            Image.asset(icon, color: iconColor ?? Colors.white, width: size, height: size),
        spacing ?? 8.5.horizontalSpace,
        Expanded(
            child: Text(
          '$text',
          softWrap: true,
          maxLines: null,
          style: TextStyle(
              fontSize: 14.sp,
              color: textColor,
              fontFamily: FONT_LIGHT,
              overflow: TextOverflow.ellipsis),
        ))
      ],
    );
  }
}
