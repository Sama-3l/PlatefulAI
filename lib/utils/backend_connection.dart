import 'package:flutter_dotenv/flutter_dotenv.dart';

class BackendConnection {
  static String baseUrl = dotenv.env['BACKEND_URL']!;
}
