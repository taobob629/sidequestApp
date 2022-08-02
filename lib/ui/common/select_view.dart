import 'package:flutter/material.dart';

class SelectView extends StatelessWidget {

  final String label;
  final String tips;
  final String? value;
  final Function? onTap;

  SelectView({
    required this.label,
    required this.tips,
    this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> onTap?.call(),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Text(label, style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: "DIN"),),
            ),
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 15,right: 15,top: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Color(0x10FFFFFF),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  value == null || value!.isEmpty ?
                  Text(
                    tips,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.white24, fontSize: 14),
                  ) : Text(
                    value!,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,size: 20,),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}