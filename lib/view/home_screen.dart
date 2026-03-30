import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avance2/view/home/tab_trabajos.dart';
import 'package:avance2/view/home/tab_informes.dart';
import 'package:avance2/view/parametros/tab_parametros.dart';
import 'package:avance2/view/usuarios/tab_usuarios.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pantallas = const [
    TabTrabajos(),
    TabInformes(),
    TabParametros(),
    TabUsuarios(),
  ];

  final List<String> _titulos = [
    'Trabajos',
    'Informes',
    'Parámetros',
    'Usuarios',
  ];

  void _cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logueado');
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titulos[_currentIndex]),
        backgroundColor: const Color(0xFF0D47A1),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: _cerrarSesion,
          ),
        ],
      ),
      body: _pantallas[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Trabajos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Informes',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.tune), label: 'Parámetros'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Usuarios'),
        ],
      ),
    );
  }
}
