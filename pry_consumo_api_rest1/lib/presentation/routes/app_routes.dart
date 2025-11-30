import 'package:flutter/material.dart';
import '../views/producto_view.dart';
import '../views/pedido_view.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    "/productos": (_) => const ProductoView(),
    "/pedidos": (_) => const PedidoView(),
  };
}
