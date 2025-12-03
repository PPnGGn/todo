import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTodoFormState {
  final String title;
  final DateTime? date;

  AddTodoFormState({this.title = '', this.date});

  bool get isValid => title.trim().isNotEmpty && date != null;

  AddTodoFormState copyWith({String? title, DateTime? date}) {
    return AddTodoFormState(
      title: title ?? this.title,
      date: date ?? this.date,
    );
  }
}

class AddTodoFormNotifier extends Notifier<AddTodoFormState> {
  @override
  AddTodoFormState build() {
    return AddTodoFormState(date: DateTime.now());
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setDate(DateTime? date) {
    state = state.copyWith(date: date);
  }

  void reset() {
    state = AddTodoFormState(date: DateTime.now());
  }
}

final addTodoFormProvider =
    NotifierProvider.autoDispose<AddTodoFormNotifier, AddTodoFormState>(
      AddTodoFormNotifier.new,
    );
