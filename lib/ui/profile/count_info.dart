import 'package:flutter/material.dart';

class CountInfo extends StatelessWidget {
  final String icon;
  final String label;
  final String info;
  final Function onTap;
  final String customIcon;

  CountInfo({
    required this.icon,
    required this.label,
    required this.info,
    required this.onTap,
    this.customIcon = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>this.onTap.call(),
      child: Container(
        color: Colors.transparent,
        // width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              customIcon.isEmpty ? "assets/images/ic_${icon}_new.webp" : customIcon,
              height:  customIcon.isEmpty?30:26,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                label,
                style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: "DIN"),
              ),
            ),
            Text(info,
                style: TextStyle(fontSize: 12, color: Colors.white38, fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}