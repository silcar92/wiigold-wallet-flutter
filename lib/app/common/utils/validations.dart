import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/validations/phone_validation_source.dart';

class Validations {
  static String? validationInputText(
    String? value, {
    int minLength = 0,
    int maxLength = 255,
    List<String> additionalAllowedChars = const [],
  }) {
    if (value == null || value.isEmpty) {
      return 'validation.empty_field'.tr;
    }

    if (value.length < minLength) {
      return 'validation.min_length'.trParams({'count': minLength.toString()});
    }

    if (value.length > maxLength) {
      return 'validation.max_length'.trParams({'count': maxLength.toString()});
    }

    String pattern = r'^[a-zA-Z0-9';

    if (additionalAllowedChars.isNotEmpty) {
      pattern += additionalAllowedChars
          .map((char) => RegExp.escape(char))
          .join();
    }

    pattern += r']+$';

    final regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'validation.invalid_chars'.tr;
    }

    if (value.contains('  ')) {
      return 'validation.no_double_spaces'.tr;
    }

    final consecutiveSpecialCharsRegex = RegExp(r"['\-?!¿¡,.\[\]()]{2,}");

    if (consecutiveSpecialCharsRegex.hasMatch(value)) {
      return 'validation.consecutive_special_chars'.tr;
    }

