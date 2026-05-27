import 'dart:async';
import 'package:flutter/material.dart';
import 'text_field_component.dart';

class AppDropdownSearch<T> extends StatefulWidget {
  final String hintText;
  final List<T> items;
  final String Function(T) itemAsString;
  final void Function(String query) onQueryChanged;
  final void Function(T)? onSelected;
  final String title;
  final bool loading;

  const AppDropdownSearch({
    super.key,
    required this.hintText,
    required this.items,
    required this.itemAsString,
    required this.onQueryChanged,
    this.onSelected,
    this.title = '',
    this.loading = false,
  });

  @override
  State<AppDropdownSearch<T>> createState() => _AppDropdownSearchState<T>();
}

class _AppDropdownSearchState<T> extends State<AppDropdownSearch<T>> {
  final controller = TextEditingController();
  final layerLink = LayerLink();

  OverlayEntry? overlay;
  Timer? debounce;

  List<T> localResults = [];

  void onChanged(String value) {
    debounce?.cancel();

    debounce = Timer(const Duration(milliseconds: 300), () {
      if (value.trim().isEmpty) {
        hideOverlay();
        return;
      }

      widget.onQueryChanged(value);
      showOverlay();
    });
  }

  void showOverlay() {
    hideOverlay();

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    overlay = OverlayEntry(
      builder: (context) {
        final data = widget.items;

        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 55),
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: widget.loading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : data.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("No results"),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: data.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = data[index];
                          final text = widget.itemAsString(item);

                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.search, size: 18),
                            title: Text(text),
                            onTap: () {
                              controller.text = text;
                              hideOverlay();
                              widget.onSelected?.call(item);
                            },
                          );
                        },
                      ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(overlay!);
  }

  void hideOverlay() {
    overlay?.remove();
    overlay = null;
  }

  @override
  void dispose() {
    controller.dispose();
    debounce?.cancel();
    hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: TextFormFieldComponent(
        controller: controller,
        titleText: widget.title,
        placeholder: widget.hintText,
        onChanged: onChanged,
        suffixIcon: widget.loading
            ? const Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : null,
      ),
    );
  }
}
