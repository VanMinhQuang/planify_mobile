import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CommonUtils {
  CommonUtils._();

  static Future<void> openFile(File file) async {
    await OpenFile.open(file.path);
  }

  static String formatMonthLabel(BuildContext context, int month) {
    final localeCode = context.locale.languageCode;
    if (localeCode == 'en') {
      const monthsEn = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return monthsEn[month - 1];
    }

    return 'T$month'; // Vietnamese style
  }

  static Future<void> askNotificationPermission() async {
    if (Platform.isAndroid) {
      final isGranted = await Permission.notification.isGranted;
      if (!isGranted) {
        final status = await Permission.notification.request();
        // if (status.isPermanentlyDenied) {
        //   await openAppSettings();
        // }
      }
    } else if (Platform.isIOS) {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // if (settings.authorizationStatus == AuthorizationStatus.denied) {
      //   await openAppSettings();
      // }
    }
  }

  static Future<String> getFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();

      return token ?? '';
    } catch (e) {
      return '';
    }
  }

  static void launchUrl({required String url}) async {
    try {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      print(e.toString());
    }
  }

  static void launchPhone({required String phoneNumber}) {
    try {
      launchUrlString('tel:$phoneNumber');
    } catch (e) {
      print(e.toString());
    }
  }

  static void launchEmail({required String email}) {
    try {
      launchUrlString('mailto:$email');
    } catch (e) {
      print(e.toString());
    }
  }

  static void launchSms({required String phoneNumber}) {
    try {
      launchUrlString('sms:$phoneNumber');
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<DateTime?> showAdaptiveDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final now = DateTime.now();
    final DateTime startDate = firstDate ?? DateTime(now.year - 100);
    final DateTime endDate = lastDate ?? DateTime(now.year + 100);
    final DateTime initDate = _clampDate(
      initialDate ?? now,
      startDate,
      endDate,
    );
    DateTime selectedDate = DateTime(
      initDate.year,
      initDate.month,
      initDate.day,
    );

    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final colors = context.colors;
        return SafeArea(
          child: Container(
            height: 460.h,
            margin: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(24.sp),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 12.w, 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Select date',
                          style: context.bold18(color: colors.onSurface),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        icon: Icon(Icons.close, color: colors.onSurface),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SfDateRangePicker(
                    initialSelectedDate: selectedDate,
                    minDate: startDate,
                    maxDate: endDate,
                    selectionMode: DateRangePickerSelectionMode.single,
                    backgroundColor: colors.surface,
                    headerStyle: DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      backgroundColor: colors.surface,
                      textStyle: context.bold16(color: colors.primary),
                    ),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: context.normal14(color: colors.onSurface),
                      todayTextStyle: context.bold14(color: colors.primary),
                      disabledDatesTextStyle: context.normal14(
                        color: colors.onSurfaceVariant.withAlpha(120),
                      ),
                    ),
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                      firstDayOfWeek: 1,
                    ),
                    todayHighlightColor: colors.primary,
                    selectionColor: colors.primary,
                    selectionTextStyle: context.bold14(color: colors.onPrimary),
                    onSelectionChanged: (args) {
                      final value = args.value;
                      if (value is DateTime) {
                        selectedDate = DateTime(
                          value.year,
                          value.month,
                          value.day,
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: FilledButton(
                          onPressed: () =>
                              Navigator.of(sheetContext).pop(selectedDate),
                          child: const Text('Done'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static DateTime _clampDate(DateTime date, DateTime min, DateTime max) {
    if (date.isBefore(min)) {
      return min;
    }
    if (date.isAfter(max)) {
      return max;
    }
    return date;
  }

  static Future<DateTimeRange?> showAdaptiveDateRangePicker({
    required BuildContext context,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final now = DateTime.now();
    final DateTime startDate = firstDate ?? DateTime(now.year - 100);
    final DateTime endDate = lastDate ?? DateTime(now.year + 100);
    final DateTime initStartDate = _dateOnly(
      _clampDate(initialStartDate ?? now, startDate, endDate),
    );
    final DateTime initEndDate = _dateOnly(
      _clampDate(
        initialEndDate ?? initStartDate.add(const Duration(days: 1)),
        startDate,
        endDate,
      ),
    );
    PickerDateRange selectedRange = PickerDateRange(
      initStartDate,
      initEndDate.isBefore(initStartDate) ? initStartDate : initEndDate,
    );

    return showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final colors = context.colors;
        return SafeArea(
          child: Container(
            height: 500.h,
            margin: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(24.sp),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 12.w, 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Select date range',
                          style: context.bold18(color: colors.onSurface),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        icon: Icon(Icons.close, color: colors.onSurface),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SfDateRangePicker(
                    initialSelectedRange: selectedRange,
                    minDate: startDate,
                    maxDate: endDate,
                    selectionMode: DateRangePickerSelectionMode.range,
                    backgroundColor: colors.surface,
                    headerStyle: DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      backgroundColor: colors.surface,
                      textStyle: context.bold16(color: colors.primary),
                    ),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: context.normal14(color: colors.onSurface),
                      todayTextStyle: context.bold14(color: colors.primary),
                      disabledDatesTextStyle: context.normal14(
                        color: colors.onSurfaceVariant.withAlpha(120),
                      ),
                    ),
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                      firstDayOfWeek: 1,
                    ),
                    todayHighlightColor: colors.primary,
                    startRangeSelectionColor: colors.primary,
                    endRangeSelectionColor: colors.primary,
                    rangeSelectionColor: colors.primary.withAlpha(40),
                    selectionTextStyle: context.bold14(color: colors.onPrimary),
                    rangeTextStyle: context.semiBold14(color: colors.onSurface),
                    onSelectionChanged: (args) {
                      final value = args.value;
                      if (value is PickerDateRange) {
                        selectedRange = value;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            final pickedStart = selectedRange.startDate;
                            final pickedEnd =
                                selectedRange.endDate ?? pickedStart;
                            if (pickedStart == null || pickedEnd == null) {
                              Navigator.of(sheetContext).pop();
                              return;
                            }
                            Navigator.of(sheetContext).pop(
                              DateTimeRange(
                                start: _dateOnly(pickedStart),
                                end: _dateOnly(pickedEnd),
                              ),
                            );
                          },
                          child: const Text('Done'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static Future<int?> showAdaptiveYearPicker({
    required BuildContext context,
    int? initialYear,
    int? firstYear,
    int? lastYear,
  }) async {
    final isEnglish = context.locale.languageCode == 'en';
    final now = DateTime.now();
    final int initYear = initialYear ?? now.year;
    final int startYear = firstYear ?? now.year - 100;
    final int endYear = lastYear ?? now.year + 100;

    if (Platform.isIOS) {
      int selectedYear = initYear;
      final years = List.generate(
        endYear - startYear + 1,
        (i) => startYear + i,
      );
      final initialIndex = (initYear - startYear).clamp(0, years.length - 1);

      return await showCupertinoModalPopup<int>(
        context: context,
        builder: (popupContext) => Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(12),
                child: TextButton(
                  child: Text("Xong", style: AppTextStyles.bold16()),
                  onPressed: () {
                    Navigator.of(popupContext).pop(selectedYear);
                  },
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: initialIndex,
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    selectedYear = years[index];
                  },
                  children: years
                      .map(
                        (year) => Center(
                          child: Text(
                            year.toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return await showDialog<int>(
        context: context,

        builder: (dialogContext) {
          int selectedYear = initYear;
          return AlertDialog(
            backgroundColor: AppColor.white,
            title: Text(
              isEnglish ? 'Pick year' : 'Chọn năm',
              style: AppTextStyles.bold16(),
            ),
            contentPadding: const EdgeInsets.only(top: 12),
            content: SizedBox(
              width: 300.w,
              height: 300.h,
              child: Theme(
                data: Theme.of(context).copyWith(
                  datePickerTheme: DatePickerThemeData(
                    backgroundColor: AppColor.white,

                    // Selected year background
                    yearBackgroundColor: WidgetStateProperty.resolveWith((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColor.primary;
                      }
                      return Colors.transparent;
                    }),

                    // Selected/unselected text color
                    yearForegroundColor: WidgetStateProperty.resolveWith((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }

                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey;
                      }

                      return Colors.black;
                    }),

                    // Shape of selected item
                    yearShape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                    ),
                    yearOverlayColor: WidgetStateColor.resolveWith((states) {
                      return Colors.transparent;
                    }),

                    todayBackgroundColor: WidgetStateColor.resolveWith((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColor.primary;
                      }
                      return Colors.transparent;
                    }),

                    // Border for current year
                    todayBorder: BorderSide(
                      color: AppColor.primary,
                      width: 1.5,
                    ),

                    // Current year text color
                    todayForegroundColor: WidgetStateColor.resolveWith((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return AppColor.primary;
                    }),
                  ),
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return YearPicker(
                      firstDate: DateTime(startYear),
                      lastDate: DateTime(endYear),
                      selectedDate: DateTime(selectedYear),
                      onChanged: (DateTime date) {
                        setState(() => selectedYear = date.year);

                        Navigator.of(dialogContext).pop(selectedYear);
                      },
                    );
                  },
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'Hủy',
                  style: AppTextStyles.semiBold14(color: AppColor.primary),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
