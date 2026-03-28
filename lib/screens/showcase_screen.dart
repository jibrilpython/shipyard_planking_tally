import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipyard_planking_tally/models/tool_model.dart';
import 'package:shipyard_planking_tally/providers/image_provider.dart';
import 'package:shipyard_planking_tally/providers/project_provider.dart';
import 'package:shipyard_planking_tally/utils/const.dart';

class ShowcaseScreen extends ConsumerStatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  ConsumerState<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends ConsumerState<ShowcaseScreen> {
  // Astrolabe Data
  List<_RingData> _rings = [];
  ShipwrightToolModel? _activeTool;
  Offset? _lastPanPosition;
  int? _activePanRingIndex;

  void _initializeRings(List<ShipwrightToolModel> entries) {
    _rings.clear();
    
    // Distribute equally among 3 rings (Inner, Middle, Outer)
    List<ShipwrightToolModel> r1 = [];
    List<ShipwrightToolModel> r2 = [];
    List<ShipwrightToolModel> r3 = [];
    
    for (int i = 0; i < entries.length; i++) {
        if (i % 3 == 0) r1.add(entries[i]);
        else if (i % 3 == 1) r2.add(entries[i]);
        else r3.add(entries[i]);
    }

    // Radius constants
    double baseRadius = 80.w; // Shrunk down to prevent completely bleeding off on narrow devices
    double gap = 45.w;

    if (r1.isNotEmpty) _rings.add(_RingData(index: 0, radius: baseRadius, tools: r1));
    if (r2.isNotEmpty) _rings.add(_RingData(index: 1, radius: baseRadius + gap, tools: r2));
    if (r3.isNotEmpty) _rings.add(_RingData(index: 2, radius: baseRadius + (gap * 2), tools: r3));
    
    // Set default active tool if available
    if (entries.isNotEmpty) {
       _activeTool = entries.first;
       // We force the first ring to align its first item to the Golden Meridian (-pi/2)
       if (_rings.isNotEmpty && _rings[0].nodes.isNotEmpty) {
           _rings[0].currentRotation = -math.pi / 2 - _rings[0].nodes[0].baseAngle;
       }
    }
  }

  // --- RADIAL GESTURE MATHEMATICS ---

  void _onPanDown(DragDownDetails details, Offset center) {
    double distance = (details.localPosition - center).distance;

    _activePanRingIndex = null;
    for (int i = 0; i < _rings.length; i++) {
       // Tolerance of 40 physical pixels to grab a ring
       if ((distance - _rings[i].radius).abs() < 40.w) {
           _activePanRingIndex = i;
           break;
       }
    }
    _lastPanPosition = details.localPosition;
  }

  void _onPanUpdate(DragUpdateDetails details, Offset center) {
    if (_activePanRingIndex == null || _lastPanPosition == null) return;
    
    double lastAngle = math.atan2(_lastPanPosition!.dy - center.dy, _lastPanPosition!.dx - center.dx);
    double currentAngle = math.atan2(details.localPosition.dy - center.dy, details.localPosition.dx - center.dx);
    
    double deltaAngle = currentAngle - lastAngle;
    
    if (deltaAngle > math.pi) deltaAngle -= 2 * math.pi;
    else if (deltaAngle < -math.pi) deltaAngle += 2 * math.pi;

    setState(() {
      _rings[_activePanRingIndex!].currentRotation += deltaAngle;
    });

    _lastPanPosition = details.localPosition;
    _checkForMeridianSnap(_activePanRingIndex!);
  }

  void _onPanEnd(DragEndDetails details) {
    _activePanRingIndex = null;
    _lastPanPosition = null;
  }

  // Snap tapped node instantly to the Meridian
  void _onTapUp(TapUpDetails details, Offset center) {
    for (int i = 0; i < _rings.length; i++) {
        var ring = _rings[i];
        for (var node in ring.nodes) {
            double finalAngle = node.baseAngle + ring.currentRotation;
            Offset nodePos = Offset(
                center.dx + math.cos(finalAngle) * ring.radius,
                center.dy + math.sin(finalAngle) * ring.radius,
            );
            
            if ((details.localPosition - nodePos).distance < 40.w) {
                 HapticFeedback.lightImpact();
                 setState(() {
                    ring.currentRotation = -math.pi / 2 - node.baseAngle;
                    _activeTool = node.tool;
                 });
                 return;
            }
        }
    }
  }

