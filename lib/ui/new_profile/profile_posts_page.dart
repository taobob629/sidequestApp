import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfilePostsPage extends StatelessWidget {
  const ProfilePostsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.only(top: 15),
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.yellow,
                      child: Image.asset(
                        "assets/images/ic_dialog.webp",
                        width: 30,
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                Text(
                                  "Anonusers",
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "4h",
                                  style: TextStyle(color: Color(0xff808388), fontSize: 14, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Text(
                            """{"code":200,"msg":"操作成功","data":{"user":{"id":16955,"sex":"2","firstName":"bob","lastName":"tao","phone":"123456789","email":"1277389320@qq.com","birth":"29/06/1983","location":"web","memberCode":"UK20021778","memberLevel":0,"balance":"500.00","freeTime":0,"lastNumber":"0","cardNumber":null,"createTime":"2022-04-25 02:53:19","memberPhoto":"https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/header_1671808367645.jpg","nickName":"bob-prod2","admin":0},"validate":0,"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ3YW55b28gd2ViIHVzZXIgdG9rZW4iLCJhdWQiOiJXQU5ZT09BUFAiLCJpc3MiOiJXQU5ZT08iLCJleHAiOjE2NzY2MDkxMzgsImlhdCI6MTY3NjYwMTkzOCwibWVtYmVySWQiOjE2OTU1fQ.tlaHSHPMKcpYjNq2epIovpWu5R1CL3JzRTsjaGHZU5w"}}""",
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  "https://sidequest-1307226287.cos.eu-frankfurt.myqcloud.com/_805B-1.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                child: Row(),
              )
            ],
          ),
        )
      ],
    ));
  }
}
