import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shipyard_planking_tally/enum/my_enums.dart';
import 'package:shipyard_planking_tally/models/tool_model.dart';
import 'package:shipyard_planking_tally/providers/image_provider.dart';
import 'package:shipyard_planking_tally/providers/project_provider.dart';
import 'package:shipyard_planking_tally/providers/search_provider.dart';
import 'package:shipyard_planking_tally/providers/input_provider.dart';
import 'package:shipyard_planking_tally/utils/const.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  ToolType? _selectedFilter;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchProv = ref.watch(searchProvider);
    final projectProv = ref.watch(projectProvider);
    final allEntries = projectProv.entries;

    final filteredByType = _selectedFilter == null
        ? allEntries
        : allEntries.where((e) => e.toolType == _selectedFilter).toList();
    final entries = searchProv.filteredList(filteredByType);

    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        slivers: [
          SliverAppBar(
            expandedHeight: 160.h,
            stretch: true,
            pinned: false,
            backgroundColor: kBackground,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle
              ],
              background: _buildHeader(allEntries.length),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 14.h),
                  _buildSearchBar(),
                  SizedBox(height: 12.h),
                  _buildFilterChips(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          entries.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(),
                )
              : SliverPadding(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 140.h),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = entries[index];
                        final mainIndex =
                            ref.read(projectProvider).entries.indexOf(entry);
                        return _buildToolCard(context, entry, mainIndex);
                      },
                      childCount: entries.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14.w,
                      mainAxisSpacing: 14.h,
                      childAspectRatio: 0.72,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 56.h, 20.w, 20.h),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: label + add button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 18.w, height: 1.5.h, color: kAccent),
                      SizedBox(width: 8.w),
                      Text(
                        'PLANKING TALLY',
                        style: GoogleFonts.firaCode(
                          color: kAccent,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'The Archive',
                    style: GoogleFonts.inter(
                      color: kPrimaryText,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              // Add button — thin bordered square
              GestureDetector(
                onTap: () {
                  ref.read(inputProvider).clearAll();
                  ref.read(imageProvider).clearImage();
                  Navigator.pushNamed(context, '/add_screen');
                },
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: kAccent,
                    borderRadius: BorderRadius.circular(kRadiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: kAccent.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child:
                      Icon(Icons.add_rounded, color: kPrimaryText, size: 26.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Count pill
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: kAccentSurface,
                  borderRadius: BorderRadius.circular(kRadiusPill),
                  border: Border.all(
                      color: kAccent.withValues(alpha: 0.25), width: 1),
                ),
                child: Text(
                  '$count TOOLS LOGGED',
                  style: GoogleFonts.firaCode(
                    color: kAccent,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                  child: Container(
                      height: 1, color: kOutline.withValues(alpha: 0.5))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final isFocused = _searchFocusNode.hasFocus;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 44.h,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isFocused ? kAccent : kOutline.withValues(alpha: 0.6),
            width: isFocused ? 1.8 : 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: isFocused ? kAccent : kSecondaryText.withValues(alpha: 0.4),
            size: 16.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (v) =>
                  ref.read(searchProvider.notifier).setSearchQuery(v),
              style: GoogleFonts.inter(
                color: kPrimaryText,
                fontSize: 12.sp,
                letterSpacing: 0.3,
              ),
              decoration: InputDecoration(
                hintText: 'Search tools, forges, eras...',
                hintStyle: GoogleFonts.inter(
                  color: kSecondaryText.withValues(alpha: 0.35),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                ref.read(searchProvider.notifier).clearSearchQuery();
                setState(() {});
              },
              child: Text(
                'CLR',
                style: GoogleFonts.firaCode(
                  color: kAccent.withValues(alpha: 0.7),
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 36.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildChip('All', null),
          ...ToolType.values.map((t) => _buildChip(t.label, t)),
        ],
      ),
    );
  }

  Widget _buildChip(String label, ToolType? type) {
    final isSelected = _selectedFilter == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.only(right: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                color: isSelected
                    ? kPrimaryText
                    : kSecondaryText.withValues(alpha: 0.45),
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 3.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 2,
              width: isSelected ? label.length * 7.0.w : 0,
              color: kAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(
      BuildContext context, ShipwrightToolModel entry, int index) {
    final imageProv = ref.watch(imageProvider);
    final imagePath = imageProv.getImagePath(entry.photoPath);
    final conditionColor = getConditionColor(entry.conditionState);
    final typeColor = getToolTypeColor(entry.toolType);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/info_screen',
          arguments: {'index': index}),
      child: Container(
        decoration: BoxDecoration(
          color: kPanelBg,
          borderRadius: BorderRadius.circular(kRadiusXLarge),
          border: Border.all(color: kOutline, width: 1),
          boxShadow: [
            BoxShadow(
              color: kAccent.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Area
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(kRadiusXLarge),
                ),
                child: (entry.photoPath.isNotEmpty &&
                        imagePath != null &&
                        File(imagePath).existsSync())
                    ? Image.file(File(imagePath),
                        width: double.infinity, fit: BoxFit.cover)
                    : Container(
                        width: double.infinity,
                        color: kBackground,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.anchor_rounded,
                                color: typeColor.withValues(alpha: 0.3),
                                size: 32.sp),
                          ],
                        ),
                      ),
              ),
            ),
            // Info Area
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Condition dot + type badge
                        Row(
                          children: [
                            Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: BoxDecoration(
                                color: conditionColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                entry.toolType.label.toUpperCase(),
                                style: GoogleFonts.inter(
                                  color: typeColor,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          entry.toolName,
                          style: GoogleFonts.inter(
                            color: kPrimaryText,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            entry.forgeOrMaker.isNotEmpty
                                ? entry.forgeOrMaker
                                : (entry.shipyardIdentifier.isNotEmpty
                                    ? entry.shipyardIdentifier
                                    : 'Unknown origin'),
                            style: GoogleFonts.inter(
                              color: kSecondaryText,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (entry.eraOfProduction.isNotEmpty) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: kBackground,
                              borderRadius: BorderRadius.circular(kRadiusPill),
                              border: Border.all(
                                  color: kOutline.withValues(alpha: 0.5),
                                  width: 1),
                            ),
                            child: Text(
                              entry.eraOfProduction,
                              style: GoogleFonts.firaCode(
                                color: kSecondaryText,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: const BoxDecoration(
              color: kPanelBg,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.anchor_rounded,
                size: 36.sp, color: kSecondaryText.withValues(alpha: 0.3)),
          ),
          SizedBox(height: 24.h),
          Text(
            'NO TOOLS LOGGED',
            style: GoogleFonts.inter(
              color: kSecondaryText,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Tap + to begin cataloguing your collection.',
            style: GoogleFonts.inter(
              color: kSecondaryText.withValues(alpha: 0.5),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 100.h), // Push content up
        ],
      ),
    );
  }
}
