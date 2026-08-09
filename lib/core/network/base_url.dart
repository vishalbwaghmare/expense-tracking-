import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseUrl {
  BaseUrl._();

  static String get apiUrl {
    final url = dotenv.env['BASE_URL'];

    if (url == null || url.isEmpty) {
      throw Exception("BASE_URL is not configured in .env");
    }

    return url;
  }
}
