import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_datetime.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_file_picker.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/data/models/entities/locations_model.dart';
import 'package:wiigold/app/modules/kyb/controllers/kyb_controller.dart';
import 'package:wiigold/theme/Colors.dart';

class KybUboFormView extends GetView<KybController> {
  const KybUboFormView({super.key});

  static const _idTypes = [
    DropdownItem(label: 'Cédula de ciudadanía', value: 'national_id'),
    DropdownItem(label: 'Pasaporte', value: 'passport'),
    DropdownItem(label: 'Licencia de conducir', value: 'drivers_license'),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      appBar: DynamicAppBar(
        showLogo: false,
        showAutoBackButton: true,
        backbuttomFunction: () => Get.back(),
        title: const Text('Agregar beneficiario'),
      ),
      isContentCentered: false,
      body: DynamicForm(
        formKey: controller.uboFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Text('Datos del beneficiario final', style: textTheme.displayLarge),
            Text(
              'Persona natural con control directo o indirecto del 25% o más.',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.dark2),
            ),
            DynamicInput(
              label: 'Nombre completo *',
              hint: 'Nombre y apellidos',
              controller: controller.uboFullNameCtrl,
              inputType: TextInputType.name,
              validationPatter: (v) =>
                  v == null || v.trim().isEmpty ? 'Campo requerido' : null,
            ),
            DynamicDateTime(
              label: 'Fecha de nacimiento *',
              hint: 'DD/MM/AAAA',
              controller: controller.uboDateOfBirthCtrl,
            ),
            Obx(
              () => DynamicDropdownInput<String>(
                label: 'Nacionalidad *',
                hint: 'Selecciona un país',
                items: controller.locationController.countries
                    .map((Country c) => DropdownItem(value: '${c.id}', label: c.name))
                    .toList(),
                value: controller.selectedUboNationalityId.value.isEmpty
                    ? null
                    : controller.selectedUboNationalityId.value,
                onChanged: (v) => controller.selectedUboNationalityId.value = v ?? '',
                dropdownSearchInputType: TextInputType.text,
                searchController: controller.uboNationalitySearchCtrl,
                searchable: true,
                searchHint: 'Buscar país...',
              ),
            ),
            Obx(
              () => DynamicDropdownInput<String>(
                label: 'País de residencia *',
                hint: 'Selecciona un país',
                items: controller.locationController.countries
                    .map((Country c) => DropdownItem(value: '${c.id}', label: c.name))
                    .toList(),
                value: controller.selectedUboCountryOfResidenceId.value.isEmpty
                    ? null
                    : controller.selectedUboCountryOfResidenceId.value,
                onChanged: (v) =>
                    controller.selectedUboCountryOfResidenceId.value = v ?? '',
                dropdownSearchInputType: TextInputType.text,
                searchController: controller.uboCountryOfResidenceSearchCtrl,
                searchable: true,
                searchHint: 'Buscar país...',
              ),
            ),
            DynamicInput(
              label: 'Porcentaje de participación *',
              hint: 'Ej. 25',
              controller: controller.uboOwnershipCtrl,
              inputType: TextInputType.number,
              validationPatter: (v) {
                if (v == null || v.trim().isEmpty) return 'Campo requerido';
                final n = double.tryParse(v);
                if (n == null || n < 0 || n > 100) return 'Valor inválido (0-100)';
                return null;
              },
            ),
            Obx(
              () => DynamicDropdownInput<String>(
                label: 'Tipo de documento *',
                hint: 'Selecciona',
                items: _idTypes,
                value: controller.uboIdType.value.isEmpty
                    ? null
                    : controller.uboIdType.value,
                onChanged: (v) => controller.uboIdType.value = v ?? '',
                dropdownSearchInputType: TextInputType.text,
                searchable: false,
              ),
            ),
            DynamicInput(
              label: 'Número de documento *',
              controller: controller.uboIdNumberCtrl,
              inputType: TextInputType.text,
              validationPatter: (v) =>
                  v == null || v.trim().isEmpty ? 'Campo requerido' : null,
            ),
            Obx(
              () => DynamicFilePickerInput(
                label: 'Foto del documento de identidad *',
                value: controller.uboIdFile.value,
                onTap: controller.pickUboIdFile,
              ),
            ),
            Obx(
              () => DynamicFilePickerInput(
                label: 'Comprobante de domicilio *',
                value: controller.uboAddressProof.value,
                onTap: controller.pickUboAddressProof,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: DynamicButton(
          width: double.infinity,
          onPressed: controller.submitUboForm,
          child: Text(
            'Guardar beneficiario',
            style: textTheme.labelLarge?.copyWith(color: AppColors.light),
          ),
        ),
      ),
    );
  }
}
