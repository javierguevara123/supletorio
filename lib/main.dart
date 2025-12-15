import 'dart:io'; // <--- IMPORTANTE: Necesario para HttpOverrides
import 'package:flutter/material.dart';
import 'package:supletorio/screens/pantalla_principal.dart';

// 1. Crea esta clase que "perdona" los certificados malos
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = 
          (X509Certificate cert, String host, int port) => true; // <--- Acepta TODO
  }
}

void main() {
  // 2. Activa la anulación de seguridad ANTES de correr la app
  HttpOverrides.global = MyHttpOverrides();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PantallaPrincipal(),
    );
  }
}