  void _checkForMeridianSnap(int ringIndex) {
     final ring = _rings[ringIndex];
     final double targetAngle = -math.pi / 2;

     for (var node in ring.nodes) {
         double absoluteAngle = (node.baseAngle + ring.currentRotation) % (2 * math.pi);
         if (absoluteAngle > math.pi) absoluteAngle -= 2 * math.pi;
         
         if ((absoluteAngle - targetAngle).abs() < 0.08) {
             if (_activeTool != node.tool) {
                HapticFeedback.lightImpact();
                setState(() => _activeTool = node.tool);
             }
             break;
         }
     }
  }

  void _openActiveDetails() {
    if (_activeTool != null) {
        final entries = ref.read(projectProvider).entries;
        int idx = entries.indexOf(_activeTool!);
        if (idx != -1) {
             HapticFeedback.heavyImpact();
             Navigator.pushNamed(context, '/info_screen', arguments: {'index': idx});
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageProv = ref.watch(imageProvider);
    final entries = ref.watch(projectProvider).entries;

    int totalNodes = _rings.fold(0, (sum, ring) => sum + ring.tools.length);
    if (entries.isNotEmpty && totalNodes != entries.length) {
       WidgetsBinding.instance.addPostFrameCallback((_) {
         if (mounted) setState(() => _initializeRings(entries));
       });
    }

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'THE ASTROLABE',
              style: GoogleFonts.cinzel(
                color: kAccent,
                fontSize: 16.sp,
                letterSpacing: 4.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Spin the tracks to align coordinates',
              style: GoogleFonts.inter(
                color: kSecondaryText,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          // Shifted center up slightly
          final centerOffset = Offset(size.width / 2, size.height / 2 - 60.h);

          return GestureDetector(
            onPanDown: (d) => _onPanDown(d, centerOffset),
            onPanUpdate: (d) => _onPanUpdate(d, centerOffset),
            onPanEnd: _onPanEnd,
            onTapUp: (d) => _onTapUp(d, centerOffset),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. The Concentric Astrolabe Rings
                CustomPaint(
                   size: Size.infinite,
                   painter: _AstrolabePainter(
                       rings: _rings, 
                       activeTool: _activeTool,
                       centerOffset: centerOffset,
                   ),
                ),

                // 2. The Golden Meridian (Reading Line)
                Positioned(
                  top: 0,
                  bottom: size.height - centerOffset.dy, // Drop from top exactly to center
                  left: size.width / 2 - 1,
                  child: Container(
                    width: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [kAccent.withValues(alpha: 0.0), kAccent],
                      )
                    ),
                  ),
                ),
                
                // Glowing focal point on meridian exactly at center
                Positioned(
                   top: centerOffset.dy - 4,
                   left: centerOffset.dx - 4,
                   child: Container(
                      width: 8, height: 8,
                      decoration: const BoxDecoration(
                         color: kAccent,
                         shape: BoxShape.circle,
                         boxShadow: [BoxShadow(color: kAccent, blurRadius: 15, spreadRadius: 4)]
                      ),
                   ),
                ),

                // 3. Floating Discovery Card
                _buildFloatingCard(imageProv),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildFloatingCard(ImageNotifier imageProv) {
     if (_activeTool == null) return const SizedBox();
     
     final imagePath = imageProv.getImagePath(_activeTool!.photoPath);
     
     return Positioned(
        bottom: 120.h, // Lifted high to clear standard bottom navbars
        left: 20.w,
        right: 20.w,
        child: AnimatedSwitcher(
           duration: const Duration(milliseconds: 300),
           transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(animation),
              child: FadeTransition(opacity: animation, child: child)
           ),
           child: Container(
              key: ValueKey<String>(_activeTool!.id),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                  color: kPanelBg, // Unified dark Charcoal background
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kOutline.withValues(alpha: 0.5)),
                  boxShadow: [
                     BoxShadow(
                        color: Colors.black.withValues(alpha: 0.6),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                     )
                  ]
              ),
              child: Row(
                 mainAxisSize: MainAxisSize.max,
                 children: [
                    // Tool Image
                    Hero(
                       tag: 'tool_image_${_activeTool!.id}',
                       child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: kBackground, // Background for missing image
                              image: (imagePath != null && imagePath.isNotEmpty && File(imagePath).existsSync())
                                 ? DecorationImage(
                                     image: FileImage(File(imagePath)),
                                     fit: BoxFit.cover,
                                   )
                                 : null,
                          ),
                          child: (imagePath == null || imagePath.isEmpty || !File(imagePath).existsSync())
                              ? Icon(Icons.handyman, color: kSecondaryText.withValues(alpha: 0.5))
                              : null,
                       ),
                    ),
                    SizedBox(width: 16.w),
                    // Tool Info
                    Expanded(
                       child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                                _activeTool!.toolName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                   color: kPrimaryText,
                                   fontSize: 16.sp,
                                   fontWeight: FontWeight.w700,
                                ),
                             ),
                             SizedBox(height: 4.h),
                             Text(
                                _activeTool!.toolType.label.toUpperCase(),
                                style: GoogleFonts.inter(
                                   color: kAccent,
                                   fontSize: 10.sp,
                                   fontWeight: FontWeight.w600,
                                   letterSpacing: 1.0,
                                ),
                             ),
                             SizedBox(height: 12.h),
                             // Action Button
                             SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                   onPressed: _openActiveDetails,
                                   style: ElevatedButton.styleFrom(
                                      backgroundColor: kAccent,
                                      foregroundColor: kPrimaryText,
                                      padding: EdgeInsets.symmetric(vertical: 10.h),
                                      shape: RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0,
                                   ),
                                   child: Text(
                                      'View Details',
                                      style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w700),
                                   ),
                                ),
                             )
                          ],
                       ),
                    )
                 ],
              ),
           ),
        ),
     );
  }
}

