import 'package:flutter/material.dart';
import 'package:wiigold/theme/Colors.dart';

class DynamicDateTime extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final Function(DateTime?)? onDateSelected;
  final bool includeTime;
  final bool isDisabled;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final InputDecoration? inputDecoration;

  const DynamicDateTime({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.onDateSelected,
    this.includeTime = false,
    this.isDisabled = false,
    this.labelStyle,
    this.inputStyle,
    this.inputDecoration,
  });

  @override
  State<DynamicDateTime> createState() => _DynamicDateTimeState();
}

class _DynamicDateTimeState extends State<DynamicDateTime> {
  @override
  void initState() {
    super.initState();

    if (widget.controller.text.isEmpty) {
      final now = DateTime.now();
      widget.controller.text = _formatDateTime(now);
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    if (widget.isDisabled) return;

    DateTime initialPickerDate = DateTime.now();
    try {
      if (widget.controller.text.isNotEmpty) {
        initialPickerDate = DateTime.parse(widget.controller.text);
      }
    } catch (e) {
      initialPickerDate = DateTime.now();
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialPickerDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(1.0),
        ),
        child: child!,
      ),
    );

    if (pickedDate != null) {
      DateTime selectedDateTime = pickedDate;

      if (widget.includeTime) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(selectedDateTime),
        );

        if (pickedTime != null) {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        }
      }

      widget.controller.text = _formatDateTime(selectedDateTime);

      widget.onDateSelected?.call(selectedDateTime);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    String datePart =
        "${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    if (widget.includeTime) {
      String timePart =
          "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      return "$datePart $timePart";
    } else {
      return datePart;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            widget.label,
            style:
                widget.labelStyle ??
                textTheme.titleSmall?.copyWith(
                  color: AppColors.dark2,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          style: widget.inputStyle ?? textTheme.titleMedium,
          readOnly: true,
          onTap: () => _selectDateTime(context),
          decoration: _buildInputDecoration(context, textTheme),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(
    BuildContext context,
    TextTheme textTheme,
  ) {
    return widget.inputDecoration ??
        InputDecoration(
          hintText: widget.hint ?? '',
          hintStyle: textTheme.bodyLarge?.copyWith(color: AppColors.dark2),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 10.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.dark3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.dark3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.failure),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.failure, width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.dark2),
          ),
          errorStyle: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.failure,
          ),
        );
  }
}
