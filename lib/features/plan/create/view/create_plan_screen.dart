import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:planify_mobile/app/router.dart';
import 'package:planify_mobile/domain/enum/create_plan_enum.dart';
import 'package:planify_mobile/domain/models/plan.dart';
import 'package:planify_mobile/features/plan/create/cubit/create_plan_cubit.dart';

class CreatePlanScreen extends StatefulWidget {
  const CreatePlanScreen({super.key});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePlanCubit, CreatePlanState>(
      listener: (context, state) {
        if (state.status.isSuccess && state.createdPlan != null) {
          context.go(Routes.planDetailPath(state.createdPlan!.id));
        }
        if (state.status.isFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMsg)));
        }
      },
      builder: (context, state) {
        final bloc = context.read<CreatePlanCubit>();
        return AppContainer(
          appBarTitle: 'Create your plan',
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormFieldComponent(
                  titleText: 'Title',
                  placeholder: 'Enter plan title',
                  isRequired: true,
                  onChanged: (value) =>
                      bloc.updateField(CreatePlanField.title, value),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormFieldComponent(
                  titleText: 'Overview',
                  placeholder: 'Enter plan overview',
                  isRequired: true,
                  minLine: 3,
                  maxLine: 5,
                  onChanged: (value) =>
                      bloc.updateField(CreatePlanField.description, value),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Required' : null,
                ),

                const SizedBox(height: 12),
                TextFormFieldComponent(
                  key: ValueKey(state.plan.category),
                  titleText: 'Category',
                  initialValue: _titleCase(state.plan.category.name),
                  placeholder: 'Select plan category',
                  isRequired: true,
                  isDropDown: true,
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'Required' : null,
                  onTap: () async {
                    final result = await SheetUtils.openBottomSheet(
                      context: context,
                      items: PlanCategory.values,
                      labelBuilder: (item) => _titleCase(item.name),
                      title: 'Select category',
                    );
                    if (result != null) {
                      bloc.updateField(CreatePlanField.category, result);
                    }
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormFieldComponent(
                        key: ValueKey('start-${state.plan.startDate}'),
                        initialValue: state.plan.startDate?.toDDMMYYYY(),
                        titleText: 'Start',
                        placeholder: 'Select start',
                        isRequired: true,
                        isDateBox: true,
                        validator: (_) =>
                            state.plan.startDate == null ? 'Required' : null,
                        onTap: () => _pickDateRange(context, state, bloc),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormFieldComponent(
                        key: ValueKey('end-${state.plan.endDate}'),
                        initialValue: state.plan.endDate?.toDDMMYYYY(),
                        titleText: 'End',
                        placeholder: 'Select end',
                        isRequired: true,
                        isDateBox: true,
                        validator: (_) =>
                            state.plan.endDate == null ? 'Required' : null,
                        onTap: () => _pickDateRange(context, state, bloc),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormFieldComponent(
                  key: ValueKey(state.plan.visibility),
                  titleText: 'Privacy',
                  initialValue: _titleCase(state.plan.visibility.name),
                  placeholder: 'Select privacy',
                  isDropDown: true,
                  onTap: () async {
                    final result = await SheetUtils.openBottomSheet(
                      context: context,
                      items: PlanVisibility.values,
                      labelBuilder: (item) => _titleCase(item.name),
                      title: 'Select privacy',
                    );
                    if (result != null) {
                      bloc.updateField(CreatePlanField.visibility, result);
                    }
                  },
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: state.plan.isSharedToFeed,
                  onChanged: (value) =>
                      bloc.updateField(CreatePlanField.isSharedToFeed, value),
                  title: const Text('Share to feed'),
                  subtitle: const Text('Visible based on selected privacy'),
                ),
                const SizedBox(height: 16),
                BlocBuilder<CreatePlanCubit, CreatePlanState>(
                  builder: (context, state) {
                    return ImageAddingWidget(
                      items: state.journeyImages,
                      baseUrl: '',
                      onAddImage: () async {
                        final result =
                            await ImagePickerUtil.openBottomSheetMultipleImageFilePicker(
                              context,
                              canPickFile: false,
                              title: 'Select images',
                            );
                        if (result != null && result.isNotEmpty) {
                          bloc.onAddImage(result);
                        }
                      },
                      onRemove: (item) {
                        bloc.removeImage(item);
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                AppButton(
                  isDisabled: state.status.isLoading,
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      bloc.createPlan();
                    }
                  },
                  child: state.status.isLoading
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Save plan',
                          style: context.semiBold16(color: AppColor.white),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _titleCase(String value) {
    return value.isEmpty
        ? value
        : '${value[0].toUpperCase()}${value.substring(1)}';
  }

  Future<void> _pickDateRange(
    BuildContext context,
    CreatePlanState state,
    CreatePlanCubit bloc,
  ) async {
    final result = await CommonUtils.showAdaptiveDateRangePicker(
      context: context,
      initialStartDate: state.plan.startDate,
      initialEndDate: state.plan.endDate,
    );
    if (result != null) {
      bloc
        ..updateField(CreatePlanField.startDate, result.start)
        ..updateField(CreatePlanField.endDate, result.end);
    }
  }
}
