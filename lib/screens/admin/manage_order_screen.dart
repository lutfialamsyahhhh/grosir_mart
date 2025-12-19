import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Wajib import ini untuk Rupiah

class ManageOrdersScreen extends StatelessWidget {
  const ManageOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Formatter Rupiah
    final currency = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Pesanan")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada pesanan masuk"));
          }

          return ListView(
            padding: const EdgeInsets.all(10),
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              // Ambil data penting
              final String currentStatus = data['status'] ?? 'pending';
              final List<dynamic> items = data['items'] ?? [];
              final int total = data['totalPayable'] ?? 0;
              final String buyerName = data['userName'] ?? 'Tanpa Nama';

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // BAGIAN ATAS: Nama Pembeli & Status Dropdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                                buyerName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                            ),
                          ),
                          // Dropdown untuk Ubah Status
                          DropdownButton<String>(
                            value: ['pending', 'dikemas', 'dikirim', 'selesai'].contains(currentStatus)
                                ? currentStatus
                                : 'pending', // Penjagaan agar tidak error jika status aneh
                            underline: Container(), // Hilangkan garis bawah biar rapi
                            items: const [
                              DropdownMenuItem(value: 'pending', child: Text("Pending (Merah)", style: TextStyle(color: Colors.red))),
                              DropdownMenuItem(value: 'dikemas', child: Text("Dikemas (Oranye)", style: TextStyle(color: Colors.orange))),
                              DropdownMenuItem(value: 'dikirim', child: Text("Dikirim (Biru)", style: TextStyle(color: Colors.blue))),
                              DropdownMenuItem(value: 'selesai', child: Text("Selesai (Hijau)", style: TextStyle(color: Colors.green))),
                            ],
                            onChanged: (newValue) {
                              if (newValue != null) {
                                FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(doc.id)
                                    .update({'status': newValue});
                              }
                            },
                          ),
                        ],
                      ),

                      const Divider(),
                      const Text("Barang yang harus dikirim:", style: TextStyle(fontSize: 12, color: Colors.grey)),

                      // BAGIAN TENGAH: List Barang (Looping)
                      // Ini penting agar Admin tahu isi paketnya!
                      ...items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Text("${item['qty']}x ", style: const TextStyle(fontWeight: FontWeight.bold)),
                              Expanded(child: Text(item['name'])),
                            ],
                          ),
                        );
                      }),

                      const Divider(),

                      // BAGIAN BAWAH: Total Harga
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Tagihan:"),
                          Text(
                            currency.format(total),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                                fontSize: 15
                            ),
                          ),
                        ],
                      )
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