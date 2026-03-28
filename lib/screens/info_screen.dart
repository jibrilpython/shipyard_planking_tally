import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shipyard_planking_tally/enum/my_enums.dart';
import 'package:shipyard_planking_tally/models/tool_model.dart';
import 'package:shipyard_planking_tally/providers/image_provider.dart';
import 'package:shipyard_planking_tally/providers/project_provider.dart';
import 'package:shipyard_planking_tally/utils/const.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoScreen extends ConsumerWidget {
  final int index;
  const InfoScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectProv = ref.watch(projectProvider);
    if (index < 0 || index >= projectProv.entries.length) {
      return const Scaffold(body: Center(child: Text('TOOL NOT FOUND')));
    }
    final entry = projectProv.entries[index];
    final imageProv = ref.watch(imageProvider);
    final imagePath = imageProv.getImagePath(entry.photoPath);

    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            slivers: [
              SliverAppBar(
                expandedHeight: 320.h,
                stretch: true,
                backgroundColor: kBackground,
                elevation: 0,
                pinned: false,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: _buildHeroImage(imagePath, entry),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 140.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildIdentityPanel(entry),
                    SizedBox(height: 20.h),
                    _buildSpecGrid(entry),
                    SizedBox(height: 16.h),
                    if (entry.specificFunction.isNotEmpty ||
                        entry.markingsAndStamps.isNotEmpty ||
                        entry.specialFeatures.isNotEmpty ||
                        entry.provenance.isNotEmpty ||
                        entry.notes.isNotEmpty)
                      _buildTextPanels(entry),
                    if (entry.tags.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      _buildTagsPanel(entry),
                    ],
                  ]),
                ),
              ),
            ],
          ),
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            left: 20.w,
            child: _navBtn(context,
                icon: Icons.arrow_back_rounded,
                onTap: () => Navigator.pop(context)),
          ),
          // Action buttons
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            right: 20.w,
            child: Row(
              children: [
                _navBtn(
                  context,
                  icon: Icons.edit_rounded,
                  onTap: () {
                    projectProv.fillInput(ref, index);
                    Navigator.pushNamed(context, '/add_screen', arguments: {
                      'isEdit': true,
                      'currentIndex': index,
                    });
                  },
                ),
                SizedBox(width: 10.w),
                _navBtn(
                  context,
                  icon: Icons.delete_rounded,
                  iconColor: kError,
                  onTap: () => _showDeleteDialog(context, projectProv, index),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(String? imagePath, ShipwrightToolModel entry) {
    final typeColor = getToolTypeColor(entry.toolType);
    return Stack(
      fit: StackFit.expand,
      children: [
        if (entry.photoPath.isNotEmpty &&
            imagePath != null &&
            File(imagePath).existsSync())
          Image.file(File(imagePath), fit: BoxFit.cover)
        else
          // Blueprint Grid — premium empty state
          CustomPaint(
            painter: _BlueprintGridPainter(color: typeColor),
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: typeColor.withValues(alpha: 0.6), width: 1.5),
                        color: typeColor.withValues(alpha: 0.08),
                      ),
                      child: Icon(
                        Icons.anchor_rounded,
                        size: 38.sp,
                        color: typeColor.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      'NO PHOTOGRAPHIC\nRECORD',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.firaCode(
                        color: typeColor.withValues(alpha: 0.5),
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        // Gradient overlay for better text/button contrast
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                  Colors.transparent,
                  kBackground,
                ],
                stops: const [0.0, 0.2, 0.8, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIdentityPanel(ShipwrightToolModel entry) {
    final conditionColor = getConditionColor(entry.conditionState);
    final typeColor = getToolTypeColor(entry.toolType);
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: kPanelBg,
        borderRadius: BorderRadius.circular(kRadiusXLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entry.shipyardIdentifier.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: kAccentSurface,
                borderRadius: BorderRadius.circular(kRadiusPill),
              ),
              child: Text(
                entry.shipyardIdentifier,
                style: GoogleFonts.firaCode(
                  color: kAccent,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 12.h),
          ],
          Text(
            entry.toolName,
            style: GoogleFonts.inter(
              color: kPrimaryText,
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -0.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (entry.forgeOrMaker.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              entry.forgeOrMaker,
              style: GoogleFonts.inter(
                color: kSecondaryText,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          SizedBox(height: 14.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _pill(conditionColor, entry.conditionState.label),
              _pill(typeColor, entry.toolType.label),
              if (entry.eraOfProduction.isNotEmpty)
                _pill(kSecondaryText, entry.eraOfProduction),
              if (entry.shipbuildingTradition != ShipbuildingTradition.unknown)
                _pill(kAccent, entry.shipbuildingTradition.label),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill(Color color, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(kRadiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 6.w),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              color: color,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecGrid(ShipwrightToolModel entry) {
    final specs = <String, String>{};
    if (entry.materials.isNotEmpty) specs['MATERIALS'] = entry.materials;
    if (entry.dimensions.isNotEmpty) specs['DIMENSIONS'] = entry.dimensions;

    if (specs.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: specs.entries.map((e) => _specTile(e.key, e.value)).toList(),
    );
  }

  Widget _specTile(String label, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: kPanelBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(kRadiusPill),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: kAccent,
              fontSize: 8.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: GoogleFonts.inter(
              color: kPrimaryText,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextPanels(ShipwrightToolModel entry) {
    return Column(
      children: [
        if (entry.specificFunction.isNotEmpty)
          _textPanel('SPECIFIC FUNCTION', entry.specificFunction),
        if (entry.markingsAndStamps.isNotEmpty)
          _textPanel('MARKINGS & STAMPS', entry.markingsAndStamps),
        if (entry.specialFeatures.isNotEmpty)
          _textPanel('SPECIAL FEATURES', entry.specialFeatures),
        if (entry.provenance.isNotEmpty)
          _textPanel('PROVENANCE', entry.provenance),
        if (entry.notes.isNotEmpty) _textPanel('ARCHIVAL NOTES', entry.notes),
      ],
    );
  }

  Widget _textPanel(String label, String text) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: kPanelBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(kRadiusXLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 3.w, height: 14.h, color: kAccent),
              SizedBox(width: 8.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: kAccent,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            text,
            style: GoogleFonts.inter(
              color: kSecondaryText,
              fontSize: 13.sp,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsPanel(ShipwrightToolModel entry) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: entry.tags
          .map((tag) => Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: kPanelBg.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(kRadiusPill),
                ),
                child: Text(
                  '#$tag',
                  style: GoogleFonts.inter(
                    color: kSecondaryText,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _navBtn(BuildContext context,
      {required IconData icon,
      required VoidCallback onTap,
      Color iconColor = kPrimaryText}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: kPanelBg,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20.sp),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, ProjectNotifier projectProv, int idx) {
    showDialog(
      context: context,
      builder: (ctx) => _DeleteDialog(
        onConfirm: () {
          projectProv.deleteEntry(idx);
          Navigator.pop(ctx);
          Navigator.pop(context);
        },
        onCancel: () => Navigator.pop(ctx),
      ),
    );
  }
}

// ── DELETE DIALOG ──────────────────────────────────────────────────────────────
class _DeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  const _DeleteDialog({required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(28.r),
        decoration: BoxDecoration(
          color: kPanelBg,
          borderRadius: BorderRadius.circular(kRadiusXLarge),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: kError.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border:
                    Border.all(color: kError.withValues(alpha: 0.3), width: 1),
              ),
              child: Icon(Icons.delete_outline_rounded,
                  color: kError, size: 28.sp),
            ),
            SizedBox(height: 20.h),
            Text(
              'REMOVE FROM LEDGER?',
              style: GoogleFonts.inter(
                color: kPrimaryText,
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'This tool record will be permanently removed from your archive.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  color: kSecondaryText, fontSize: 13.sp, height: 1.5),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: kBackground,
                        borderRadius: BorderRadius.circular(kRadiusPill),
                      ),
                      child: Center(
                        child: Text('CANCEL',
                            style: GoogleFonts.inter(
                                color: kSecondaryText,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.sp)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: kError.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(kRadiusPill),
                      ),
                      child: Center(
                        child: Text('REMOVE',
                            style: GoogleFonts.inter(
                                color: kError,
                                fontWeight: FontWeight.w800,
                                fontSize: 13.sp)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Blueprint Grid Painter — premium empty state for info screen
class _BlueprintGridPainter extends CustomPainter {
  final Color color;
  _BlueprintGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = color.withValues(alpha: 0.06);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final gridPaint = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Crosshair at center
    final crossPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..strokeWidth = 1.0;
    final cx = size.width / 2;
    final cy = size.height / 2;
    canvas.drawLine(Offset(cx - 20, cy), Offset(cx + 20, cy), crossPaint);
    canvas.drawLine(Offset(cx, cy - 20), Offset(cx, cy + 20), crossPaint);
    canvas.drawCircle(Offset(cx, cy), 4, crossPaint..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(covariant _BlueprintGridPainter oldDelegate) =>
      oldDelegate.color != color;
}
