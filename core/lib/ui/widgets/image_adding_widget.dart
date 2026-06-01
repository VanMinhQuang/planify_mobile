import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

class ImageAddingWidget extends StatelessWidget {
  final List<AttachmentItem> items;
  final VoidCallback? onAddImage;
  final VoidCallback? onAddFile;
  final void Function(AttachmentItem item)? onRemove;
  final String title;
  final String? subTitle;
  final IconData? iconData;
  final String baseUrl;

  const ImageAddingWidget({
    super.key,
    required this.items,
    this.onAddImage,
    this.onAddFile,
    this.onRemove,
    this.title = 'Hình ảnh',
    this.subTitle,
    this.iconData,
    required this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.hint.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4.w,
              children: [
                Icon(
                  iconData ?? LucideIcons.imagePlus,
                  size: 18.sp,
                  color: colors.primary,
                ),
                Text(
                  title,
                  style: AppTextStyles.semiBold14(color: colors.onSurface),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 4.h),
            child: Separator.divider(
              color: AppColor.hint.withValues(alpha: 0.4),
            ),
          ),

          if (subTitle != null)
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8,
                bottom: 8,
                top: 4,
              ),
              child: Text(
                subTitle!,
                style: AppTextStyles.normal12(color: AppColor.hint),
              ),
            ),

          /// LIST
          /// GRID
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              if (index == items.length) {
                return InkWell(
                  onTap: onAddImage,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: colors.primary.withOpacity(0.4),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.imagePlus,
                          color: colors.primary,
                          size: 24.sp,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          LocaleKeys.add_data.tr(),
                          style: AppTextStyles.normal12(color: colors.primary),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final item = items[index];

              return InkWell(
                onTap: () {
                  if (item.isLocal) {
                    CommonUtils.openFile(File(item.path));
                  } else {
                    CommonUtils.launchUrl(url: "$baseUrl/${item.path}");
                  }
                },
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.08),
                          border: Border.all(
                            color: AppColor.hint.withOpacity(0.2),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: item.isImage
                              ? item.isLocal
                                    ? Image.file(
                                        File(item.path),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        "$baseUrl/${item.path}",
                                        fit: BoxFit.cover,
                                      )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.insert_drive_file,
                                      size: 32,
                                    ),
                                    SizedBox(height: 4.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                      ),
                                      child: Text(
                                        item.path.split('/').last,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.normal10(),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    if (onRemove != null)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => onRemove!(item),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
