import 'package:flutter/material.dart';
import '../../services/weather_service.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tentang Aplikasi")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Icon(Icons.storefront, size: 80, color: Colors.blueAccent),
                  SizedBox(height: 10),
                  Text(
                    "GrosirMart v1.0",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text("Aplikasi Belanja Grosir Terpercaya"),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // BAGIAN TIM PENGEMBANG (Wajib untuk Video Demo)
            const Text(
              "Tim Pengembang:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text("Nama Mahasiswa 1"),
              subtitle: Text("NRP: 15202xxxx"),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text("Nama Mahasiswa 2"),
              subtitle: Text("NRP: 15202xxxx"),
            ),

            const SizedBox(height: 30),

            // BAGIAN API (SYARAT WAJIB SUBCPMK 4)
            const Text(
              "Sumber Data Publik (API):",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const Text(
              "Aplikasi ini menggunakan Open-Meteo API untuk data cuaca.",
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
              ),
              child: SelectableText(
                // Agar dosen bisa copy linknya
                WeatherService().apiUrl,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
