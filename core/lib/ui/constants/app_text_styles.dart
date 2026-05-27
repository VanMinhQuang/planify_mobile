import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

typedef AppTextStyles = CustomTheme;

class CustomTheme extends TextTheme {
  // 10
  static TextStyle normal10({
    Color color = AppColor.textDark,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
  }) => GoogleFonts.beVietnamPro(
    color: color,
    fontSize: 10.sp,
    fontWeight: fontWeight,
    height: height,
  );

  static TextStyle semiBold10({
    Color color = AppColor.textDark,
    double? height,
  }) => normal10(fontWeight: FontWeight.w500, color: color, height: height);

  static TextStyle bold10({Color color = AppColor.textDark, double? height}) =>
      normal10(fontWeight: FontWeight.w700, color: color, height: height);

  // 12
  static TextStyle normal12({
    Color color = AppColor.textDark,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
  }) => GoogleFonts.beVietnamPro(
    color: color,
    fontSize: 12.sp,
    fontWeight: fontWeight,
    height: height,
  );

  static TextStyle semiBold12({
    Color color = AppColor.textDark,
    double? height,
  }) => normal12(fontWeight: FontWeight.w500, color: color, height: height);

  static TextStyle bold12({Color color = AppColor.textDark, double? height}) =>
      normal12(fontWeight: FontWeight.w700, color: color, height: height);

  // 14
  static TextStyle normal14({
    Color color = AppColor.textDark,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
  }) => GoogleFonts.beVietnamPro(
    color: color,
    fontSize: 14.sp,
    fontWeight: fontWeight,
    height: height,
  );

  static TextStyle semiBold14({
    Color color = AppColor.textDark,
    double? height,
  }) => normal14(fontWeight: FontWeight.w500, color: color, height: height);

  static TextStyle bold14({Color color = AppColor.textDark, double? height}) =>
      normal14(fontWeight: FontWeight.w700, color: color, height: height);

  // 16
  static TextStyle normal16({
    Color color = AppColor.textDark,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
  }) => GoogleFonts.beVietnamPro(
    color: color,
    fontSize: 16.sp,
    fontWeight: fontWeight,
    height: height,
  );

  static TextStyle semiBold16({
    Color color = AppColor.textDark,
    double? height,
  }) => normal16(fontWeight: FontWeight.w500, color: color, height: height);

  static TextStyle bold16({Color color = AppColor.textDark, double? height}) =>
      normal16(fontWeight: FontWeight.w700, color: color, height: height);

  // 18
  static TextStyle normal18({
    Color color = AppColor.textDark,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
  }) => GoogleFonts.beVietnamPro(
    color: color,
    fontSize: 18.sp,
    fontWeight: fontWeight,
    height: height,
  );

  static TextStyle semiBold18({
    Color color = AppColor.textDark,
    double? height,
  }) => normal18(fontWeight: FontWeight.w500, color: color, height: height);

  static TextStyle bold18({Color color = AppColor.textDark, double? height}) =>
      normal18(fontWeight: FontWeight.w700, color: color, height: height);

  // 20
  static TextStyle normal20({
    Color color = AppColor.textDark,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
  }) => GoogleFonts.beVietnamPro(
    color: color,
    fontSize: 20.sp,
    fontWeight: fontWeight,
    height: height,
  );

  static TextStyle semiBold20({
    Color color = AppColor.textDark,
    double? height,
  }) => normal20(fontWeight: FontWeight.w500, color: color, height: height);

  static TextStyle bold20({Color color = AppColor.textDark, double? height}) =>
      normal20(fontWeight: FontWeight.w700, color: color, height: height);

  // 22
  static TextStyle normal22({
    Color color = AppColor.textDark,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
  }) => GoogleFonts.beVietnamPro(
    color: color,
    fontSize: 22.sp,
    fontWeight: fontWeight,
    height: height,
  );

  static TextStyle semiBold22({
    Color color = AppColor.textDark,
    double? height,
  }) => normal22(fontWeight: FontWeight.w500, color: color, height: height);

  static TextStyle bold22({Color color = AppColor.textDark, double? height}) =>
      normal22(fontWeight: FontWeight.w700, color: color, height: height);

  // 24
  static TextStyle normal24({
    Color color = AppColor.textDark,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
  }) => GoogleFonts.beVietnamPro(
    color: color,
    fontSize: 24.sp,
    fontWeight: fontWeight,
    height: height,
  );

  static TextStyle semiBold24({
    Color color = AppColor.textDark,
    double? height,
  }) => normal24(fontWeight: FontWeight.w500, color: color, height: height);

  static TextStyle bold24({Color color = AppColor.textDark, double? height}) =>
      normal24(fontWeight: FontWeight.w700, color: color, height: height);
}
