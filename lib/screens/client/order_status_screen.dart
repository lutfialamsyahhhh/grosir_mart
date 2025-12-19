import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Jangan lupa import ini
import '../../providers/auth_provider.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    // Formatter untuk Rupiah
    final currency = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0
    );

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Status Pesanan"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("Belum ada pesanan", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(10),
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final status = data['status'] ?? 'pending'; // Default pending jika null

              // 1. Ambil List Items dari Database
              final List<dynamic> items = data['items'] ?? [];

              // 2. Tentukan Warna & Ikon berdasarkan Status
              Color statusColor = Colors.orange;
              IconData statusIcon = Icons.local_shipping;
              String statusText = "Sedang di proses";

              if (status == 'selesai') {
                statusColor = Colors.green;
                statusIcon = Icons.check_circle;
                statusText = "Pesanan Selesai";
              } else if (status == 'dikirim') {
                statusColor = Colors.blue;
                statusIcon = Icons.delivery_dining;
                statusText = "Sedang Dikirim";
              }

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BAGIAN ATAS: STATUS
                      Row(
                        children: [
                          Icon(statusIcon, color: statusColor),
                          const SizedBox(width: 10),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status.toString().toUpperCase(),
                              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      const Divider(thickness: 1, height: 20),

                      // BAGIAN TENGAH: LIST BARANG (Looping)
                      const Text("Rincian Barang:", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 5),

                      // Ini Logika untuk menampilkan semua barang
                      ...items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Nama Barang & Jumlah
                              Expanded(
                                child: Text(
                                  "${item['qty']}x  ${item['name']}",
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ),
                              // Harga per item (Optional)
                              Text(
                                currency.format(item['price']),
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      }),

                      const Divider(thickness: 1, height: 20),

                      // BAGIAN BAWAH: TOTAL HARGA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            // PENTING: Pakai 'totalPayable' sesuai database Anda
                            currency.format(data['totalPayable'] ?? 0),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}