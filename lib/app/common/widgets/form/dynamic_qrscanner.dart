import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wiigold/app/common/widgets/ui/dynamic_button.dart';
import 'package:wiigold/theme/Colors.dart';

class DynamicQRScanner extends StatefulWidget {
  final Function(String qrCode) onDetect;
  final TextEditingController? scannedTextController;
  final String noPermissionText;
  final double width;
  final double height;
  final String resumeButtonText;

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const DynamicQRScanner({
    required this.onDetect,
    this.scannedTextController,

    this.noPermissionText = 'widgets.dynamic_qrscanner.default_permission_text',
    this.width = 250,
    this.height = 250,

    this.resumeButtonText = 'widgets.dynamic_qrscanner.default_resume_button',
    this.borderColor = AppColors.main,
    this.borderWidth = 8,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.5),
    this.borderRadius = 12,
    this.borderLength = 30,
    double? cutOutSize,
    super.key,
  }) : cutOutSize = cutOutSize ?? 250.0;

  @override
  State<DynamicQRScanner> createState() => _DynamicQRScannerState();
}

class _DynamicQRScannerState extends State<DynamicQRScanner> {
  final MobileScannerController _scannerController = MobileScannerController(
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isProcessingScan = false;

  bool? _permissionGranted;

  @override
  void initState() {
    super.initState();
    widget.scannedTextController?.clear();

    _checkPermissionStatus();
  }

  Future<void> _checkPermissionStatus() async {
    final status = await Permission.camera.status;
    if (mounted) {
      setState(() {
        _permissionGranted = status.isGranted;
      });
    }
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    _checkPermissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: _buildScannerOrPermissionMessage(),
        ),
        if (_isProcessingScan && _permissionGranted == true)
          _buildResumeButton(context),
      ],
    );
  }

  Widget _buildScannerOrPermissionMessage() {
    if (_permissionGranted == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_permissionGranted == false) {
      return _buildPermissionMessage();
    }

    return _buildScanner();
  }

  Widget _buildScanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(controller: _scannerController, onDetect: _onDetect),

          _buildScannerOverlay(),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: ScannerOverlayPainter(
        borderColor: widget.borderColor,
        borderWidth: widget.borderWidth,
        overlayColor: widget.overlayColor,
        borderRadius: widget.borderRadius,
        borderLength: widget.borderLength,
        cutOutSize: widget.cutOutSize,
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessingScan) return;
    final String? code = capture.barcodes.firstOrNull?.rawValue;

    if (code != null && code.isNotEmpty) {
      _scannerController.stop();
      if (mounted) {
        setState(() {
          _isProcessingScan = true;
        });
        widget.scannedTextController?.text = code;
        widget.onDetect(code);
      }
    }
  }

  Widget _buildPermissionMessage() {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: AppColors.dark3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.noPermissionText.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.dark2, fontSize: 16),
          ),
          const SizedBox(height: 16),

          DynamicButton(
            baseColor: AppColors.main,
            isGradient: true,
            onPressed: _requestPermission,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'widgets.dynamic_qrscanner.grant_permission_button'.tr,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.light,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumeButton(BuildContext context) {
    return GestureDetector(
      onTap: _resumeCamera,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Icon(Icons.sync, color: AppColors.main, size: 30),
      ),
    );
  }

  void _resumeCamera() {
    widget.scannedTextController?.clear();
    if (mounted) {
      setState(() {
        _isProcessingScan = false;
      });
      _scannerController.start();
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  ScannerOverlayPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.overlayColor,
    required this.borderRadius,
    required this.borderLength,
    required this.cutOutSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = overlayColor;
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutOutRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: cutOutSize,
      height: cutOutSize,
    );

    final cutOutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      );

    final overlayPath = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutOutPath,
    );
    canvas.drawPath(overlayPath, paint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final borderPath = Path();

    borderPath.moveTo(cutOutRect.left, cutOutRect.top + borderLength);
    borderPath.lineTo(cutOutRect.left, cutOutRect.top);
    borderPath.lineTo(cutOutRect.left + borderLength, cutOutRect.top);

    borderPath.moveTo(cutOutRect.right - borderLength, cutOutRect.top);
    borderPath.lineTo(cutOutRect.right, cutOutRect.top);
    borderPath.lineTo(cutOutRect.right, cutOutRect.top + borderLength);

    borderPath.moveTo(cutOutRect.right, cutOutRect.bottom - borderLength);
    borderPath.lineTo(cutOutRect.right, cutOutRect.bottom);
    borderPath.lineTo(cutOutRect.right - borderLength, cutOutRect.bottom);

    borderPath.moveTo(cutOutRect.left + borderLength, cutOutRect.bottom);
    borderPath.lineTo(cutOutRect.left, cutOutRect.bottom);
    borderPath.lineTo(cutOutRect.left, cutOutRect.bottom - borderLength);

    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
