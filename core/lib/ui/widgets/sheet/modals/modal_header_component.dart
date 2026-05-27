import 'package:app_core/ui/constants/app_color.dart';
import 'package:app_core/ui/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_size.dart';

class ModalHeaderComponent extends StatelessWidget {
  final String title;

  const ModalHeaderComponent({super.key, this.title = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColor.white,
          padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
          child: Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColor.gray500,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          decoration: BoxDecoration(color: AppColor.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8.h,
            children: <Widget>[
              SizedBox.square(dimension: 24.h),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.semiBold16().copyWith(fontSize: 15.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close, color: AppColor.textDark, size: 24.h),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
