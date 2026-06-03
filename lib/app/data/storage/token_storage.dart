import 'package:get_storage/get_storage.dart';

class TokenStorage {
  final GetStorage _storage = GetStorage();
  final String _currentTokenKey = 'user_token_key_v2';

  String getCurrentToken() {
    final token = _storage.read(_currentTokenKey) ?? '';

    return token;
  }

  void setCurrentToken(String token) {
    _storage.write(_currentTokenKey, token);
  }

  void deleteCurrentToken() {
    _storage.remove(_currentTokenKey);
  }
}
