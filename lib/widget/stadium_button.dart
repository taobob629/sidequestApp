import 'package:flutter/material.dart';
import 'package:wy/config/app_color.dart';

class StadiumButton extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final TextStyle textStyle;
  final Function() onTap;

  StadiumButton(this.text,
      {this.width,
      this.height,
      this.padding,
      this.textStyle = const TextStyle(color: Colors.white, fontSize: 16),
      required this.onTap});

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(
          shape: StadiumBorder(),
          gradient: LinearGradient(colors: AppColor.buttonGradientBg, tileMode: TileMode.decal),
        ),
        child: ElevatedButton(
          onPressed: onTap,
          child: Text(
            text ?? 'unknown',
            style: textStyle,
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(StadiumBorder()),
            padding: MaterialStateProperty.all(padding),
            textStyle: MaterialStateProperty.all(textStyle),
            //去除阴影
            elevation: MaterialStateProperty.all(0),
            //将按钮背景设置为透明
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),
      );
}
