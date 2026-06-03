import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:wiigold/theme/Colors.dart';

class DynamicQr extends StatefulWidget {
  final String data;
  final double maxSize;

  const DynamicQr({super.key, required this.data, this.maxSize = 260});

  @override
  State<DynamicQr> createState() => DynamicQrState();
}

class DynamicQrState extends State<DynamicQr> {
  QrImage? _qrImage;

  @override
  void initState() {
    super.initState();
    _buildQr(widget.data);
  }

  @override
  void didUpdateWidget(covariant DynamicQr oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _buildQr(widget.data);
    }
  }

  void _buildQr(String data) {
    if (data.isEmpty) {
      setState(() => _qrImage = null);
      return;
    }
    final qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    setState(() {
      _qrImage = QrImage(qrCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = math.min(
      MediaQuery.of(context).size.width * 0.65,
      widget.maxSize,
    );

    if (_qrImage == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: PrettyQrView(
        qrImage: _qrImage!,
        decoration: const PrettyQrDecoration(
          shape: PrettyQrSquaresSymbol(),
          quietZone: PrettyQrQuietZone.zero,
          image: PrettyQrDecorationImage(
            scale: 0.3,
            image: AssetImage('assets/images/brand/logos/isologo.png'),
            position: PrettyQrDecorationImagePosition.embedded,
          ),
        ),
      ),
    );
  }
}
