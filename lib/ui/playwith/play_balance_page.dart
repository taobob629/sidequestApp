import 'package:flutter/material.dart';
import 'package:wy/ui/playwith/balance/my_earnings_page.dart';
import 'package:wy/ui/playwith/balance/play_balance_child.dart';
import 'package:wy/ui/playwith/play_tab_widget.dart';
import 'package:wy/widget/paixs_widget.dart';
import 'package:wy/widget/scaffold_widget.dart';

class PlayBalancePage extends StatefulWidget {
  @override
  _PlayBalancePageState createState() => _PlayBalancePageState();
}

class _PlayBalancePageState extends State<PlayBalancePage> {
  var tabList = ["Balance", "My earnings"];
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      body: PlayTabWidget(
        controller: ScrollController(),
        isScrollable: true,
        color: Color(0xff171525),
        // rightChild: PWidget.text('Wallet record', [Colors.white], {'pd': 8}),
        tabList: tabList,
        tabPage: [
          PlayBalanceChild(),
          MyEarningsPage(),
        ],
      ),
    );
  }
}
