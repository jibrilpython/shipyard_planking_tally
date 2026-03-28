import 'package:flutter/material.dart';
import 'package:shipyard_planking_tally/enum/my_enums.dart';

// ─── COLOR PALETTE — "The Shipwright's Ledger" ───────────────────────────────
const Color kBackground  = Color(0xFF0F1216); // Deep Atlantic / Cold Forge black
const Color kPrimaryText = Color(0xFFE4E7EB); // Salted canvas / Weathered paper
const Color kPanelBg     = Color(0xFF1B1E24); // Dark Oak / Wet hull timber
const Color kSecondaryText = Color(0xFF828D99); // Mist grey / Oxidized iron
const Color kAccent      = Color(0xFF2A5B8A); // Deep Mariner Blue
const Color kOutline     = Color(0xFF2D333B); // Cast iron / Bulkhead grey
const Color kError       = Color(0xFFD14343); // Signal buoy red

// ─── DERIVED COLORS ───────────────────────────────────────────────────────────
const Color kAccentLight = Color(0xFF2D4F6A); // Muted mariner tint
const Color kAccentSurface = Color(0xFF1A2D3F); // Very dark blue surface
const Color kSuccess    = Color(0xFF386B4B);  // Muted signal green
const Color kWarning    = Color(0xFF7A6033);  // Amber-warning

// ─── SPACING ─────────────────────────────────────────────────────────────────
const double kSpacingXXS  = 4.0;
const double kSpacingXS   = 8.0;
const double kSpacingS    = 12.0;
const double kSpacingM    = 16.0;
const double kSpacingL    = 20.0;
const double kSpacingXL   = 24.0;
const double kSpacingXXL  = 32.0;
const double kSpacingXXXL = 48.0;

// ─── BORDER RADIUS ────────────────────────────────────────────────────────────
const double kRadiusZero     = 0.0;
const double kRadiusSubtle   = 8.0;
const double kRadiusStandard = 16.0;
const double kRadiusMedium   = 24.0;
const double kRadiusLarge    = 32.0;
const double kRadiusXLarge   = 40.0;
const double kRadiusPill     = 999.0;

// ─── SHADOWS — dark-theme card depth ─────────────────────────────────────────
const BoxShadow kShadowSubtle = BoxShadow(
  offset: Offset(0, 1),
  blurRadius: 4,
  color: Color(0x33000000),
);
const BoxShadow kShadowMedium = BoxShadow(
  offset: Offset(0, 4),
  blurRadius: 12,
  spreadRadius: -2,
  color: Color(0x55000000),
);
const BoxShadow kAccentGlow = BoxShadow(
  offset: Offset(0, 2),
  blurRadius: 8,
  color: Color(0x332A5B8A),
);

const double kStrokeWeight        = 0.5;
const double kStrokeWeightMedium  = 1.0;

// ─── TOOL TYPE COLORS ─────────────────────────────────────────────────────────
Color getToolTypeColor(ToolType type) {
  switch (type) {
    case ToolType.holdfast:
      return const Color(0xFF4A7A9B); // steel blue
    case ToolType.plankDog:
      return const Color(0xFF5B7A5B); // muted sage
    case ToolType.spilingClamp:
      return const Color(0xFF7A5B4A); // warm teak
    case ToolType.wedgeClamp:
      return const Color(0xFF3D6B6B); // slate teal
    case ToolType.ribbandClamp:
      return const Color(0xFF6B4F7A); // dusty violet
    case ToolType.hollowAuger:
      return const Color(0xFF4A6B5B); // deep kelp
    case ToolType.shipwrightMallet:
      return const Color(0xFF7A6B4A); // brass
    case ToolType.treenailDriver:
      return const Color(0xFF4A5B7A); // deep navy
    case ToolType.other:
      return kSecondaryText;
  }
}

// ─── CONDITION COLORS ─────────────────────────────────────────────────────────
Color getConditionColor(ConditionState state) {
  switch (state) {
    case ConditionState.workingCondition:
      return kSuccess;
    case ConditionState.displayCondition:
      return kAccent;
    case ConditionState.forConservation:
      return kWarning;
    case ConditionState.forParts:
      return kError;
    case ConditionState.unknown:
      return kSecondaryText;
  }
}
