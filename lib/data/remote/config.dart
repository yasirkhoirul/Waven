import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return "/api";
    }
    return "http://waven-development.site";
  }

  static Uri path(String endpoint, {Map<String, dynamic>? query}) {
    // Hilangkan slash double
    final cleanEndpoint = endpoint.startsWith('/')
        ? endpoint.substring(1)
        : endpoint;

    if (kIsWeb) {
      return Uri.parse("${baseUrl}/${cleanEndpoint}");
    }
    return Uri.parse("${baseUrl}/${cleanEndpoint}");
  }
}