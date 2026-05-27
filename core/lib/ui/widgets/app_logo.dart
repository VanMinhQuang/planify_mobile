import 'package:flutter/material.dart';

import '../../app_core.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFFFFC107).withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Assets.logo.logoCongAnVector03Png.image(
              fit: BoxFit.contain,
              width: 40.w,
            ),
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.police_force_title.tr(),
                style: AppTextStyles.bold16(color: AppColor.white),
              ),
              Text(
                    LocaleKeys.police_force_name.tr(),
                    style: AppTextStyles.bold14(color: AppColor.textYellow),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .shimmer(duration: Duration(seconds: 1)),
            ],
          ),
        ),
      ],
    );
  }
}
