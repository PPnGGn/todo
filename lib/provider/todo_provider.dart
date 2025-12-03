import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/data/todo_local_data_source.dart';
import 'package:todo/models/todo.dart';

class TodoNotifier extends Notifier<List<Todo>> {
  final _dataSource = TodoLocalDataSource();

  @override
  List<Todo> build() {
    _loadTodos();
    return [];
  }

  Future<void> _loadTodos() async {
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
