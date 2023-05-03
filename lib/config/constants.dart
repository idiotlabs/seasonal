import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static String? apiBaseUrl = dotenv.env['API_URL'];
  static String? apiToken = dotenv.env['API_TOKEN'];
  static String? imageBaseUrl = dotenv.env['IMAGE_URL'];
}