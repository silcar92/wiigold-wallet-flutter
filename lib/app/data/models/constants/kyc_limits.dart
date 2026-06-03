import 'package:flutter/material.dart';
import 'package:wiigold/theme/Colors.dart';

class KycTier {
  final String code;
  final String name;
  final String description;
  final String perOperation;
  final String perDay;
  final String perMonth;
  final Color color;

  const KycTier({
    required this.code,
    required this.name,
    required this.description,
    required this.perOperation,
    required this.perDay,
    required this.perMonth,
    required this.color,
  });
}

class KycLimits {
  // Mapeo de códigos numéricos (backend actual) a tier string
  static const Map<String, String> _numericToTier = {
    '300': 'REGISTERED_RESTRICTED',
    '310': 'REGISTERED_RESTRICTED',
    '320': 'KYC_APPROVED_STANDARD',
    '340': 'KYC_APPROVED_STANDARD',
    // Pass-through para códigos string directos
    'REGISTERED_RESTRICTED': 'REGISTERED_RESTRICTED',
    'KYC_APPROVED_STANDARD': 'KYC_APPROVED_STANDARD',
    'KYC_APPROVED_ENHANCED_LIMITED': 'KYC_APPROVED_ENHANCED_LIMITED',
    'EDD_APPROVED': 'EDD_APPROVED',
  };

  static final Map<String, KycTier> _tiers = {
    'REGISTERED_RESTRICTED': const KycTier(
      code: 'REGISTERED_RESTRICTED',
      name: 'Cuenta básica',
      description:
          'Puedes explorar la app e iniciar tu proceso de verificación.',
      perOperation: 'USD 0',
      perDay: 'USD 0',
      perMonth: 'USD 0',
      color: AppColors.dark2,
    ),
    'KYC_APPROVED_STANDARD': const KycTier(
      code: 'KYC_APPROVED_STANDARD',
      name: 'Cuenta verificada',
      description:
          'Accede a on-ramp, off-ramp, intercambio y custodia dentro de límites estándar.',
      perOperation: 'USD 999',
      perDay: 'USD 1.500',
      perMonth: 'USD 5.000',
      color: AppColors.main,
    ),
    'KYC_APPROVED_ENHANCED_LIMITED': const KycTier(
      code: 'KYC_APPROVED_ENHANCED_LIMITED',
      name: 'Cuenta verificada con soporte',
      description:
          'Operación ampliada dentro de la wallet cerrada con límites extendidos.',
      perOperation: 'USD 2.500',
      perDay: 'USD 3.000',
      perMonth: 'USD 10.000',
      color: AppColors.main2,
    ),
    'EDD_APPROVED': const KycTier(
      code: 'EDD_APPROVED',
      name: 'Cuenta avanzada',
      description:
          'Límites personalizados según tu perfil aprobado por el Oficial de Cumplimiento.',
      perOperation: 'Personalizado',
      perDay: 'Personalizado',
      perMonth: 'Personalizado',
      color: AppColors.accent,
    ),
  };

  static KycTier? forStatus(String? status) {
    if (status == null) return null;
    final tierCode = _numericToTier[status] ?? status;
    return _tiers[tierCode];
  }

  static bool isApproved(String? status) {
    if (status == null) return false;
    const approvedCodes = {
      '320',
      '340',
      'KYC_APPROVED_STANDARD',
      'KYC_APPROVED_ENHANCED_LIMITED',
      'EDD_APPROVED',
    };
    return approvedCodes.contains(status);
  }
}
