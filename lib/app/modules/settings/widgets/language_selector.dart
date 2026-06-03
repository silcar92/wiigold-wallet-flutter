import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiigold/theme/Colors.dart';

class LanguageSelector extends StatelessWidget {
  final List<Map<String, String>> supportedLanguages = [
    {'code': 'es_ES', 'name': 'Español'},
    {'code': 'en_US', 'name': 'English'},
  ];

  LanguageSelector({super.key});

  Locale _localeFromString(String code) {
    var parts = code.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : null);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    String? currentLanguageCode = Get.locale?.toString().replaceAll('-', '_');

    if (!supportedLanguages.any(
      (lang) => lang['code'] == currentLanguageCode,
    )) {}

    return ListTile(
      leading: Icon(Icons.translate, color: AppColors.dark2),

      title: Text(
        'settings.language_selector.title'.tr,

        style: textTheme.titleMedium?.copyWith(color: AppColors.light),
      ),
      trailing: DropdownButton<String>(
        value: currentLanguageCode,
        dropdownColor: AppColors.dark3,
        iconEnabledColor: AppColors.main,
        underline: Container(height: 0, color: Colors.transparent),
        items: supportedLanguages.map((language) {
          return DropdownMenuItem<String>(
            value: language['code'],
            child: Text(
              language['name']!,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.dark2),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) async {
          if (newValue != null && newValue != currentLanguageCode) {
            Locale newLocale = _localeFromString(newValue);

            Get.updateLocale(newLocale);

            try {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('language_code', newLocale.languageCode);

              if (newLocale.countryCode != null) {
                await prefs.setString('country_code', newLocale.countryCode!);
              }
              print(
                "Idioma guardado: ${newLocale.languageCode}_${newLocale.countryCode}",
              );
            } catch (e) {
              print("Error al guardar el idioma: $e");
            }
          }
        },
      ),
    );
  }
}
