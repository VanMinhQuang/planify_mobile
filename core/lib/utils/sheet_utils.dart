import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SheetUtils {
  static Future<T?> openBottomSheet<T>({
    required BuildContext context,
    required List<T> items,
    required String Function(T) labelBuilder,
    required String title,
    bool canSearch = false,
    String searchPlaceHolder = "Search...",
    double height = 0.6,
  }) async {
    final isAndroid = Platform.isAndroid;

    if (isAndroid) {
      return await showModalBottomSheet<T>(
        context: context,
        clipBehavior: Clip.hardEdge,
        isScrollControlled: true,
        useSafeArea: true,
        constraints: BoxConstraints(
          maxHeight: SizeConfig.height * height,
          minHeight: SizeConfig.height * 0.2,
        ),
        builder: (_) => GenericModal<T>(
          items: items,
          itemLabelBuilder: labelBuilder,
          title: title,
          searchPlaceHolder: searchPlaceHolder,
          canSearch: canSearch,
        ),
      );
    } else {
      return await showCupertinoSheet<T>(
        context: context,

        builder: (_) => GenericModal<T>(
          items: items,
          itemLabelBuilder: labelBuilder,
          title: title,
          searchPlaceHolder: searchPlaceHolder,
          canSearch: canSearch,
        ),
      );
    }
  }

  static Future<T?> openCustomBottomSheet<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    double height = 0.6,
  }) async {
    final isAndroid = Platform.isAndroid;

    if (isAndroid) {
      return await showModalBottomSheet<T>(
        context: context,
        backgroundColor: AppColor.white,
        clipBehavior: Clip.hardEdge,
        isScrollControlled: true,
        useSafeArea: true,
        constraints: BoxConstraints(
          maxHeight: SizeConfig.height * height,
          minHeight: SizeConfig.height * 0.2,
        ),
        builder: builder,
      );
    } else {
      return await showCupertinoSheet<T>(context: context, builder: builder);
    }
  }
}
