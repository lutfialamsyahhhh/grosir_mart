import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk mengambil teks inputan
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController(); // Nama Warung
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Mengambil state dari provider (loading atau tidak)
    final isLoading = Provider.of<AuthProvider>(context).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Mitra Grosir")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Warung / Pemilik",
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama harus diisi" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                    !value!.contains('@') ? "Email tidak valid" : null,
              ),
              TextFormField(
                controller: _passController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? "Password min 6 karakter" : null,
              ),
              const SizedBox(height: 20),

              // Tombol Daftar
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
                          // Panggil fungsi register di Provider
                          String? error =
                              await Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              ).register(
                                _emailController.text,
                                _passController.text,
                                _nameController.text,
                              );

                          // FIX: Cek apakah widget masih aktif sebelum navigasi
                          if (!context.mounted) return;

                          if (error == null) {
                            // Jika sukses, kembali ke login & tampilkan pesan
                            Navigator.pop(context); // Balik ke halaman login
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Registrasi Berhasil! Silakan Login.",
                                ),
                              ),
                            );
                          } else {
                            // Jika gagal
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $error")),
                            );
                          }
                        }
                      },
                      child: const Text("DAFTAR SEKARANG"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
