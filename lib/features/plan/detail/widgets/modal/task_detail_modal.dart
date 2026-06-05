import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:planify_mobile/domain/models/plan_task.dart';
import 'package:planify_mobile/domain/models/requests/update_task_request.dart';
import 'package:planify_mobile/features/plan/detail/bloc/plan_detail_cubit.dart';

class TaskDetailSheet extends StatefulWidget {
  const TaskDetailSheet({super.key, required this.task});

  final PlanTask task;

  @override
  State<TaskDetailSheet> createState() => _TaskDetailSheetState();
}

class _TaskDetailSheetState extends State<TaskDetailSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationNameController;
  final _mapController = MapController();
  AppMapController? _appMapController;
  late DateTime _selectedDay;
  late TimeOfDay _time;
  LatLng? _location;
  late bool _isDone;
  bool _isEditing = false;

  PlanTask get task => widget.task;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: task.title);
    _descriptionController = TextEditingController(
      text: task.description ?? '',
    );
    _locationNameController = TextEditingController(
      text: task.locationName ?? '',
    );
    final dueDate = task.dueDate?.toLocal() ?? DateTime.now();
    _selectedDay = DateUtils.dateOnly(dueDate);
    _time = TimeOfDay.fromDateTime(dueDate);
    if (task.locationLat != null && task.locationLng != null) {
      _location = LatLng(task.locationLat!, task.locationLng!);
    }
    _isDone = task.isDone;
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
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        minChildSize: 0.35,
        maxChildSize: 0.94,
        builder: (context, scrollController) {
          return SafeArea(
            child: BlocListener<PlanDetailCubit, PlanDetailState>(
              listenWhen: (previous, current) =>
                  previous.taskStatus == PlanTaskStatus.updating &&
                  previous.activeTaskId == task.id &&
                  current.taskStatus == PlanTaskStatus.success,
              listener: (context, state) {
                Navigator.of(context).pop();
              },
              child: BlocBuilder<PlanDetailCubit, PlanDetailState>(
                buildWhen: (previous, current) =>
                    previous.taskStatus != current.taskStatus ||
                    previous.activeTaskId != current.activeTaskId,
                builder: (context, state) {
                  final isUpdating =
                      state.taskStatus == PlanTaskStatus.updating &&
                      state.activeTaskId == task.id;
                  return Column(
                    children: [
                      _TaskDetailHeader(
                        title: _isEditing ? 'Edit task' : task.title,
                        isEditing: _isEditing,
                        isUpdating: isUpdating,
                        onEdit: () => setState(() => _isEditing = true),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                          child: _isEditing
                              ? _EditContent(
                                  isUpdating: isUpdating,
                                  titleController: _titleController,
                                  descriptionController: _descriptionController,
                                  locationNameController:
                                      _locationNameController,
                                  mapController: _mapController,
                                  location: _location,
                                  selectedDay: _selectedDay,
                                  time: _time,
                                  isDone: _isDone,
                                  onDoneChanged: (value) =>
                                      setState(() => _isDone = value),
                                  onMapReady: (controller) {
                                    _appMapController = controller;
                                  },
                                  onMapTap: (latLng) {
                                    setState(() => _location = latLng);
                                    _appMapController?.animatedMove(latLng, 15);
                                  },
                                  onPickDate: () => _pickDate(context),
                                  onPickTime: _pickTime,
                                  onCancel: isUpdating
                                      ? null
                                      : () =>
                                            setState(() => _isEditing = false),
                                  onSave: isUpdating
                                      ? null
                                      : () => _save(context),
                                )
                              : _ViewContent(
                                  task: task,
                                  isUpdating: isUpdating,
                                ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(_selectedDay.year - 5),
      lastDate: DateTime(_selectedDay.year + 5),
    );
    if (date != null) {
      setState(() => _selectedDay = DateUtils.dateOnly(date));
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  void _save(BuildContext context) {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task title is required')));
      return;
    }

    context.read<PlanDetailCubit>().updateTask(
      task,
      UpdateTaskRequest(
        title: title,
        description: _descriptionController.text,
        locationName: _locationNameController.text,
        locationLat: _location?.latitude,
        locationLng: _location?.longitude,
        isDone: _isDone,
        assignedTo: task.assignedTo,
        dueDate: DateTime(
          _selectedDay.year,
          _selectedDay.month,
          _selectedDay.day,
          _time.hour,
          _time.minute,
        ),
      ),
    );
  }
}

class _TaskDetailHeader extends StatelessWidget {
  const _TaskDetailHeader({
    required this.title,
    required this.isEditing,
    required this.isUpdating,
    required this.onEdit,
  });

  final String title;
  final bool isEditing;
  final bool isUpdating;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(color: colorScheme.surface),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 12, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: .42),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (!isEditing)
                  IconButton(
                    tooltip: 'Edit task',
                    onPressed: isUpdating ? null : onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: isUpdating ? null : Navigator.of(context).pop,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewContent extends StatelessWidget {
  const _ViewContent({required this.task, required this.isUpdating});

  final PlanTask task;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dueDate = task.dueDate?.toLocal();
    final currentLocation = LatLng(
      task.locationLat ?? 0.0,
      task.locationLng ?? 0.0,
    );
    final isDisplayLocation =
        currentLocation.latitude != 0.0 && currentLocation.longitude != 0.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _DetailChip(
              icon: Icons.schedule,
              label: dueDate == null
                  ? 'Anytime'
                  : DateFormat('MMM d, h:mm a').format(dueDate),
            ),
            _DetailChip(
              icon: task.isDone
                  ? Icons.check_circle_outline
                  : Icons.radio_button_unchecked,
              label: task.isDone ? 'Completed' : 'Planned',
            ),
          ],
        ),
        if (task.hasLocation()) ...[
          const SizedBox(height: 18),
          Text(
            'Location',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          if (task.hasText(task.locationName))
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.place_outlined, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(task.locationName ?? '')),
                ],
              ),
            ),

          if (isDisplayLocation)
            SizedBox(
              height: 200.h,
              width: double.infinity,
              child: AppMap(
                initialCenter: currentLocation,
                initialZoom: 18,
                interactive: false,
                currentLocation: currentLocation,
                showCurrentLocation: true,
                openInMapsText: LocaleKeys.open_in_maps.tr(),
                openInMaps: () {
                  final lat = currentLocation.latitude;
                  final lng = currentLocation.longitude;
                  CommonUtils.launchUrl(
                    url:
                        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
                  );
                },
              ),
            ),
        ],
        if (task.hasText(task.description)) ...[
          const SizedBox(height: 18),
          Text(
            'Description',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(task.description!.trim()),
        ],
        const SizedBox(height: 22),
        FilledButton.icon(
          onPressed: isUpdating
              ? null
              : () => context.read<PlanDetailCubit>().toggleTask(task),
          icon: isUpdating
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(task.isDone ? Icons.undo : Icons.check),
          label: Text(
            isUpdating
                ? 'Saving...'
                : task.isDone
                ? 'Mark planned'
                : 'Mark complete',
          ),
        ),
      ],
    );
  }
}

class _EditContent extends StatelessWidget {
  const _EditContent({
    required this.isUpdating,
    required this.titleController,
    required this.descriptionController,
    required this.locationNameController,
    required this.mapController,
    required this.location,
    required this.selectedDay,
    required this.time,
    required this.isDone,
    required this.onDoneChanged,
    required this.onMapReady,
    required this.onMapTap,
    required this.onPickDate,
    required this.onPickTime,
    required this.onCancel,
    required this.onSave,
  });

  final bool isUpdating;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController locationNameController;
  final MapController mapController;
  final LatLng? location;
  final DateTime selectedDay;
  final TimeOfDay time;
  final bool isDone;
  final ValueChanged<bool> onDoneChanged;
  final ValueChanged<AppMapController> onMapReady;
  final ValueChanged<LatLng> onMapTap;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final VoidCallback? onCancel;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormFieldComponent(
          controller: titleController,
          isReadOnly: isUpdating,
          labelText: 'Title',
          placeholder: 'e.g., Buy tickets',
        ),
        const SizedBox(height: 12),
        TextFormFieldComponent(
          controller: descriptionController,
          isReadOnly: isUpdating,
          minLine: 2,
          maxLine: 4,
          labelText: 'Description',
          placeholder: 'Tickets, notes, what to see...',
        ),
        const SizedBox(height: 12),
        TextFormFieldComponent(
          controller: locationNameController,
          isReadOnly: isUpdating,
          labelText: 'Location name',
          placeholder: 'Restaurant, landmark, hotel...',
          prefixIcon: Icon(Icons.place_outlined),
        ),
        const SizedBox(height: 12),
        IgnorePointer(
          ignoring: isUpdating,
          child: SizedBox(
            height: 200.h,
            width: double.infinity,
            child: AppMap(
              controller: mapController,
              initialCenter: location,
              showCurrentLocation: true,
              showZoomControls: true,
              onMapReady: onMapReady,
              markers: location == null
                  ? []
                  : [
                      MapMarkerModel(
                        id: 'selected',
                        latLng: location!,
                        type: MarkerType.pin,
                      ),
                    ],
              onMapTap: (_, latLng) => onMapTap(latLng),
            ),
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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: isUpdating ? null : onPickDate,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          DateFormat('MMM d, yyyy').format(selectedDay),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: isUpdating ? null : onPickTime,
              icon: const Icon(Icons.schedule),
              label: Text(time.format(context)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          value: isDone,
          onChanged: isUpdating ? null : onDoneChanged,
          title: const Text('Completed'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCancel,
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: onSave,
                icon: isUpdating
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(isUpdating ? 'Saving...' : 'Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}