    return null;
  }

  static String? validationInputEmail(
    String? value, {
    bool pureValidation = false,
    bool notRequiered = false,
  }) {
    if (value == null || value.isEmpty) {
      if (notRequiered == true) {
        return pureValidation ? 'true' : null;
      }

      return pureValidation ? 'false' : 'validation.empty_field'.tr;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return pureValidation ? 'false' : 'validation.invalid_email'.tr;
    }

    return pureValidation ? 'true' : null;
  }

  static String? validationInputPass(
    String? value, {
    int minLength = 8,
    int? maxLength,
  }) {
    if (value == null || value.isEmpty) {
      return 'validation.empty_field'.tr;
    }

    if (value.length < minLength) {
      return 'validation.min_length'.trParams({'count': minLength.toString()});
    }

    if (maxLength != null && value.length > maxLength) {
      return 'validation.max_length'.trParams({'count': maxLength.toString()});
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) return 'validation.pass_condition_lowercase'.tr;
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'validation.pass_condition_uppercase'.tr;
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'validation.pass_condition_numbers'.tr;
    if (!RegExp(r'[!@#$%^&*()\[\]{}<>,.?":;_\-+=/\\|~`]').hasMatch(value)) {
      return 'validation.pass_condition_special'.tr;
    }

    return null;
  }

  static String? validationInputName(
    String? value, {
    int minLength = 2,
    int maxLength = 50,
    bool trimWhitespace = true,
  }) {
    final processedValue = trimWhitespace ? value?.trim() : value;

    if (processedValue == null || processedValue.isEmpty) {
      return 'validation.empty_field'.tr;
    }

    if (processedValue.length < minLength) {
      return 'validation.min_length'.trParams({'count': minLength.toString()});
    }

    if (processedValue.length > maxLength) {
      return 'validation.max_length'.trParams({'count': maxLength.toString()});
    }

    final allowedCharsRegex = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ' \-]+$");
    if (!allowedCharsRegex.hasMatch(processedValue)) {
      return 'validation.invalid_name_chars'.tr;
    }

    final consecutiveSpecialCharsRegex = RegExp(r"['\-]{2,}");
    if (consecutiveSpecialCharsRegex.hasMatch(processedValue)) {
      return 'validation.consecutive_special_chars'.tr;
    }

    if (processedValue.contains('  ')) {
      return 'validation.no_double_spaces'.tr;
    }

    return null;
  }

  static String? validationInputNumericText(
    String? value, {
    bool pureValidation = false,
    int? minLength,
    int? maxLength,
  }) {
    if (value == null || value.isEmpty) {
      return pureValidation ? 'false' : 'validation.empty_field'.tr;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return pureValidation ? 'false' : 'validation.only_numbers'.tr;
    }

    final evalMinMax = Validations.validationInputText(
      value,
      minLength: minLength ?? 2,
      maxLength: maxLength ?? 10,
    );

    if (evalMinMax != null) {
      return pureValidation ? 'false' : evalMinMax;
    }

    return pureValidation ? 'true' : null;
  }

  static String? validationInputPhone(String? value, {String? phoneCode}) {
    if (value == null || value.isEmpty) {
      return 'validation.empty_field'.tr;
    }

    if (phoneCode == null) {
      return 'No se proporcionó un código de país';
    }

    final regex = phoneRegexByCountry[phoneCode];

    if (regex == null) {
      return 'El código de país no es válido';
    }

    if (!RegExp(regex).hasMatch(value)) {
      return 'El número no coincide con el formato esperado para ese país';
    }

    return null;
  }

  static String? validationInputNumeric(
    String? value, {
    int? minLength,
    double? min,
    double? max,
    bool disallowZero = false,
    String locale = 'es_ES',
    String? customZeroErrorMessageKey,
  }) {
    if (value == null || value.isEmpty) {
      return 'validation.empty_field'.tr;
    }

    final numberFormatParser = NumberFormat.decimalPattern(locale);
    double numericValue;

    try {
      numericValue = numberFormatParser.parse(value).toDouble();
    } catch (e) {
      return 'validation.invalid_number'.tr;
    }

    if (disallowZero && numericValue == 0.0) {
      return 'validation.zero_not_allowed'.tr;
    }

    if (minLength != null && value.length < minLength) {
      return 'validation.min_length'.trParams({'count': minLength.toString()});
    }

    if (min != null && numericValue < min) {
      return 'validation.min_value'.trParams({
        'value': numberFormatParser.format(min),
      });
    }

    if (max != null && numericValue > max) {
      return 'validation.max_value'.trParams({
        'value': numberFormatParser.format(max),
      });
    }

    return null;
  }

  static String? validationDropdown(String? value) {
    if (value == null || value.isEmpty || value == '') {
      return 'Por favor, selecciona una opción.';
    }

    return null;
  }

  static String? validationSpecial(
    String? value, {
    int minLength = 0,
    int maxLength = 255,
  }) {
    if (value == null || value.isEmpty) {
      return 'validation.empty_field'.tr;
    }

    if (value.length < minLength) {
      return 'validation.min_length'.trParams({'count': minLength.toString()});
    }

    if (value.length > maxLength) {
      return 'validation.max_length'.trParams({'count': maxLength.toString()});
    }

    return null;
  }

  static String? validationAddress(
    String? value, {
    int minLength = 0,
    int maxLength = 255,
  }) {
    if (value == null || value.isEmpty) {
      return 'validation.empty_field'.tr;
    }

    if (value.length < minLength) {
      return 'validation.min_length'.trParams({'count': minLength.toString()});
    }

    if (value.length > maxLength) {
      return 'validation.max_length'.trParams({'count': maxLength.toString()});
    }

    final addressRegex = RegExp(
      r'^(?!.*[#\-&,/.]{2})'
      r'[\w\s#\-&,/.áéíóúÁÉÍÓÚñÑüÜ]+$',
    );

    if (!addressRegex.hasMatch(value)) {
      return 'validation.invalid_address_format'.tr;
    }

    if (value.contains('  ')) {
      return 'validation.no_double_spaces'.tr;
    }

    return null;
  }

  static String? validateSwiftCode(String? value, {bool isRequired = true}) {
    if (isRequired && (value == null || value.isEmpty)) {
      return 'validation.empty_field'.tr;
    }

    if (!isRequired && (value == null || value.isEmpty)) {
      return null;
    }

    final cleanedValue = value!.trim().toUpperCase();

    if (cleanedValue.length != 8 && cleanedValue.length != 11) {
      return 'validation.swift_length'.tr;
    }

    final RegExp swiftRegExp = RegExp(
      r'^[A-Z]{4}([A-Z]{2})[A-Z0-9]{2}([A-Z0-9]{3})?$',
    );

    if (!swiftRegExp.hasMatch(cleanedValue)) {
      return 'validation.swift_invalid'.tr;
    }

    return null;
  }

  static String? validationBankAccount(
    String? value, {
    bool validateChecksum = false,
    int minLength = 1,
    int maxLength = 20,
    bool allowSpaces = false,
    bool allowLetters = false,
  }) {
    bool isValidLuhn(String value) {
      int sum = 0;
      bool alternate = false;

      for (int i = value.length - 1; i >= 0; i--) {
        int digit = int.parse(value[i]);

        if (alternate) {
          digit *= 2;
          if (digit > 9) {
            digit = (digit % 10) + 1;
          }
        }

        sum += digit;
        alternate = !alternate;
      }

      return (sum % 10 == 0);
    }

    if (value == null || value.isEmpty) {
      return 'validation.empty_field'.tr;
    }

    String processedValue = allowSpaces ? value : value.replaceAll(' ', '');

    if (processedValue.length < minLength) {
      return 'validation.min_length'.trParams({'count': minLength.toString()});
    }

    if (processedValue.length > maxLength) {
      return 'validation.max_length'.trParams({'count': maxLength.toString()});
    }

    final validCharsRegex = allowLetters
        ? RegExp(r'^[a-zA-Z0-9]+$')
        : RegExp(r'^[0-9]+$');

    if (!validCharsRegex.hasMatch(processedValue)) {
      return allowLetters
          ? 'validation.only_alphanumeric'.tr
          : 'validation.only_digits'.tr;
    }

    if (allowLetters && processedValue.length >= 4) {
      final countryCode = processedValue.substring(0, 2).toUpperCase();
      final controlDigits = processedValue.substring(2, 4);

      final countryRegex = RegExp(r'^[A-Z]{2}$');
      if (!countryRegex.hasMatch(countryCode)) {
        return 'validation.invalid_country_code'.tr;
      }

      final digitsRegex = RegExp(r'^[0-9]{2}$');
      if (!digitsRegex.hasMatch(controlDigits)) {
        return 'validation.invalid_control_digits'.tr;
      }
    }

    if (validateChecksum && !allowLetters) {
      if (!isValidLuhn(processedValue)) {
        return 'validation.invalid_checksum'.tr;
      }
    }

    return null;
  }

  static String? validationCreditCardExpired(
    String? value, {
    bool pureValidation = false,
  }) {
    if (value == null || value.isEmpty) {
      return pureValidation ? 'false' : 'validation.empty_field'.tr;
    }

    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return pureValidation ? 'false' : 'validation.invalid_format'.tr;
    }

    final parts = value.split('/');
    final monthStr = parts[0];
    final yearStr = parts[1];

    final month = int.tryParse(monthStr);
    final year = int.tryParse(yearStr);

    if (month == null || year == null) {
      return pureValidation ? 'false' : 'validation.invalid_number'.tr;
    }

    if (month < 1 || month > 12) {
      return pureValidation ? 'false' : 'validation.invalid_month'.tr;
    }

    final currentYear = DateTime.now().year % 100;

    if (year < currentYear || year > 99) {
      return pureValidation ? 'false' : 'validation.invalid_year'.tr;
    }

    return pureValidation ? 'true' : null;
  }

  static String? validationCreditCardNumber(
    String? value, {
    bool pureValidation = false,
  }) {
    if (value == null || value.isEmpty) {
      return pureValidation ? 'false' : 'validation.empty_field'.tr;
    }

    final cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanedValue.length != 16) {
      return pureValidation ? 'false' : 'validation.invalid_card_length'.tr;
    }

    if (!RegExp(r'^\d+$').hasMatch(cleanedValue)) {
      return pureValidation ? 'false' : 'validation.only_numbers'.tr;
    }

    if (!_isValidLuhn(cleanedValue)) {
      return pureValidation ? 'false' : 'validation.invalid_card_number'.tr;
    }

    return pureValidation ? 'true' : null;
  }

  static bool _isValidLuhn(String number) {
    int sum = 0;
    bool isDouble = false;

    for (int i = number.length - 1; i >= 0; i--) {
      int digit = int.parse(number[i]);

      if (isDouble) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      isDouble = !isDouble;
    }

    return sum % 10 == 0;
  }
}
