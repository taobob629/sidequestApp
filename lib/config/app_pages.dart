import 'package:get/get.dart';
import 'package:wy/ui/frame/main_page.dart';
import 'package:wy/ui/playwith/balance/withdraw/view.dart';
import 'package:wy/ui/profile/bankcard/bindings.dart';
import 'package:wy/ui/profile/bankcard/view.dart';

class AppPages {
  static const Main = '/main';
  static const BindBankCard = '/bindbankcard';
  static const WithDrawRecord = '/withdrawRecord';
  static final routes = [
    GetPage(
      name: Main,
      page: () => MainPage(),
      binding: MainPageBinding(),
    ),
    GetPage(
      name: BindBankCard,
      page: () => BindBankCardPage(),
      binding: BindBankCardPageBinding(),
    ),
    GetPage(
      name: WithDrawRecord,
      page: () => WithDrawMainPage(),
    ),
  ];
}
