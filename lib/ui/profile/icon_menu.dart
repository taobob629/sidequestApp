import 'package:flutter/material.dart';

class IconMenu extends StatelessWidget {

  final String icon;
  final String title;
  final Function? onTap;

  IconMenu({
    required this.icon,
    required this.title,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> onTap?.call(),
      child: Container(
        width: 80,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon == "" ? Container(width: 40,height: 40) :
            Image.asset(icon, width: 40,height: 40, fit: BoxFit.contain,),
            SizedBox(height: 5,),
            Text("$title", style: TextStyle(color: Colors.white54, fontSize: 12),)
          ],
        ),
      ),
    );
  }
}