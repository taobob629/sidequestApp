import 'package:flutter/material.dart';

import '../../model/store_model.dart';

class StoreItem extends StatelessWidget {

  final StoreModel model;

  StoreItem({required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container()
    );
  }
}