import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/theme/Colors.dart';

class DynamicImagePickerInput extends StatefulWidget {
  final String? label;
  final ValueNotifier<String?> controller;
  final bool isDisabled;
  final TextStyle? labelStyle;
  final InputSemantics? semanticSettings;
  final double height;
  final double width;
  final Widget? placeholder;
  final BoxDecoration? decoration;

  const DynamicImagePickerInput({
    super.key,
    this.label,
    required this.controller,
    this.isDisabled = false,
    this.labelStyle,
    this.semanticSettings,
    this.height = 150.0,
    this.width = double.infinity,
    this.placeholder,
    this.decoration,
  });

  @override
  State<DynamicImagePickerInput> createState() =>
      _DynamicImagePickerInputState();
}

class _DynamicImagePickerInputState extends State<DynamicImagePickerInput> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (widget.isDisabled) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        final String base64String = base64Encode(imageBytes);

        widget.controller.value = base64String;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar la imagen: ${e.toString()}')),
      );
    }
  }

  Widget _buildImageWidget(String base64String) {
    try {
      final Uint8List imageBytes = base64Decode(base64String);
      return Image.memory(
        imageBytes,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
        semanticLabel: "Imagen cargada. Toca para cambiar.",
      );
    } catch (e) {
      return _buildPlaceholder(
        icon: Icons.error_outline,
        text: "Imagen inválida",
        color: AppColors.failure,
      );
    }
  }

  Widget _buildPlaceholder({
    required IconData icon,
    required String text,
    Color? color,
  }) {
    final placeholderColor = color ?? (AppColors.main);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: placeholderColor),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(color: placeholderColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    Widget pickerBody = ValueListenableBuilder<String?>(
      valueListenable: widget.controller,
      builder: (context, base64Image, child) {
        final bool hasImage = base64Image != null && base64Image.isNotEmpty;

        return GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: widget.height,
            width: widget.width,
            clipBehavior: Clip.antiAlias,
            decoration:
                widget.decoration ??
                BoxDecoration(
                  color: AppColors.dark3,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: AppColors.dark3,
                    style: BorderStyle.solid,
                  ),
                ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasImage)
                  _buildImageWidget(base64Image!)
                else
                  widget.placeholder ??
                      _buildPlaceholder(
                        icon: Icons.add_a_photo_outlined,
                        text: "Tocar para agregar imagen",
                      ),

                if (hasImage && !widget.isDisabled)
                  Container(
                    color: AppColors.main.withAlpha(150),
                    child: const Center(
                      child: Icon(Icons.edit, color: AppColors.light, size: 32),
                    ),
                  ),

                if (widget.isDisabled) Container(color: AppColors.dark),
              ],
            ),
          ),
        );
      },
    );

    if (widget.semanticSettings != null) {
      pickerBody = Semantics(
        identifier: widget.semanticSettings!.identifier,
        label: widget.semanticSettings!.semanticLabel ?? widget.label,
        hint:
            widget.semanticSettings!.hint ??
            "Toca para seleccionar una imagen de la galería",
        button: true,
        enabled: !widget.isDisabled,
        value:
            widget.controller.value != null &&
                widget.controller.value!.isNotEmpty
            ? "Imagen seleccionada"
            : "Sin imagen seleccionada",
        child: pickerBody,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.label!,
              style:
                  widget.labelStyle ??
                  textTheme.titleSmall?.copyWith(
                    color: AppColors.dark2,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        pickerBody,
      ],
    );
  }
}
