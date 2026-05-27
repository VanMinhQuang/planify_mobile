import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';

import 'cubit/image_action_cubit.dart';

class ImageActionModal extends StatelessWidget {
  final String title;
  final bool canPickFile;
  final bool canMultipleFile;

  const ImageActionModal({
    super.key,
    this.title = '',
    this.canPickFile = false,
    this.canMultipleFile = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ImageActionCubit, ImageActionState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ImageActionStatus.success:
            Navigator.pop(context, state.files);
            break;
          case ImageActionStatus.error:
            AppWarningDialog.show(context: context, message: state.errorMsg);
            break;
          default:
            break;
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ModalHeaderComponent(title: title),
              Separator.divider(),
              ListTile(
                onTap: () async {
                  final hasPermission =
                      await ImagePickerUtil.requestCameraPermission();
                  if (!hasPermission) {
                    if (context.mounted) {
                      AppWarningDialog.show(
                        context: context,
                        message: LocaleKeys.permission_gallery_required.tr(),
                      );
                    }
                  }
                  Navigator.pop(context, 'camera');
                },
                title: Text('Chụp hình', style: AppTextStyles.normal14()),
                leading: Icon(LucideIcons.camera),
              ),
              Separator.divider(),
              ListTile(
                onTap: () async {
                  Navigator.pop(context, 'gallery');
                },
                title: Text(
                  'Chọn từ thư viện',
                  style: AppTextStyles.normal14(),
                ),
                leading: Icon(LucideIcons.imagePlus),
              ),

              if (canPickFile) ...[
                Separator.divider(),
                ListTile(
                  onTap: () async {
                    Navigator.pop(context, 'file');
                  },
                  title: Text('Chọn từ file', style: AppTextStyles.normal14()),
                  leading: Icon(LucideIcons.filePlus),
                ),
              ],
              Separator.spacer(40.h),
            ],
          ),
        ),
      ),
    );
  }
}
