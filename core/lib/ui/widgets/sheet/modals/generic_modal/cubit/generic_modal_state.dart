part of 'generic_modal_cubit.dart';

class GenericModalState<T> extends Equatable {
  final List<T> originalItems;
  final List<T> filteredItems;
  final T? selectedItems;

  GenericModalState({
    List<T>? originalItems,
    List<T>? filteredItems,
    this.selectedItems,
  }) : originalItems = originalItems ?? <T>[],
       filteredItems = filteredItems ?? <T>[];

  @override
  List<Object?> get props => [originalItems, filteredItems, selectedItems];

  GenericModalState<T> copyWith({
    List<T>? originalItems,
    List<T>? filteredItems,
    T? selectedItems,
  }) {
    return GenericModalState<T>(
      originalItems: originalItems ?? this.originalItems,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedItems: selectedItems ?? this.selectedItems,
    );
  }
}
