import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_theme.dart';
import 'presentation/viewmodels/producto_viewmodel.dart';
import 'presentation/viewmodels/pedido_viewmodel.dart';
import 'data/repositories/producto_repository.dart';
import 'data/repositories/pedido_repository.dart';
import 'data/datasource/producto_api_datasource.dart';
import 'data/datasource/pedido_api_datasource.dart';
import 'presentation/views/home_page.dart';

void main() {
  // Inyección de dependencias
  final productoDataSource = ProductoApiDataSource();
  final productoRepository = ProductoRepository(productoDataSource);

  final pedidoDataSource = PedidoApiDataSource();
  final pedidoRepository = PedidoRepository(pedidoDataSource);

  runApp(
    MyApp(
      productoRepository: productoRepository,
      pedidoRepository: pedidoRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ProductoRepository productoRepository;
  final PedidoRepository pedidoRepository;

  const MyApp({
    super.key,
    required this.productoRepository,
    required this.pedidoRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductoViewModel(productoRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => PedidoViewModel(pedidoRepository),
        ),
      ],
      child: MaterialApp(
        title: "Gestión de Tienda",
        theme: AppTheme.getTheme(),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
