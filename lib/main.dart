import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:avance2/view/home_screen.dart';
import 'package:avance2/view/informes_screen.dart';
import 'package:avance2/view/configuracion_screen.dart';
import 'package:avance2/view/trabajo_lista_screen.dart';
import 'package:avance2/view/login/splash_screen.dart';
import 'package:avance2/view/login/login_page.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //Inicializa los datos de fecha para español
  await initializeDateFormatting('es_ES', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller Aguileta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginPage(),
        '/bienvenida': (context) => const HomeScreen(),
        '/trabajos': (context) => const TrabajoListaScreen(),
        '/informes': (context) => const InformesScreen(),
        '/configuracion': (context) => const ConfiguracionScreen(),
      },
    );
  }
}