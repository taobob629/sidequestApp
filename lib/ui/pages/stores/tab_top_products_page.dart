import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sq_hub_app/api/hubs_api.dart';
import 'package:sq_hub_app/model/top_food_model.dart';
import 'package:sq_hub_app/model/top_game_model.dart';
import 'package:sq_hub_app/model/top_tea_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../config/icon_font.dart';
import '../hubs/bubble_tea_detail_page.dart';

// 静态变量存储排行榜数据，实现缓存
class RankDataCache {
  static List<TopTeaModel> topTeas = [];
  static List<TopGameModel> topGames = [];
  static List<TopFoodModel> topFoods = [];
  static bool isLoaded = false;

  // 预加载排行榜数据
  static Future<void> preloadData() async {
    if (isLoaded) return;

    try {
      // 首次加载，请求接口
      var results = await Future.wait([
        HubsApi.getTopTeas(),
        HubsApi.getTopGames(),
        HubsApi.getTopFoods(),
      ]);

      // 缓存数据
      topTeas = results[0] as List<TopTeaModel>;
      topGames = results[1] as List<TopGameModel>;
      topFoods = results[2] as List<TopFoodModel>;
      isLoaded = true;
    } catch (e) {
      print('Error preloading rank data: $e');
    }
  }
}

class TabTopProductsPage extends StatefulWidget {
  const TabTopProductsPage({Key? key}) : super(key: key);

  @override
  State<TabTopProductsPage> createState() => _TabTopProductsPageState();
}

class _TabTopProductsPageState extends State<TabTopProductsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<TopTeaModel> _topTeas = [];
  List<TopGameModel> _topGames = [];
  List<TopFoodModel> _topFoods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      // 检查是否已经加载过数据
      if (RankDataCache.isLoaded) {
        // 使用缓存的数据
        setState(() {
          _topTeas = RankDataCache.topTeas;
          _topGames = RankDataCache.topGames;
          _topFoods = RankDataCache.topFoods;
          _isLoading = false;
        });
        return;
      }

      // 首次加载，请求接口
      var results = await Future.wait([
        HubsApi.getTopTeas(),
        HubsApi.getTopGames(),
        HubsApi.getTopFoods(),
      ]);

      // 缓存数据
      RankDataCache.topTeas = results[0] as List<TopTeaModel>;
      RankDataCache.topGames = results[1] as List<TopGameModel>;
      RankDataCache.topFoods = results[2] as List<TopFoodModel>;
      RankDataCache.isLoaded = true;

      setState(() {
        _topTeas = RankDataCache.topTeas;
        _topGames = RankDataCache.topGames;
        _topFoods = RankDataCache.topFoods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
            child: Column(
              children: [
                Text(
                  'SIDEQUEST RANK',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Color(0xFFFFB20E), Color(0xFFFF9500)],
                      ).createShader(Rect.fromLTWH(0, 0, 200.w, 70.h)),
                    letterSpacing: 1,
                  ),
                ),
                6.verticalSpace,
                Text(
                  '${_getCurrentMonthYear()} • Top Picks at This Store',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1e1e1e),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFB20E), Color(0xFFFF9500)],
                ),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFB20E).withOpacity(0.2),
                    blurRadius: 6,
                  ),
                ],
              ),
              indicatorPadding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white.withOpacity(0.6),
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                _buildTab('🏆', 'Games', 3),
                _buildTab('🧋', 'Bubble Tea', 4),
                _buildTab('🍜', 'Food', 3),
              ],
            ),
          ),
          16.verticalSpace,
          Container(
            height: 220.h,
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFB20E)),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTopGamesList(),
                      _buildTopTeasList(),
                      _buildTopFoodsList(),
                    ],
                  ),
          ),
          20.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildTab(String icon, String label, int flex) {
    return Expanded(
      flex: flex,
      child: Tab(
        height: 44.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: TextStyle(fontSize: 18.sp)),
            3.horizontalSpace,
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildTopGamesList() {
    if (_topGames.isEmpty) {
      return Center(
        child: Text(
          'No games available',
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: _topGames.length > 5 ? 5 : _topGames.length,
      itemBuilder: (context, index) {
        final game = _topGames[index];
        return _buildRankingItem(
          index + 1,
          game.name ?? 'Unknown',
          game.desc ?? '',
          game.trend,
          type: 'game',
          id: game.id,
        );
      },
    );
  }

  Widget _buildTopTeasList() {
    if (_topTeas.isEmpty) {
      return Center(
        child: Text(
          'No bubble tea available',
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: _topTeas.length > 5 ? 5 : _topTeas.length,
      itemBuilder: (context, index) {
        final tea = _topTeas[index];
        return _buildRankingItem(
          index + 1,
          tea.name ?? 'Unknown',
          tea.desc ?? '',
          tea.trend,
          type: 'tea',
          id: tea.id,
        );
      },
    );
  }

  Widget _buildTopFoodsList() {
    if (_topFoods.isEmpty) {
      return Center(
        child: Text(
          'No food available',
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: _topFoods.length > 5 ? 5 : _topFoods.length,
      itemBuilder: (context, index) {
        final food = _topFoods[index];
        return _buildRankingItem(
          index + 1,
          food.name ?? 'Unknown',
          food.desc ?? '',
          food.trend,
          type: 'food',
          id: food.id,
        );
      },
    );
  }

  Widget _buildRankingItem(
    int rank,
    String name,
    String desc,
    dynamic trendValue, {
    String? type,
    dynamic id,
  }) {
    // 转换趋势值为图标
    String? trend;
    if (trendValue == null) {
      trend = ''; // 默认不变➡️
    } else if (trendValue is int) {
      switch (trendValue) {
        case 1:
          trend = '⬆️'; // 上升
          break;
        case -1:
          trend = '⬇️'; // 下降
          break;
        default:
          trend = '➡️'; // 不变
      }
    } else if (trendValue is String) {
      trend = trendValue; // 已经是字符串，直接使用
    } else {
      trend = ''; // 默认不变
    }

    return GestureDetector(
      onTap: () {
        // 跳转到详情页
        if (id != null && type == 'tea') {
          Get.to(() => BubbleTeaDetailPage(), arguments: id);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: _getRankGradient(rank),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '$rank',
                style: TextStyle(
                  color: rank <= 3
                      ? Colors.black
                      : Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w900,
                  fontSize: 14.sp,
                ),
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (desc.isNotEmpty) ...[
                    2.verticalSpace,
                    Text(
                      desc,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: 24.w,
              height: 24.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _getTrendColor(trend).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                trend,
                style: TextStyle(color: _getTrendColor(trend), fontSize: 18.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient? _getRankGradient(int rank) {
    switch (rank) {
      case 1:
        return const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        );
      case 2:
        return const LinearGradient(
          colors: [Color(0xFFC0C0C0), Color(0xFFA0A0A0)],
        );
      case 3:
        return const LinearGradient(
          colors: [Color(0xFFCD7F32), Color(0xFFB8860B)],
        );
      default:
        return null;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case '⬆️':
        return const Color(0xFFef4444);
      case '⬇️':
        return const Color(0xFF10b981);
      case '➡️':
        return const Color(0xff6ab910);
      default:
        return const Color(0xFF3b82f6);
    }
  }

  String _getCurrentMonthYear() {
    final now = DateTime.now();
    final month = now.month;
    final year = now.year;

    // 月份名称映射
    const monthNames = [
      '',
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];

    return '${monthNames[month]} $year';
  }
}
