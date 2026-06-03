import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:wiigold/theme/Colors.dart';

class DynamicFilePickerInput extends StatelessWidget {
  final String label;
  final PlatformFile? value;
  final VoidCallback onTap;
  final bool isDisabled;

  const DynamicFilePickerInput({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool hasFile = value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.titleSmall?.copyWith(
            color: AppColors.dark2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: isDisabled ? null : onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.dark3,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasFile ? AppColors.main : AppColors.dark3,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  hasFile ? Icons.insert_drive_file_outlined : Icons.upload_file_outlined,
                  color: hasFile ? AppColors.main : AppColors.dark2,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hasFile ? value!.name : 'Toca para seleccionar archivo',
                    style: textTheme.bodyMedium?.copyWith(
                      color: hasFile ? AppColors.light : AppColors.dark2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasFile)
                  Icon(Icons.check_circle_outline, color: AppColors.main, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
