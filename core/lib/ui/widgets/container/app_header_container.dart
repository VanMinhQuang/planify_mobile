import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class AppHeaderContainer extends StatelessWidget {
  const AppHeaderContainer({
    super.key,
    required this.headerContent,
    required this.bodyContent,
    this.headerHeight,
    this.overlapOffset,
    this.bodyColor,
    this.headerColor,
    this.bodyBorderRadius,
    this.headerBackgroundImage,
    this.headerImageOpacity = 0.15,
    this.headerImageFit = BoxFit.cover,
  });

  final Widget headerContent;
  final Widget bodyContent;
  final double? headerHeight;
  final double? overlapOffset;
  final Color? bodyColor;
  final Color? headerColor;
  final BorderRadiusGeometry? bodyBorderRadius;
  final ImageProvider? headerBackgroundImage;
  final double headerImageOpacity;
  final BoxFit headerImageFit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: Platform.isAndroid,
      left: false,
      right: false,
      top: false,
      child: Scaffold(
        body: ClipRect(
          child: Column(
            children: [
              // Header
              SizedBox(
                height: headerHeight ?? SizeConfig.height * 0.25,
                width: double.infinity,
                child: Stack(
                  clipBehavior:
                      Clip.none, // ← allows image to overflow outside header
                  fit: StackFit.expand,
                  children: [
                    // Base color
                    Container(color: headerColor ?? AppColor.primary),

                    // Optional opacity background image
                    if (headerBackgroundImage != null)
                      Positioned(
                        bottom: -150.h,
                        left: 0,
                        right: 0,
                        child: Opacity(
                          opacity: headerImageOpacity,
                          child: Image(
                            image: headerBackgroundImage!,
                            fit: headerImageFit,
                            width: SizeConfig.width * 0.4,
                          ),
                        ),
                      ),

                    // Header content on top
                    headerContent,
                  ],
                ),
              ),

              // Body with overlap
              Expanded(
                child: Transform.translate(
                  offset: Offset(0, -(overlapOffset ?? 20.h)),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: bodyColor ?? AppColor.white,
                      borderRadius:
                          bodyBorderRadius ??
                          BorderRadius.vertical(top: Radius.circular(20.sp)),
                    ),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: bodyContent,
                    ),
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
