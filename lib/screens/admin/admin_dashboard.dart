import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import 'admin_users_screen.dart'; // Import halaman user
import 'admin_products_screen.dart'; // Import halaman produk

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // DefaultTabController untuk mengatur TabBar (User & Produk)
    return DefaultTabController(
      length: 2, // Jumlah Tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin GrosirMart"),
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.people), text: "Kelola User"),
              Tab(icon: Icon(Icons.inventory), text: "Kelola Produk"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Logout",
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            AdminUsersScreen(), // Tab 1: List User & Approval
            AdminProductsScreen(), // Tab 2: CRUD Produk
          ],
        ),
      ),
    );
  }
}
