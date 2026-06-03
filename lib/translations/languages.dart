import 'package:get/get.dart';
import 'langs/es_ES.dart';
import 'langs/en_US.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'es_ES': esES,
    'en_US': enUS,
  };
}

String getString(String key) => key.tr;