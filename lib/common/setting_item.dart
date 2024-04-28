import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/icon_font.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final String? info;
  final Function onTap;

  SettingItem({required this.title, required this.onTap, this.info});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap.call(),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontFamily: FONT_LIGHT,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        info == null ? "" : info!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    5.horizontalSpace,
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Color(0xFFC5C3C6),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
