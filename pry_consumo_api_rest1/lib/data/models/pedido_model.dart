import '../../domain/entities/pedido_entity.dart';

class PedidoModel extends PedidoEntity {
  PedidoModel({
    required super.id,
    required super.productoId,
    required super.cantidad,
    required super.total,
    required super.estado,
  });

  // Convertir JSON a modelo
  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    return PedidoModel(
      id: json["_id"] ?? json["id"] ?? '',
      productoId: json["productoId"] ?? json["producto_id"] ?? '',
      cantidad: json["cantidad"] ?? 0,
      total: (json["total"] ?? 0).toDouble(),
      estado: json["estado"] ?? 'pendiente',
    );
  }

  // Convertir modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'productoId': productoId,
      'cantidad': cantidad,
      'total': total,
      'estado': estado,
    };
  }
}
