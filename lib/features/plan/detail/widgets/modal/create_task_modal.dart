import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:planify_mobile/domain/models/requests/create_task_request.dart';
import 'package:planify_mobile/features/plan/detail/bloc/plan_detail_cubit.dart';

class CreateTaskSheet extends StatefulWidget {
  const CreateTaskSheet({super.key, required this.selectedDay});

  final DateTime selectedDay;

  @override
  State<CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends State<CreateTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationNameController = TextEditingController();
  final _mapController = MapController();
  AppMapController? _appMapController;
  LatLng? _location;
  var _time = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationNameController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: BlocListener<PlanDetailCubit, PlanDetailState>(
        listenWhen: (previous, current) =>
            previous.taskStatus == PlanTaskStatus.adding &&
            current.taskStatus == PlanTaskStatus.success,
        listener: (context, state) {
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 18, 20, bottomInset + 20),
          child: BlocBuilder<PlanDetailCubit, PlanDetailState>(
            buildWhen: (previous, current) =>
                previous.taskStatus != current.taskStatus,
            builder: (context, state) {
              final isAdding = state.taskStatus == PlanTaskStatus.adding;
              final isDisable =
                  isAdding || _titleController.text.trim().isEmpty;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ModalHeaderComponent(title: 'Add task'),
                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(height: 12),
                        TextFormFieldComponent(
                          controller: _titleController,
                          labelText: 'Title',
                          placeholder: 'e.g., Buy tickets',
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 12),
                        TextFormFieldComponent(
                          controller: _descriptionController,
                          minLine: 2,
                          maxLine: 4,
                          labelText: 'Description',
                          placeholder: 'Tickets, notes, what to see...',
                        ),
                        const SizedBox(height: 12),
                        TextFormFieldComponent(
                          controller: _locationNameController,
                          labelText: 'Location name',
                          placeholder: 'Restaurant, landmark, hotel...',
                          prefixIcon: Icon(Icons.place_outlined),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 200.h,
                          width: double.infinity,
                          child: AppMap(
                            controller: _mapController,
                            initialCenter: _location,
                            showCurrentLocation: true,
                            showZoomControls: true,
                            onMapReady: (controller) {
                              _appMapController = controller;
                            },
                            markers: _location == null
                                ? []
                                : [
                                    MapMarkerModel(
                                      id: 'selected',
                                      latLng: LatLng(
                                        _location?.latitude ?? 0,
                                        _location?.longitude ?? 0,
                                      ),
                                      type: MarkerType.pin,
                                    ),
                                  ],
                            onMapTap: (tapPos, latLng) {
                              setState(() {
                                _location = latLng;
                              });
                              _appMapController?.animatedMove(latLng, 15);
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.touch_app_outlined,
                              size: 16,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Tap the map to set this task location',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: colorScheme.outlineVariant,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        DateFormat(
                                          'MMM d, yyyy',
                                        ).format(widget.selectedDay),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton.icon(
                              onPressed: isAdding ? null : _pickTime,
                              icon: const Icon(Icons.schedule),
                              label: Text(_time.format(context)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        AppButton(
                          isDisabled: isDisable,
                          onTap: isDisable ? null : () => _save(context),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            spacing: 10.w,
                            children: [
                              isAdding
                                  ? const SizedBox.square(
                                      dimension: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      LucideIcons.plus600,
                                      color: isDisable
                                          ? Colors.grey
                                          : Colors.white,
                                    ),
                              Text(
                                isAdding ? 'Adding...' : 'Add to day',
                                style: context.bold14(
                                  color: isDisable ? Colors.grey : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  void _save(BuildContext context) {
    final dueDate = DateTime(
      widget.selectedDay.year,
      widget.selectedDay.month,
      widget.selectedDay.day,
      _time.hour,
      _time.minute,
    );

    final request = CreateTaskRequest(
      title: _titleController.text,
      description: _descriptionController.text,
      locationName: _locationNameController.text,
      locationLat: _location?.latitude,
      locationLng: _location?.longitude,
      dueDate: dueDate,
    );

    context.read<PlanDetailCubit>().addTask(request);
  }
}
