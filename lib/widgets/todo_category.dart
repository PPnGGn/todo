import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:todo/widgets/todo_card.dart';

class TodoCategory extends StatefulWidget {
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
  State<TodoCategory> createState() => _TodoCategoryState();
}

class _TodoCategoryState extends State<TodoCategory> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 32;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Белая шапка категории, margin только для нее
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.whiteColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.category,
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
                      widget.todos.length.toString(),
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
                    turns: _expanded ? 0.5 : 0,
                    child: const Icon(Icons.expand_more, size: 24),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Если категория раскрыта — просто список карточек без контейнера
        if (_expanded)
          Column(
            children: widget.todos.map((todo) {
              return Draggable<Todo>(
                data: todo,
                axis: Axis.vertical,
                feedback: SizedBox(
                  width: width,
                  child: Material(
                    elevation: 0,
                    color: Colors.transparent,
                    child: TodoCard(todo: todo),
                  ),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.6,
                  child: SizedBox(
                    width: width,
                    child: TodoCard(todo: todo),
                  ),
                ),
                child: SizedBox(
                  width: width,
                  child: TodoCard(
                    todo: todo,
                    onDelete: widget.onDelete != null
                        ? () => widget.onDelete!(todo)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
