import 'dart:ui';
import 'package:intl/intl.dart';

extension HexColor on Color {
  String toHex() => '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

  String toHexWithAlpha() => '#${value.toRadixString(16).padLeft(8, '0')}';
}

extension StringToDouble on String {
  double toDouble() {
    if (isEmpty) return 0.0;

    String textToParse = trim();

    int lastDotIndex = textToParse.lastIndexOf('.');
    int lastCommaIndex = textToParse.lastIndexOf(',');

    if (lastDotIndex != -1 && lastCommaIndex != -1) {
      if (lastCommaIndex > lastDotIndex) {
        textToParse = textToParse.replaceAll('.', '');
        textToParse = textToParse.replaceAll(',', '.');
      } else {
        textToParse = textToParse.replaceAll(',', '');
      }
    } else if (lastCommaIndex != -1) {
      textToParse = textToParse.replaceAll(',', '.');
    } else if (lastDotIndex != -1) {
      int dotCount = '.'.allMatches(textToParse).length;
      if (dotCount > 1) {
        textToParse = textToParse.replaceAll('.', '');
      } else {
        if (textToParse.substring(lastDotIndex + 1).length == 3) {
          textToParse = textToParse.replaceAll('.', '');
        }
      }
    }

    return double.tryParse(textToParse) ?? 0.0;
  }

  Map<String, dynamic> decodeUriParams() {
    final Uri? uri = Uri.tryParse(this);

    if (uri != null) {
      return uri.queryParameters;
    } else {
      return {};
    }
  }
}

extension DoubleToString on double {
  String toHauvNumericString({int decimals = 4}) {
    final formatter = NumberFormat.decimalPatternDigits(
      locale: 'es_ES',
      decimalDigits: decimals,
    );

    return formatter.format(this);
  }
}

extension StringDateFormatting on String {
  String toHauvNumericString({int decimals = 4}) {
    try {
      final num = double.parse(this);

      final formatter = NumberFormat.decimalPatternDigits(
        locale: 'es_ES',
        decimalDigits: decimals,
      );

      return formatter.format(num);
    } on FormatException {
      return this;
    }
  }

  String truncateText(int maxLength) {
    if (maxLength <= 0) {
      return '';
    }

    final String trunc = this ?? '';

    if (this.isEmpty) {
      return '';
    }

    if (this.length <= maxLength) {
      return this;
    } else {
      return '${this.substring(0, maxLength)}...';
    }
  }

  String formatFirstName({int maxLength = 12}) {
    if (this.trim().isEmpty) {
      return '';
    }

    final trimmedName = this.trim();
    final parts = trimmedName.split(' ');
    final firstName = parts.first;

    if (firstName.isEmpty) {
      return '';
    }
    final formattedName =
        '${firstName[0].toUpperCase()}${firstName.substring(1).toLowerCase()}';

    if (formattedName.length <= maxLength) {
      return formattedName;
    } else {
      return '${formattedName.substring(0, maxLength)}...';
    }
  }
}

extension DateFormatting on DateTime {
  String toDateTimeFormat({
    bool formatAsHeader = false,
    bool showDate = true,
    bool showTime = false,
  }) {
    final dateTimeToFormat = this;

    if (formatAsHeader) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      final dateToCompare = DateTime(
        dateTimeToFormat.year,
        dateTimeToFormat.month,
        dateTimeToFormat.day,
      );

      if (dateToCompare == today) return 'Hoy';
      if (dateToCompare == yesterday) return 'Ayer';
      return DateFormat('dd/MM/yyyy', 'es_ES').format(dateTimeToFormat);
    }

    String formatPattern = '';
    if (showDate) formatPattern += 'dd/MM/yyyy';
    if (showTime) {
      if (formatPattern.isNotEmpty) formatPattern += ' ';
      formatPattern += 'HH:mm';
    }

    return formatPattern.isNotEmpty
        ? DateFormat(formatPattern, 'es_ES').format(dateTimeToFormat)
        : '';
  }
}
