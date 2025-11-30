import '../datasource/pedido_api_datasource.dart';
import '../models/pedido_model.dart';
import '../../domain/entities/pedido_entity.dart';

class PedidoRepository {
  final PedidoApiDataSource _dataSource;

  PedidoRepository(this._dataSource);

  // Obtener todos los pedidos
  Future<List<PedidoEntity>> obtenerPedidos() async {
    try {
      return await _dataSource.fetchPedidos();
    } catch (e) {
      throw Exception("Error al obtener pedidos: $e");
    }
  }

  // Crear un pedido
  Future<PedidoEntity> crearPedido({
    required String productoId,
    required int cantidad,
    required double total,
    required String estado,
  }) async {
    try {
      final pedidoModel = PedidoModel(
        id: '',
        productoId: productoId,
        cantidad: cantidad,
        total: total,
        estado: estado,
      );
      return await _dataSource.createPedido(pedidoModel);
    } catch (e) {
      throw Exception("Error al crear pedido: $e");
    }
  }

  // Actualizar un pedido
  Future<PedidoEntity> actualizarPedido({
    required String id,
    required String productoId,
    required int cantidad,
    required double total,
    required String estado,
  }) async {
    try {
      final pedidoModel = PedidoModel(
        id: id,
        productoId: productoId,
        cantidad: cantidad,
        total: total,
        estado: estado,
      );
      return await _dataSource.updatePedido(id, pedidoModel);
    } catch (e) {
      throw Exception("Error al actualizar pedido: $e");
    }
  }

  // Eliminar un pedido
  Future<void> eliminarPedido(String id) async {
    try {
      return await _dataSource.deletePedido(id);
    } catch (e) {
      throw Exception("Error al eliminar pedido: $e");
    }
  }

  // Obtener un pedido por ID
  Future<PedidoEntity> obtenerPedidoPorId(String id) async {
    try {
      return await _dataSource.getPedidoById(id);
    } catch (e) {
      throw Exception("Error al obtener pedido: $e");
    }
  }
}