// ----------------------------------------------------
// THE ASTROLABE MATHEMATICS & PAINTER
// ----------------------------------------------------

class _AstrolabeNode {
  final double baseAngle;
  final ShipwrightToolModel tool;
  _AstrolabeNode({required this.baseAngle, required this.tool});
}

class _RingData {
  final int index;
  final double radius;
  final List<ShipwrightToolModel> tools;
  List<_AstrolabeNode> nodes = [];
  double currentRotation = 0.0;

  _RingData({required this.index, required this.radius, required this.tools}) {
     if (tools.isEmpty) return;
     double angleStep = (2 * math.pi) / tools.length;
     for(int i = 0; i < tools.length; i++) {
         nodes.add(_AstrolabeNode(baseAngle: i * angleStep, tool: tools[i]));
     }
  }
}

class _AstrolabePainter extends CustomPainter {
  final List<_RingData> rings;
  final ShipwrightToolModel? activeTool;
  final Offset centerOffset;

  _AstrolabePainter({required this.rings, required this.activeTool, required this.centerOffset});

  @override
  void paint(Canvas canvas, Size size) {
     final center = centerOffset;

     final Paint trackPaint = Paint()
       ..color = kSecondaryText.withValues(alpha: 0.15)
       ..style = PaintingStyle.stroke
       ..strokeWidth = 1.5;

     final Paint nodePaint = Paint()
       ..color = kSecondaryText
       ..style = PaintingStyle.fill;
       
     final Paint activeNodePaint = Paint()
       ..color = kAccent
       ..style = PaintingStyle.fill;

     // Central aesthetic pin (since aperture is gone)
     canvas.drawCircle(center, 12, trackPaint);
     canvas.drawCircle(center, 4, nodePaint);

     for (var ring in rings) {
         canvas.drawCircle(center, ring.radius, trackPaint);

         for (double a = 0; a < 2 * math.pi; a += math.pi / 24) {
              Offset inner = Offset(
                 center.dx + math.cos(a + ring.currentRotation) * (ring.radius - 4),
                 center.dy + math.sin(a + ring.currentRotation) * (ring.radius - 4));
              Offset outer = Offset(
                 center.dx + math.cos(a + ring.currentRotation) * (ring.radius + 4),
                 center.dy + math.sin(a + ring.currentRotation) * (ring.radius + 4));
              canvas.drawLine(inner, outer, Paint()..color = kSecondaryText.withValues(alpha: 0.1)..strokeWidth = 1.0);
         }

         for (var node in ring.nodes) {
              double finalAngle = node.baseAngle + ring.currentRotation;
              Offset nodePos = Offset(
                 center.dx + math.cos(finalAngle) * ring.radius,
                 center.dy + math.sin(finalAngle) * ring.radius,
              );

              bool isActive = activeTool == node.tool;
              
              if (isActive) {
                 // Increased blurRadius for significantly more glow
                 canvas.drawCircle(nodePos, 14, Paint()..color=kAccent.withValues(alpha: 0.6)..maskFilter=const MaskFilter.blur(BlurStyle.normal, 20));
                 canvas.drawCircle(nodePos, 6, activeNodePaint);
                 canvas.drawCircle(nodePos, 10, Paint()..color=kAccent..style=PaintingStyle.stroke..strokeWidth=2);
              } else {
                 canvas.drawCircle(nodePos, 4, nodePaint);
                 canvas.drawCircle(nodePos, 8, Paint()..color=kSecondaryText.withValues(alpha: 0.3)..style=PaintingStyle.stroke..strokeWidth=1);
              }
         }
     }
  }

  @override
  bool shouldRepaint(covariant _AstrolabePainter oldDelegate) => true;
}
