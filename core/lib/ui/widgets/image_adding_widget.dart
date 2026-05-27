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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.hint.withOpacity(0.2)),
        color: AppColor.white,
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
                  color: AppColor.hint,
                ),
                Text(
                  title,
                  style: AppTextStyles.semiBold14(color: AppColor.hint),
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
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsetsGeometry.symmetric(
              horizontal: 8.w,
              vertical: 8.h,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              if (index == items.length) {
                return AppButton(
                  onTap: onAddImage,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4.w,
                    children: [
                      Icon(LucideIcons.imagePlus, color: AppColor.white),
                      Text(
                        LocaleKeys.add_data.tr(),
                        style: AppTextStyles.bold14(color: AppColor.white),
                      ),
                    ],
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
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.withOpacity(0.08),
                    border: Border.all(color: AppColor.hint.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      /// PREVIEW
                      item.isImage
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: item.isLocal
                                  ? Image.file(
                                      File(item.path),
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      baseUrl + item.path,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                    ),
                            )
                          : const Icon(Icons.insert_drive_file, size: 36),

                      const SizedBox(width: 10),

                      /// FILE NAME
                      Expanded(
                        child: Text(
                          item.path.split('/').last,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: AppTextStyles.normal12(),
                        ),
                      ),

                      /// REMOVE
                      if (onRemove != null)
                        GestureDetector(
                          onTap: () => onRemove!(item),
                          child: const Icon(Icons.close, size: 18),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
