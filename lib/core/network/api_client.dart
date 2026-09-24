import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'exceptions.dart';

class ApiClient {
  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 15);

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        // CoinLore devuelve a veces lista, a veces mapa
        if (decoded is List) {
          return {'data': decoded};
        }
        return decoded as Map<String, dynamic>;
      } else {
        throw NetworkException(
          'Error HTTP ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw NetworkException('Sin conexión a internet');
    } on FormatException catch (e) {
      throw ParseException('Error al parsear JSON: $e');
    }
  }
}
