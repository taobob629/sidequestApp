import 'package:flutter/material.dart';

class ColorfulButton extends StatelessWidget {
  final Widget child;
  final double height;
  final double? width;
  final Function? onTap;

  ColorfulButton({
    required this.child,
    required this.height,
    this.width,
    this.onTap
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFFC3C02),Color(0xFF841FC3)]
              )
            ),
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