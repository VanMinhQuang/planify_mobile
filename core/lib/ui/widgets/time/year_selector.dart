import 'package:app_core/app_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YearSelector extends StatelessWidget {
  final int value;
  final Function(int year) onChanged;
  const YearSelector({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await CommonUtils.showAdaptiveYearPicker(
          context: context,
          initialYear: value,
        );
        if (result != null) {
          onChanged(result);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.hint),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(value.toString(), style: AppTextStyles.normal12()),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class IosYearPickerSheet extends StatefulWidget {
  final int initialYear;
  final int firstYear;
  final int lastYear;

  const IosYearPickerSheet({
    super.key,
    required this.initialYear,
    required this.firstYear,
    required this.lastYear,
  });

  @override
  State<IosYearPickerSheet> createState() => _IosYearPickerSheetState();
}

class _IosYearPickerSheetState extends State<IosYearPickerSheet> {
  late int _selectedYear;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear;
    final initialIndex = widget.initialYear - widget.firstYear;
    _scrollController = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final years = List.generate(
      widget.lastYear - widget.firstYear + 1,
      (i) => widget.firstYear + i,
    );

    return Container(
      height: 300,
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: Column(
        children: [
          // Toolbar
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: CupertinoColors.systemBackground.resolveFrom(context),
              border: Border(
                bottom: BorderSide(
                  color: CupertinoColors.separator.resolveFrom(context),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  onPressed: () => Navigator.of(context).pop(_selectedYear),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // Picker
          Expanded(
            child: CupertinoPicker(
              scrollController: _scrollController,
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                _selectedYear = years[index];
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
    );
  }
}
