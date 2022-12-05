import 'package:flutter/material.dart';

class CountInfo extends StatelessWidget {
  final String icon;
  final String label;
  final String info;
  final Function onTap;
  final String customIcon;
  double height;

  CountInfo({required this.icon, required this.label, required this.info, required this.onTap, this.customIcon = '', this.height = 30});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => this.onTap.call(),
      child: Container(
        color: Colors.transparent,
        // width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 30,
              margin: EdgeInsets.only(bottom: 3),
              child: Center(
                child: Image.asset(
                  customIcon.isEmpty ? "assets/images/ic_${icon}_new.webp" : customIcon,
                  height: height,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                label,
                style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: "DIN"),
              ),
            ),
            Text(info, style: TextStyle(fontSize: 12, color: Colors.white38, fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
