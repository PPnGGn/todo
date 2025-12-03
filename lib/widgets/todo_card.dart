import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/theme/app_theme.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback? onDelete;

  const TodoCard({super.key, required this.todo, this.onDelete});

  String _formatDate(DateTime date) {
    final months = [
      '',
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];
    return '${date.day} ${months[date.month]}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isOverdue =
        DateTime.now().isAfter(todo.date) && todo.status != 'Выполнено';
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final result = await showMenu(
            context: context,
            color: AppTheme.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            position: RelativeRect.fromLTRB(100, 100, 100, 100),
            items: [
              PopupMenuItem(
                value: 'delete',

                child: Row(
                  children: [
                    SvgPicture.asset('assets/svg/trash.svg', width: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Удалить',
                      style: AppTheme.themeData.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
          if (result == 'delete' && onDelete != null) onDelete!();
        },

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svg/flag.svg'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      todo.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SvgPicture.asset('assets/svg/calendar.svg', width: 12),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(todo.date),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Manrope',
                      color: AppTheme.cardTextColor,
                    ),
                  ),
                  const Spacer(),
                  if (isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Просрочена',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.buttonTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
