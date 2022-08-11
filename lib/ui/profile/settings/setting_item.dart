import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final String? info;
  final Function onTap;

  SettingItem({
    required this.title,
    required this.onTap,
    this.info
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>onTap.call(),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: Colors.white,fontSize: 16),),
            Spacer(),
            Text(info == null ?"":info!, style: TextStyle(color: Colors.grey,fontSize: 14)),
            SizedBox(width: 5,),
            Icon(Icons.arrow_forward_ios_rounded,size: 16, color: Colors.white38,)

          ],
        ),
      ),
    );
  }
}