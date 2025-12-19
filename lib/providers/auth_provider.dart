import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  UserModel? get user => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // --- FUNGSI REGISTER (DAFTAR) ---
  Future<String?> register(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();

      // 1. Buat akun di Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Simpan data tambahan ke Firestore
      // PENTING: Default role = 'client' dan status = 'pending'
      UserModel newUser = UserModel(
        uid: cred.user!.uid,
        email: email,
        name: name,
        role: 'client',
        approvalStatus: 'pending',
      );

      await _db.collection('users').doc(newUser.uid).set(newUser.toMap());

      _isLoading = false;
      notifyListeners();
      return null; // Null artinya sukses gak ada error
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString(); // Kembalikan pesan error
    }
  }

  // --- FUNGSI LOGIN ---
  Future<String?> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // 1. Login ke Firebase Auth
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Ambil data user dari Firestore untuk cek Role & Status
      DocumentSnapshot doc = await _db
          .collection('users')
          .doc(cred.user!.uid)
          .get();

      if (!doc.exists) {
        _isLoading = false;
        notifyListeners();
        return "Data user tidak ditemukan!";
      }

      _currentUser = UserModel.fromMap(doc.data() as Map<String, dynamic>);

      _isLoading = false;
      notifyListeners();

      // 3. Logika Pengarahan Halaman (PENTING UNTUK SOAL UTS)
      if (_currentUser!.role == 'admin') {
        return 'admin'; // Masuk dashboard admin
      } else {
        // Kalau Client, cek status approval
        if (_currentUser!.approvalStatus == 'approved') {
          return 'client'; // Boleh belanja
        } else if (_currentUser!.approvalStatus == 'rejected') {
          return 'rejected'; // Ditolak
        } else {
          return 'pending'; // Masih nunggu approval
        }
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "Email atau password salah";
    }
  }

  // --- FUNGSI LOGOUT ---
  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
