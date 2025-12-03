import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoCategoryState {
  final bool isExpanded;
  final bool isDragOver;

  TodoCategoryState({this.isExpanded = true, this.isDragOver = false});

  TodoCategoryState copyWith({bool? isExpanded, bool? isDragOver}) {
    return TodoCategoryState(
      isExpanded: isExpanded ?? this.isExpanded,
      isDragOver: isDragOver ?? this.isDragOver,
    );
  }
}

class TodoCategoryNotifier extends Notifier<TodoCategoryState> {
  TodoCategoryNotifier(this.category);

  final String category;

  @override
  TodoCategoryState build() {
    return TodoCategoryState();
  }

  void toggleExpanded() {
    state = state.copyWith(isExpanded: !state.isExpanded);
  }

  void setDragOver(bool isDragOver) {
    state = state.copyWith(isDragOver: isDragOver);
  }
}

final todoCategoryProvider =
    NotifierProvider.family<TodoCategoryNotifier, TodoCategoryState, String>(
      TodoCategoryNotifier.new,
    );
