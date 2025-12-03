import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/provider/add_todo_form_provider.dart';
import 'package:todo/theme/app_theme.dart';

class AddTodoBottomSheet extends ConsumerWidget {
  final void Function(String title, DateTime date) onCreate;

  const AddTodoBottomSheet({super.key, required this.onCreate});

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final currentDate = ref.read(addTodoFormProvider).date;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      ref.read(addTodoFormProvider.notifier).setDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).textTheme.bodyLarge;
    final formState = ref.watch(addTodoFormProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ).add(MediaQuery.of(context).viewInsets),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text('Создание задачи', style: theme?.copyWith(fontSize: 22)),
          const SizedBox(height: 24),

          TextField(
            style: theme,
            onChanged: (value) {
              ref.read(addTodoFormProvider.notifier).setTitle(value);
            },
            decoration: InputDecoration(
              labelText: 'Задача',
              labelStyle: theme?.copyWith(fontWeight: FontWeight.w400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: formState.title.trim().isNotEmpty
                      ? AppTheme.primaryColor
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: () => _selectDate(context, ref),
            child: AbsorbPointer(
              child: TextField(
                style: theme,
                decoration: InputDecoration(
                  labelText: 'Дата завершения',
                  labelStyle: theme?.copyWith(fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: formState.date != null
                          ? AppTheme.primaryColor
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset('assets/svg/calendar.svg'),
                  ),
                ),
                controller: TextEditingController(
                  text: formState.date != null
                      ? '${formState.date!.day}.${formState.date!.month}.${formState.date!.year}'
                      : '',
                ),
                readOnly: true,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: AppTheme.cancelButtonStyle,
                  onPressed: () {
                    ref.read(addTodoFormProvider.notifier).reset();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Отменить'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: formState.isValid
                      ? AppTheme.primaryButtonStyle
                      : AppTheme.primaryButtonStyle.copyWith(
                          backgroundColor: WidgetStateProperty.all(
                            AppTheme.primaryColor.withValues(alpha: 0.4),
                          ),
                          foregroundColor: WidgetStateProperty.all(
                            AppTheme.buttonTextColor,
                          ),
                        ),
                  onPressed: formState.isValid
                      ? () {
                          onCreate(formState.title.trim(), formState.date!);
                          ref.read(addTodoFormProvider.notifier).reset();
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text('Применить'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
