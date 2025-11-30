import 'package:flutter/foundation.dart';
import '../../data/repositories/pedido_repository.dart';
import '../../data/models/pedido_model.dart';

class PedidoViewModel extends ChangeNotifier {
  final PedidoRepository _repository;

  PedidoViewModel(this._repository);

  // Estados
  List<PedidoModel> _pedidos = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<PedidoModel> get pedidos => _pedidos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Obtener todos los pedidos
  Future<void> cargarPedidos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final pedidosEntities = await _repository.obtenerPedidos();
      _pedidos = pedidosEntities.cast<PedidoModel>();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Crear pedido
  Future<void> crearPedido(PedidoModel pedido) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final nuevoPedido =
          await _repository.crearPedido(
                productoId: pedido.productoId,
                cantidad: pedido.cantidad,
                total: pedido.total,
                estado: pedido.estado,
              )
              as PedidoModel;
      _pedidos.add(nuevoPedido);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualizar pedido
  Future<void> actualizarPedido(PedidoModel pedido) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.actualizarPedido(
        id: pedido.id,
        productoId: pedido.productoId,
        cantidad: pedido.cantidad,
        total: pedido.total,
        estado: pedido.estado,
      );

      final index = _pedidos.indexWhere((p) => p.id == pedido.id);
      if (index >= 0) {
        _pedidos[index] = pedido;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Eliminar pedido
  Future<void> eliminarPedido(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.eliminarPedido(id);
      _pedidos.removeWhere((p) => p.id == id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
