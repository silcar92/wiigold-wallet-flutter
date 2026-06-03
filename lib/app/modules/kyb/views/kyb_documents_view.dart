import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/modules/kyb/controllers/kyb_controller.dart';
import 'package:wiigold/theme/Colors.dart';

class KybDocumentsView extends GetView<KybController> {
  const KybDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      appBar: DynamicAppBar(
        showLogo: false,
        showAutoBackButton: false,
        title: const Text('Documentos de la empresa'),
      ),
      isContentCentered: false,
      body: const _DocumentsBody(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: Builder(
          builder: (context) => DynamicButton(
            width: double.infinity,
            onPressed: controller.submitForReview,
            child: Text(
              'Enviar para revisión',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.light,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DocumentsBody extends StatefulWidget {
  const _DocumentsBody();

  @override
  State<_DocumentsBody> createState() => _DocumentsBodyState();
}

class _DocumentsBodyState extends State<_DocumentsBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<KybController>().loadDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.find<KybController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Text('Documentos requeridos', style: textTheme.displayLarge),
        Text(
          'Sube los 6 documentos en formato PDF, JPG o PNG.',
          style: textTheme.bodyMedium?.copyWith(color: AppColors.dark2),
        ),
        Obx(
          () => Column(
            spacing: 12,
            children: KybController.requiredDocTypes.map((docType) {
              final label = KybController.docTypeLabels[docType] ?? docType;
              final isUploaded = controller.isDocUploaded(docType);
              final docId = controller.getDocId(docType);

              return _DocRow(
                label: label,
                isUploaded: isUploaded,
                onUpload: () => controller.uploadDocument(docType),
                onDelete: docId != null
                    ? () => controller.deleteDocument(docId)
                    : null,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _DocRow extends StatelessWidget {
  final String label;
  final bool isUploaded;
  final VoidCallback onUpload;
  final VoidCallback? onDelete;

  const _DocRow({
    required this.label,
    required this.isUploaded,
    required this.onUpload,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.dark3,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUploaded ? AppColors.main : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isUploaded
                ? Icons.check_circle_outline
                : Icons.upload_file_outlined,
            color: isUploaded ? AppColors.main : AppColors.dark2,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: isUploaded ? AppColors.light : AppColors.dark2,
              ),
            ),
          ),
          if (isUploaded && onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.failure, size: 20),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            )
          else
            GestureDetector(
              onTap: onUpload,
              child: Text(
                'Subir',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.main,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
