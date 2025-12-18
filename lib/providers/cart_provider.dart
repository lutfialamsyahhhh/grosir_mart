import 'package:flutter/material.dart';
import '../models/product_model.dart';

// Class kecil untuk item di keranjang
class CartItem {
  final String id;
  final String name;
  final int price;
  int qty;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.qty = 1,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // --- RUMUS MATEMATIKA (SUBCPMK 3) ---

  // 1. Subtotal (Harga x Jumlah Barang)
  int get subtotal {
    return _items.fold(0, (sum, item) => sum + (item.price * item.qty));
  }

  // 2. Pajak 11% (Dikonversi ke Int biar gampang format Rupiah)
  int get tax {
    return (subtotal * 0.11).toInt();
  }

  // 3. Ongkir Flat (Misal Rp 15.000 jauh dekat sama)
  int get shippingCost {
    return _items.isEmpty ? 0 : 15000;
  }

  // 4. Total Bayar Akhir
  int get totalPayable {
    return subtotal + tax + shippingCost;
  }

  // --- FUNGSI LOGIKA KERANJANG ---

  void addToCart(ProductModel product) {
    // Cek apakah barang sudah ada di keranjang?
    int index = _items.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      // Kalau sudah ada, tambah jumlahnya (qty)
      _items[index].qty++;
    } else {
      // Kalau belum ada, masukkan sebagai item baru
      _items.add(
        CartItem(id: product.id, name: product.name, price: product.price),
      );
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
