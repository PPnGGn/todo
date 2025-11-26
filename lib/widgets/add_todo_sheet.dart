import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/theme/app_theme.dart';

class AddTodoBottomSheet extends StatefulWidget {
  final void Function(String title, DateTime date) onCreate;

  const AddTodoBottomSheet({super.key, required this.onCreate});

  @override
  State<AddTodoBottomSheet> createState() => _AddTodoBottomSheetState();
}

class _AddTodoBottomSheetState extends State<AddTodoBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updateButtonState);
    _updateButtonState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled =
          _titleController.text.trim().isNotEmpty && _selectedDate != null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    setState(() {
      _selectedDate = pickedDate;
      _updateButtonState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme.bodyLarge;

    return Container(
      decoration: BoxDecoration(
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
            controller: _titleController,
            style: theme,
            decoration: InputDecoration(
              labelText: 'Задача',
              labelStyle: theme?.copyWith(fontWeight: FontWeight.w400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _titleController.text.trim().isNotEmpty
                      ? AppTheme.primaryColor
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),

          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _selectDate(context),
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
                      color: _selectedDate != null
                          ? AppTheme.primaryColor
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
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
                  text: _selectedDate != null
                      ? '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}'
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отменить'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: _isButtonEnabled
                      ? AppTheme.primaryButtonStyle
                      : AppTheme.primaryButtonStyle.copyWith(
                          backgroundColor: WidgetStateProperty.all(
                            AppTheme.primaryColor.withOpacity(0.4),
                          ),
                          foregroundColor: WidgetStateProperty.all(
                            AppTheme.buttonTextColor,
                          ),
                        ),
                  onPressed: _isButtonEnabled
                      ? () {
                          widget.onCreate(
                            _titleController.text.trim(),
                            _selectedDate!,
                          );
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
