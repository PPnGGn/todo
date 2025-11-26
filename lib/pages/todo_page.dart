import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/provider/todo_provider.dart';
import 'package:todo/widgets/app_bar_button.dart';

import 'package:todo/widgets/todo_category.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);

    Map<String, List<Todo>> grouped = {
      'К выполнению': [],
      'В работе': [],
      'На проверке': [],
      'Выполнено': [],
    };
    for (var todo in todos) {
      grouped[todo.status]?.add(todo);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        centerTitle: false,
        titleSpacing: 16,
        actions: [AppBarButton()],
      ),
      body: ListView(
        children: grouped.entries.map((entry) {
          return TodoCategory(
            category: entry.key,
            todos: entry.value,
            onDelete: (todo) {
              ref.read(todoProvider.notifier).removeTodo(todo.id);
            },
            onEdit: (updated) {
              ref.read(todoProvider.notifier).updateTodo(updated);
            },
          );
        }).toList(),
      ),
    );
  }
}
