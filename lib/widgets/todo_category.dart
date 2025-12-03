// lib/widgets/todo_category.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/provider/todo_category_provider.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:todo/widgets/todo_card.dart';

class TodoCategory extends ConsumerWidget {
  final String category;
  final List<Todo> todos;
  final ValueChanged<Todo>? onDelete;
  final ValueChanged<Todo>? onEdit;

  const TodoCategory({
    super.key,
    required this.category,
    required this.todos,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double width = MediaQuery.of(context).size.width - 32;
    final categoryState = ref.watch(todoCategoryProvider(category));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DragTarget<Todo>(
          onWillAcceptWithDetails: (details) {
            return details.data.status != category;
          },
          onAcceptWithDetails: (details) {
            final updatedTodo = Todo(
              id: details.data.id,
              title: details.data.title,
              date: details.data.date,
              status: category,
            );
            onEdit?.call(updatedTodo);
            ref
                .read(todoCategoryProvider(category).notifier)
                .setDragOver(false);
          },
          onMove: (details) {
            if (!categoryState.isDragOver) {
              ref
                  .read(todoCategoryProvider(category).notifier)
                  .setDragOver(true);
            }
          },
          onLeave: (data) {
            ref
                .read(todoCategoryProvider(category).notifier)
                .setDragOver(false);
          },
          builder: (context, candidateData, rejectedData) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.whiteColor,
                borderRadius: BorderRadius.circular(8),
                border: categoryState.isDragOver || candidateData.isNotEmpty
                    ? Border.all(
                        color: AppTheme.primaryColor.withValues(alpha: 0.5),
                        width: 2,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  ref
                      .read(todoCategoryProvider(category).notifier)
                      .toggleExpanded();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7FA),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 10,
                        ),
                        child: Text(
                          todos.length.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF7E7E7E),
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: categoryState.isExpanded ? 0.5 : 0,
                        child: const Icon(Icons.expand_more, size: 24),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        if (categoryState.isExpanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: todos.isEmpty
                ? SizedBox(
                    height: 80,
                    child: Center(
                      child: Text(
                        'Перетащите сюда задачу',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: todos.map((todo) {
                      return LongPressDraggable<Todo>(
                        data: todo,
                        feedback: SizedBox(
                          width: width,
                          child: Material(
                            elevation: 6,
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.transparent,
                            child: Opacity(
                              opacity: 0.85,
                              child: TodoCard(todo: todo),
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.4,
                          child: TodoCard(todo: todo),
                        ),
                        child: TodoCard(
                          todo: todo,
                          onDelete: onDelete != null
                              ? () => onDelete!(todo)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
          ),
      ],
    );
  }
}
