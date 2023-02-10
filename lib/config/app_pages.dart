import 'package:get/get.dart';
import 'package:wy/ui/frame/main_page.dart';
import 'package:wy/ui/login/login_page.dart';
import 'package:wy/ui/login/register/bindings.dart';
import 'package:wy/ui/login/register/register_page.dart';
import 'package:wy/ui/middleware/login_middleware.dart';
import 'package:wy/ui/middleware/strip_middleware.dart';
import 'package:wy/ui/playwith/balance/withdraw/view.dart';
import 'package:wy/ui/playwith/play_balance_page.dart';
import 'package:wy/ui/playwith/search/bindings.dart';
import 'package:wy/ui/playwith/search/search_page.dart';
import 'package:wy/ui/playwith/service/bindings.dart';
import 'package:wy/ui/playwith/service/view.dart';
import 'package:wy/ui/playwith/skill/list/bindings.dart';
import 'package:wy/ui/playwith/skill/list/view.dart';
import 'package:wy/ui/playwith/skill/skill_item/bindings.dart';
import 'package:wy/ui/playwith/skill/skill_item/view.dart';
import 'package:wy/ui/profile/attention/bindings.dart';
import 'package:wy/ui/profile/attention/tab_view.dart';
import 'package:wy/ui/profile/bankcard/bindings.dart';
import 'package:wy/ui/profile/bankcard/view.dart';
import 'package:wy/ui/profile/coupon/tab/bindings.dart';
import 'package:wy/ui/profile/coupon/tab/tab_view.dart';
import 'package:wy/ui/profile/grade/bindings.dart';
import 'package:wy/ui/profile/grade/index.dart';
import 'package:wy/ui/splash/bindings.dart';
import 'package:wy/ui/splash/view.dart';
import 'app_config.dart';

class AppPages {
  static const Main = '/main';
  static const Login = '/login';
  static const REGISTER = '/register';
  static const BindBankCard = '/bindbankcard';
  static const WithDrawRecord = '/withdrawRecord';
  static const AttentionTab = '/attentionTabPage';
  static const Grade = '/gradePage';
  static const MoreGames = '/moreGames';
  static const SkillItem = '/skillItem';
  static const SkillList = '/skillList';
  static const WALLET_PAGE = '/wallet';
  static const COUPON_TAB_PAGE = '/coupon_tab_page';
  static const SEARCH_USER_PAGE = '/search_user_page';
  static const SPLASH = '/splash';
  static final routes = [
    GetPage(
      name: REGISTER,
      binding: RegisterPageBinding(),
      page: () => RegisterPage(),
    ),
    GetPage(
      name: SPLASH,
      binding: SplashPageBinding(),
      page: () => SplashPage(),
    ),
    GetPage(
      name: Login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: Main,
      page: () => MainPage(),
      binding: MainPageBinding(),
      middlewares: [LoginMiddleWare()],
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
    GetPage(
      name: AttentionTab,
      page: () => AttentionTabPage(),
      binding: AttentionTabBinding(),
    ),
    GetPage(
      name: Grade,
      page: () => GradePage(),
      binding: GradePageBinding(),
    ),
    GetPage(
      name: MoreGames,
      page: () => MoreGamesPage(),
      binding: MoreGamesTabBinding(),
    ),
    GetPage(name: SkillItem, page: () => SkillItemPage(), binding: SkillItemBinding()),
    GetPage(name: SkillList, page: () => SkillListPage(), binding: SkillListBinding()),
    GetPage(
        name: WALLET_PAGE,
        page: () => PlayBalancePage(),
        middlewares: [StripMiddleWare(action: AppConfig.ACTION_PW)]),
    GetPage(name: COUPON_TAB_PAGE, page: () => CouponTabPage(), binding: CouponTabBinding()),
    GetPage(
      name: SEARCH_USER_PAGE,
      binding: SearchUserBinding(),
      page: () => SearchUserPage(),
    ),
  ];
}
