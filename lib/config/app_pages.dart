import 'package:get/get.dart';
import 'package:wy/model/game_user_model.dart';
import 'package:wy/ui/frame/main_page.dart';
import 'package:wy/ui/frame/profile/other_profile/other_profile_page.dart';
import 'package:wy/ui/frame/profile/other_profile/record/bindings.dart';
import 'package:wy/ui/frame/profile/other_profile/record/view.dart';
import 'package:wy/ui/frame/profile/sidekick/bindings.dart';
import 'package:wy/ui/frame/profile/sidekick/view.dart';
import 'package:wy/ui/frame/profile/vip/vip_page.dart';
import 'package:wy/ui/frame/sidekick/search/bindings.dart';
import 'package:wy/ui/frame/sidekick/search/search_page.dart';
import 'package:wy/ui/frame/sidekick/view.dart';
import 'package:wy/ui/frame/social/group/create/bindings.dart';
import 'package:wy/ui/frame/social/group/create/create_group.dart';
import 'package:wy/ui/frame/social/post/page/post_detail_page.dart';
import 'package:wy/ui/login/choose_game/bindings.dart';
import 'package:wy/ui/login/choose_game/view.dart';
import 'package:wy/ui/login/login_page.dart';
import 'package:wy/ui/login/register/bindings.dart';
import 'package:wy/ui/login/register/register_page.dart';
import 'package:wy/ui/middleware/login_middleware.dart';
import 'package:wy/ui/middleware/strip_middleware.dart';
import 'package:wy/ui/order/detail/bindings.dart';
import 'package:wy/ui/order/detail/view.dart';
import 'package:wy/ui/order/refound/bindings.dart';
import 'package:wy/ui/order/refound/view.dart';
import 'package:wy/ui/playwith/balance/withdraw/view.dart';
import 'package:wy/ui/playwith/play_balance_page.dart';
import 'package:wy/ui/profile/attention/bindings.dart';
import 'package:wy/ui/profile/attention/tab_view.dart';
import 'package:wy/ui/profile/bankcard/bindings.dart';
import 'package:wy/ui/profile/bankcard/view.dart';
import 'package:wy/ui/profile/booking/bindings.dart';
import 'package:wy/ui/profile/booking/booking_page.dart';
import 'package:wy/ui/profile/coupon/tab/bindings.dart';
import 'package:wy/ui/profile/coupon/tab/tab_view.dart';
import 'package:wy/ui/profile/grade/bindings.dart';
import 'package:wy/ui/profile/grade/index.dart';
import 'package:wy/ui/profile/notification/notification_page.dart';
import 'package:wy/ui/profile/settings/language/bindings.dart';
import 'package:wy/ui/profile/settings/language/view.dart';
import 'package:wy/ui/profile/settings/settings_page.dart';
import 'package:wy/ui/service/add/bio/view.dart';
import 'package:wy/ui/service/add/service_type/view.dart';
import 'package:wy/ui/service/bindings.dart';
import 'package:wy/ui/service/skill/list/bindings.dart';
import 'package:wy/ui/service/skill/list/view.dart';
import 'package:wy/ui/service/skill/skill_item/add/bindings.dart';
import 'package:wy/ui/service/skill/skill_item/add/view.dart';
import 'package:wy/ui/service/skill/skill_item/bindings.dart';
import 'package:wy/ui/service/skill/skill_item/view.dart';
import 'package:wy/ui/service/view.dart';
import 'package:wy/ui/splash/bindings.dart';
import 'package:wy/ui/splash/view.dart';
import '../ui/frame/social/post/page/release_post_page.dart';
import '../ui/match/filter/bindings.dart';
import '../ui/match/filter/view.dart';
import '../ui/match/match_suc/bindings.dart';
import '../ui/match/match_suc/view.dart';
import '../ui/match/matching/bindings.dart';
import '../ui/match/matching/view.dart';
import 'app_config.dart';

class AppPages {
  AppPages._();

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
  static const CHOOSE_GAME = '/choose_game';
  static const NOTICE_PAGE = '/notice_page';
  static const VIP_PAGE = '/vip_page';
  static const LANGUAGE_PAGE = '/language_page';
  static const ReleasePost = '/release_post_page';
  static const PostDetail = '/post_detail_page';
  static const BOOKING_PAGE = '/booking_page';
  static const Setting = '/setting_page';
  static const AddServiceType = '/add_service_type_page';
  static const ServiceAndOrders = '/service_and_orders_page';
  static const OtherProfile = '/other_profile_page';
  static const OrderDetail = '/order_detail_page';
  static const SideKick = '/sidekick_page';
  static const Refound = '/refound_page';
  static const AddSkillItem = '/add_skill_item_page';
  static const Record = '/record_page';
  static const CreateGroup = '/create_group_page';
  static const side_kick_match_page = '/side_kick_match_page';
  static const side_kick_match_suc_page = '/side_kick_match_suc_page';
  static const side_kick_matching_page = '/side_kick_matching_page';
  static const bio_page = '/bio_page';

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
      name: LANGUAGE_PAGE,
      binding: LanguagePageBinding(),
      page: () => LanguagePage(),
    ),
    GetPage(
      name: Login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: CHOOSE_GAME,
      binding: ChooseGamePageBinding(),
      page: () => ChooseGamesPage(),
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
    GetPage(
      name: NOTICE_PAGE,
      page: () => NotificationPage(),
    ),

    ///profile setting
    GetPage(
      name: Setting,
      page: () => SettingsPage(),
    ),
    GetPage(name: VIP_PAGE, page: () => VipPage()),
    GetPage(name: ReleasePost, page: () => ReleasePostPage()),
    GetPage(name: PostDetail, page: () => PostDetailPage()),
    GetPage(
      name: BOOKING_PAGE,
      page: () => BookingPage(),
      binding: BookingBinding(),
    ),
    GetPage(name: AddServiceType, page: () => AddServiceTypePage()),
    GetPage(
        name: ServiceAndOrders,
        page: () => ServiceAndOrdersPage(),
        binding: ServiceAndOrdersTabBinding()),

    GetPage(name: OtherProfile, page: () => OtherProfilePage()),
    GetPage(name: SideKick, page: () => SideKickPage()),
    GetPage(name: OrderDetail, page: () => OrderDetailPage(), binding: OrderDetailPageBinding()),
    GetPage(name: Record, page: () => RecordViewPage(), binding: RecordBinding()),
    GetPage(
      name: Refound,
      page: () => OrderRefoundPage(),
      binding: OrderRefoundPageBinding(),
    ),
    GetPage(
      name: AddSkillItem,
      page: () => SkillItemAddPage(),
      binding: SkillItemAddBinding(),
    ),
    GetPage(
      name: side_kick_match_page,
      page: () => SideKickMatchPage(),
      binding: SideKickMatchBinding(),
    ),
    GetPage(
      name: side_kick_match_suc_page,
      page: () => SideKickMatchSucPage(),
      binding: SideKickMatchSucBinding(),
    ),
    GetPage(
      name: side_kick_matching_page,
      page: () => SideKickMatchingPage(),
      binding: SideKickMatchingBinding(),
    ),
    GetPage(
      name: bio_page,
      page: () => BioPage(),
    ),
    GetPage(
      name: CreateGroup,
      binding: CreateGroupBinding(),
      page: () => CreateGroupPage(),
    ),
  ];
}
