import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/config/icon_font.dart';

import 'colorful_button.dart';

class FloatingButton extends StatelessWidget {
  final String label;
  final Function? onTap;

  FloatingButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ColorfulButton(
        height: 20.h,
        borderRadius: 20.h,
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: FONT_MEDIUM),
          ),
        ),
        onTap: () => onTap?.call(),
      ),
    );
  }
}
