import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'firebase_options.dart';
import 'screens/splash/splash_screen.dart';


// Import Provider yang sudah dibuat
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const GrosirMartApp());
}

class GrosirMartApp extends StatelessWidget {
  const GrosirMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Bungkus MaterialApp dengan MultiProvider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GrosirMart',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        // Nanti 'home' ini akan kita ganti ke halaman Login
        home: const SplashScreen(),
      ),
    );
  }
}
