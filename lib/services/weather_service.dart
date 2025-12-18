import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // URL API Open-Meteo (Lokasi Jakarta)
  // Tidak perlu API Key, jadi aman & gratis 100%
  static const String _baseUrl =
      "https://api.open-meteo.com/v1/forecast?latitude=-6.2088&longitude=106.8456&current_weather=true";

  // Getter agar URL bisa diambil oleh halaman About
  String get apiUrl => _baseUrl;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat data cuaca');
      }
    } catch (e) {
      throw Exception('Error koneksi: $e');
    }
  }
}
