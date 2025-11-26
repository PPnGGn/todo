import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../data/todo_local_data_source.dart';

class TodoNotifier extends Notifier<List<Todo>> {
  late final TodoLocalDataSource _dataSource;

  @override
  List<Todo> build() {
    _dataSource = TodoLocalDataSource();
    _load();
    return [];
  }

  Future<void> _load() async {
    final todos = await _dataSource.loadTodos();
    state = todos;
  }

  Future<void> addTodo(Todo todo) async {
    state = [...state, todo];
    await _dataSource.saveTodos(state);
  }

  Future<void> removeTodo(String id) async {
    state = state.where((t) => t.id != id).toList();
    await _dataSource.saveTodos(state);
  }

  Future<void> updateTodo(Todo updated) async {
    state = [
      for (final t in state)
        if (t.id == updated.id) updated else t,
    ];
    await _dataSource.saveTodos(state);
  }
}

final todoProvider = NotifierProvider<TodoNotifier, List<Todo>>(
  TodoNotifier.new,
);