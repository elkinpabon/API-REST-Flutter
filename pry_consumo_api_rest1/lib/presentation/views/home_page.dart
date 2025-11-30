import 'package:flutter/material.dart';

import '../widgets/productos_tab.dart';
import '../widgets/pedidos_tab.dart';
import '../../config/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestión de Tienda'),
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              color: AppTheme.primaryColor,
              child: const TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 4,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                tabs: [
                  Tab(icon: Icon(Icons.shopping_bag), text: 'Productos'),
                  Tab(icon: Icon(Icons.receipt), text: 'Pedidos'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(children: [ProductosTab(), PedidosTab()]),
      ),
    );
  }
}
