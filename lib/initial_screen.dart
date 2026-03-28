import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shipyard_planking_tally/providers/user_provider.dart';
import 'package:shipyard_planking_tally/utils/const.dart';
import 'package:google_fonts/google_fonts.dart';

class InitialScreen extends ConsumerWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProv = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 48.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rich Shipyard Header Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(width: 24.w, height: 2.h, color: kAccent),
                      SizedBox(width: 8.w),
                      Text(
                        'EST. 1884',
                        style: GoogleFonts.firaCode(
                          color: kSecondaryText,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.0,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Container(height: 1.h, color: kOutline),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      color: kPanelBg,
                      borderRadius: BorderRadius.circular(kRadiusLarge),
                      border: Border.all(color: kOutline, width: 1.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(kRadiusLarge),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),

              // Hero Typography block
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SHIPYARD\nPLANKING\nTALLY.',
                    style: GoogleFonts.inter(
                      color: kPrimaryText,
                      fontSize: 54.sp,
                      fontWeight: FontWeight.w900,
                      height: 0.95,
                      letterSpacing: -2.5,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'A digital archive for historical maritime woodworking antiquities.',
                    style: GoogleFonts.inter(
                      color: kSecondaryText,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),

              // Modern CTA
              GestureDetector(
                onTap: () {
                  userProv.setFirstTimeUser(false);
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: Container(
                  width: double.infinity,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: kPrimaryText, // High contrast button (off-white on black bg)
                    borderRadius: BorderRadius.circular(kRadiusPill),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Enter Archive',
                        style: GoogleFonts.inter(
                          color: kBackground,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.arrow_forward_rounded, color: kBackground, size: 20.sp),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
