import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_datetime.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_dropdown.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_form.dart';
import 'package:wiigold/app/common/widgets/form/dynamic_input.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_bar.dart';
import 'package:wiigold/app/common/widgets/layout/dynamic_app_scaffold.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/app/data/models/entities/locations_model.dart';
import 'package:wiigold/app/modules/kyb/controllers/kyb_controller.dart';
import 'package:wiigold/theme/Colors.dart';

class KybCompanyInfoView extends GetView<KybController> {
  const KybCompanyInfoView({super.key});

  static const _legalForms = [
    DropdownItem(label: 'S.A.S.', value: 'SAS'),
    DropdownItem(label: 'S.A.', value: 'SA'),
    DropdownItem(label: 'LLC', value: 'LLC'),
    DropdownItem(label: 'Corp.', value: 'Corp'),
    DropdownItem(label: 'Otro', value: 'other'),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DynamicAppScaffold(
      isLoading: controller.isLoading,
      showLoader: controller.showLoader,
      appBar: DynamicAppBar(
        showLogo: false,
        showAutoBackButton: false,
        title: const Text('Datos de la empresa'),
      ),
      isContentCentered: false,
      body: DynamicForm(
        formKey: controller.companyInfoFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Text('Información empresarial', style: textTheme.displayLarge),
            Text(
              'Completa los datos de constitución de tu empresa.',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.dark2),
            ),
            DynamicInput(
              label: 'Razón social *',
              hint: 'Nombre legal registrado',
              controller: controller.legalNameCtrl,
              inputType: TextInputType.text,
              validationPatter: (v) =>
                  v == null || v.trim().isEmpty ? 'Campo requerido' : null,
            ),
            DynamicInput(
              label: 'Nombre comercial',
              hint: 'Nombre con el que opera (opcional)',
              controller: controller.tradingNameCtrl,
              inputType: TextInputType.text,
            ),
            Obx(
              () => DynamicDropdownInput<String>(
                label: 'País de constitución *',
                hint: 'Selecciona un país',
                items: controller.locationController.countries
                    .map((Country c) => DropdownItem(value: '${c.id}', label: c.name))
                    .toList(),
                value: controller.selectedCountryId.value.isEmpty
                    ? null
                    : controller.selectedCountryId.value,
                onChanged: (v) => controller.selectedCountryId.value = v ?? '',
                dropdownSearchInputType: TextInputType.text,
                searchController: controller.countrySearchCtrl,
                searchable: true,
                searchHint: 'Buscar país...',
              ),
            ),
            DynamicInput(
              label: 'NIT / Registro mercantil *',
              hint: 'Número de identificación tributaria',
              controller: controller.registrationNumberCtrl,
              inputType: TextInputType.text,
              validationPatter: (v) =>
                  v == null || v.trim().isEmpty ? 'Campo requerido' : null,
            ),
            DynamicDateTime(
              label: 'Fecha de constitución *',
              hint: 'DD/MM/AAAA',
              controller: controller.incorporationDateCtrl,
            ),
            Obx(
              () => DynamicDropdownInput<String>(
                label: 'Tipo societario *',
                hint: 'Selecciona',
                items: _legalForms,
                value: controller.selectedLegalForm.value.isEmpty
                    ? null
                    : controller.selectedLegalForm.value,
                onChanged: (v) => controller.selectedLegalForm.value = v ?? '',
                dropdownSearchInputType: TextInputType.text,
                searchable: false,
              ),
            ),
            DynamicInput(
              label: 'Dirección registrada *',
              hint: 'Dirección fiscal de la empresa',
              controller: controller.addressCtrl,
              inputType: TextInputType.streetAddress,
              validationPatter: (v) =>
                  v == null || v.trim().isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: DynamicButton(
          width: double.infinity,
          onPressed: controller.submitCompanyInfo,
          child: Text(
            'Continuar',
            style: textTheme.labelLarge?.copyWith(color: AppColors.light),
          ),
        ),
      ),
    );
  }
}
