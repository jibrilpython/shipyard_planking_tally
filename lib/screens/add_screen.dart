import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shipyard_planking_tally/common/photo_bottom_sheet.dart';
import 'package:shipyard_planking_tally/enum/my_enums.dart';
import 'package:shipyard_planking_tally/providers/image_provider.dart';
import 'package:shipyard_planking_tally/providers/input_provider.dart';
import 'package:shipyard_planking_tally/providers/project_provider.dart';
import 'package:shipyard_planking_tally/utils/const.dart';
import 'package:google_fonts/google_fonts.dart';

class AddScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  final int currentIndex;
  const AddScreen({super.key, this.isEdit = false, this.currentIndex = 0});

  @override
  ConsumerState<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends ConsumerState<AddScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late TextEditingController _idCtrl;
  late TextEditingController _nameCtrl;
  late TextEditingController _forgeCtrl;
  late TextEditingController _functionCtrl;
  late TextEditingController _eraCtrl;
  late TextEditingController _materialsCtrl;
  late TextEditingController _dimensionsCtrl;
  late TextEditingController _markingsCtrl;
  late TextEditingController _featuresCtrl;
  late TextEditingController _provenanceCtrl;
  late TextEditingController _notesCtrl;
  late TextEditingController _tagsCtrl;

  @override
  void initState() {
    super.initState();
    final p = ref.read(inputProvider);
    _idCtrl = TextEditingController(text: p.shipyardIdentifier);
    _nameCtrl = TextEditingController(text: p.toolName);
    _forgeCtrl = TextEditingController(text: p.forgeOrMaker);
    _functionCtrl = TextEditingController(text: p.specificFunction);
    _eraCtrl = TextEditingController(text: p.eraOfProduction);
    _materialsCtrl = TextEditingController(text: p.materials);
    _dimensionsCtrl = TextEditingController(text: p.dimensions);
    _markingsCtrl = TextEditingController(text: p.markingsAndStamps);
    _featuresCtrl = TextEditingController(text: p.specialFeatures);
    _provenanceCtrl = TextEditingController(text: p.provenance);
    _notesCtrl = TextEditingController(text: p.notes);
    _tagsCtrl = TextEditingController(text: p.tags.join(', '));
  }

  @override
  void dispose() {
    for (final c in [
      _idCtrl, _nameCtrl, _forgeCtrl, _functionCtrl, _eraCtrl,
      _materialsCtrl, _dimensionsCtrl, _markingsCtrl, _featuresCtrl,
      _provenanceCtrl, _notesCtrl, _tagsCtrl,
    ]) {
      c.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
      setState(() => _currentPage++);
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
      setState(() => _currentPage--);
    }
  }

  void _save() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const _SavingDialog());
    await Future.delayed(const Duration(milliseconds: 1200));
    if (widget.isEdit) {
      ref.read(projectProvider).editEntry(ref, widget.currentIndex);
    } else {
      ref.read(projectProvider).addEntry(ref);
    }
    if (mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
      ref.read(inputProvider).clearAll();
      ref.read(imageProvider).clearImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = ['REGISTRY', 'SPECIFICATION', 'CONDITION', 'RECORDS'];
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(steps),
            _buildStepBar(steps.length),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPage1(),
                  _buildPage2(),
                  _buildPage3(),
                  _buildPage4(),
                ],
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // ── HEADER ──────────────────────────────────────────────────────────────────
  Widget _buildHeader(List<String> steps) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      child: Row(
        children: [
          _circleBtn(icon: Icons.close_rounded, onTap: () => Navigator.pop(context)),
          const Spacer(),
          Column(
            children: [
              Text(
                widget.isEdit ? 'EDIT TOOL' : 'NEW TOOL',
                style: GoogleFonts.firaCode(
                  color: kAccent,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                steps[_currentPage],
                style: GoogleFonts.inter(
                  color: kPrimaryText,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(width: 44.w),
        ],
      ),
    );
  }

  // ── STEP BAR ────────────────────────────────────────────────────────────────
  Widget _buildStepBar(int totalSteps) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        children: List.generate(totalSteps, (i) {
          final isDone = i < _currentPage;
          final isCurrent = i == _currentPage;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 3.h,
              margin: EdgeInsets.only(right: i < totalSteps - 1 ? 6.w : 0),
              decoration: BoxDecoration(
                color: isDone || isCurrent ? kAccent : kOutline,
                borderRadius: BorderRadius.circular(kRadiusPill),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── PAGE 1: REGISTRY ────────────────────────────────────────────────────────
  Widget _buildPage1() {
    final p = ref.watch(inputProvider);
    return _scrollPage(children: [
      _pageLabel('01 · CORE IDENTITY'),
      SizedBox(height: 16.h),
      _field(
        label: 'TOOL NAME',
        ctrl: _nameCtrl,
        hint: 'e.g. Bench Holdfast, Plank Dog',
        icon: Icons.label_important_outline,
        onChanged: (v) => p.toolName = v,
      ),
      SizedBox(height: 12.h),
      _field(
        label: 'SHIPYARD IDENTIFIER',
        ctrl: _idCtrl,
        hint: 'e.g. TSTA-NORWEGIAN-HOLDFAST-1880-047',
        icon: Icons.fingerprint_rounded,
        onChanged: (v) => p.shipyardIdentifier = v,
      ),
      SizedBox(height: 20.h),
      _sectionLabel('TOOL CATEGORY'),
      SizedBox(height: 10.h),
      _toolTypeGrid(p),
      SizedBox(height: 20.h),
      _field(
        label: 'FORGE OR MAKER',
        ctrl: _forgeCtrl,
        hint: 'e.g. B.S. Co., local shipyard forge',
        icon: Icons.hardware_outlined,
        onChanged: (v) => p.forgeOrMaker = v,
      ),
    ]);
  }

  Widget _toolTypeGrid(InputNotifier p) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: ToolType.values.map((t) {
        final isSel = p.toolType == t;
        final typeColor = getToolTypeColor(t);
        return GestureDetector(
          onTap: () => p.toolType = t,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSel ? kAccentSurface : kPanelBg,
              borderRadius: BorderRadius.circular(kRadiusPill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSel) ...[
                  Container(
                    width: 6.w, height: 6.w,
                    decoration: BoxDecoration(color: typeColor, shape: BoxShape.circle),
                  ),
                  SizedBox(width: 6.w),
                ],
                Text(
                  t.label,
                  style: GoogleFonts.inter(
                    color: isSel ? kPrimaryText : kSecondaryText,
                    fontSize: 11.sp,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── PAGE 2: SPECIFICATION ───────────────────────────────────────────────────
  Widget _buildPage2() {
    final p = ref.watch(inputProvider);
    return _scrollPage(children: [
      _pageLabel('02 · SPECIFICATION'),
      SizedBox(height: 16.h),
      _field(
        label: 'ERA OF PRODUCTION',
        ctrl: _eraCtrl,
        hint: 'e.g. 1880, 1900',
        icon: Icons.history_rounded,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
        ],
        onChanged: (v) => p.eraOfProduction = v,
      ),
      SizedBox(height: 12.h),
      _field(
        label: 'SPECIFIC FUNCTION',
        ctrl: _functionCtrl,
        hint: 'e.g. Holding planks to frames during construction',
        maxLines: 2,
        onChanged: (v) => p.specificFunction = v,
      ),
      SizedBox(height: 20.h),
      _sectionLabel('SHIPBUILDING TRADITION'),
      SizedBox(height: 10.h),
      _traditionGrid(p),
      SizedBox(height: 20.h),
      _field(
        label: 'MATERIALS',
        ctrl: _materialsCtrl,
        hint: 'e.g. Hand-forged wrought iron, oak handle',
        maxLines: 2,
        icon: Icons.science_outlined,
        onChanged: (v) => p.materials = v,
      ),
      SizedBox(height: 12.h),
      _field(
        label: 'DIMENSIONS',
        ctrl: _dimensionsCtrl,
        hint: 'e.g. 380mm L × 45mm W, 1.2kg',
        icon: Icons.straighten_rounded,
        onChanged: (v) => p.dimensions = v,
      ),
    ]);
  }

  Widget _traditionGrid(InputNotifier p) {
    return Column(
      children: ShipbuildingTradition.values.map((t) {
        final isSel = p.shipbuildingTradition == t;
        return GestureDetector(
          onTap: () => p.shipbuildingTradition = t,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isSel ? kAccentSurface : kPanelBg,
              borderRadius: BorderRadius.circular(kRadiusPill),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    t.label,
                    style: GoogleFonts.inter(
                      color: isSel ? kPrimaryText : kSecondaryText,
                      fontSize: 13.sp,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSel)
                  Icon(Icons.check_circle_rounded, color: kAccent, size: 18.sp)
                else
                  Icon(Icons.radio_button_off_rounded,
                      color: kOutline, size: 18.sp),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── PAGE 3: CONDITION ───────────────────────────────────────────────────────
  Widget _buildPage3() {
    final p = ref.watch(inputProvider);
    return _scrollPage(children: [
      _pageLabel('03 · CONDITION & PROVENANCE'),
      SizedBox(height: 16.h),
      _sectionLabel('CURRENT STATE'),
      SizedBox(height: 10.h),
      ...ConditionState.values.map((state) {
        final isSel = p.conditionState == state;
        final col = getConditionColor(state);
        return GestureDetector(
          onTap: () => p.conditionState = state,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isSel ? kAccentSurface : kPanelBg,
              borderRadius: BorderRadius.circular(kRadiusPill),
            ),
            child: Row(
              children: [
                Container(
                  width: 10.w, height: 10.w,
                  decoration: BoxDecoration(
                    color: isSel ? col : kOutline,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    state.label,
                    style: GoogleFonts.inter(
                      color: isSel ? kPrimaryText : kSecondaryText,
                      fontSize: 13.sp,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSel) Icon(Icons.check_rounded, color: col, size: 16.sp),
              ],
            ),
          ),
        );
      }),
      SizedBox(height: 20.h),
      _field(
        label: 'MARKINGS & STAMPS',
        ctrl: _markingsCtrl,
        hint: 'Forge stamps, inventory numbers, initials...',
        maxLines: 2,
        onChanged: (v) => p.markingsAndStamps = v,
      ),
      SizedBox(height: 12.h),
      _field(
        label: 'SPECIAL FEATURES',
        ctrl: _featuresCtrl,
        hint: 'Adjustable jaws, depth stops, scribing blade...',
        maxLines: 2,
        onChanged: (v) => p.specialFeatures = v,
      ),
      SizedBox(height: 12.h),
      _field(
        label: 'PROVENANCE',
        ctrl: _provenanceCtrl,
        hint: 'Where discovered — boatyard, estate, auction...',
        maxLines: 3,
        onChanged: (v) => p.provenance = v,
      ),
    ]);
  }

  // ── PAGE 4: RECORDS ─────────────────────────────────────────────────────────
  Widget _buildPage4() {
    final p = ref.watch(inputProvider);
    final imageProv = ref.watch(imageProvider);
    final displayPath = imageProv.getImagePath(imageProv.resultImage);

    return _scrollPage(children: [
      _pageLabel('04 · VISUAL RECORD & NOTES'),
      SizedBox(height: 16.h),
      _sectionLabel('PHOTOGRAPHIC DOCUMENTATION'),
      SizedBox(height: 12.h),
      GestureDetector(
        onTap: () => photoBottomSheet(context, ref.read(imageProvider), 0, ref),
        child: Container(
          width: double.infinity,
          height: 220.h,
          decoration: BoxDecoration(
            color: kPanelBg,
            borderRadius: BorderRadius.circular(kRadiusXLarge),
            border: Border.all(
              color: displayPath != null && File(displayPath).existsSync()
                  ? kOutline
                  : kAccent.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kRadiusXLarge),
            child: displayPath != null && File(displayPath).existsSync()
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(File(displayPath), fit: BoxFit.cover),
                      Positioned(
                        bottom: 12.h,
                        right: 12.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: kBackground.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(kRadiusPill),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit_outlined,
                                  color: kPrimaryText, size: 12.sp),
                              SizedBox(width: 4.w),
                              Text('Change',
                                  style: GoogleFonts.inter(
                                      color: kPrimaryText,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          color: kAccentSurface,
                          borderRadius: BorderRadius.circular(kRadiusMedium),
                          border: Border.all(
                              color: kAccent.withValues(alpha: 0.3), width: 1),
                        ),
                        child: Icon(Icons.add_a_photo_outlined,
                            color: kAccent, size: 24.sp),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'TAP TO ADD PHOTOGRAPH',
                        style: GoogleFonts.inter(
                          color: kSecondaryText,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      SizedBox(height: 20.h),
      _field(
        label: 'ARCHIVAL NOTES',
        ctrl: _notesCtrl,
        hint: 'History, observations, restoration notes...',
        maxLines: 4,
        onChanged: (v) => p.notes = v,
      ),
      SizedBox(height: 12.h),
      _field(
        label: 'TAGS (COMMA SEPARATED)',
        ctrl: _tagsCtrl,
        hint: 'norwegian, iron, 19th-century...',
        onChanged: (v) =>
            p.tags = v.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      ),
    ]);
  }

  // ── SHARED ──────────────────────────────────────────────────────────────────
  Widget _scrollPage({required List<Widget> children}) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 40.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _pageLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.firaCode(
        color: kAccent,
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Row(
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
        SizedBox(width: 10.w),
        Expanded(child: Container(height: 1, color: kOutline)),
      ],
    );
  }

  Widget _field({
    required String label,
    required TextEditingController ctrl,
    required Function(String) onChanged,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    IconData? icon,
  }) {
    return TextField(
      controller: ctrl,
      onChanged: onChanged,
      minLines: 1,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: GoogleFonts.inter(
          color: kPrimaryText, fontSize: 14.sp, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null
            ? Icon(icon, color: kSecondaryText.withValues(alpha: 0.4), size: 18.sp)
            : null,
        filled: true,
        fillColor: kPanelBg,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusLarge),
          borderSide: const BorderSide(color: kOutline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusLarge),
          borderSide: const BorderSide(color: kOutline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusLarge),
          borderSide: const BorderSide(color: kAccent, width: 1.5),
        ),
      ),
    );
  }

  Widget _circleBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: const BoxDecoration(
          color: kPanelBg,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: kSecondaryText, size: 20.sp),
      ),
    );
  }

  Widget _buildBottomNav() {
    final isValid = _currentPage == 0
        ? ref.read(inputProvider).toolName.isNotEmpty
        : true;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
      decoration: const BoxDecoration(
        color: kBackground,
        border: Border(top: BorderSide(color: kOutline, width: 1)),
      ),
      child: Row(
        children: [
          if (_currentPage > 0) ...[
            _circleBtn(icon: Icons.arrow_back_rounded, onTap: _prevPage),
            SizedBox(width: 14.w),
          ],
          Expanded(
            child: GestureDetector(
              onTap: isValid ? (_currentPage == 3 ? _save : _nextPage) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 56.h,
                decoration: BoxDecoration(
                  color: isValid ? kAccent : kPanelBg,
                  borderRadius: BorderRadius.circular(kRadiusPill),
                  boxShadow: isValid ? const [kAccentGlow] : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage == 3 ? 'SAVE TO ARCHIVE' : 'NEXT',
                        style: GoogleFonts.inter(
                          color: isValid ? kPrimaryText : kSecondaryText,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Icon(
                        _currentPage == 3
                            ? Icons.check_circle_outline_rounded
                            : Icons.arrow_forward_rounded,
                        color: isValid ? kPrimaryText : kSecondaryText,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── SAVING DIALOG ─────────────────────────────────────────────────────────────
class _SavingDialog extends StatefulWidget {
  const _SavingDialog();
  @override
  State<_SavingDialog> createState() => _SavingDialogState();
}

class _SavingDialogState extends State<_SavingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 1))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(32.r),
        decoration: BoxDecoration(
          color: kPanelBg,
          borderRadius: BorderRadius.circular(kRadiusXLarge),
          border: Border.all(color: kOutline, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              turns: _ctrl,
              child: Icon(Icons.anchor_rounded, color: kAccent, size: 36.sp),
            ),
            SizedBox(height: 20.h),
            Text(
              'INSCRIBING TO LEDGER',
              style: GoogleFonts.inter(
                color: kPrimaryText,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Saving to archive...',
              style: GoogleFonts.inter(
                color: kSecondaryText,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
