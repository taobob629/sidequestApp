import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wy/config/icon_font.dart';

class SelectView extends StatelessWidget {
  final String label;
  final String tips;
  final String? value;
  final Function? onTap;

  SelectView({
    required this.label,
    required this.tips,
    this.value,
    this.onTap,
  });

  var textColor = Color(0xFFC5C3C6);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 10,
              ).h,
              child: Text(
                label,
                style: TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: FONT_MEDIUM),
              ),
            ),
            Container(
                height: 45.h,
                margin: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 3),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Color(0xff48464a), borderRadius: BorderRadius.circular(10).r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    value == null || value!.isEmpty
                        ? Text(
                            tips,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: textColor, fontFamily: FONT_LIGHT, fontSize: 14.sp),
                          )
                        : Text(
                            value!,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: textColor, fontFamily: FONT_LIGHT, fontSize: 14.sp),
                          ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: textColor,
                      size: 20,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
