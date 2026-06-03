import 'package:flutter/material.dart';

//CONST
import 'package:wiigold/config/environment.dart';

class FormSemantics {
  final String identifier;
  final String? semanticLabel;
  final String? hint;
  final bool liveRegion;

  const FormSemantics({
    required this.identifier,
    this.semanticLabel,
    this.hint,
    this.liveRegion = false,
  });
}

class DynamicForm extends StatelessWidget {
  final Widget child;
  final Key formKey;
  final AutovalidateMode autovalidateMode;
  final FormSemantics? semanticSettings;

  const DynamicForm({
    super.key,
    required this.formKey,
    required this.child,
    required this.autovalidateMode,
    this.semanticSettings,
  });

  @override
  Widget build(BuildContext context) {
    return _formatSemantic(
      Form(key: formKey, autovalidateMode: autovalidateMode, child: child),
    );
  }

  Widget _formatSemantic(Widget form) {
    if (!EnvironmentConfig.inRenderSemantics || semanticSettings == null) {
      return form;
    }

    return semanticSettings != null
        ? Semantics(
            liveRegion: semanticSettings!.liveRegion,
            container: true,
            label: semanticSettings!.semanticLabel,
            hint: semanticSettings!.hint,
            identifier: semanticSettings!.identifier,
            child: form,
          )
        : form;
  }
}
