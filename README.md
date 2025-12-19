# 🛒 GrosirMart - Aplikasi Marketplace Mobile

**GrosirMart** adalah aplikasi mobile berbasis Flutter yang dirancang untuk memudahkan transaksi jual-beli barang grosir secara online. Aplikasi ini memiliki dua peran pengguna (Admin & Client) dan terintegrasi penuh dengan **Firebase** secara Realtime.

---

## 📱 Fitur Unggulan

### 🛍️ Client (Pembeli/Warung)
* **Katalog Produk:** Melihat daftar barang dengan tampilan Grid yang responsif.
* **Keranjang Belanja:** Menambah barang, menghitung total otomatis (termasuk PPN 11% & Ongkir).
* **Checkout System:** Pemesanan barang yang langsung masuk ke database.
* **Riwayat & Pelacakan Pesanan:** Memantau status paket (*Dikemas, Dikirim, Selesai*) secara realtime.
* **Informasi Cuaca:** Integrasi API Cuaca untuk info terkini.
* **Registrasi Akun:** Daftar akun baru (Menunggu approval Admin).

### 🔐 Admin (Pemilik Toko)
* **Dashboard:** Ringkasan menu pengelolaan.
* **Kelola Produk (CRUD):** Tambah, Edit, dan Hapus barang dagangan.
* **Approval User:** Menyetujui pendaftar baru agar bisa login.
* **Kelola Pesanan:** Melihat pesanan masuk, rincian barang, dan mengubah status pengiriman (*Update Status Realtime ke Client*).

---

## 🛠️ Teknologi yang Digunakan
* **Framework:** Flutter (Dart)
* **Backend & Database:** Firebase Auth & Cloud Firestore
* **State Management:** Provider
* **API Eksternal:** OpenWeatherMap (Rest API)
* **Fitur Lain:** Formatting Rupiah, Date Formatting.