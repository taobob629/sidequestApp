import 'package:flutter/material.dart';

class RecordItem extends StatelessWidget {
  final String title;
  final String detail;
  final String amount;
  final int type;

  RecordItem({
    required this.title,
    required this.detail,
    required this.amount,
    required this.type
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: TextStyle(fontSize: 16,color: Colors.white),),
              SizedBox(height: 10,),
              Text(detail,style: TextStyle(fontSize: 14,color: Colors.grey),)
            ],
          ),
          Spacer(),
          Text("$amount",style: TextStyle(fontSize: 16,color: Color(0xFFFFA900)),),

        ],
      ),
    );
  }
}