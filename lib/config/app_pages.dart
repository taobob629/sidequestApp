
import 'package:get/get.dart';
import 'package:wy/ui/events/event/event_page.dart';
import 'package:wy/ui/frame/main_page.dart';
import 'package:wy/ui/index/news/news_page.dart';
import 'package:wy/ui/scan/scan_page.dart';

class AppPages {
  static const Main = '/main';

  static final routes = [
    GetPage(
      name: Main,
      page: () => MainPage(),
      binding: MainPageBinding(),
    ),
  ];
}