// Entidad de Pedido - Reglas de negocio puro
class PedidoEntity {
  final String id;
  final String productoId;
  final int cantidad;
  final double total;
  final String estado;

  PedidoEntity({
    required this.id,
    required this.productoId,
    required this.cantidad,
    required this.total,
    required this.estado,
  });
}
