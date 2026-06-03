import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:wiigold/app/common/utils/validations.dart';
import 'package:wiigold/theme/Colors.dart';

class PasswordSemantics {
  final String identifier;
  final String? semanticLabel;
  final String? hint;

  const PasswordSemantics({
    required this.identifier,
    this.semanticLabel,
    this.hint,
  });
}

class DynamicAuthInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final bool isDisabled;
  final bool showVisibilityToggle;
  final String obscuringCharacter;
  final int minLength;
  final int? maxLength;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final InputDecoration? inputDecoration;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onTapEnter;
  final Widget? leading;
  final Widget? prefix;
  final PasswordSemantics? semanticSettings;
  final bool enableBiometrics;
  final VoidCallback? onBiometricSuccess;
  final VoidCallback? onBiometricFailed;

  final VoidCallback? onBiometricCancel;
  final VoidCallback? onStartBiometric;
  final VoidCallback? onEndBiometric;
  final String? Function(String?)? validator;
  final bool showErrorText;

  const DynamicAuthInput({
    super.key,
    this.label,
    required this.controller,
    this.hint,
    this.isDisabled = false,
    this.showVisibilityToggle = true,
    this.obscuringCharacter = '●',
    this.minLength = 5,
    this.maxLength,
    this.labelStyle,
    this.inputStyle,
    this.inputDecoration,
    this.leading,
    this.autovalidateMode,
    this.onChanged,
    this.onTapEnter,
    this.prefix,
    this.semanticSettings,
    this.enableBiometrics = false,
    this.onBiometricSuccess,
    this.onBiometricFailed,
    this.onBiometricCancel,
    this.onStartBiometric,
    this.onEndBiometric,
    this.validator,
    this.showErrorText = true,
  });

  @override
  State<DynamicAuthInput> createState() => _DynamicAuthInputState();
}

class _DynamicAuthInputState extends State<DynamicAuthInput> {
  bool _isPasswordObscured = true;
  final LocalAuthentication _auth = LocalAuthentication();

  Future<void> _handleBiometricAuth() async {
    final bool canAuthenticate =
        await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    if (!mounted) return;

    if (!canAuthenticate) {
      widget.onBiometricFailed?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La autenticación biométrica no está disponible en este dispositivo.',
          ),
        ),
      );
      return;
    }

    widget.onStartBiometric?.call();

    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Autenticación requerida',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (didAuthenticate) {
        widget.onBiometricSuccess?.call();
      } else {
        widget.onBiometricCancel?.call();
      }
    } on PlatformException catch (e) {
      if (mounted) {
        widget.onBiometricFailed?.call();
      }
      print('Error de autenticación biométrica: $e');
    } finally {
      if (mounted) {
        widget.onEndBiometric?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final List<TextInputFormatter> formatters = [];
    if (widget.maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(widget.maxLength!));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null && widget.label!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              widget.label!,
              style:
                  widget.labelStyle ??
                  textTheme.titleSmall?.copyWith(
                    color: AppColors.dark2,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: _formatSemantic(
            TextFormField(
              controller: widget.controller,
              style: widget.inputStyle ?? textTheme.titleSmall,
              decoration: _buildInputDecoration(context, textTheme),
              keyboardType: TextInputType.visiblePassword,
              onChanged: widget.onChanged,
              validator: (value) {
                final base = widget.validator != null
                    ? widget.validator!(value)
                    : Validations.validationSpecial(value, minLength: 5);
                if (!widget.showErrorText && base != null) return '';
                return base;
              },
              enabled: !widget.isDisabled,
              autovalidateMode:
                  widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
              onFieldSubmitted: widget.onTapEnter,
              obscureText: _isPasswordObscured,
              obscuringCharacter: widget.obscuringCharacter,
              inputFormatters: formatters,
            ),
          ),
          leading: widget.leading,
        ),
      ],
    );
  }

  Widget _formatSemantic(TextFormField input) {
    if (widget.semanticSettings == null) {
      return input;
    }
    return Semantics(
      label: widget.semanticSettings!.semanticLabel ?? widget.label,
      hint: widget.semanticSettings!.hint ?? widget.hint,
      identifier: widget.semanticSettings!.identifier,
      textField: true,
      obscured: true,
      child: input,
    );
  }

  InputDecoration _buildInputDecoration(
    BuildContext context,
    TextTheme textTheme,
  ) {
    final baseDecoration =
        widget.inputDecoration ??
        InputDecoration(
          hintText: widget.hint,
          hintStyle: textTheme.bodyLarge?.copyWith(color: AppColors.dark2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.dark3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.dark3),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.failure),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1.5,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.failure, width: 2.0),
          ),
          errorStyle: widget.showErrorText
              ? textTheme.bodyMedium?.copyWith(
                  height: .75,
                  fontWeight: FontWeight.w500,
                  color: AppColors.failure,
                )
              : const TextStyle(height: 0, fontSize: 0),
        );

    List<Widget> suffixIcons = [];

    if (widget.enableBiometrics) {
      suffixIcons.add(
        IconButton(
          icon: Icon(Icons.fingerprint, color: AppColors.dark2),
          onPressed: _handleBiometricAuth,
          tooltip: 'Usar autenticación biométrica',
        ),
      );
    }

    if (widget.showVisibilityToggle) {
      suffixIcons.add(
        IconButton(
          icon: Icon(
            _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
            color: AppColors.dark2,
          ),
          onPressed: () {
            setState(() {
              _isPasswordObscured = !_isPasswordObscured;
            });
          },
        ),
      );
    }

    final Widget? finalSuffixIcon = suffixIcons.isNotEmpty
        ? Row(mainAxisSize: MainAxisSize.min, children: suffixIcons)
        : null;

    return baseDecoration.copyWith(
      prefixIcon: baseDecoration.prefixIcon ?? widget.prefix,
      suffixIcon: baseDecoration.suffixIcon ?? finalSuffixIcon,
    );
  }
}
