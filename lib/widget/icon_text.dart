/**
    author:mac
    创建日期:2023/4/1
    描述:
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/config/icon_font.dart';
import 'package:wy/utils/image_util.dart';

class IconTextWidget extends StatelessWidget {
  Widget? spacing;
  String icon;
  Color? iconColor;
  Color? textColor;
  String text;
  double? size;

  IconTextWidget(
      {this.spacing,
      this.size,
      required this.icon,
      this.iconColor,
      this.textColor,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageUtil.assetImage(icon, color: iconColor ?? Colors.white, width: size, height: size),
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
