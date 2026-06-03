import 'dart:io';

import 'package:wiigold/app/data/providers/easypost_provider.dart';

class TrackingRepository {
  final EasypostProvider _easypostProvider = EasypostProvider();

  Future<Map<String, dynamic>> trackShipment(
    String trackingCode,
    String carrier,
  ) async {
    try {
      final Map<String, dynamic> body = {
        'tracker': {'tracking_code': trackingCode, 'carrier': carrier},
      };

      final response = await _easypostProvider.post(
        EasypostEndpoints.trackers,
        body: body,
      );

      return response;
    } on HttpException catch (e) {
      print('Error al rastrear el envío: ${e.message}');
      rethrow;
    } catch (e) {
      print('Ocurrió un error desconocido en TrackingRepository: $e');
      throw Exception('No se pudo completar el seguimiento en este momento.');
    }
  }
}
