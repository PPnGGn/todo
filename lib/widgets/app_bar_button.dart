import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/provider/todo_provider.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:todo/widgets/add_todo_sheet.dart';

class AppBarButton extends ConsumerWidget {
  const AppBarButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        child: Container(
          height: 48,
          width: 48,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppTheme.primaryColor,
          ),
          child: const Icon(Icons.add, color: AppTheme.whiteColor, size: 24),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            isScrollControlled: true,
            builder: (ctx) => AddTodoBottomSheet(
              onCreate: (title, date) {
                final id = DateTime.now().millisecondsSinceEpoch.toString();
                final todo = Todo(
                  id: id,
                  title: title,
                  date: date,
                  status: 'К выполнению',
                );
                ref.read(todoProvider.notifier).addTodo(todo);
              },
            ),
          );
        },
      ),
    );
  }
}
