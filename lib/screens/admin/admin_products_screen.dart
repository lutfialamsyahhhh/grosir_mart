import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  String formatRupiah(int number) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }

  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Barang Grosir"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama Produk"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Harga (Angka)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(labelText: "Stok Awal"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                await FirebaseFirestore.instance.collection('products').add({
                  'name': nameController.text,
                  'price': int.parse(priceController.text),
                  'stock': int.parse(stockController.text),
                  'description': 'Barang kualitas super',
                  'createdAt': FieldValue.serverTimestamp(),
                });
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(String id) {
    FirebaseFirestore.instance.collection('products').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // PERBAIKAN DI SINI: Menambahkan kurung kurawal {}
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          // PERBAIKAN DI SINI: Menambahkan kurung kurawal {}
          if (products.isEmpty) {
            return const Center(child: Text("Belum ada produk. Klik tombol +"));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var data = products[index].data() as Map<String, dynamic>;
              String id = products[index].id;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(
                    Icons.inventory_2,
                    color: Colors.blueAccent,
                  ),
                  title: Text(data['name'] ?? '-'),
                  subtitle: Text(
                    "Stok: ${data['stock']} | ${formatRupiah(data['price'] ?? 0)}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteProduct(id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
