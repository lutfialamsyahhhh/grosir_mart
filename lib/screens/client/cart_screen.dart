import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Panggil Provider Keranjang
    final cart = Provider.of<CartProvider>(context);
    final currency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang Belanja")),
      body: cart.items.isEmpty
          ? const Center(child: Text("Keranjang kosong. Yuk belanja!"))
          : Column(
              children: [
                // LIST BARANG
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text(
                          "${currency.format(item.price)} x ${item.qty}",
                        ),
                        trailing: Text(
                          currency.format(item.price * item.qty),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),

                // BAGIAN PERHITUNGAN (SUBCPMK 3)
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          "Rincian Pembayaran",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Subtotal"),
                            Text(currency.format(cart.subtotal)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("PPN (11%)"),
                            Text(currency.format(cart.tax)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Ongkir (Flat)"),
                            Text(currency.format(cart.shippingCost)),
                          ],
                        ),
                        const Divider(thickness: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "TOTAL BAYAR",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              currency.format(cart.totalPayable),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // TOMBOL CHECKOUT
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              // Simpan Order ke Firestore
                              final user = Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              ).currentUser;

                              await FirebaseFirestore.instance
                                  .collection('orders')
                                  .add({
                                    'userId': user!.uid,
                                    'userName': user.name,
                                    'items': cart.items
                                        .map(
                                          (i) => {
                                            'name': i.name,
                                            'qty': i.qty,
                                            'price': i.price,
                                          },
                                        )
                                        .toList(),
                                    'totalPayable': cart.totalPayable,
                                    'status': 'Dikemas',
                                    'createdAt': FieldValue.serverTimestamp(),
                                  });

                              // Bersihkan keranjang & Info User
                              cart.clearCart();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Order Berhasil!"),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("BUAT PESANAN"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
