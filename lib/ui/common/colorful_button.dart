import 'package:flutter/material.dart';

class ColorfulButton extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final Function? onTap;
  double borderRadius;

  ColorfulButton(
      {required this.child, this.height, this.width, this.onTap, this.borderRadius = 15});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFD49C21), Color(0xFFE96524)])),
            child: Center(
              child: child,
            ),
          ),
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            clipBehavior: Clip.antiAlias,
            child: Ink(
              child: InkWell(
                onTap: () => onTap?.call(),
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
