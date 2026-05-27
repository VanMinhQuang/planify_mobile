import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Option model
// ---------------------------------------------------------------------------

/// Hàm tiện ích: lấy kết quả từ SelectionResult<Object?> và cast về kiểu T

class SelectOption<T> {
  const SelectOption({required this.value, required this.label});

  final T value;
  final String label;
}

// ---------------------------------------------------------------------------
// Section config
// ---------------------------------------------------------------------------

class SelectSectionConfig<T> {
  const SelectSectionConfig({
    required this.key,
    required this.title,
    required this.options,
  });

  final String key;
  final String title;
  final List<SelectOption<T>> options;
}

// ---------------------------------------------------------------------------
// Result model
// ---------------------------------------------------------------------------

class SelectionResult<T> {
  SelectionResult({Map<String, T?>? values}) : values = values ?? {};

  final Map<String, T?> values;

  bool get isEmpty => values.isEmpty || values.values.every((v) => v == null);

  T? section(String key) => values[key];

  SelectionResult<T> copyWithSection(String key, T? value) {
    return SelectionResult<T>(values: {...values, key: value});
  }

  SelectionResult<T> reset() => SelectionResult<T>();
}

extension SelectionResultX on SelectionResult<Object?> {
  V? getAs<V>(String key) {
    final value = section(key);
    return value is V ? value : null;
  }
}
// ---------------------------------------------------------------------------
// Modal
// ---------------------------------------------------------------------------

class SingleSelectionModal<T> extends StatefulWidget {
  SingleSelectionModal({
    super.key,
    required this.sections,
    this.initialSelection,
    this.title,
    this.resetLabel,
    this.cancelLabel,
    this.applyLabel,
  });

  final List<SelectSectionConfig<T>> sections;
  final SelectionResult<T>? initialSelection;
  final String? title;
  final String? resetLabel;
  final String? cancelLabel;
  final String? applyLabel;

  @override
  State<SingleSelectionModal<T>> createState() =>
      _SingleSelectionModalState<T>();
}

class _SingleSelectionModalState<T> extends State<SingleSelectionModal<T>> {
  late SelectionResult<T> _selection;

  @override
  void initState() {
    super.initState();
    _selection = widget.initialSelection ?? SelectionResult();
  }

  void _select(String sectionKey, T value) {
    final current = _selection.section(sectionKey);
    final T? next = current == value ? null : value;
    setState(() => _selection = _selection.copyWithSection(sectionKey, next));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      right: false,
      left: false,
      child: Padding(
        padding: EdgeInsets.only(
          top: 20.h,
          left: 16.w,
          right: 16.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title ?? LocaleKeys.filter.tr(),
                  style: AppTextStyles.bold16(),
                ),
                InkWell(
                  onTap: () => setState(() => _selection = _selection.reset()),
                  child: Text(
                    widget.resetLabel ?? LocaleKeys.reset.tr(),
                    style: AppTextStyles.semiBold12(color: AppColor.blueDark),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Sections
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.sections
                      .map(
                        (section) => Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: SelectSection<T>(
                            title: section.title,
                            options: section.options,
                            selected: _selection.section(section.key),
                            onSelect: (value) => _select(section.key, value),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            SizedBox(height: 8.h),

            // Buttons
            Row(
              spacing: 12.w,
              children: [
                Expanded(
                  child: AppButton(
                    onTap: () => Navigator.pop(context),
                    colorButton: AppColor.transparentGradient,
                    borderColor: AppColor.primary,
                    child: Text(
                      widget.cancelLabel ?? LocaleKeys.cancel.tr(),
                      style: AppTextStyles.semiBold14(color: AppColor.primary),
                    ),
                  ),
                ),
                Expanded(
                  child: AppButton(
                    onTap: () => Navigator.pop(context, _selection),
                    colorButton: AppColor.primaryGradient,

                    child: Text(
                      widget.applyLabel ?? LocaleKeys.apply.tr(),
                      style: AppTextStyles.semiBold14(color: AppColor.white),
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

// ---------------------------------------------------------------------------
// Section widget
// ---------------------------------------------------------------------------

class SelectSection<T> extends StatelessWidget {
  const SelectSection({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final String title;
  final List<SelectOption<T>> options;
  final T? selected;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.semiBold12(color: AppColor.slate500)),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: options.map((option) {
            final isActive = selected == option.value;
            return GestureDetector(
              onTap: () => onSelect(option.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? AppColor.skeletonGradient
                      : AppColor.whiteGradient,
                  borderRadius: BorderRadius.circular(20.sp),
                  border: Border.all(
                    color: isActive ? AppColor.blueDark : AppColor.slate300,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  option.label,
                  style: AppTextStyles.semiBold12(
                    color: isActive ? AppColor.white : AppColor.slate600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Usage examples
// ---------------------------------------------------------------------------

// -- With String values (simple case) ----------------------------------------
//
// enum TrangThai { hoatDong, viPham, tamNgung, chuaDangKy }
//
// static const _boardingSections = [
//   SelectSectionConfig<TrangThai>(
//     key: 'trangThai',
//     title: 'Trạng thái',
//     options: [
//       SelectOption(value: TrangThai.hoatDong, label: 'Hoạt động'),
//       SelectOption(value: TrangThai.viPham,   label: 'Vi phạm'),
//       SelectOption(value: TrangThai.tamNgung, label: 'Tạm ngưng'),
//       SelectOption(value: TrangThai.chuaDangKy, label: 'Chưa đăng ký'),
//     ],
//   ),
//   SelectSectionConfig<bool>(
//     key: 'camera',
//     title: 'Camera',
//     options: [
//       SelectOption(value: true,  label: 'Có camera'),
//       SelectOption(value: false, label: 'Không có camera'),
//     ],
//   ),
// ];
//
// ⚠️  When sections use different value types, use SelectionResult<Object?>
//     and cast when reading:
//
// final result = await SheetUtils.openCustomBottomSheet<SelectionResult<Object?>>(
//   context: context,
//   builder: (_) => SingleSelectionModal<Object?>(sections: _boardingSections),
// );
//
// final trangThai = result?.section('trangThai') as TrangThai?;
// final hasCamera = result?.section('camera') as bool?;

// -- With a single typed enum (cleanest) -------------------------------------
//
// enum KetQuaPCCC { dat, khongDat, chuaKiemTra }
//
// final result = await SheetUtils.openCustomBottomSheet<SelectionResult<KetQuaPCCC>>(
//   context: context,
//   builder: (_) => SingleSelectionModal<KetQuaPCCC>(
//     title: 'Kết quả PCCC',
//     sections: [
//       SelectSectionConfig<KetQuaPCCC>(
//         key: 'ketQua',
//         title: 'Kết quả',
//         options: [
//           SelectOption(value: KetQuaPCCC.dat,           label: 'Đạt'),
//           SelectOption(value: KetQuaPCCC.khongDat,      label: 'Không đạt'),
//           SelectOption(value: KetQuaPCCC.chuaKiemTra,   label: 'Chưa kiểm tra'),
//         ],
//       ),
//     ],
//   ),
// );
//
// final ketQua = result?.section('ketQua'); // KetQuaPCCC?
