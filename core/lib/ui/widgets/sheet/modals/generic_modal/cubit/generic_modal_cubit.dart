import 'package:app_core/app_core.dart';

part 'generic_modal_state.dart';

class GenericModalCubit<T> extends Cubit<GenericModalState<T>> {
  final String Function(T item) itemLabelBuilder;

  GenericModalCubit({required this.itemLabelBuilder})
    : super(GenericModalState());

  void init(List<T> items) {
    emit(state.copyWith(originalItems: items, filteredItems: items));
  }

  void filter(String query) {
    final cleanQuery = query.toNonAccentLowerCase();

    if (cleanQuery.isEmpty) {
      emit(state.copyWith(filteredItems: state.originalItems));
      return;
    }

    final updated = state.originalItems.where((e) {
      final label = itemLabelBuilder(e).toNonAccentLowerCase();
      return label.contains(cleanQuery);
    }).toList();

    emit(state.copyWith(filteredItems: updated));
  }
}
