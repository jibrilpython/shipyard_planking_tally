import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shipyard_planking_tally/enum/my_enums.dart';
import 'package:shipyard_planking_tally/models/tool_model.dart';
import 'package:shipyard_planking_tally/providers/project_provider.dart';
import 'package:shipyard_planking_tally/utils/const.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  bool _isDetailedMode = false;
  ToolType? _highlightedType;

  @override
  Widget build(BuildContext context) {
    final projectProv = ref.watch(projectProvider);
    final entries = projectProv.entries;

    if (projectProv.isLoading) {
      return const Scaffold(
        backgroundColor: kBackground,
        body: Center(child: CircularProgressIndicator(color: kAccent)),
      );
    }

    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 160.h,
            stretch: true,
            pinned: true,
            backgroundColor: kBackground,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImmersiveHeader(entries.length),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 140.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (entries.isEmpty)
                    _buildEmptyState()
                  else ...[
                    _buildInteractiveToggle(),
                    SizedBox(height: 24.h),
                    if (!_isDetailedMode) ...[
                      _buildHeroOverview(entries),
                      SizedBox(height: 32.h),
                      _sectionHeader('HISTORICAL TIMELINE'),
                      SizedBox(height: 16.h),
                      _buildEraTimeline(entries),
                    ] else ...[
                      _sectionHeader('COLLECTION COMPOSITION'),
                      SizedBox(height: 16.h),
                      _buildPebbleDistribution(entries),
                      SizedBox(height: 32.h),
                      _sectionHeader('CONDITION STATUS'),
                      SizedBox(height: 16.h),
                      _buildGlassConditionGrid(entries),
                      SizedBox(height: 32.h),
                      _sectionHeader('TRADITIONAL ROOTS'),
                      SizedBox(height: 16.h),
                      _buildTraditionPebbles(entries),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImmersiveHeader(int count) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kBackground,
            kAccentSurface.withValues(alpha: 0.6),
            kBackground,
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 14.w, height: 1.5.h, color: kAccent),
              SizedBox(width: 8.w),
              Text(
                'THE CHART ROOM',
                style: GoogleFonts.firaCode(
                  color: kAccent,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Archival Intel',
            style: GoogleFonts.inter(
              color: kPrimaryText,
              fontSize: 32.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 480.h,
      child: CustomPaint(
        painter: _StatsGridPainter(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Compass rose
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: kAccent.withValues(alpha: 0.3), width: 1),
                color: kAccentSurface.withValues(alpha: 0.5),
              ),
              child: CustomPaint(
                painter: _CompassRosePainter(),
                child: Center(
                  child: Icon(
                    Icons.adjust_rounded,
                    color: kAccent.withValues(alpha: 0.5),
                    size: 28.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 28.h),
            Text(
              'NO DATA TO CHART',
              style: GoogleFonts.firaCode(
                color: kAccent.withValues(alpha: 0.7),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.5,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Log tools to the archive to\ngenerate analytical charts.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: kSecondaryText.withValues(alpha: 0.5),
                fontSize: 13.sp,
                height: 1.55,
              ),
            ),
            SizedBox(height: 36.h),
            // Ornamental data line rows
            ...List.generate(
                4,
                (i) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40.w, vertical: 5.h),
                      child: Row(
                        children: [
                          Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: const BoxDecoration(
                                  color: kAccent, shape: BoxShape.circle)),
                          SizedBox(width: 10.w),
                          Expanded(
                              child: Container(
                            height: 1,
                            color: kOutline.withValues(alpha: 0.3 - (i * 0.05)),
                          )),
                          SizedBox(width: 10.w),
                          Text(
                            '--- %',
                            style: GoogleFonts.firaCode(
                              color: kSecondaryText.withValues(alpha: 0.25),
                              fontSize: 9.sp,
                            ),
                          ),
                        ],
                      ),
                    )),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveToggle() {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: kPanelBg,
        borderRadius: BorderRadius.circular(kRadiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleBtn('OVERVIEW', !_isDetailedMode,
              () => setState(() => _isDetailedMode = false)),
          _toggleBtn('ANALYTICS', _isDetailedMode,
              () => setState(() => _isDetailedMode = true)),
        ],
      ),
    );
  }

  Widget _toggleBtn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: active ? kAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(kRadiusPill),
          boxShadow: active ? [kAccentGlow] : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: active ? kPrimaryText : kSecondaryText,
            fontSize: 10.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroOverview(List<ShipwrightToolModel> entries) {
    final workingCount = entries
        .where((e) => e.conditionState == ConditionState.workingCondition)
        .length;
    final totalCount = entries.length;
    final healthRatio = totalCount == 0 ? 0.0 : workingCount / totalCount;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: kPanelBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(kRadiusXLarge),
        border: Border.all(color: kOutline.withValues(alpha: 0.5), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _heroCounter('TOTAL HERITAGE', totalCount, kAccent),
              _heroCounter('OPERATIONAL', workingCount, kSuccess),
            ],
          ),
          SizedBox(height: 30.h),
          _liquidHealthIndicator(healthRatio),
        ],
      ),
    );
  }

  Widget _heroCounter(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: kSecondaryText,
            fontSize: 9.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value.toDouble()),
          duration: const Duration(seconds: 2),
          curve: Curves.easeOutExpo,
          builder: (context, val, child) => Text(
            val.toInt().toString().padLeft(3, '0'),
            style: GoogleFonts.firaCode(
              color: color,
              fontSize: 36.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _liquidHealthIndicator(double ratio) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 160.w,
              height: 160.w,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: ratio),
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOutExpo,
                builder: (context, val, child) => CustomPaint(
                  painter: LiquidGaugePainter(
                    value: val,
                    color: kAccent,
                    backgroundColor: kOutline.withValues(alpha: 0.15),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  '${(ratio * 100).toInt()}%',
                  style: GoogleFonts.inter(
                    color: kPrimaryText,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'ARCHIVAL HEALTH',
                  style: GoogleFonts.inter(
                    color: kSecondaryText,
                    fontSize: 7.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPebbleDistribution(List<ShipwrightToolModel> entries) {
    final Map<ToolType, int> counts = {};
    for (final e in entries) {
      counts[e.toolType] = (counts[e.toolType] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: sorted.map((entry) {
        final isHighlighted = _highlightedType == entry.key;
        final color = getToolTypeColor(entry.key);
        return GestureDetector(
          onTap: () => setState(
              () => _highlightedType = isHighlighted ? null : entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(16.r),
            width: isHighlighted
                ? double.infinity
                : (MediaQuery.of(context).size.width - 56.w) / 2,
            decoration: BoxDecoration(
              color: isHighlighted ? color.withValues(alpha: 0.15) : kPanelBg,
              borderRadius: BorderRadius.circular(kRadiusXLarge),
              border: Border.all(
                color: isHighlighted ? color : kOutline.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key.label.toUpperCase(),
                      style: GoogleFonts.inter(
                        color: isHighlighted ? color : kSecondaryText,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${entry.value}',
                      style: GoogleFonts.firaCode(
                        color: kPrimaryText,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                if (isHighlighted) ...[
                  SizedBox(height: 12.h),
                  Text(
                    'Representing ${(entry.value / (entries.isEmpty ? 1 : entries.length) * 100).toStringAsFixed(1)}% of your archival collection.',
                    style: GoogleFonts.inter(
                        color: kPrimaryText, fontSize: 11.sp, height: 1.4),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGlassConditionGrid(List<ShipwrightToolModel> entries) {
    final Map<ConditionState, int> counts = {};
    for (final e in entries) {
      counts[e.conditionState] = (counts[e.conditionState] ?? 0) + 1;
    }

    return Column(
      children: ConditionState.values.map((state) {
        final count = counts[state] ?? 0;
        final color = getConditionColor(state);
        final ratio = entries.isEmpty ? 0.0 : count / entries.length;

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: kPanelBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(kRadiusPill),
          ),
          child: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: color.withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 1)
                    ]),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.label,
                        style: GoogleFonts.inter(
                            color: kPrimaryText,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: 4.h),
                    Stack(
                      children: [
                        Container(
                            height: 4.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: kOutline.withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(kRadiusPill))),
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          height: 4.h,
                          width: (MediaQuery.of(context).size.width - 100.w) *
                              ratio,
                          decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(kRadiusPill)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Text('$count',
                  style: GoogleFonts.firaCode(
                      color: kPrimaryText,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTraditionPebbles(List<ShipwrightToolModel> entries) {
    final Map<ShipbuildingTradition, int> counts = {};
    for (final e in entries) {
      if (e.shipbuildingTradition != ShipbuildingTradition.unknown) {
        counts[e.shipbuildingTradition] =
            (counts[e.shipbuildingTradition] ?? 0) + 1;
      }
    }
    if (counts.isEmpty) return _noData();

    return Column(
      children: counts.entries.map((e) {
        final ratio = e.value / entries.length;
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: kPanelBg,
            borderRadius: BorderRadius.circular(kRadiusXLarge),
            border: Border.all(color: kOutline.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.key.label.toUpperCase(),
                        style: GoogleFonts.inter(
                            color: kPrimaryText,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800)),
                    SizedBox(height: 4.h),
                    Text(
                        '${(ratio * 100).toStringAsFixed(1)}% of collection heritage',
                        style: GoogleFonts.inter(
                            color: kSecondaryText, fontSize: 10.sp)),
                  ],
                ),
              ),
              Text('${e.value}',
                  style: GoogleFonts.firaCode(
                      color: kAccent,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEraTimeline(List<ShipwrightToolModel> entries) {
    final Map<String, int> counts = {};
    for (final e in entries) {
      if (e.eraOfProduction.isNotEmpty)
        counts[e.eraOfProduction] = (counts[e.eraOfProduction] ?? 0) + 1;
    }
    final sortedEras = counts.keys.toList()..sort();

    if (sortedEras.isEmpty) return _noData();

    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: sortedEras.length,
        itemBuilder: (context, idx) {
          final era = sortedEras[idx];
          final count = counts[era]!;
          return Container(
            margin: EdgeInsets.only(right: 12.w),
            padding: EdgeInsets.all(18.r),
            width: 120.w,
            decoration: BoxDecoration(
              color: kAccentSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(kRadiusXLarge),
              border: Border.all(color: kAccent.withValues(alpha: 0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(era,
                    style: GoogleFonts.firaCode(
                        color: kAccent,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 4.h),
                Text('$count TOOLS',
                    style: GoogleFonts.inter(
                        color: kSecondaryText,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String label) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: kSecondaryText,
            fontSize: 10.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
            child:
                Container(height: 1.h, color: kOutline.withValues(alpha: 0.3))),
      ],
    );
  }

  Widget _noData() {
    return Center(
      child: Text('INSUFFICIENT DATARECORDS',
          style: GoogleFonts.inter(
              color: kSecondaryText,
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0)),
    );
  }
}

class LiquidGaugePainter extends CustomPainter {
  final double value;
  final Color color;
  final Color backgroundColor;

  LiquidGaugePainter({
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw Background Circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.w;
    canvas.drawCircle(center, radius - 6.w, bgPaint);

    // Draw Main Progress Arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.w
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 6.w),
      -1.5708, // Start at top
      2 * 3.14159 * value,
      false,
      progressPaint,
    );

    // Draw Inner Liquid Effect
    if (value > 0) {
      final innerRect = Rect.fromCircle(center: center, radius: radius - 18.w);
      canvas.save();
      canvas.clipPath(Path()..addOval(innerRect));

      final liquidPaint = Paint()..color = color.withValues(alpha: 0.1);
      final liquidHeight = innerRect.height * value;
      canvas.drawRect(
        Rect.fromLTWH(
          innerRect.left,
          innerRect.bottom - liquidHeight,
          innerRect.width,
          liquidHeight,
        ),
        liquidPaint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant LiquidGaugePainter oldDelegate) =>
      oldDelegate.value != value;
}

// Blueprint grid background for stats empty state
class _StatsGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = kAccent.withValues(alpha: 0.05)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Compass rose ornament for the empty state circle
class _CompassRosePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = kAccent.withValues(alpha: 0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    // 8 direction spokes
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi) / 4;
      final inner = Offset(
          center.dx + math.cos(angle) * 12, center.dy + math.sin(angle) * 12);
      final outer = Offset(center.dx + math.cos(angle) * (size.width / 2 - 4),
          center.dy + math.sin(angle) * (size.height / 2 - 4));
      canvas.drawLine(inner, outer, paint);
    }
    canvas.drawCircle(center, size.width / 2 - 8, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
