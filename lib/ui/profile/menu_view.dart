import 'package:flutter/material.dart';

class MenuView extends StatelessWidget {

  final String icon;
  final String title;
  final String detail;
  final Function onTap;

  MenuView({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>onTap(),
      child: Container(
        height: 60,
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/ic_${icon}_new.webp",width: 28),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(title, style: TextStyle(color: Colors.white38,fontSize: 16),),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(detail, style: TextStyle(color: Colors.white38,fontSize: 12),),
            ),
            Icon(Icons.arrow_forward_ios,size: 16, color: Colors.white38,)
          ],
        ),
      ),
    );
  }
}