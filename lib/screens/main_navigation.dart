import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shipyard_planking_tally/screens/home_screen.dart';
import 'package:shipyard_planking_tally/screens/stats_screen.dart';
import 'package:shipyard_planking_tally/screens/showcase_screen.dart';
import 'package:shipyard_planking_tally/utils/const.dart';
import 'package:google_fonts/google_fonts.dart';

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animController;

  final List<Widget> _screens = const [
    HomeScreen(),
    StatsScreen(),
    ShowcaseScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _setIndex(int i) {
    if (i == _currentIndex) return;
    setState(() => _currentIndex = i);
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildTallyNav(),
          ),
        ],
      ),
    );
  }

  Widget _buildTallyNav() {
    return Container(
      height: 80.h + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            kBackground,
            kBackground.withValues(alpha: 0.95),
            kBackground.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTallyItem(0, Icons.grid_4x4_rounded, 'ARCHIVE'),
          _buildTallyItem(1, Icons.show_chart_rounded, 'CHARTS'),
          _buildTallyItem(2, Icons.radar_rounded, 'ASTROLABE'),
        ],
      ),
    );
  }

  Widget _buildTallyItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _setIndex(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tally mark — the unique brand indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: isSelected ? 32.w : 0,
              height: 2.5.h,
              margin: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                color: kAccent,
                borderRadius: BorderRadius.circular(kRadiusPill),
                boxShadow: isSelected
                    ? [BoxShadow(color: kAccent.withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 1)]
                    : null,
              ),
            ),
            Icon(
              icon,
              color: isSelected ? kAccent : kSecondaryText.withValues(alpha: 0.35),
              size: isSelected ? 22.sp : 20.sp,
            ),
            SizedBox(height: 4.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.firaCode(
                color: isSelected ? kAccent : kSecondaryText.withValues(alpha: 0.3),
                fontSize: 7.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 1.2,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
