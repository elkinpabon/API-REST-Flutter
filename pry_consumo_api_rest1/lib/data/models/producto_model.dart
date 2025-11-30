//Aqui es donde se encuentra la conexión de http
import '../../domain/entities/producto_entity.dart';

class ProductoModel extends ProductoEntity {
  ProductoModel({
    required super.id,
    required super.nombre,
    required super.descripcion,
    required super.precio,
    required super.stock,
  });

  //Convertir un JSON que se recibe en objeto (Json -> objeto)
  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json["_id"] ?? '',
      nombre: json["nombre"] ?? '',
      descripcion: json["descripcion"] ?? '',
      precio: (json["precio"] ?? 0).toDouble(),
      stock: json["stock"] ?? 0,
    );
  }

  //Convertir objeto a JSON (objeto -> Json)
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
    };
  }
}
