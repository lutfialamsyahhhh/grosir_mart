import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../admin/admin_dashboard.dart';
import '../client/client_home_screen.dart';
import '../client/status_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context).isLoading;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_cart,
                size: 80,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 10),
              const Text(
                "GrosirMart Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (val) => val!.isEmpty ? "Isi email dulu" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (val) => val!.isEmpty ? "Isi password dulu" : null,
              ),
              const SizedBox(height: 20),

              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // 1. Panggil Login dari Provider
                          String? result = await Provider.of<AuthProvider>(
                            context,
                            listen: false,
                          ).login(_emailController.text, _passController.text);

                          // FIX: Cek apakah widget masih aktif sebelum menggunakan context
                          if (!context.mounted) return;

                          // 2. Cek Hasilnya (Role/Status)
                          if (result == 'admin') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AdminDashboard(),
                              ),
                            );
                          } else if (result == 'client') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ClientHomeScreen(),
                              ),
                            );
                          } else if (result == 'pending') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StatusScreen(),
                              ),
                            );
                          } else if (result == 'rejected') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Maaf, akun Anda ditolak Admin."),
                              ),
                            );
                          } else {
                            // Kalau result berisi pesan error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result ?? "Login Gagal")),
                            );
                          }
                        }
                      },
                      child: const Text("MASUK"),
                    ),

              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text("Belum punya akun? Daftar Mitra"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
