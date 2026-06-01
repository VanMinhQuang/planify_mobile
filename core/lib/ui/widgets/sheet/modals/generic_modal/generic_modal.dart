import 'package:app_core/app_core.dart';
import 'package:app_core/ui/widgets/sheet/modals/modal_header_component.dart';
import 'package:flutter/material.dart';

import 'cubit/generic_modal_cubit.dart';

class GenericModal<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final bool canSearch;
  final String searchPlaceHolder;
  final String Function(T item) itemLabelBuilder;

  const GenericModal({
    super.key,
    required this.title,
    required this.items,
    this.canSearch = true,
    this.searchPlaceHolder = "Search...",
    required this.itemLabelBuilder,
  });

  @override
  State<GenericModal<T>> createState() => _GenericModalState<T>();
}

class _GenericModalState<T> extends State<GenericModal<T>> {
  final TextEditingController _controller = TextEditingController();

  void _onSearch(String value, BuildContext context) {
    context.read<GenericModalCubit<T>>().filter(value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocProvider<GenericModalCubit<T>>(
      create: (_) {
        final cubit = GenericModalCubit<T>(
          itemLabelBuilder: widget.itemLabelBuilder,
        );
        Future.microtask(() => cubit.init(widget.items));
        return cubit;
      },
      child: Column(
        children: [
          ModalHeaderComponent(title: widget.title),
          Separator.divider(),

          if (widget.canSearch)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              child: TextFormFieldComponent(
                controller: _controller,
                prefixIcon: Icon(Icons.search, color: colors.onSurface),
                showClearButton: true,
                placeholder: widget.searchPlaceHolder,
                onChanged: (value) => _onSearch(value, context),
                onClear: () {
                  _controller.clear();
                  _onSearch('', context);
                },
              ),
            ),

          Expanded(
            child: BlocBuilder<GenericModalCubit<T>, GenericModalState<T>>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = state.filteredItems[index];
                    final isLastItem = index == state.filteredItems.length - 1;

                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            widget.itemLabelBuilder(item),
                            style: AppTextStyles.normal14(
                              color: colors.onSurface,
                            ),
                          ),
                          onTap: () => Navigator.pop(context, item),
                        ),
                        if (!isLastItem) Separator.divider(),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
