import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class ModalHeaderComponent extends StatelessWidget {
  final String title;

  const ModalHeaderComponent({super.key, this.title = ''});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
          child: Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8.h,
            children: <Widget>[
              SizedBox.square(dimension: 24.h),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.semiBold16(
                    color: colors.onSurface,
                  ).copyWith(fontSize: 15.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close, color: colors.onSurface, size: 24.h),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
