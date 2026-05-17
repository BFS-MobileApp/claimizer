// lib/CommonUtils/logout_manager.dart
import 'package:dio/dio.dart';

class LogoutManager {
  static final List<CancelToken> _activeTokens = [];

  static void register(CancelToken token) {
    _activeTokens.add(token);
  }

  static void unregister(CancelToken token) {
    _activeTokens.remove(token);
  }

  static void cancelAll() {
    for (final token in _activeTokens) {
      if (!token.isCancelled) {
        token.cancel('User logged out');
      }
    }
    _activeTokens.clear();
  }
}