import 'package:flutter/material.dart';

import '../../../model/notification_model.dart';

class NotificationItem extends StatelessWidget {

  final NotificationModel model;

  NotificationItem({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Text("${model.time}", style: TextStyle(fontSize: 12, color: Colors.grey),),
          SizedBox(height: 15,),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xFF28253D),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    "${model.title}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  "${model.body}",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14
                  ),
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}