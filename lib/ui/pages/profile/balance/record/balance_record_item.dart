import 'package:flutter/material.dart';

import '../../../../../model/balance_record_model.dart';

class BalanceRecordItem extends StatelessWidget {

  final BalanceRecordModel model;

  BalanceRecordItem({required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _buildItems(),
    );
  }

  List<Widget> _buildItems(){
    List<Widget> list = [];
    list.add(_buildHeader());
    model.details.forEach((element) {
      list.add(_buildDetail(element));
    });
    return list;
  }

  Widget _buildHeader(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${model.time}",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
        Text("${model.amount}",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
      ],
    );
  }

  Widget _buildDetail(BalanceDetailModel model){
    return Row(
      children: [
        Text("${model.title}",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
        Spacer(),
        Text("${model.amount}",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
      ],
    );
  }
}