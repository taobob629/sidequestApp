import 'package:flutter/material.dart';
import 'package:wy/config/app_color.dart';

class Button extends StatelessWidget {
  final String? text;
  final Color borderColor;
  final Color fillColor;
  final Color splashColor;
  final double radius;
  final double height;
  final double? width;
  final bool isBorder;
  final bool isFill;
  final void Function()? onPressed;
  final Widget child;

  const Button({
    Key? key,
    this.text,
    this.borderColor = Colors.black12,
    this.radius = 0,
    this.isBorder = false,
    this.isFill = false,
    this.height = 40,
    this.width,
    this.onPressed,
    required this.child,
    this.fillColor = Colors.black12,
    this.splashColor = const Color(0x08000000),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Material(
        color: isFill ? fillColor : Colors.transparent,
        child: onPressed == null
            ? Container(
                height: height,
                width: width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    width: isBorder ? 1 : 0,
                    color: isBorder ? borderColor : Colors.transparent,
                  ),
                ),
                child: child,
              )
            : InkWell(
                onTap: onPressed,
                splashColor: splashColor,
                highlightColor: splashColor,
                child: Container(
                  height: height,
                  width: width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(
                      width: isBorder ? 1 : 0,
                      color: isBorder ? borderColor : Colors.transparent,
                    ),
                  ),
                  child: child,
                ),
              ),
      ),
    );
  }
}

class ClickIcon extends StatelessWidget {
  var size;
  IconData? icon;
  Function()? onTap;
  Color? color;
  Widget? customIcon;

  ClickIcon({this.size, this.icon, this.onTap, this.color, this.customIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: InkWell(
        onTap: onTap,
        child: customIcon ??
            Icon(
              icon,
              size: size ?? 16,
              color: color ?? AppColor.iconColorPrimary,
            ),
      ),
    );
  }
}

class ClickableWidget extends StatelessWidget {
  var width;
  var height;
  Function()? onTap;
  Widget? widget;

  ClickableWidget({this.width, this.height, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: InkWell(
        onTap: onTap,
        child: widget,
      ),
    );
  }
}
