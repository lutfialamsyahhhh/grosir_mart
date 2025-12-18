import 'package:flutter/material.dart';
import '../../services/weather_service.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherService = WeatherService();

    return Scaffold(
      appBar: AppBar(title: const Text("Info Cuaca Pengiriman")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weatherService.getCurrentWeather(),
        builder: (context, snapshot) {
          // 1. Sedang Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Jika Error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 10),
                  Text("Error: ${snapshot.error}", textAlign: TextAlign.center),
                ],
              ),
            );
          }

          // 3. Jika Sukses (Ada Data)
          final data = snapshot.data!;
          final currentWeather = data['current_weather'];
          final double temp = currentWeather['temperature'];
          final double wind = currentWeather['windspeed'];

          return Center(
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Cuaca Jakarta Hari Ini",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    const Icon(
                      Icons.wb_sunny,
                      size: 80,
                      color: Colors.orange,
                    ), // Ikon statis dulu biar simpel
                    const SizedBox(height: 20),
                    Text(
                      "$temp°C",
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.air, color: Colors.blue),
                        const SizedBox(width: 5),
                        Text("Angin: $wind km/h"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Pastikan cuaca aman sebelum mengirim barang grosir!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
