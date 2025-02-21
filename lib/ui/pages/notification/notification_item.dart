import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../model/notification_model.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel model;

  NotificationItem({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFF28253D),
      ),
      child: Column(
        children: [
          5.verticalSpace,
          Center(
            child: Text(
              "${model.title}",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "${model.body}",
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Text(
              "${model.time}",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
